export function buildNetworkFigures(H) {
  const {svg, text, line, curve, circle, rect, node, matrix, C, contractionCosts, training} = H;
  // One bond with two possible labels: the lanes are a metaphor, not two graph edges.
  {
    let b = text(30, 35, 'Small local descriptions share latent choices', 26, C.ink, 'start', 'bold');
    const xs = [145, 465, 785], names = ['A', 'B', 'C'];
    for (let k = 0; k < 2; k++) {
      const y = 142 + k * 52, color = k === 0 ? C.blue : C.orange;
      b += curve('M145,' + y + ' Q305,' + (y - 25) + ' 465,' + y + ' Q625,' + (y - 25) + ' 785,' + y, color, 10);
      b += text(305, y - 20, 'label ' + (k + 1), 18, color, 'middle');
      b += text(625, y - 20, 'label ' + (k + 1), 18, color, 'middle');
    }
    xs.forEach((x, i) => {
      b += line(x, 98, x, 237, C.gray, 6);
      b += circle(x, 165, 43, C.white, C.ink, 3) + text(x, 174, names[i], 30, C.ink, 'middle', 'bold');
      b += text(x, 273, 'local index ' + ['i', 'j', 'k'][i], 20, C.ink, 'middle');
    });
    b += text(465, 317, 'Formal diagram: each internal line below is one bond of size 2.', 20, C.gray, 'middle');
    b += line(145, 377, 465, 377, C.gray, 4) + line(465, 377, 785, 377, C.gray, 4);
    xs.forEach((x, i) => {
      b += line(x, 377, x, 435, C.gray, 3) + node(x, 377, names[i]);
      b += text(x, 463, ['i: 1…4', 'j: 1…4', 'k: 1…4'][i], 19, C.ink, 'middle');
    });
    b += text(305, 357, 'α: 1, 2', 21, C.blue, 'middle') + text(625, 357, 'β: 1, 2', 21, C.orange, 'middle');
    b += text(465, 510, 'dense: 4³ = 64 entries    ·    TT cores: 8 + 16 + 8 = 32 entries', 22, C.ink, 'middle');
    svg('06-latent-relay', 960, 545, 'Latent choices across a tensor train', 'A relay metaphor shows two possible labels on each internal connection. The formal diagram has three cores, each physical index of size four, and two bonds of size two. A dense tensor stores sixty-four entries; these TT cores store thirty-two.', b);
  }
  // Actual network topologies; circles and a branching tree complement the metaphors.
  {
    let b = text(30, 35, 'Different ways to organise the same kind of building blocks', 25, C.ink, 'start', 'bold');
    b += text(160, 86, 'CP: a shared component', 21, C.ink, 'middle', 'bold');
    const cp = [[70, 207, 'U', 'i'], [160, 240, 'V', 'j'], [250, 207, 'W', 'k']];
    cp.forEach(([x, y, label, idx]) => {
      b += line(160, 140, x, y, C.gray, 2.5) + line(x, y, x, y + 52, C.gray, 2.5);
      b += node(x, y, label, C.blue, 22) + text(x, y + 78, idx, 20, C.ink, 'middle');
    });
    b += node(160, 140, 'δ', C.orange, 23) + text(205, 141, 'r', 19, C.gray);
    b += text(480, 86, 'Tucker: a mixing hub', 21, C.ink, 'middle', 'bold');
    [[380, 210, 'U', 'i'], [480, 250, 'V', 'j'], [580, 210, 'W', 'k']].forEach(([x, y, label, idx], i) => {
      b += line(480, 140, x, y, C.gray, 2.5) + line(x, y, x, y + 44, C.gray, 2.5);
      b += text((480 + x) / 2 + (i === 1 ? 22 : 0), (140 + y) / 2, 'r' + (i + 1), 17, C.gray);
      b += node(x, y, label, C.blue, 22) + text(x, y + 68, idx, 20, C.ink, 'middle');
    });
    b += node(480, 140, 'G', C.teal, 30);
    b += text(800, 86, 'TT / MPS: beads on a string', 21, C.ink, 'middle', 'bold');
    b += line(700, 185, 900, 185, C.gray, 3);
    [700, 800, 900].forEach((x, i) => {
      b += line(x, 185, x, 258, C.gray, 2.5) + node(x, 185, ['A','B','C'][i], C.blue, 23);
      b += text(x, 283, ['i','j','k'][i], 20, C.ink, 'middle');
    });
    b += text(750, 163, 'r₁', 18, C.gray, 'middle') + text(850, 163, 'r₂', 18, C.gray, 'middle');
    b += line(40, 347, 920, 347, C.light, 1);
    b += text(265, 400, 'MPO: paired input and output legs', 21, C.ink, 'middle', 'bold');
    b += line(155, 493, 375, 493, C.gray, 3);
    [155, 265, 375].forEach((x, i) => {
      b += line(x, 441, x, 555, C.gray, 2.5) + node(x, 493, ['M₁','M₂','M₃'][i], C.teal, 25);
      b += text(x, 430, 'j' + (i + 1), 19, C.ink, 'middle') + text(x, 584, 'i' + (i + 1), 19, C.ink, 'middle');
    });
    b += text(715, 400, 'Tree: local groups meet higher up', 21, C.ink, 'middle', 'bold');
    b += line(715, 440, 645, 490, C.gray, 3) + line(715, 440, 785, 490, C.gray, 3);
    [[595,545],[685,545],[745,545],[835,545]].forEach(([x,y], i) => {
      b += line(i < 2 ? 645 : 785, 490, x, y, C.gray, 3) + line(x, y, x, 590, C.gray, 2.5);
      b += node(x, y, 'L' + (i + 1), C.blue, 20);
      b += text(x, 616, 'i' + (i + 1), 18, C.ink, 'middle');
    });
    b += node(715,440,'G',C.orange,23) + node(645,490,'B₁',C.teal,23) + node(785,490,'B₂',C.teal,23);
    b += text(480, 660, 'Open legs identify the represented object; internal legs are summed.', 21, C.ink, 'middle');
    svg('07-network-topologies', 960, 695, 'Network topologies as organisational metaphors', 'CP uses a copy tensor delta to select the same component across factors. Tucker has a general mixing core. TT is a chain. MPO has input-output index pairs. A binary tree groups local tensors hierarchically.', b);
  }
  // Packing early avoids a large temporary object; both computations are exact.
  {
    let b = text(30, 35, 'Choose when to combine the pieces', 26, C.ink, 'start', 'bold');
    for (let panel = 0; panel < 2; panel++) {
      const x = panel * 470;
      b += text(x + 245, 82, panel === 0 ? '(AB)C' : 'A(BC)', 25, C.ink, 'middle', 'bold');
      b += line(x + 120, 150, x + 365, 150, C.gray, 3);
      [120, 245, 365].forEach((p,i) => { b += node(x+p,150,['A','B','C'][i]); });
      b += text(x + 120, 195, '40 × 2', 19, C.gray, 'middle')
        + text(x + 245, 195, '2 × 30', 19, C.gray, 'middle')
        + text(x + 365, 195, '30 × 2', 19, C.gray, 'middle');
      const cx = x + (panel === 0 ? 182 : 305);
      b += curve('M' + (cx - 88) + ',123 Q' + cx + ',78 ' + (cx + 88) + ',123', panel === 0 ? C.orange : C.teal, 3);
      b += line(cx, 216, cx, 264, C.gray, 2, false, true);
    }
    // Both thumbnails use five pixels per stored entry.
    for (let i=0;i<40;i++) for (let j=0;j<30;j++)
      b += rect(105+j*5, 285+i*5, 5,5,'#FBE2D4',C.white,0.5);
    b += text(180, 516, '40 × 30: 1,200 entries', 20, C.orange, 'middle');
    b += matrix([[1,1],[1,1]], 675, 330, 5, false);
    b += line(685,335,742,325,C.light,2,true) + line(685,340,742,394,C.light,2,true);
    b += matrix([[1,1],[1,1]], 745, 315, 42, false);
    b += text(787, 425, 'magnified', 18, C.gray, 'middle');
    b += text(680, 516, '2 × 2: only 4 entries', 20, C.teal, 'middle');
    b += text(245, 563, contractionCosts.left.multiplications.toLocaleString('en-US') + ' scalar multiplications', 21, C.orange, 'middle');
    b += text(710, 563, contractionCosts.right.multiplications.toLocaleString('en-US') + ' scalar multiplications', 21, C.teal, 'middle');
    b += text(480, 609, 'Both routes produce the same 40 × 2 result.', 22, C.ink, 'middle');
    svg('08-contraction-packing', 960, 645, 'Contraction order as packing early', 'Two associative matrix products yield the same output. Combining A and B first creates twelve hundred temporary entries and costs forty-eight hundred scalar multiplications. Combining B and C first creates four entries and costs two hundred eighty multiplications.', b);
  }
  // Gauge freedom as translating the coordinates of the same physical arrow.
  {
    let b = text(30, 35, 'A new coordinate language; the same vector', 26, C.ink, 'start', 'bold');
    for (let p=0;p<2;p++) {
      const x=185+p*470,y=260,px=x+120,py=y-60;
      b += text(x+50,83,p===0?'original basis':'rotated basis',23,C.ink,'middle','bold');
      b += line(x-65,y,x+170,y,C.light,1) + line(x,y+60,x,y-150,C.light,1);
      if(p===0) {
        b += line(x,y,x+160,y,C.blue,3,false,true) + line(x,y,x,y-135,C.teal,3,false,true);
        b += text(x+173,y+7,'e₁',20,C.blue) + text(x+8,y-140,'e₂',20,C.teal);
        b += line(px,y,px,py,C.gray,1.5,true) + line(x,py,px,py,C.gray,1.5,true);
        b += text(px,y+30,'2',20,C.blue,'middle') + text(x-15,py+5,'1',20,C.teal,'end');
      } else {
        b += line(x,y,x,y-135,C.blue,3,false,true) + line(x,y,x-140,y,C.teal,3,false,true);
        b += text(x+10,y-140,'e₁′',20,C.blue) + text(x-148,y-10,'e₂′',20,C.teal,'end');
        b += line(px,y,px,py,C.gray,1.5,true) + line(x,py,px,py,C.gray,1.5,true);
        b += text(px,y+30,'−2 along e₂′',19,C.teal,'middle') + text(x-15,py+5,'1',20,C.blue,'end');
      }
      b += line(x,y,px,py,C.orange,5,false,true) + circle(px,py,6,C.orange);
      b += text(px+12,py-12,'same v',20,C.orange);
      b += text(x+50,345,p===0?'v = 2e₁ + e₂':'v = e₁′ − 2e₂′',22,C.ink,'middle');
    }
    b += text(480,410,'A tensor bond can also change basis without changing the represented object.',20,C.gray,'middle');
    b += text(480,460,'AB = (AG)(G⁻¹B)     ·     G must be invertible',25,C.ink,'middle');
    svg('09-gauge-coordinates',960,495,'Gauge freedom as a coordinate translation','The same vector two comma one is described in an ordinary basis and a basis rotated ninety degrees. Its coordinates become one comma minus two. A tensor-bond transformation inserts G and its inverse without changing the full contraction.',b);
  }
  // A bilinear interaction bends a sheet; it cannot be captured by an additive plane.
  {
    let b=text(30,35,'A learned interaction changes the shape of the prediction',25,C.ink,'start','bold');
    function surface(cx,cy,interaction) {
      const project=(a,d,z)=>[cx+100*a+70*d,cy+35*a-40*d-38*z];
      const predict=(a,d)=>0.5+0.8*a-0.2*d+(interaction?1.3*a*d:0);
      let result='';
      for(let j=9;j>=0;j--) for(let i=0;i<10;i++) {
        const a=-1+i/5,d=-1+j/5;
        const pts=[[a,d],[a+0.2,d],[a+0.2,d+0.2],[a,d+0.2]].map(([u,v])=>project(u,v,predict(u,v)));
        result+='<polygon points="'+pts.map(p=>p.join(',')).join(' ')+'" fill="'+(interaction?'#DDF1EE':'#E2EDF8')+'" stroke="'+(interaction?C.teal:C.blue)+'" stroke-width="1.2"/>';
      }
      const origin=project(-1.2,-1.2,-1.5), axisA=project(1.3,-1.2,-1.5),axisB=project(-1.2,1.3,-1.5),axisY=project(-1.2,-1.2,1.5);
      result+=line(...origin,...axisA,C.gray,2,false,true)+line(...origin,...axisB,C.gray,2,false,true)+line(...origin,...axisY,C.gray,2,false,true);
      result+=text(axisA[0]+10,axisA[1]+9,'a',20,C.gray)+text(axisB[0]-15,axisB[1],'b',20,C.gray)+text(axisY[0]-10,axisY[1]-10,'ŷ',20,C.gray);
      return result;
    }
    b+=text(245,90,'additive effects',23,C.blue,'middle','bold')+surface(270,255,false);
    b+=text(715,90,'with an interaction',23,C.teal,'middle','bold')+surface(730,255,true);
    b+=text(245,456,'0.5 + 0.8a − 0.2b',23,C.blue,'middle');
    b+=text(715,456,'0.5 + 0.8a − 0.2b + 1.3ab',23,C.teal,'middle');
    b+=text(480,514,'The effect of a now depends on b: ∂ŷ/∂a = 0.8 + 1.3b.',21,C.ink,'middle');
    svg('10-interaction-sheet',960,552,'Interactions as a bending sheet','Two surfaces use identical input domains and projection scales. An additive regression produces a plane. Adding the product feature a times b produces a saddle-like bilinear surface, so the effect of one input depends on the other.',b);
  }
  // Actual optimisation of three TT cores, displayed as an evolving curve.
  {
    let b=text(30,35,'Adjust the cores; reshape the prediction curve',26,C.ink,'start','bold');
    const plot={w:355,h:265,y:185,ymin:-1.7,ymax:0.75};
    for(let p=0;p<2;p++) {
      const left=80+p*470;
      b+=text(left+178,83,p===0?'initial core parameters':'after 1,800 updates',23,C.ink,'middle','bold');
      for(let knob=0;knob<3;knob++) {
        const x=left+107+knob*70;
        b+=circle(x,125,16,C.white,C.gray,2);
        const angle=(p===0?-1.1:0.6)+knob*0.35;
        b+=line(x,125,x+12*Math.sin(angle),125-12*Math.cos(angle),p===0?C.gray:C.blue,3);
        b+=text(x,162,['A','B','C'][knob],17,C.gray,'middle');
      }
      const px=x=>left+(x+1)/2*plot.w;
      const py=y=>plot.y+plot.h-(y-plot.ymin)/(plot.ymax-plot.ymin)*plot.h;
      b+=line(left,plot.y,left,plot.y+plot.h,C.gray,2)+line(left,plot.y+plot.h,left+plot.w,plot.y+plot.h,C.gray,2);
      [-1,0,1].forEach(x=>{b+=line(px(x),plot.y+plot.h,px(x),plot.y+plot.h+5,C.gray);b+=text(px(x),plot.y+plot.h+25,x,17,C.gray,'middle');});
      [-1.5,-1,-0.5,0,0.5].forEach(y=>{b+=line(left,py(y),left+plot.w,py(y),C.light,1);b+=text(left-12,py(y)+6,y,16,C.gray,'end');});
      const truth=training.curves.map((q,i)=>(i?'L':'M')+px(q.x)+','+py(q.truth)).join(' ');
      const fit=training.curves.map((q,i)=>(i?'L':'M')+px(q.x)+','+py(p===0?q.before:q.after)).join(' ');
      b+=curve(truth,C.gray,4,'none',true)+curve(fit,C.blue,3);
      H.trainingData.forEach(q=>{b+=circle(px(q.x),py(q.y),4.2,C.ink,C.white,1);});
      b+=text(left+plot.w+17,plot.y+plot.h+6,'x',20,C.gray);
      b+=text(left-22,plot.y-12,'y',20,C.gray);
      b+=text(left+178,514,'training MSE = '+(p===0?training.beforeMse:training.afterMse).toFixed(6),21,C.ink,'middle');
    }
    b+=line(95,562,142,562,C.gray,4,true)+text(155,569,'known generating curve',18,C.gray);
    b+=line(405,562,452,562,C.blue,3)+text(465,569,'TT prediction',18,C.blue);
    b+=circle(700,562,4.2,C.ink)+text(718,569,'noisy observations',18,C.ink);
    b+=text(480,610,'One-dimensional illustration: φ(x) ⊗ φ(x) ⊗ φ(x), with φ(x) = (1, x).',20,C.ink,'middle');
    svg('11-learning-curve',960,645,'A tensor model learns a curve','Two plots show the same synthetic cubic reference and twenty-one noisy observations. Updating sixteen parameters in three tensor-train cores changes the blue prediction curve. The training mean squared error decreases from approximately zero point three six four four to zero point zero zero zero two nine zero.',b);
  }
}
