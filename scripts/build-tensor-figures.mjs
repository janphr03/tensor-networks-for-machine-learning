import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {buildNetworkFigures} from './tensor-figure-scenes.mjs';
import {
  ledger, outer, outerU, outerV, contributions, dotA, dotB,
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
  let b = text(30, 35, 'Change the address; keep every value', 26, C.ink, 'start', 'bold');
  b += text(140, 65, 'two locations', 20, C.gray, 'middle');
  b += matrix(ledger[1], 105, 110, 42, true, [2, 0]);
  b += matrix(ledger[0], 70, 85, 42, true);
  b += line(230, 165, 350, 165, C.gray, 3, false, true);
  b += text(290, 140, 'unfold', 18, C.gray, 'middle');
  b += matrix(ledger.map(page => page.flat()), 395, 105, 62, true, [1, 4]);
  b += text(580, 85, 'one row per location', 20, C.gray, 'middle');
  const labels = ['(1,1)', '(1,2)', '(2,1)', '(2,2)', '(3,1)', '(3,2)'];
  labels.forEach((label, j) => { b += text(426 + j * 62, 258, label, 17, C.gray, 'middle'); });
  b += text(580, 290, 'column address: (day, variable)', 20, C.gray, 'middle');
  b += text(460, 337, '2 × 3 × 2 entries  →  2 × 6 entries     ·     twelve values in both views', 21, C.ink, 'middle');
  svg('02-unfolding-pages', 920, 370, 'Unfolding the location tables', 'A three-way tensor is unfolded into a two-by-six matrix with one row per location and explicitly ordered day-variable column pairs. The value eleven moves to row two, column five.', b);
}

// Outer products: all crossings are retained; no crossings are added together.
{
  let b = text(30, 35, 'A woven table of all pairwise products', 26, C.ink, 'start', 'bold');
  for (let j = 0; j < 3; j++) {
    const x = 330 + j * 175;
    b += line(x, 95, x, 305, C.teal, 12);
    b += text(x, 80, 'v' + (j + 1) + ' = ' + outerV[j], 21, C.teal, 'middle');
  }
  for (let i = 0; i < 2; i++) {
    const y = 155 + i * 115;
    b += line(215, y, 805, y, C.blue, 12);
    b += text(170, y + 6, 'u' + (i + 1) + ' = ' + outerU[i], 21, C.blue, 'end');
    for (let j = 0; j < 3; j++)
      b += circle(330 + j * 175, y, 32, C.white, C.orange, 3)
        + text(330 + j * 175, y + 8, outer[i][j], 26, C.orange, 'middle', 'bold');
  }
  b += text(460, 360, 'Each crossing keeps its own address: Mᵢⱼ = uᵢ vⱼ', 22, C.ink, 'middle');
  svg('03-outer-product-loom', 920, 400, 'The outer product as a loom', 'Two blue row threads and three teal column threads form six crossings, containing three, four, five, six, eight, and ten. No summation occurs.', b);
}

// Contraction: matching the index means multiply within lanes, then sum.
{
  let b = text(30, 35, 'Match each lane, then add its signed contribution', 26, C.ink, 'start', 'bold');
  b += text(170, 83, 'aₖ', 22, C.blue, 'middle') + text(320, 83, 'bₖ', 22, C.teal, 'middle');
  const ys = [130, 215, 300];
  ys.forEach((y, k) => {
    b += text(35, y + 7, 'k = ' + (k + 1), 19, C.gray);
    b += circle(170, y, 27, C.blue) + text(170, y + 8, dotA[k], 24, C.white, 'middle');
    b += text(244, y + 7, '×', 30, C.gray, 'middle');
    b += circle(320, y, 27, C.teal) + text(320, y + 8, dotB[k], 24, C.white, 'middle');
    b += line(360, y, 450, y, C.gray, 2, false, true);
    b += circle(500, y, 31, k === 1 ? C.orange : C.blue);
    b += text(500, y + 8, contributions[k] > 0 ? '+' + contributions[k] : contributions[k], 24, C.white, 'middle');
    b += curve('M535,' + y + ' C610,' + y + ' 645,215 685,215', k === 1 ? C.orange : C.blue, 3);
  });
  b += curve('M681,187 Q704,180 725,187 L731,270 Q704,295 675,270 Z', C.ink, 3, C.pale);
  b += text(704, 233, '8', 32, C.ink, 'middle', 'bold');
  b += text(790, 213, '4 − 2 + 6', 21, C.ink) + text(790, 245, '= 8', 25, C.ink);
  b += text(460, 370, 'The index k is used internally; the result has no k-axis.', 21, C.ink, 'middle');
  svg('04-contraction-lanes', 960, 410, 'Contraction as matching lanes', 'Three lanes show products four, minus two, and six. They merge to the scalar eight. The orange lane is a negative algebraic contribution, not a negative amount of physical material.', b);
}

// Exact SVD-built pattern: the numerical panels use known orthonormal modes.
function heatColor(value) {
  const t = Math.max(-1, Math.min(1, value / 2.8));
  const base = t >= 0 ? [33, 102, 172] : [212, 107, 50];
  const strength = Math.abs(t) * 0.9;
  return 'rgb(' + base.map(c => Math.round(255 * (1 - strength) + c * strength)).join(',') + ')';
}
{
  let b = text(30, 35, 'Reconstruct a pattern by retaining more separable layers', 25, C.ink, 'start', 'bold');
  const ranks = [3, 1, 2, 3], titles = ['Original pattern', 'One layer', 'Two layers', 'All three layers'];
  const errors = ['reference', 'error = √10', 'error = 1', 'error = 0'];
  for (let p = 0; p < 4; p++) {
    const x = 35 + 230 * p, y = 105, m = patternMatrix(ranks[p]);
    b += text(x + 92, 82, titles[p], 20, C.ink, 'middle', 'bold');
    for (let i = 0; i < 8; i++) for (let j = 0; j < 8; j++)
      b += rect(x + j * 23, y + i * 23, 23, 23, heatColor(m[i][j]), C.white, 0.7);
    b += text(x + 92, 318, errors[p], 20, C.gray, 'middle');
  }
  b += text(35, 374, 'Layer strength', 21, C.ink);
  [9, 3, 1].forEach((s, k) => {
    b += line(250, 369 + 37 * k, 250 + s * 42, 369 + 37 * k, [C.blue, C.teal, C.orange][k], 16);
    b += text(665, 376 + 37 * k, 'σ' + (k + 1) + ' = ' + s, 21, C.ink);
  });
  b += text(470, 512, 'The scale and colours are identical in all four panels.', 19, C.gray, 'middle');
  svg('05-svd-pattern-layers', 960, 545, 'SVD as layers of a pattern', 'Four eight-by-eight heatmaps show an original rank-three matrix and its rank-one, rank-two and rank-three SVD reconstructions. The singular values are nine, three and one.', b);
}

const training = trainIllustration();
buildNetworkFigures({svg, text, line, curve, circle, rect, node, matrix, C, contractionCosts, training, trainingData});
fs.writeFileSync(path.join(outDir, 'manifest.json'), JSON.stringify({figures: manifest, numericalData: {ledger, outer, contributions, contractionCosts, training}}, null, 2) + '\n');
console.log('Built ' + manifest.length + ' original vector figures.');
