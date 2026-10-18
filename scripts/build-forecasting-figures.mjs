import fs from 'node:fs';
import './build-simple-forecasting-figures.mjs';
import './build-learning-model-figures.mjs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {
  hourlyTracks, components, memoryExample, randomWalk, windowExample, baselineExample,
  fitExample, patchSeries, miniSeries, newSeries, windowValues, linearExample, linearPrediction
} from './forecasting-examples.mjs';

// Teaching figures for Sections 2.1 and 2.2, drawn in the style of figures/tensors.
const projectRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const outDir = path.join(projectRoot, 'figures', 'forecasting');
fs.mkdirSync(outDir, {recursive: true});
const C = {ink: '#173552', blue: '#2166AC', teal: '#008C82', orange: '#D46B32',
  gray: '#617185', light: '#E8EEF4', pale: '#F5F8FB', white: '#FFFFFF',
  blueWash: '#DCE9F5', orangeWash: '#FBE2D4', tealWash: '#D7EFEC'};
const esc = s => String(s).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');
const f1 = n => n.toFixed(1), f2 = n => n.toFixed(2);

function text(x, y, value, size = 20, fill = C.ink, anchor = 'start', weight = 'normal') {
  return '<text x="' + x + '" y="' + y + '" font-size="' + size + '" fill="' + fill
    + '" text-anchor="' + anchor + '" font-weight="' + weight + '">' + esc(value) + '</text>';
}
// Base text with a lowered, smaller index, e.g. x with index t-1.
function sub(x, y, base, index, size = 20, fill = C.ink, anchor = 'middle', weight = 'normal') {
  const small = Math.round(size * 0.68);
  return '<text x="' + x + '" y="' + y + '" font-size="' + size + '" fill="' + fill
    + '" text-anchor="' + anchor + '" font-weight="' + weight + '">' + esc(base)
    + '<tspan dy="' + Math.round(size * 0.3) + '" font-size="' + small + '">' + esc(index) + '</tspan></text>';
}
function line(x1, y1, x2, y2, color = C.gray, width = 2, dashed = false, arrow = null) {
  return '<line x1="' + x1 + '" y1="' + y1 + '" x2="' + x2 + '" y2="' + y2
    + '" stroke="' + color + '" stroke-width="' + width + '"'
    + (dashed ? ' stroke-dasharray="6 5"' : '') + (arrow ? ' marker-end="url(#' + arrow + ')"' : '') + '/>';
}
function curve(d, color = C.gray, width = 2, fill = 'none', dashed = false, arrow = null, extra = '') {
  return '<path d="' + d + '" stroke="' + color + '" stroke-width="' + width + '" fill="' + fill
    + '"' + (dashed ? ' stroke-dasharray="6 5"' : '') + (arrow ? ' marker-end="url(#' + arrow + ')"' : '') + extra + '/>';
}
function circle(x, y, r, fill = C.blue, stroke = C.white, width = 2) {
  return '<circle cx="' + x + '" cy="' + y + '" r="' + r + '" fill="' + fill
    + '" stroke="' + stroke + '" stroke-width="' + width + '"/>';
}
function rect(x, y, w, h, fill = 'none', stroke = C.light, width = 1, rx = 0) {
  return '<rect x="' + x + '" y="' + y + '" width="' + w + '" height="' + h + '" rx="' + rx
    + '" fill="' + fill + '" stroke="' + stroke + '" stroke-width="' + width + '"/>';
}
function cell(x, y, w, h, label, fill, stroke, size = 20, color = C.ink) {
  return rect(x, y, w, h, fill, stroke, 2, 6) + text(x + w / 2, y + h / 2 + size * 0.35, label, size, color, 'middle');
}
function poly(points, px, py) {
  return points.map((p, i) => (i ? 'L' : 'M') + px(p[0]).toFixed(1) + ',' + py(p[1]).toFixed(1)).join(' ');
}
const indexed = values => values.map((v, i) => [i, v]);

// Plot frame with light horizontal grid, baseline, and tick labels.
function frame({x0, y0, w, h, xmin, xmax, ymin, ymax, xticks = [], yticks = [], xfmt = String, yfmt = String,
  xlabel = '', ylabel = '', size = 16, xLabelsShown = true}) {
  const px = v => x0 + (v - xmin) / (xmax - xmin) * w;
  const py = v => y0 + h - (v - ymin) / (ymax - ymin) * h;
  let b = '';
  yticks.forEach(v => {
    b += line(x0, py(v), x0 + w, py(v), C.light, 1);
    b += text(x0 - 10, py(v) + 6, yfmt(v), size, C.gray, 'end');
  });
  b += line(x0, y0 + h, x0 + w, y0 + h, C.gray, 1.5);
  xticks.forEach(v => {
    b += line(px(v), y0 + h, px(v), y0 + h + 5, C.gray, 1.5);
    if (xLabelsShown) b += text(px(v), y0 + h + 24, xfmt(v), size, C.gray, 'middle');
  });
  if (xlabel) b += text(x0 + w, y0 + h + 50, xlabel, 17, C.gray, 'end');
  if (ylabel) b += text(x0, y0 - 14, ylabel, 17, C.gray);
  return {b, px, py};
}

const manifest = [];
const markers = [['arrow', C.gray], ['arrowInk', C.ink], ['arrowTeal', C.teal], ['arrowOrange', C.orange], ['arrowBlue', C.blue]];
function svg(name, w, h, title, description, body, defs = '') {
  const markerDefs = markers.map(([id, color]) => '<marker id="' + id + '" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto">'
    + '<path d="M0,0 L8,4 L0,8 z" fill="' + color + '"/></marker>').join('');
  const xml = '<svg xmlns="http://www.w3.org/2000/svg" width="' + w + '" height="' + h
    + '" viewBox="0 0 ' + w + ' ' + h + '" role="img" aria-labelledby="title description">'
    + '<title id="title">' + esc(title) + '</title><desc id="description">' + esc(description) + '</desc>'
    + '<defs>' + markerDefs + defs + '</defs>'
    + '<rect width="' + w + '" height="' + h + '" fill="white"/>'
    + '<g font-family="Arial, Helvetica, sans-serif" stroke-linecap="round" stroke-linejoin="round">'
    + body + '</g></svg>';
  fs.writeFileSync(path.join(outDir, name + '.svg'), xml, 'utf8');
  manifest.push({name, width: w, height: h, title, description});
}
const numbers = {};

// 00 Roadmap of the theoretical background.
{
  let b = text(30, 38, 'How the foundations build on each other', 26, C.ink, 'start', 'bold');
  const box = (x, y, w, h, num, lines, stroke) => {
    let s = rect(x, y, w, h, stroke === C.gray ? C.pale : C.white, stroke, 2.5, 10);
    s += text(x + 16, y + 30, num, 19, stroke, 'start', 'bold');
    lines.forEach((l, i) => { s += text(x + 16, y + 57 + i * 23, l, 18, C.ink); });
    return s;
  };
  b += box(24, 176, 160, 100, '2.1', ['Time series', 'and the task'], C.gray);
  b += box(228, 74, 540, 96, '2.2', ['Established methods: baselines, lag features,', 'trees, neural networks, pretrained models'], C.ink);
  [['2.3', 'Why', 'tensors?'], ['2.4', 'Tensor', 'mathematics'], ['2.5', 'Tensor', 'networks'], ['2.6', 'Tensor', 'models']]
    .forEach(([n, a, c], i) => { b += box(228 + i * 140, 290, 124, 100, n, [a, c], C.teal); });
  b += box(808, 126, 128, 100, '2.7', ['Fair', 'evaluation'], C.orange);
  b += box(808, 290, 128, 100, '2.8', ['Evidence', 'and gap'], C.orange);
  b += curve('M184,206 C206,206 204,122 224,122', C.gray, 2.5, 'none', false, 'arrow');
  b += curve('M184,246 C206,246 204,340 224,340', C.gray, 2.5, 'none', false, 'arrow');
  [352, 492, 632].forEach(x => { b += line(x, 340, x + 12, 340, C.teal, 2.5, false, 'arrowTeal'); });
  b += curve('M768,122 C790,122 786,166 804,166', C.ink, 2.5, 'none', false, 'arrowInk');
  b += curve('M752,290 C770,250 782,206 804,198', C.teal, 2.5, 'none', false, 'arrowTeal');
  b += line(872, 226, 872, 286, C.orange, 2.5, false, 'arrowOrange');
  b += text(228, 62, 'machine-learning route', 17, C.ink, 'start', 'bold');
  b += text(228, 418, 'tensor route', 17, C.teal, 'start', 'bold');
  b += text(808, 112, 'both routes meet', 17, C.orange, 'start', 'bold');
  svg('00-roadmap', 960, 440, 'Structure of the theoretical background',
    'Section 2.1 leads to two routes: established methods in Section 2.2, and the tensor route through Sections 2.3 to 2.6. Both routes meet in fair evaluation, Section 2.7, and the evidence review, Section 2.8.', b);
}

// 01 Three tracks measured at the same hours.
{
  const {temp, hum, wind} = hourlyTracks();
  numbers.x30 = temp[30];
  let b = text(30, 38, 'Measurements in time order: three tracks', 26, C.ink, 'start', 'bold');
  const panels = [
    {y0: 92, h: 120, data: temp, ymin: 0, ymax: 12, yticks: [0, 4, 8, 12], name: 'Temperature', unit: '°C', dots: true},
    {y0: 262, h: 90, data: hum, ymin: 60, ymax: 100, yticks: [60, 80, 100], name: 'Humidity', unit: '% relative'},
    {y0: 402, h: 80, data: wind, ymin: 0, ymax: 6, yticks: [0, 3, 6], name: 'Wind speed', unit: 'm/s'},
  ];
  panels.forEach((p, k) => {
    const last = k === panels.length - 1;
    const fr = frame({x0: 230, y0: p.y0, w: 690, h: p.h, xmin: 0, xmax: 48, ymin: p.ymin, ymax: p.ymax,
      xticks: [0, 12, 24, 36, 48], yticks: p.yticks, xLabelsShown: last, xlabel: last ? 'time t (hours)' : ''});
    b += fr.b;
    b += text(30, p.y0 + p.h / 2, p.name, 18, C.ink, 'start', 'bold');
    b += text(30, p.y0 + p.h / 2 + 24, p.unit, 17, C.gray);
    b += curve(poly(indexed(p.data), fr.px, fr.py), C.blue, 2.5);
    if (p.dots) {
      p.data.forEach((v, t) => { b += circle(fr.px(t), fr.py(v), 4.2, C.blue, C.white, 1.5); });
      const hx = fr.px(30), hy = fr.py(p.data[30]);
      b += circle(hx, hy, 10, 'none', C.ink, 2);
      b += line(hx + 9, hy + 5, hx + 38, hy + 18, C.ink, 1.5);
      b += '<text x="' + (hx + 44) + '" y="' + (hy + 26) + '" font-size="19" fill="' + C.ink + '">x'
        + '<tspan dy="6" font-size="13">30</tspan><tspan dy="-6"> = ' + f1(p.data[30]) + ' °C</tspan></text>';
    }
  });
  svg('01-time-series-tracks', 960, 545, 'A multivariate time series',
    'Three invented tracks measured at the same 48 hours: temperature with one dot per hour, relative humidity, and wind speed. One temperature observation at hour 30 is highlighted.', b);
}

// 02 Observed series = trend + seasonality + noise.
{
  const {trend, season, noise, observed} = components();
  let b = text(30, 38, 'One observed series, three ingredients', 26, C.ink, 'start', 'bold');
  const panels = [
    {data: observed, ymin: 0, ymax: 12, yticks: [0, 6, 12], name: 'observed', sign: '', color: C.blue},
    {data: trend, ymin: 0, ymax: 12, yticks: [0, 6, 12], name: 'trend', sign: '=', color: C.ink},
    {data: season, ymin: -4, ymax: 4, yticks: [-4, 0, 4], name: 'seasonality', sign: '+', color: C.teal},
    {data: noise, ymin: -2, ymax: 2, yticks: [-2, 0, 2], name: 'noise', sign: '+', color: C.gray},
  ];
  panels.forEach((p, k) => {
    const y0 = 78 + k * 122, last = k === panels.length - 1;
    const fr = frame({x0: 230, y0, w: 690, h: 82, xmin: 0, xmax: 96, ymin: p.ymin, ymax: p.ymax,
      xticks: [0, 24, 48, 72, 96], yticks: p.yticks, xLabelsShown: last, xlabel: last ? 'time (hours)' : ''});
    b += fr.b;
    if (p.sign) b += text(40, y0 + 48, p.sign, 30, C.gray, 'middle', 'bold');
    b += text(70, y0 + 48, p.name, 19, C.ink, 'start', 'bold');
    b += curve(poly(indexed(p.data), fr.px, fr.py), p.color, p.color === C.gray ? 2 : 2.5);
  });
  svg('02-trend-season-noise', 960, 600, 'Trend, seasonality, and noise',
    'An invented hourly series over four days and its three additive ingredients: a rising trend, a daily seasonal cycle, and irregular noise.', b);
}

// 03 Memory: autocorrelation versus a random walk.
{
  const {acf} = memoryExample();
  const rw = randomWalk();
  numbers.acf = {lag1: acf[0], lag12: acf[11], lag24: acf[23], lag48: acf[47]};
  let b = text(30, 38, 'Memory decides what can be predicted', 26, C.ink, 'start', 'bold');
  b += text(90, 84, 'Strong memory: hourly temperature', 19, C.ink, 'start', 'bold');
  const fa = frame({x0: 90, y0: 124, w: 360, h: 240, xmin: 0, xmax: 49, ymin: -1, ymax: 1,
    xticks: [1, 12, 24, 36, 48], yticks: [-1, -0.5, 0, 0.5, 1], xlabel: 'lag k (hours)', ylabel: 'autocorrelation'});
  b += fa.b + line(90, fa.py(0), 450, fa.py(0), C.gray, 1.5);
  acf.forEach((v, i) => {
    const k = i + 1, x = fa.px(k) - 2.5, y = Math.min(fa.py(v), fa.py(0));
    b += rect(x.toFixed(1), y.toFixed(1), 5, Math.abs(fa.py(v) - fa.py(0)).toFixed(1), C.blue, 'none', 0);
  });
  [[24, '1 day'], [48, '2 days']].forEach(([k, label]) => {
    b += text(fa.px(k), fa.py(acf[k - 1]) - 12, label, 16, C.ink, 'middle');
  });

  b += text(560, 84, 'Little memory: a random walk', 19, C.ink, 'start', 'bold');
  const fb = frame({x0: 560, y0: 124, w: 300, h: 240, xmin: 0, xmax: 50, ymin: 0.98, ymax: 1.14,
    xticks: [0, 10, 20, 30, 40, 50], yticks: [1.0, 1.04, 1.08, 1.12], yfmt: v => v.toFixed(2), xlabel: 'step', ylabel: 'value'});
  b += fb.b;
  rw.futures.forEach(path => { b += curve(poly(path.map((v, s) => [30 + s, v]), fb.px, fb.py), C.gray, 1.6); });
  b += curve(poly(indexed(rw.hist), fb.px, fb.py), C.blue, 2.8);
  b += line(fb.px(30), fb.py(rw.naive), fb.px(50), fb.py(rw.naive), C.orange, 3.2);
  b += line(fb.px(30), 124, fb.px(30), 364, C.ink, 1.5, true);
  b += text(fb.px(30) - 8, 142, 'today', 16, C.ink, 'end');
  b += text(fb.px(50) + 8, fb.py(rw.naive) + 6, 'naive', 16, C.orange, 'start', 'bold');
  b += text(fb.px(15), fb.py(1.065), 'history', 16, C.blue, 'middle', 'bold');
  b += text(fb.px(50) + 8, fb.py(1.11) + 6, 'possible', 16, C.gray);
  b += text(fb.px(50) + 8, fb.py(1.11) + 26, 'futures', 16, C.gray);
  svg('03-memory-and-random-walk', 960, 440, 'Memory and the random walk',
    'Left: the autocorrelation of an invented hourly temperature series is high for short lags and peaks again at 24 and 48 hours. Right: a random walk history with five equally likely continuations; the naive forecast repeats the last value.', b);
}

// 04 Forecast origin, input window, and horizon.
{
  const {x, origin, L, H, forecast} = windowExample();
  let b = text(30, 38, 'At the forecast origin, only the past is known', 26, C.ink, 'start', 'bold');
  const fr = frame({x0: 90, y0: 110, w: 820, h: 250, xmin: 0, xmax: 84, ymin: 0, ymax: 18,
    xticks: [0, 12, 24, 36, 48, 60, 72, 84], yticks: [0, 6, 12, 18], xlabel: 'time (hours)', ylabel: '°C'});
  b += rect(fr.px(origin - L + 0.5), 110, fr.px(origin) - fr.px(origin - L + 0.5), 250, C.blueWash, 'none', 0);
  b += rect(fr.px(origin), 110, fr.px(origin + H) - fr.px(origin), 250, C.orangeWash, 'none', 0);
  b += fr.b;
  b += curve(poly(indexed(x.slice(0, origin + 1)), fr.px, fr.py), C.blue, 2.8);
  b += curve(poly(forecast.map((v, k) => [origin + 1 + k, v]), fr.px, fr.py), C.orange, 3.2);
  b += circle(fr.px(origin), fr.py(x[origin]), 5.5, C.blue, C.white, 2);
  b += line(fr.px(origin), 96, fr.px(origin), 360, C.ink, 2);
  b += text(fr.px(origin), 88, 'forecast origin t', 18, C.ink, 'middle', 'bold');
  b += text(fr.px(origin - L / 2), 136, 'input window:', 17, C.blue, 'middle', 'bold');
  b += text(fr.px(origin - L / 2), 158, 'last L = 24 values', 17, C.blue, 'middle');
  b += text(fr.px(origin + H / 2), 136, 'horizon H = 24:', 17, C.orange, 'middle', 'bold');
  b += text(fr.px(origin + H / 2), 158, 'unknown at time t', 17, C.orange, 'middle');
  b += text(fr.px(18), 136, 'known past', 17, C.gray, 'middle');
  b += text(fr.px(origin + H / 2), fr.py(0.5), 'forecast', 17, C.orange, 'middle', 'bold');
  svg('04-origin-window-horizon', 960, 440, 'Forecast origin, input window, and horizon',
    'An invented hourly series is known up to the forecast origin. The last 24 values form the input window. The next 24 hours form the horizon, where only a forecast exists.', b);
}

// 05 Chronological split and rolling origins.
{
  let b = text(30, 38, 'Split in time: learn, choose, test', 26, C.ink, 'start', 'bold');
  const x0 = 40, total = 880, y = 118, h = 50;
  const parts = [['training', 0.70, C.blueWash, ['learn the parameters']], ['validation', 0.15, C.light, ['choose', 'settings']],
    ['test', 0.15, C.orangeWash, ['final check', '(used once)']]];
  let x = x0;
  parts.forEach(([name, share, fill, role]) => {
    const w = total * share;
    b += rect(x, y, w, h, fill, C.white, 3);
    b += text(x + w / 2, y + 32, name, 19, C.ink, 'middle', 'bold');
    role.forEach((r, i) => { b += text(x + w / 2, role.length === 1 ? 104 : 82 + i * 22, r, 17, C.ink, 'middle'); });
    x += w;
  });
  b += line(x0, 190, x0 + total, 190, C.gray, 2, false, 'arrow');
  b += text(x0, 214, 'time', 17, C.gray);
  const testX = x0 + total * 0.85;
  b += line(testX, y + h, 600, 230, C.gray, 1.2, true) + line(x0 + total, y + h, 920, 230, C.gray, 1.2, true);
  for (let r = 0; r < 4; r++) {
    const ry = 248 + r * 22, ox = 680 + r * 45;
    b += line(600, ry, ox, ry, C.blue, 5);
    b += line(ox, ry, ox + 60, ry, C.orange, 5);
    b += circle(ox, ry, 5, C.ink, C.white, 1.5);
  }
  b += text(585, 256, 'rolling origins in the test part:', 17, C.ink, 'end', 'bold');
  b += text(585, 278, 'known part (blue), horizon (orange),', 17, C.ink, 'end');
  b += text(585, 300, 'then one step forward', 17, C.ink, 'end');
  svg('05-chronological-split', 960, 340, 'Chronological split and rolling origins',
    'A series is divided in time into training, validation, and test parts. In the test part, forecasts start from several successive origins.', b);
}

// 06 Recursive versus direct multi-step forecasting.
{
  let b = text(30, 38, 'Two ways to forecast several steps', 26, C.ink, 'start', 'bold');
  const inputs = [['x', '1'], ['x', '2'], ['x', '3'], ['x', '4']];
  const drawCell = (x, y, label, predicted) => rect(x, y, 52, 40, predicted ? C.orangeWash : C.blueWash, predicted ? C.orange : C.blue, 2, 6)
    + sub(x + 26, y + 26, label[0], label[1], 19, predicted ? C.orange : C.ink);
  b += text(40, 84, 'recursive', 20, C.ink, 'start', 'bold');
  const rows = [[['x', '1'], ['x', '2'], ['x', '3'], ['x', '4']], [['x', '2'], ['x', '3'], ['x', '4'], ['ŷ', '1']], [['x', '3'], ['x', '4'], ['ŷ', '1'], ['ŷ', '2']]];
  rows.forEach((row, r) => {
    const y = 100 + r * 62;
    b += text(40, y + 27, 'step ' + (r + 1), 17, C.gray);
    row.forEach((c, i) => { b += drawCell(150 + i * 60, y, c, c[0] === 'ŷ'); });
    b += line(398, y + 20, 438, y + 20, C.gray, 2, false, 'arrow');
    b += rect(444, y, 190, 40, C.white, C.ink, 2, 8) + text(539, y + 26, 'one-step model', 18, C.ink, 'middle');
    b += line(634, y + 20, 674, y + 20, C.gray, 2, false, 'arrow');
    b += drawCell(680, y, ['ŷ', String(r + 1)], true);
    if (r < 2) b += curve('M706,' + (y + 41) + ' C706,' + (y + 56) + ' 356,' + (y + 46) + ' 356,' + (y + 57), C.orange, 1.8, 'none', true, 'arrowOrange');
  });
  b += text(780, 132, 'own forecasts', 17, C.orange);
  b += text(780, 154, 'are fed back:', 17, C.orange);
  b += text(780, 176, 'errors can add up', 17, C.orange);
  b += line(40, 302, 920, 302, C.light, 2);
  b += text(40, 340, 'direct', 20, C.ink, 'start', 'bold');
  inputs.forEach((c, i) => { b += drawCell(150 + i * 60, 360, c, false); });
  b += line(398, 380, 438, 380, C.gray, 2, false, 'arrow');
  b += rect(444, 360, 190, 40, C.white, C.ink, 2, 8) + text(539, 386, 'multi-output model', 18, C.ink, 'middle');
  b += line(634, 380, 674, 380, C.gray, 2, false, 'arrow');
  [1, 2, 3].forEach((k, i) => { b += drawCell(680 + i * 60, 360, ['ŷ', String(k)], true); });
  b += text(866, 386, 'all at once', 16, C.orange);
  svg('06-recursive-and-direct', 960, 430, 'Recursive and direct multi-step forecasts',
    'Recursive: a one-step model is applied three times and its own forecasts move into the input window. Direct: one model returns all three future values at once.', b);
}

// 07 Naive and seasonal naive forecasts.
{
  const e = baselineExample();
  numbers.baselines = {maeNaive: e.maeNaive, maeSeasonal: e.maeSeasonal};
  const rules = [
    {name: '07-repeat-last-value', values: e.naive,
      description: 'The forecast repeats the last observed value and is therefore horizontal.'},
    {name: '07-repeat-seasonal-pattern', values: e.seasonal,
      description: 'The forecast repeats the hourly observations from the previous day.'},
  ];
  rules.forEach(rule => {
    const fr = frame({x0: 100, y0: 48, w: 780, h: 135,
      xmin: 24, xmax: 96, ymin: 0, ymax: 14,
      xticks: [24, 48, 72, 96], yticks: [0, 7, 14],
      xlabel: 'Hour', ylabel: 'Temperature (°C)'});
    let b = rect(fr.px(72),48,fr.px(96)-fr.px(72),135,C.orangeWash,'none',0);
    b += fr.b;
    b += curve(poly(e.x.slice(24,e.origin+1).map((v,k)=>[24+k,v]),fr.px,fr.py),C.blue,3);
    const forecast = [[e.origin,e.x[e.origin]], ...rule.values.map((v,k)=>[e.origin+1+k,v])];
    b += curve(poly(forecast,fr.px,fr.py),C.orange,3.5);
    b += line(fr.px(72),43,fr.px(72),183,C.ink,2);
    b += circle(fr.px(72),fr.py(e.x[e.origin]),5,C.ink);
    b += text(fr.px(72),33,'Now',18,C.ink,'middle','bold');
    b += text(fr.px(44),68,'Measured values',18,C.blue,'middle');
    b += text(fr.px(84),68,'Forecast',18,C.orange,'middle');
    svg(rule.name,960,245,'Measured history and forecast',rule.description,b);
  });
}

// 08 Historical inputs and targets, followed by one illustrative prediction error.
{
  let b = '';
  const xs = [120,290,460,750];
  [12,13,15,16].forEach((v,i) => {
    b += text(xs[i]+50,30,'Hour '+(i+1),22,C.gray,'middle');
    b += cell(xs[i],55,100,58,v+' °C',i<3?C.blueWash:C.tealWash,i<3?C.blue:C.teal,26);
  });
  b += line(110,140,570,140,C.blue,2);
  b += line(110,130,110,140,C.blue,2) + line(570,130,570,140,C.blue,2);
  b += text(340,176,'Input given to the model',23,C.blue,'middle');
  b += text(800,155,'Observed target',23,C.teal,'middle');
  b += text(800,185,'for comparison',21,C.teal,'middle');
  b += line(645,45,645,195,C.light,2);
  svg('08-sliding-windows',960,215,'One training example from four historical measurements',
    'Four temperatures were measured at successive hours. The first three are grouped as input; the fourth is the observed target, not a predicted or calculated value.',b);
}
{
  let b = text(165,30,'Input (°C)',22,C.blue,'middle');
  b += text(470,30,'Chosen model',22,C.ink,'middle');
  b += text(795,30,'Prediction (°C)',22,C.orange,'middle');
  b += cell(45,52,240,58,'12, 13, 15',C.blueWash,C.blue,27);
  b += line(295,81,355,81,C.gray,2,false,'arrow');
  b += cell(365,52,210,58,'Parameters',C.pale,C.ink,24);
  b += line(585,81,650,81,C.gray,2,false,'arrow');
  b += cell(665,52,260,58,'14',C.orangeWash,C.orange,27);
  b += text(45,160,'Observed target: 16 °C',23,C.teal);
  b += text(435,160,'Prediction: 2 °C too low',23,C.orange);
  b += text(480,215,'Training uses errors to adjust the parameters.',23,C.ink,'middle');
  svg('08-learning-from-error',960,240,'Prediction error during training',
    'An illustrative model predicts 14 degrees from inputs 12, 13, and 15. The observed target is 16, so the prediction is two degrees too low. Training uses such errors across examples to adjust parameters.',b);
}
// 09 Underfitting and overfitting.
{
  const e = fitExample();
  numbers.fit = {trainMse: e.trainMse, truthMse: e.truthMse};
  let b = text(30, 38, 'Fitting the training points is not the goal', 26, C.ink, 'start', 'bold');
  const titles = {simple: 'too simple', suitable: 'suitable', flexible: 'too flexible'};
  const defs = [];
  Object.keys(titles).forEach((name, p) => {
    const x0 = 60 + p * 310;
    const fr = frame({x0, y0: 110, w: 250, h: 220, xmin: 0, xmax: 1, ymin: -1.4, ymax: 1.6, yticks: [], xticks: []});
    defs.push('<clipPath id="clip' + p + '"><rect x="' + x0 + '" y="110" width="250" height="220"/></clipPath>');
    b += rect(x0, 110, 250, 220, C.pale, 'none', 0) + fr.b;
    b += text(x0 + 125, 92, titles[name], 20, C.ink, 'middle', 'bold');
    b += '<g clip-path="url(#clip' + p + ')">'
      + curve(poly(e.grid.map((x, i) => [x, e.truth[i]]), fr.px, fr.py), C.gray, 2, 'none', true)
      + curve(poly(e.grid.map((x, i) => [x, e.curves[name][i]]), fr.px, fr.py), C.orange, 3) + '</g>';
    e.xs.forEach((x, i) => { b += circle(fr.px(x), fr.py(e.ys[i]), 5, C.ink, C.white, 1.5); });
    b += text(x0, 362, 'error on training points: ' + f2(e.trainMse[name]), 16, C.ink);
    b += text(x0, 386, 'error against true curve: ' + f2(e.truthMse[name]), 16, C.ink);
  });
  b += circle(70, 430, 5, C.ink, C.white, 1.5) + text(84, 436, 'training points', 16, C.ink);
  b += line(240, 430, 280, 430, C.gray, 2, true) + text(290, 436, 'true curve (unknown in practice)', 16, C.ink);
  b += line(570, 430, 610, 430, C.orange, 3) + text(620, 436, 'fitted model', 16, C.ink);
  svg('09-under-and-overfitting', 960, 460, 'Underfitting and overfitting',
    'Three models fitted to the same twelve invented points. The straight line misses the shape, the smooth curve follows it, and the flexible curve passes through every point but departs from the true curve between them.', b, defs.join(''));
}

// 10 A linear model as a weighted sum.
{
  const {values, weights, bias} = linearExample;
  const yhat = linearPrediction();
  numbers.linear = {yhat};
  let b = text(30, 38, 'A linear model weights recent values and adds them up', 26, C.ink, 'start', 'bold');
  const labels = [['x', 't−3'], ['x', 't−2'], ['x', 't−1'], ['x', 't']];
  b += text(40, 131, 'values', 17, C.ink, 'start', 'bold');
  b += text(40, 236, 'weights', 17, C.ink, 'start', 'bold');
  values.forEach((v, i) => {
    const x = 130 + i * 140, cx = x + 50;
    b += sub(cx, 86, labels[i][0], labels[i][1], 19, C.gray);
    b += cell(x, 100, 100, 50, f1(v), C.blueWash, C.blue, 21);
    const barH = weights[i] * 200;
    b += line(cx, 150, cx, 290 - barH - 4, C.light, 2);
    b += rect(x + 30, 290 - barH, 40, barH, C.ink, 'none', 0, 3);
    b += text(cx, 312, 'w = ' + f2(weights[i]), 17, C.ink, 'middle');
    b += line(cx, 322, cx, 346, C.gray, 2);
  });
  b += line(180, 346, 690, 346, C.gray, 2, false, 'arrow');
  b += circle(735, 346, 38, C.white, C.ink, 2.5) + text(735, 358, 'Σ', 32, C.ink, 'middle', 'bold');
  b += text(735, 408, '+ bias b = ' + f1(bias), 17, C.ink, 'middle');
  b += line(773, 346, 803, 346, C.gray, 2, false, 'arrow');
  b += cell(810, 322, 120, 48, f2(yhat), C.orangeWash, C.orange, 21, C.orange);
  b += sub(870, 306, 'ŷ', 't+1', 19, C.orange);
  b += text(480, 456, 'ŷ = ' + f1(bias) + values.map((v, i) => ' + ' + f2(weights[i]) + ' · ' + f1(v)).join('') + ' = ' + f2(yhat), 18, C.ink, 'middle');
  svg('10-linear-lag-model', 960, 480, 'Linear lag regression as a weighted sum',
    'Four recent values are multiplied by learned weights, summed, and shifted by a bias. The most recent value has the largest weight. The result is the forecast for the next step.', b);
}

// 11 Decision tree and gradient boosting.
{
  let b = text(30, 38, 'Trees ask questions; boosting adds up many small trees', 26, C.ink, 'start', 'bold');
  const q = (cx, y, w, label) => rect(cx - w / 2, y, w, 50, C.white, C.ink, 2, 10) + text(cx, y + 31, label, 17, C.ink, 'middle');
  const leaf = (cx, y, label) => rect(cx - 56, y, 112, 46, C.orangeWash, C.orange, 2, 10) + text(cx, y + 29, label, 18, C.orange, 'middle', 'bold');
  b += q(290, 76, 300, 'temperature now > 10 °C?');
  b += q(150, 196, 200, 'hour < 14?') + q(430, 196, 220, 'wind > 5 m/s?');
  b += line(240, 126, 170, 194, C.gray, 2) + line(340, 126, 410, 194, C.gray, 2);
  b += text(186, 160, 'yes', 16, C.gray, 'end') + text(394, 160, 'no', 16, C.gray);
  const leaves = [[80, '+1.5 °C'], [220, '−0.5 °C'], [360, '−1.0 °C'], [500, '+0.3 °C']];
  b += line(120, 246, 88, 312, C.gray, 2) + line(180, 246, 212, 312, C.gray, 2)
    + line(400, 246, 368, 312, C.gray, 2) + line(460, 246, 492, 312, C.gray, 2);
  b += text(92, 284, 'yes', 16, C.gray, 'end') + text(208, 284, 'no', 16, C.gray)
    + text(372, 284, 'yes', 16, C.gray, 'end') + text(488, 284, 'no', 16, C.gray);
  leaves.forEach(([x, l]) => { b += leaf(x, 314, l); });
  b += text(290, 392, 'leaf = predicted change over the next hour', 17, C.ink, 'middle');
  const icon = (cx, y) => circle(cx, y, 9, C.ink, C.white, 1.5) + line(cx, y, cx - 22, y + 36, C.ink, 2) + line(cx, y, cx + 22, y + 36, C.ink, 2)
    + circle(cx - 22, y + 40, 8, C.orange, C.white, 1.5) + circle(cx + 22, y + 40, 8, C.orange, C.white, 1.5);
  b += text(650, 96, 'gradient boosting', 19, C.ink, 'start', 'bold');
  [660, 750, 840].forEach((cx, i) => {
    b += icon(cx, 138) + text(cx, 214, 'tree ' + (i + 1), 16, C.gray, 'middle');
    if (i < 2) b += text(cx + 45, 172, '+', 26, C.gray, 'middle', 'bold');
  });
  b += text(900, 172, '+ …', 22, C.gray);
  b += text(650, 270, 'Each new tree fits the errors', 17, C.ink);
  b += text(650, 292, 'that the previous trees leave.', 17, C.ink);
  b += text(650, 326, 'The forecast adds up all trees.', 17, C.ink);
  svg('11-trees-and-boosting', 960, 410, 'Decision trees and gradient boosting',
    'A decision tree asks yes-or-no questions about temperature, hour, and wind and ends in leaves with predicted changes. Gradient boosting adds many small trees, each fitted to the remaining errors.', b);
}

// 12 A recurrent network reads step by step.
{
  let b = text(30, 38, 'A recurrent network reads step by step and carries a memory', 26, C.ink, 'start', 'bold');
  const xs = [100, 250, 400, 550, 700];
  xs.forEach((cx, i) => {
    b += rect(cx - 40, 262, 80, 46, C.blueWash, C.blue, 2, 6) + sub(cx, 292, 'x', String(i + 1), 20, C.ink);
    b += line(cx, 262, cx, 196, C.gray, 2, false, 'arrow');
    b += rect(cx - 52, 132, 104, 60, C.white, C.ink, 2.5, 12) + text(cx, 168, 'cell', 19, C.ink, 'middle');
    if (i < 4) {
      b += line(cx + 52, 162, cx + 94, 162, C.teal, 3, false, 'arrowTeal');
      b += sub(cx + 75, 148, 'h', String(i + 1), 17, C.teal);
    }
  });
  b += line(752, 162, 808, 162, C.gray, 2, false, 'arrow');
  b += rect(814, 138, 110, 48, C.orangeWash, C.orange, 2, 6) + sub(869, 169, 'ŷ', '6', 20, C.orange);
  b += text(400, 96, 'the hidden state h carries what has been read so far', 17, C.teal, 'middle');
  b += text(400, 344, 'one observation per step, read in time order', 17, C.gray, 'middle');
  svg('12-recurrent-memory', 960, 370, 'A recurrent network with memory',
    'Five observations are read one after another by the same cell. A hidden state passes from step to step as a memory, and the last state produces the forecast of the next value.', b);
}

// 13 Patches and attention.
{
  const s = patchSeries();
  let b = text(30, 38, 'Patches as words: attention links related pieces', 26, C.ink, 'start', 'bold');
  const x0 = 70, w = 840, px = t => x0 + t / 143 * w, py = v => 330 - v * 34;
  for (let p = 1; p < 6; p++) b += line(px(p * 24 - 0.5), 280, px(p * 24 - 0.5), 380, C.light, 2, true);
  b += curve(poly(indexed(s), px, py), C.blue, 2.6);
  const centers = Array.from({length: 6}, (_, p) => px(p * 24 + 11.5));
  centers.forEach((cx, p) => {
    b += sub(cx, 404, 'P', String(p + 1), 18, C.gray);
    b += line(cx, 280, cx, 214, C.gray, 1.6, false, 'arrow');
    b += rect(cx - 46, 164, 92, 46, C.white, C.ink, 2, 10) + text(cx, 193, 'token', 17, C.ink, 'middle');
  });
  const weights = [0.08, 0.10, 0.12, 0.20, 0.50];
  weights.forEach((wgt, p) => {
    const xa = centers[5], xb = centers[p], apex = 150 - 18 * (5 - p);
    b += curve('M' + xa + ',164 Q' + ((xa + xb) / 2) + ',' + apex + ' ' + xb + ',164', wgt > 0.3 ? C.ink : C.gray, 1.5 + wgt * 9);
  });
  b += text(centers[4], 92, 'strong link: the previous day', 17, C.ink, 'middle', 'bold');
  b += text(70, 450, 'Each patch covers one day of an invented hourly series; line width shows how much the last patch attends to the others.', 16, C.gray);
  svg('13-patches-and-attention', 960, 470, 'Patches and attention',
    'An invented series is cut into six daily patches. Each patch becomes a token. Arcs from the last token show attention weights; the strongest link goes to the previous day.', b);
}

// 14 A pretrained model forecasts a new series without retraining.
{
  const minis = miniSeries();
  const fresh = newSeries();
  let b = text(30, 38, 'A pretrained model brings experience from other series', 26, C.ink, 'start', 'bold');
  minis.forEach((m, i) => {
    const col = i % 4, row = Math.floor(i / 4), x = 40 + col * 82, y = 90 + row * 66;
    const lo = Math.min(...m), hi = Math.max(...m);
    b += rect(x, y, 72, 54, C.pale, C.light, 1, 6);
    b += curve(poly(indexed(m), t => x + 4 + t / 29 * 64, v => y + 48 - (v - lo) / (hi - lo + 1e-9) * 42), C.gray, 1.6);
  });
  b += text(40, 316, 'pretraining on very many', 17, C.ink);
  b += text(40, 338, 'other series', 17, C.ink);
  b += line(372, 190, 420, 190, C.gray, 2.5, false, 'arrow');
  b += rect(428, 146, 190, 88, C.ink, C.ink, 2, 14);
  b += text(523, 184, 'pretrained model', 18, C.white, 'middle', 'bold');
  b += text(523, 210, 'e.g. Chronos-2', 17, C.white, 'middle');
  const x0 = 680, px = t => x0 + t / 77 * 250, py = v => 250 - (v + 1.2) / 3.6 * 140;
  b += rect(x0 - 10, 96, 270, 170, C.white, C.light, 1, 8);
  b += curve(poly(indexed(fresh.x), px, py), C.blue, 2.4);
  b += curve(poly(fresh.forecast.map((v, k) => [60 + k, v]), px, py), C.orange, 3);
  b += line(px(59.5), 104, px(59.5), 258, C.ink, 1.5, true);
  b += line(618, 190, 668, 190, C.gray, 2.5, false, 'arrow');
  b += text(x0 + 125, 292, 'new series: history (blue)', 17, C.ink, 'middle');
  b += text(x0 + 125, 316, 'and forecast (orange)', 17, C.ink, 'middle');
  b += text(x0 + 125, 340, 'without retraining: zero-shot', 17, C.orange, 'middle', 'bold');
  svg('14-pretrained-zero-shot', 960, 370, 'Zero-shot forecasting with a pretrained model',
    'Many small series of different shapes represent the pretraining collection. The pretrained model then receives the history of a new series and forecasts its continuation without further training.', b);
}

fs.writeFileSync(path.join(outDir, 'manifest.json'), JSON.stringify({figures: manifest, numericalData: numbers}, null, 2) + '\n');
console.log('Built ' + manifest.length + ' forecasting figures.');
console.log(JSON.stringify(numbers, null, 1));
