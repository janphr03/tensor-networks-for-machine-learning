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

// A tensor as a book with separately addressable pages, rows, and columns.
{
  let b = text(35, 35, 'Three coordinates locate one entry', 26, C.ink, 'start', 'bold');
  for (let s = 0; s < 2; s++) {
    const x = 65 + s * 420, y = 95;
    b += curve('M' + (x - 20) + ',' + (y - 10) + ' Q' + (x + 90) + ',' + (y - 30)
      + ' ' + (x + 230) + ',' + (y - 10) + ' L' + (x + 230) + ',' + (y + 210)
      + ' Q' + (x + 90) + ',' + (y + 190) + ' ' + (x - 20) + ',' + (y + 210) + ' Z', C.light, 2, C.pale);
    b += curve('M' + (x - 5) + ',' + (y - 5) + ' Q' + (x + 110) + ',' + (y - 25)
      + ' ' + (x + 245) + ',' + (y - 5) + ' L' + (x + 245) + ',' + (y + 205)
      + ' Q' + (x + 110) + ',' + (y + 185) + ' ' + (x - 5) + ',' + (y + 205) + ' Z', C.gray, 1.5, C.white);
    for (let hole = 0; hole < 3; hole++) {
      b += curve('M' + (x - 15) + ',' + (y + 35 + 55 * hole) + ' q-22,-16 -25,1 q4,18 24,12', C.gray, 3);
    }
    b += text(x + 120, y + 10, 'page s = ' + (s + 1), 21, s === 0 ? C.blue : C.teal, 'middle', 'bold');
    b += text(x + 100, y + 45, 'v = 1', 18, C.gray, 'middle');
    b += text(x + 172, y + 45, 'v = 2', 18, C.gray, 'middle');
    for (let t = 0; t < 3; t++) {
      b += text(x + 25, y + 80 + t * 42, 't = ' + (t + 1), 18, C.gray);
      b += line(x + 72, y + 94 + t * 42, x + 205, y + 94 + t * 42, C.light, 1);
      for (let v = 0; v < 2; v++) {
        const cx = x + 100 + v * 72, cy = y + 80 + t * 42;
        if (s === 1 && t === 2 && v === 0) b += circle(cx, cy - 6, 18, '#FBE2D4', C.orange, 2);
        b += text(cx, cy, ledger[s][t][v], 23, s === 1 && t === 2 && v === 0 ? C.orange : C.ink, 'middle');
      }
    }
  }
  b += text(460, 345, 'X₂,₃,₁ = 11     ·     shape: 2 series × 3 times × 2 variables', 21, C.ink, 'middle');
  svg('01-indexed-ledger', 920, 375, 'An indexed ledger', 'Two ledger pages with three time rows and two variable columns; the entry at series two, time three, variable one is eleven.', b);
}

// Unfolding changes the address, not the recorded values.
{
  let b = text(30, 35, 'Change the address; keep every value', 26, C.ink, 'start', 'bold');
  b += text(140, 85, 'two pages', 20, C.gray, 'middle');
  b += matrix(ledger[1], 105, 110, 42, true, [2, 0]);
  b += matrix(ledger[0], 70, 85, 42, true);
  b += line(230, 165, 350, 165, C.gray, 3, false, true);
  b += text(290, 140, 'unfold', 18, C.gray, 'middle');
  b += matrix(ledger.map(page => page.flat()), 395, 105, 62, true, [1, 4]);
  b += text(580, 85, 'one row per series', 20, C.gray, 'middle');
  const labels = ['(1,1)', '(1,2)', '(2,1)', '(2,2)', '(3,1)', '(3,2)'];
  labels.forEach((label, j) => { b += text(426 + j * 62, 258, label, 17, C.gray, 'middle'); });
  b += text(580, 290, 'column address: (time, variable)', 20, C.gray, 'middle');
  b += text(460, 337, '2 × 3 × 2 entries  →  2 × 6 entries     ·     twelve values in both views', 21, C.ink, 'middle');
  svg('02-unfolding-pages', 920, 370, 'Unfolding the ledger', 'A three-way tensor is unfolded into a two-by-six matrix with explicitly ordered column pairs. The value eleven moves to row two, column five.', b);
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
