import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {
  ledger, outer, contributions, patternMatrix, cpFactors, ttExample,
  contractionCosts, tensorPrediction, trainingObjective, trainIllustration,
  targetCurve
} from './tensor-examples.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const checks = [];
function close(a,b,tol=1e-10) { assert.ok(Math.abs(a-b)<=tol, a+' differs from '+b); }
function check(name, run) {
  const result=run();
  checks.push({name,status:'passed',details:result});
}
function transpose(A) { return A[0].map((_,j)=>A.map(row=>row[j])); }
function multiply(A,B) {
  assert.equal(A[0].length,B.length);
  const out=A.map(()=>Array(B[0].length).fill(0));
  let scalarMultiplications=0;
  for(let i=0;i<A.length;i++) for(let j=0;j<B[0].length;j++) for(let k=0;k<B.length;k++) {
    out[i][j]+=A[i][k]*B[k][j]; scalarMultiplications++;
  }
  return {out,scalarMultiplications};
}
function distance(A,B) {
  return Math.sqrt(A.reduce((s,row,i)=>s+row.reduce((t,a,j)=>t+(a-B[i][j])**2,0),0));
}
// Independent Jacobi diagonalization checks the spectrum of generated examples.
function eigenvalues(A) {
  const M=A.map(row=>[...row]),n=M.length;
  for(let iter=0;iter<200*n*n;iter++) {
    let p=0,q=1,max=0;
    for(let i=0;i<n;i++) for(let j=i+1;j<n;j++)
      if(Math.abs(M[i][j])>max) {max=Math.abs(M[i][j]);p=i;q=j;}
    if(max<1e-12) return M.map((row,i)=>row[i]).sort((a,b)=>b-a);
    const phi=0.5*Math.atan2(2*M[p][q],M[q][q]-M[p][p]);
    const c=Math.cos(phi),s=Math.sin(phi),app=M[p][p],aqq=M[q][q],apq=M[p][q];
    for(let k=0;k<n;k++) if(k!==p&&k!==q) {
      const akp=M[k][p],akq=M[k][q];
      M[k][p]=M[p][k]=c*akp-s*akq;
      M[k][q]=M[q][k]=s*akp+c*akq;
    }
    M[p][p]=c*c*app-2*s*c*apq+s*s*aqq;
    M[q][q]=s*s*app+2*s*c*apq+c*c*aqq;
    M[p][q]=M[q][p]=0;
  }
  throw Error('Eigenvalue verification did not converge');
}
function spectrum(A) {
  return eigenvalues(multiply(A,transpose(A)).out).map(v=>v<1e-10?0:Math.sqrt(v));
}

check('Ledger addresses and reversible unfolding',()=>{
  assert.deepEqual(ledger.flat(2),Array.from({length:12},(_,i)=>i+1));
  const M=ledger.map(page=>page.flat());
  for(let s=0;s<2;s++) for(let t=0;t<3;t++) for(let v=0;v<2;v++)
    assert.equal(M[s][2*t+v],ledger[s][t][v]);
  assert.equal(M[1][4],11);
  return {tensorShape:[2,3,2],matrixShape:[2,6],highlightedValue:11};
});
check('Outer product and rank-one minors',()=>{
  assert.deepEqual(outer,[[3,4,5],[6,8,10]]);
  for(let j=0;j<3;j++) for(let k=j+1;k<3;k++)
    close(outer[0][j]*outer[1][k]-outer[0][k]*outer[1][j],0);
  return {entries:outer,rank:1};
});
check('Signed contraction and matrix contraction',()=>{
  assert.deepEqual(contributions,[4,-2,6]);close(contributions.reduce((a,b)=>a+b,0),8);
  assert.deepEqual(multiply([[1,2,3],[4,5,6]],[[1,0],[0,1],[1,1]]).out,[[4,5],[10,11]]);
  return {signedSum:8};
});
check('SVD spectrum and discarded-layer errors',()=>{
  const M=patternMatrix(),sv=spectrum(M);
  [9,3,1].forEach((s,i)=>close(sv[i],s,1e-9));
  assert.ok(sv.slice(3).every(s=>s===0));
  const errors=[1,2,3].map(r=>distance(M,patternMatrix(r)));
  [Math.sqrt(10),1,0].forEach((e,i)=>close(errors[i],e));
  return {singularValues:sv,errors,storage:{dense:64,oneLayer:17,twoLayers:34,threeLayers:51}};
});
check('TT contraction agrees with direct two-term expression',()=>{
  const T=Array.from({length:4},(_,i)=>Array.from({length:4},(_,j)=>Array.from({length:4},(_,k)=>{
    const direct=cpFactors.a[i][0]*cpFactors.b[j][0]*cpFactors.c[k][0]
      +cpFactors.a[i][1]*cpFactors.b[j][1]*cpFactors.c[k][1];
    close(ttExample(i,j,k),direct);return direct;
  })));
  close(T[3][1][2],3);
  const first=T.map(page=>page.flat());
  const second=T.flatMap(page=>page.map(row=>row));
  const ranks=[first,second].map(M=>spectrum(M).filter(s=>s>1e-8).length);
  assert.deepEqual(ranks,[2,2]);
  return {checkedEntries:64,cutRanks:ranks,denseStorage:64,ttStorage:32,T_4_2_3:3};
});
check('Contraction order preserves values and independently counts multiplications',()=>{
  const A=Array.from({length:40},(_,i)=>Array.from({length:2},(_,j)=>Math.sin(i+j+1)));
  const B=Array.from({length:2},(_,i)=>Array.from({length:30},(_,j)=>Math.cos(i+2*j)));
  const C=Array.from({length:30},(_,i)=>Array.from({length:2},(_,j)=>Math.sin(2*i-j)));
  const AB=multiply(A,B),left=multiply(AB.out,C),BC=multiply(B,C),right=multiply(A,BC.out);
  close(distance(left.out,right.out),0,1e-10);
  const counts=[AB.scalarMultiplications+left.scalarMultiplications,BC.scalarMultiplications+right.scalarMultiplications];
  assert.deepEqual(counts,[4800,280]);
  assert.equal(counts[0],contractionCosts.left.multiplications);
  assert.equal(counts[1],contractionCosts.right.multiplications);
  return {counts,intermediateEntries:[AB.out.length*AB.out[0].length,BC.out.length*BC.out[0].length],difference:distance(left.out,right.out)};
});
check('Gauge transformation and coordinate translation preserve the object',()=>{
  const A=[[1,2]],B=[[3],[4]],G=[[0,-1],[1,0]],Gi=[[0,1],[-1,0]];
  const AG=multiply(A,G).out,GiB=multiply(Gi,B).out;
  assert.deepEqual(AG,[[2,-1]]);assert.deepEqual(GiB,[[4],[-3]]);
  close(multiply(A,B).out[0][0],11);close(multiply(AG,GiB).out[0][0],11);
  assert.deepEqual([1*0+(-2)*(-1),1*1+(-2)*0],[2,1]);
  return {original:11,transformed:11,newVectorCoordinates:[1,-2]};
});
check('QR orthogonality and absorption into the neighbour',()=>{
  const A=[[1,2],[3,4],[5,7]];
  const a=A.map(row=>row[0]),b=A.map(row=>row[1]);
  const r11=Math.hypot(...a),q1=a.map(v=>v/r11),r12=q1.reduce((s,q,i)=>s+q*b[i],0);
  const residual=b.map((v,i)=>v-r12*q1[i]),r22=Math.hypot(...residual),q2=residual.map(v=>v/r22);
  const Q=q1.map((q,i)=>[q,q2[i]]),R=[[r11,r12],[0,r22]],B=[[1,0],[0,2]];
  close(distance(multiply(transpose(Q),Q).out,[[1,0],[0,1]]),0);
  close(distance(multiply(Q,R).out,A),0);
  close(distance(multiply(Q,multiply(R,B).out).out,multiply(A,B).out),0);
  return {orthogonalityError:distance(multiply(transpose(Q),Q).out,[[1,0],[0,1]])};
});
check('Product features recover the bilinear prediction and its changing slope',()=>{
  const a=0.2,b=-0.4,W=[[0.5,-0.2],[0.8,1.3]],features=[[1,b],[a,a*b]];
  const contracted=W.reduce((s,row,i)=>s+row.reduce((t,w,j)=>t+w*features[i][j],0),0);
  close(contracted,0.636);
  const f=(a,b)=>0.5+0.8*a-0.2*b+1.3*a*b,h=1e-5;
  close((f(a+h,b)-f(a-h,b))/(2*h),0.8+1.3*b,1e-9);
  return {prediction:contracted,slopeAt_b_minus_0_4:0.28};
});
const trained=trainIllustration();
check('Core gradients agree with independent finite differences',()=>{
  const w=[...trained.before],h=1e-6,analytic=trainingObjective(w).grad;
  let maximumError=0;
  for(let p=0;p<w.length;p++) {
    const plus=[...w],minus=[...w];plus[p]+=h;minus[p]-=h;
    const numeric=(trainingObjective(plus).loss-trainingObjective(minus).loss)/(2*h);
    maximumError=Math.max(maximumError,Math.abs(numeric-analytic[p]));
  }
  assert.ok(maximumError<2e-7);
  // Reconstruct eight dense coefficients independently, then evaluate a polynomial.
  for(const x of [-0.91,-0.3,0,0.47,0.92]) {
    let reference=0;
    for(let i=0;i<2;i++) for(let j=0;j<2;j++) for(let k=0;k<2;k++) {
      let coeff=0;
      for(let alpha=0;alpha<2;alpha++) for(let beta=0;beta<2;beta++)
        coeff+=w[i*2+alpha]*w[4+alpha*4+j*2+beta]*w[12+beta*2+k];
      reference+=coeff*x**(i+j+k);
    }
    close(reference,tensorPrediction(w,x).value);
  }
  return {checkedParameters:16,maximumGradientError:maximumError};
});
check('The illustrated learning run actually reduces error',()=>{
  assert.ok(trained.afterMse<trained.beforeMse*0.005);
  assert.ok(trained.referenceMse<5e-5);
  close(trained.beforeMse,0.364407,0.5e-6);close(trained.afterMse,0.000290,0.5e-6);
  close(targetCurve(-1),-1.55);close(targetCurve(1),0.55);
  return {steps:trained.steps,beforeMse:trained.beforeMse,afterMse:trained.afterMse,referenceCurveMse:trained.referenceMse};
});
check('Generated figure manifest and training data agree with the verified examples',()=>{
  const manifest=JSON.parse(fs.readFileSync(path.join(root,'figures/tensors/manifest.json'),'utf8'));
  assert.equal(manifest.figures.length,11);
  assert.equal(new Set(manifest.figures.map(f=>f.name)).size,11);
  for(const fig of manifest.figures) {
    const content=fs.readFileSync(path.join(root,'figures/tensors',fig.name+'.svg'),'utf8');
    assert.ok(content.startsWith('<svg ')&&content.endsWith('</svg>'));
    assert.ok(!/NaN|Infinity|<script\b|https?:\/\//.test(content.replace('http://www.w3.org/2000/svg','')));
    assert.ok(content.includes('<title ')&&content.includes('<desc '));
  }
  assert.deepEqual(manifest.numericalData.ledger,ledger);
  close(manifest.numericalData.training.afterMse,trained.afterMse);
  return {originalVectorFigures:11,externalAssets:0};
});
const report={date:'2026-10-08',status:'passed',checks};
fs.writeFileSync(path.join(root,'figures/tensors/verification.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(report,null,2));
