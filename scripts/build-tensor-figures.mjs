import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {buildNetworkFigures} from './tensor-figure-scenes.mjs';
import {
  ledger, outer, outerU, outerV, rankComparison, contributions, factorCalculation,
  patternMatrix, contractionCosts, trainIllustration, trainingData
} from './tensor-examples.mjs';

const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const outDir = path.join(projectRoot, 'figures', 'tensors');
fs.mkdirSync(outDir, {recursive: true});
const C = {ink: '#173552', blue: '#2166AC', teal: '#008C82', orange: '#D46B32',
  gray: '#617185', light: '#E8EEF4', pale: '#F5F8FB', white: '#FFFFFF'};
const esc = s => String(s).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
const fmt = n => Math.abs(n) < 1e-10 ? '0' : Number(n.toFixed(2)).toString();
function text(x, y, value, size = 20, fill = C.ink, anchor = 'start', weight = 'normal') {
  return '<text x="' + x + '" y="' + y + '" font-size="' + size + '" fill="' + fill
    + '" text-anchor="' + anchor + '" font-weight="' + weight + '">' + esc(value) + '</text>';
}
function line(x1, y1, x2, y2, color = C.gray, width = 2, dashed = false, arrow = false) {
  return '<line x1="' + x1 + '" y1="' + y1 + '" x2="' + x2 + '" y2="' + y2
    + '" stroke="' + color + '" stroke-width="' + width + '"'
    + (dashed ? ' stroke-dasharray="6 5"' : '') + (arrow ? ' marker-end="url(#arrow)"' : '') + '/>';
}
function curve(d, color = C.gray, width = 2, fill = 'none', dashed = false) {
  return '<path d="' + d + '" stroke="' + color + '" stroke-width="' + width + '" fill="' + fill
    + '"' + (dashed ? ' stroke-dasharray="6 5"' : '') + '/>';
}
function circle(x, y, r, fill = C.blue, stroke = C.white, width = 2) {
  return '<circle cx="' + x + '" cy="' + y + '" r="' + r + '" fill="' + fill
    + '" stroke="' + stroke + '" stroke-width="' + width + '"/>';
}
function rect(x, y, w, h, fill = 'none', stroke = C.light, width = 1) {
  return '<rect x="' + x + '" y="' + y + '" width="' + w + '" height="' + h
    + '" fill="' + fill + '" stroke="' + stroke + '" stroke-width="' + width + '"/>';
}
function node(x, y, name, color = C.blue, r = 24) {
  return circle(x, y, r, color) + text(x, y + 7, name, 21, C.white, 'middle', 'bold');
}
function matrix(m, x, y, cell, numbers = true, highlight = null) {
  let result = '';
  for (let i = 0; i < m.length; i++) for (let j = 0; j < m[0].length; j++) {
    const selected = highlight && highlight[0] === i && highlight[1] === j;
    result += rect(x + j * cell, y + i * cell, cell, cell, selected ? '#FBE2D4' : C.pale, C.white, 2);
    if (numbers) result += text(x + (j + 0.5) * cell, y + (i + 0.66) * cell, fmt(m[i][j]), 20, selected ? C.orange : C.ink, 'middle');
  }
  return result;
}
const manifest = [];
function svg(name, w, h, title, description, body) {
  const xml = '<svg xmlns="http://www.w3.org/2000/svg" width="' + w + '" height="' + h
    + '" viewBox="0 0 ' + w + ' ' + h + '" role="img" aria-labelledby="title description">'
    + '<title id="title">' + esc(title) + '</title><desc id="description">' + esc(description) + '</desc>'
    + '<defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">'
    + '<path d="M0,0 L8,4 L0,8 z" fill="' + C.gray + '"/></marker></defs>'
    + '<rect width="' + w + '" height="' + h + '" fill="white"/>'
    + '<g font-family="Arial, Helvetica, sans-serif" stroke-linecap="round" stroke-linejoin="round">'
    + body + '</g></svg>';
  fs.writeFileSync(path.join(outDir, name + '.svg'), xml, 'utf8');
  manifest.push({name, width: w, height: h, title, description});
}

// A spatial stack makes the location index visible as depth.
{
  let b=text(35,35,'One table per location: stack the tables to form a tensor',25,C.ink,'start','bold');
  // Front: location 2. Back: location 1. The grid has 2 × 3 × 2 cells.
  b+=curve('M200,170 L320,90 L640,90 L520,170 Z',C.gray,2,'#E5F4F1');
  b+=curve('M520,170 L640,90 L640,330 L520,410 Z',C.gray,2,'#D5E9E6');
  b+=line(360,170,480,90,C.gray,1.5);
  b+=line(260,130,580,130,C.gray,1.5);
  b+=line(580,130,580,370,C.gray,1.5);
  [250,330].forEach(y=>{b+=line(520,y,640,y-80,C.gray,1.5);});
  b+=rect(200,170,320,240,C.pale,C.teal,3);
  b+=rect(201,331,158,78,'#FBE2D4','none');
  b+=line(360,170,360,410,C.gray,1.5);
  [250,330].forEach(y=>{b+=line(200,y,520,y,C.gray,1.5);});
  for(let t=0;t<3;t++) for(let v=0;v<2;v++) {
    const chosen=t===2&&v===0;
    b+=text(280+v*160,220+t*80,ledger[1][t][v],chosen?31:25,chosen?C.orange:C.ink,'middle',chosen?'bold':'normal');
  }
  // Separate geometric directions for day, variable, and location.
  b+=line(145,170,145,425,C.blue,2.5,false,true);
  b+=text(130,145,'Day (t)',21,C.blue,'end','bold');
  [210,290,370].forEach((y,i)=>{
    b+=line(138,y,152,y,C.blue,2);
    b+=text(125,y+7,'Day '+(i+1),20,C.blue,'end');
  });
  b+=line(200,455,535,455,C.gray,2.5,false,true);
  [280,440].forEach(x=>{b+=line(x,449,x,462,C.gray,2);});
  b+=text(280,490,'Temperature',20,C.ink,'middle');
  b+=text(280,516,'v = 1',18,C.gray,'middle');
  b+=text(440,490,'Humidity',20,C.ink,'middle');
  b+=text(440,516,'v = 2',18,C.gray,'middle');
  b+=text(360,551,'Variable (v)',21,C.ink,'middle','bold');
  b+=line(790,97,650,190,C.teal,2.5,false,true);
  b+=line(763,99,777,121,C.teal,2);
  b+=line(643,179,657,201,C.teal,2);
  b+=text(745,70,'Location (s)',21,C.teal,'start','bold');
  b+=text(790,140,'1: back layer',20,C.teal);
  b+=text(670,220,'2: front layer',20,C.teal);
  b+=text(720,350,'Highlighted cell:',20,C.gray,'middle');
  b+=text(720,385,'11 °C',30,C.orange,'middle','bold');
  b+=text(720,421,'Location 2',20,C.ink,'middle');
  b+=text(720,449,'Day 3',20,C.ink,'middle');
  b+=text(720,477,'Temperature',20,C.ink,'middle');
  b+=text(460,601,'X₂,₃,₁ = 11     ·     2 locations × 3 days × 2 variables',22,C.ink,'middle');
  svg('01-indexed-ledger',920,625,'A tensor as a stack of location tables','A three-dimensional two-by-three-by-two block has location as depth, day as height, and variable as width. Its front layer, location two, displays readings seven to twelve. The orange cell is temperature on day three at location two, eleven degrees Celsius. Separate arrows identify all three index directions. Values are invented.',b);
}

// Holding indices fixed selects a slice and then a fiber from the same data.
{
  let b='';
  [['Tensor',150,'Order 3'],['Slice',475,'Order 2'],['Fiber',800,'Order 1']].forEach(([name,x,order])=>{
    b+=text(x,30,name,25,C.ink,'middle','bold');
    b+=text(x,62,order,21,C.gray,'middle');
  });
  b+=curve('M50,110 L95,80 L255,80 L210,110 Z',C.gray,1.5,'#E5F4F1');
  b+=curve('M210,110 L255,80 L255,224 L210,254 Z',C.gray,1.5,'#D5E9E6');
  b+=line(130,110,175,80,C.gray,1);
  b+=line(72.5,95,232.5,95,C.gray,1);
  b+=line(232.5,95,232.5,239,C.gray,1);
  [158,206].forEach(y=>{b+=line(210,y,255,y-30,C.gray,1);});
  const slice=ledger[1];
  slice.forEach((row,t)=>row.forEach((value,v)=>{
    b+=rect(50+v*80,110+t*48,80,48,'#E5F4F1',C.gray,1);
    b+=text(90+v*80,141+t*48,value,21,C.ink,'middle');
    b+=rect(395+v*80,110+t*48,80,48,v===0?'#FBE2D4':C.pale,C.white,2);
    b+=text(435+v*80,141+t*48,value,21,v===0?C.orange:C.ink,'middle');
  }));
  b+=rect(50,110,160,144,'none',C.teal,2.5);
  b+=rect(395,110,160,144,'none',C.teal,2.5);
  b+=line(275,182,365,182,C.gray,2.5,false,true);
  b+=text(320,125,'Fix location 2',18,C.teal,'middle');
  b+=line(585,182,700,182,C.gray,2.5,false,true);
  b+=text(640,125,'Fix temperature',18,C.orange,'middle');
  slice.forEach((row,t)=>{
    b+=rect(765,110+t*48,70,48,'#FBE2D4',C.white,2);
    b+=text(800,141+t*48,row[0],21,C.orange,'middle');
    b+=text(750,140+t*48,'Day '+(t+1),17,C.gray,'end');
  });
  b+=rect(765,110,70,144,'none',C.orange,2.5);
  b+=text(150,286,'2 × 3 × 2',22,C.ink,'middle');
  b+=text(475,286,'3 × 2',22,C.ink,'middle');
  b+=text(800,286,'3',22,C.ink,'middle');
  b+=text(150,327,'Free: location, day, variable',18,C.gray,'middle');
  b+=text(475,327,'Free: day, variable',18,C.gray,'middle');
  b+=text(800,327,'Free: day',18,C.gray,'middle');
  svg('01b-order-slice-fiber',920,350,'From tensor to slice to fiber','The original tensor has order three and shape two by three by two. Fixing location two selects a three-by-two matrix slice containing rows seven-eight, nine-ten, and eleven-twelve. Fixing temperature as well selects the day fiber seven, nine, eleven, which has order one. The remaining free indices are listed below each view.',b);
}

// Unfolding changes the address, not the recorded values.
{
  let b=text(656,30,'One matrix',24,C.ink,'middle','bold');
  ledger.forEach((page,s)=>{
    const x=45+s*150, color=s===0?C.blue:C.teal;
    const locationFill=s===0?'#E8F0F8':'#E5F4F1';
    b+=text(x+45,30,'Location '+(s+1),22,color,'middle','bold');
    page.forEach((row,t)=>{
      row.forEach((value,v)=>{
        const selected=s===1&&t===2&&v===0;
        const fill=selected?'#FBE2D4':locationFill;
        const ink=selected?C.orange:color;
        b+=rect(x+v*45,54+t*32,45,32,fill,C.white,2);
        b+=text(x+22.5+v*45,77+t*32,value,21,ink,'middle',selected?'bold':'normal');
        const col=2*t+v, destY=62+s*44;
        b+=rect(440+col*72,destY,72,44,fill,C.white,2);
        b+=text(476+col*72,destY+30,value,23,ink,'middle',selected?'bold':'normal');
      });
    });
  });
  b+=line(325,103,405,103,C.gray,3,false,true);
  svg('02-unfolding-pages',920,170,'Each location table becomes one matrix row','Two small three-by-two location tables stand side by side on the left. One arrow leads to a two-by-six matrix on the right. Blue location one becomes the first row, containing one through six. Teal location two becomes the second row, containing seven through twelve. Eleven stays highlighted orange in both views. All twelve values are preserved.',b);
}

// One shared row replaces separately learned copies of the same pattern.
{
  // Small outline of a physical weight; every icon marks a learned parameter.
  const weightIcon=(x,y,color)=>
    circle(x+8,y+4,3,'none',color,1.3)
    +curve('M'+(x+3)+','+(y+7)+' L'+(x+13)+','+(y+7)+' L'+(x+16)+','+(y+18)+' L'+x+','+(y+18)+' Z',color,1.2,color);
  let b=text(225,30,'12 separate weights',26,C.blue,'middle','bold');
  b+=text(715,30,'7 factor weights',26,C.teal,'middle','bold');
  b+=text(540,65,'u',20,C.teal,'middle');
  b+=text(752.5,65,'v',20,C.teal,'middle');
  outer.forEach((row,i)=>{
    row.forEach((value,j)=>{
      const x=45+j*90,y=80+i*60, selected=i===1&&j===2;
      const color=selected?C.orange:C.blue;
      b+=rect(x,y,85,50,selected?'#FBE2D4':C.pale,color,selected?2.5:1.5);
      b+=weightIcon(x+65,y+7,color);
      b+=text(x+34,y+34,fmt(value),24,color,'middle','bold');
    });
  });
  outerU.forEach((value,i)=>{
    const y=80+i*60, selected=i===1, color=selected?C.orange:C.teal;
    b+=rect(510,y,60,50,selected?'#FBE2D4':C.pale,color,selected?2.5:1.5);
    b+=weightIcon(550,y+7,color);
    b+=text(532,y+34,fmt(value),24,color,'middle','bold');
  });
  outerV.forEach((value,j)=>{
    const x=625+j*65, selected=j===2, color=selected?C.orange:C.teal;
    b+=rect(x,80,60,50,selected?'#FBE2D4':C.pale,color,selected?2.5:1.5);
    b+=weightIcon(x+40,87,color);
    b+=text(x+22,114,fmt(value),24,color,'middle','bold');
  });
  svg('03-outer-product-loom',920,270,'Twelve weight symbols versus seven, with one matching factor pair highlighted','Each box contains a numeric weight value and a small physical-weight symbol marking a learned parameter. Left: twelve separate weights in a three-by-four table, with the weight twelve highlighted orange. Right: three multiplier weights u and four shared weights v, seven parameters total. The matching factors two and six are highlighted orange. Only counts and the labels u and v appear; there are no explanatory sentences or calculation steps.',b);
}

// The second matrix needs a second base row: one altered entry breaks proportionality.
{
  let b='';
  [rankComparison.rankOne,rankComparison.rankTwo].forEach((values,panel)=>{
    const x=90+panel*460, center=x+130;
    b+=text(center,28,'Rank '+(panel+1),25,C.ink,'middle','bold');
    values.forEach((row,i)=>row.forEach((value,j)=>{
      const base=i===0, extra=panel===1&&i===1, changed=extra&&j===3;
      const color=changed?'#B53E32':extra?'#B98D87':base?C.blue:C.gray;
      const fill=changed?'#F8D4CE':extra?'#FBF3F1':base?'#DDEBF6':C.pale;
      b+=rect(x+j*65,52+i*45,60,40,fill,color,changed?2.5:base?1.5:0.7);
      b+=text(x+30+j*65,79+i*45,value,21,color,'middle',base||changed?'bold':'normal');
    }));
    b+=text(center,224,panel===0?'1 base row':'2 base rows',21,C.ink,'middle');
  });
  svg('03b-rank-comparison',920,245,'One base row or two: matrix ranks one and two','Two three-by-four matrices are compared. Left: all rows follow one blue base row, so the rank is one. Right: changing the second row last entry from 16 to 17 requires a second base row. Its unchanged values 4,8,12 are muted red; the changed 17 is strongly highlighted in red. The third row is still three times the first, so two base rows suffice and the rank is exactly two.',b);
}

// Reuse the known seven factors to calculate three outputs without building W.
{
  let b='';
  [[80,'Inputs x'],[225,'Weights v'],[445,'Sum'],[665,'Factors u'],[820,'Outputs y']].forEach(([x,label])=>{
    b+=text(x,30,label,23,C.ink,'middle','bold');
  });
  factorCalculation.input.forEach((value,j)=>{
    const y=84+j*44;
    b+=rect(50,y-18,60,36,C.pale,C.blue,1.5);
    b+=text(80,y+8,value,23,C.blue,'middle');
    b+=text(155,y+8,'×',26,C.gray,'middle');
    b+=rect(195,y-18,60,36,'#E5F4F1',C.teal,1.5);
    b+=text(225,y+8,outerV[j],23,C.teal,'middle');
    b+=curve('M270,'+y+' C330,'+y+' 350,150 410,150',C.gray,2);
  });
  b+=circle(445,150,34,'#FBE2D4',C.orange,2);
  b+=text(445,160,factorCalculation.sharedSum,29,C.orange,'middle','bold');
  b+=text(375,140,'Σ',25,C.gray,'middle');
  outerU.forEach((value,i)=>{
    const y=90+i*60;
    b+=curve('M480,150 C535,150 535,'+y+' 590,'+y,C.gray,2);
    b+=text(615,y+8,'×',26,C.gray,'middle');
    b+=rect(640,y-19,50,38,'#E5F4F1',C.teal,1.5);
    b+=text(665,y+8,value,23,C.teal,'middle');
    b+=line(705,y,770,y,C.gray,2,false,true);
    b+=rect(785,y-19,70,38,C.pale,C.blue,1.5);
    b+=text(820,y+8,factorCalculation.outputs[i],23,C.blue,'middle','bold');
  });
  svg('04-contraction-lanes',920,250,'Calculating directly with seven factors','Four inputs one, two, three, four are paired with the shared weights two, four, six, eight. Multiplying the pairs and adding produces the shared sum sixty. Multipliers one, two, three turn that sum into outputs sixty, one hundred twenty, one hundred eighty. No full weight matrix is built.',b);
}

// Exact SVD-built pattern: the numerical panels use known orthonormal modes.
function heatColor(value) {
  const t = Math.max(-1, Math.min(1, value / 2.8));
  const base = t >= 0 ? [33, 102, 172] : [212, 107, 50];
  const strength = Math.abs(t) * 0.9;
  return 'rgb(' + base.map(c => Math.round(255 * (1 - strength) + c * strength)).join(',') + ')';
}
{
  let b = '';
  const ranks = [3, 1, 2, 3], titles = ['Original', '1 pattern', '2 patterns', '3 patterns'];
  for (let p = 0; p < 4; p++) {
    const x = 25 + 230 * p, y = 50, m = patternMatrix(ranks[p]);
    b += text(x + 72, 28, titles[p], 23, C.ink, 'middle', 'bold');
    for (let i = 0; i < 8; i++) for (let j = 0; j < 8; j++)
      b += rect(x + j * 18, y + i * 18, 18, 18, heatColor(m[i][j]), C.white, 0.7);
  }
  svg('05-svd-pattern-layers', 920, 215, 'Reconstruction with one, two, or three SVD patterns', 'Four compact eight-by-eight heatmaps show an original rank-three matrix and the sums of its first one, two, or three SVD patterns. All panels use the same color scale. Three patterns reproduce the original exactly. The singular values are nine, three and one.', b);
}

const training = trainIllustration();
buildNetworkFigures({svg, text, line, curve, circle, rect, node, matrix, C, contractionCosts, training, trainingData});
fs.writeFileSync(path.join(outDir, 'manifest.json'), JSON.stringify({figures: manifest, numericalData: {ledger, outer, rankComparison, contributions, factorCalculation, contractionCosts, training}}, null, 2) + '\n');
console.log('Built ' + manifest.length + ' original vector figures.');
