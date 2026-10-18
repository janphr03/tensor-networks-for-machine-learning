// Invented, deterministic teaching data for Sections 2.1 and 2.2.
// None of these values comes from the research datasets.

const TAU = 2 * Math.PI;

export function mulberry32(seed) {
  let a = seed;
  return function next() {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export function gauss(rng) {
  let u = 0, v = 0;
  while (u === 0) u = rng();
  while (v === 0) v = rng();
  return Math.sqrt(-2 * Math.log(u)) * Math.cos(TAU * v);
}

const mean = xs => xs.reduce((s, v) => s + v, 0) / xs.length;

// Three tracks measured at the same 48 hours.
export function hourlyTracks() {
  const rng = mulberry32(11);
  const temp = [], hum = [], wind = [];
  let ar = 0;
  for (let h = 0; h < 48; h++) {
    ar = 0.6 * ar + 0.35 * gauss(rng);
    temp.push(6.5 + 4.2 * Math.sin(TAU * (h - 9) / 24) + 0.02 * h + ar);
  }
  const m = mean(temp);
  let arH = 0, arW = 0;
  for (let h = 0; h < 48; h++) {
    arH = 0.6 * arH + 1.2 * gauss(rng);
    hum.push(Math.min(100, Math.max(40, 80 - 3.4 * (temp[h] - m) + arH)));
    arW = 0.7 * arW + 0.45 * gauss(rng);
    wind.push(Math.max(0.2, 3.2 + 1.3 * Math.sin(TAU * (h - 14) / 24) + arW));
  }
  return {temp, hum, wind};
}

// Observed series = trend + seasonality + noise, 96 hourly values.
export function components() {
  const rng = mulberry32(31);
  const trend = [], season = [], noise = [], observed = [];
  for (let h = 0; h < 96; h++) {
    const tr = 4 + 0.05 * h, se = 3 * Math.sin(TAU * (h - 9) / 24), no = 0.6 * gauss(rng);
    trend.push(tr); season.push(se); noise.push(no); observed.push(tr + se + no);
  }
  return {trend, season, noise, observed};
}

// Autocorrelation of an hourly series with a daily cycle, lags 1..48.
export function memoryExample() {
  const rng = mulberry32(41);
  const x = [];
  let ar = 0;
  for (let h = 0; h < 240; h++) {
    ar = 0.8 * ar + 0.8 * gauss(rng);
    x.push(6 + 4 * Math.sin(TAU * (h - 9) / 24) + ar);
  }
  const m = mean(x);
  const den = x.reduce((s, v) => s + (v - m) ** 2, 0);
  const acf = [];
  for (let k = 1; k <= 48; k++) {
    let num = 0;
    for (let t = k; t < x.length; t++) num += (x[t] - m) * (x[t - k] - m);
    acf.push(num / den);
  }
  return {acf};
}

// A random walk: one history and five equally likely continuations.
export function randomWalk() {
  const rng = mulberry32(51);
  const hist = [1.0];
  for (let t = 1; t <= 30; t++) hist.push(hist[t - 1] + 0.006 * gauss(rng));
  const futures = [];
  for (let p = 0; p < 5; p++) {
    const r = mulberry32(52 + p);
    const path = [hist[30]];
    for (let s = 1; s <= 20; s++) path.push(path[s - 1] + 0.006 * gauss(r));
    futures.push(path);
  }
  return {hist, futures, naive: hist[30]};
}

// Forecast origin, input window, and horizon.
export function windowExample() {
  const rng = mulberry32(61);
  const x = [];
  let ar = 0;
  for (let h = 0; h <= 84; h++) {
    ar = 0.7 * ar + 0.45 * gauss(rng);
    x.push(7 + 0.015 * h + 4 * Math.sin(TAU * (h - 10) / 24) + ar);
  }
  const origin = 60, L = 24, H = 24;
  const forecast = [];
  for (let k = 1; k <= H; k++) forecast.push(x[origin + k - 24]);
  return {x, origin, L, H, forecast};
}

// Naive and seasonal naive forecasts against the later revealed values.
export function baselineExample() {
  const rng = mulberry32(71);
  const x = [];
  let ar = 0;
  for (let h = 0; h <= 96; h++) {
    ar = 0.7 * ar + 0.4 * gauss(rng);
    x.push(6.5 + 0.01 * h + 4.5 * Math.sin(TAU * (h - 10) / 24) + ar);
  }
  const origin = 72, H = 24;
  const actual = x.slice(origin + 1, origin + 1 + H);
  const naive = Array.from({length: H}, () => x[origin]);
  const seasonal = Array.from({length: H}, (_, k) => x[origin + 1 + k - 24]);
  const mae = f => f.reduce((s, v, i) => s + Math.abs(v - actual[i]), 0) / H;
  return {x, origin, H, actual, naive, seasonal, maeNaive: mae(naive), maeSeasonal: mae(seasonal)};
}

function solve(A, b) {
  const n = b.length, M = A.map((row, i) => [...row, b[i]]);
  for (let c = 0; c < n; c++) {
    let p = c;
    for (let r = c + 1; r < n; r++) if (Math.abs(M[r][c]) > Math.abs(M[p][c])) p = r;
    [M[c], M[p]] = [M[p], M[c]];
    for (let r = 0; r < n; r++) if (r !== c) {
      const f = M[r][c] / M[c][c];
      for (let k = c; k <= n; k++) M[r][k] -= f * M[c][k];
    }
  }
  return M.map((row, i) => row[n] / row[i]);
}
function polyfit(xs, ys, degree) {
  const n = degree + 1;
  const A = Array.from({length: n}, (_, i) => Array.from({length: n}, (_, j) => xs.reduce((s, x) => s + x ** (i + j), 0)));
  const b = Array.from({length: n}, (_, i) => xs.reduce((s, x, k) => s + ys[k] * x ** i, 0));
  return solve(A, b);
}
const polyval = (c, x) => c.reduce((s, ci, i) => s + ci * x ** i, 0);
function lagrange(xs, ys, x) {
  let s = 0;
  for (let i = 0; i < xs.length; i++) {
    let w = 1;
    for (let j = 0; j < xs.length; j++) if (j !== i) w *= (x - xs[j]) / (xs[i] - xs[j]);
    s += w * ys[i];
  }
  return s;
}

// Twelve noisy points and three fits of increasing flexibility.
export function fitExample() {
  const rng = mulberry32(81);
  const truthFn = x => Math.sin(TAU * 0.8 * x) + 0.3 * x;
  const xs = Array.from({length: 12}, (_, i) => i / 11);
  const ys = xs.map(x => truthFn(x) + 0.18 * gauss(rng));
  const grid = Array.from({length: 401}, (_, i) => i / 400);
  const lin = polyfit(xs, ys, 1), cub = polyfit(xs, ys, 3);
  const models = {
    simple: x => polyval(lin, x),
    suitable: x => polyval(cub, x),
    flexible: x => lagrange(xs, ys, x),
  };
  const curves = {}, trainMse = {}, truthMse = {};
  for (const [name, f] of Object.entries(models)) {
    curves[name] = grid.map(f);
    trainMse[name] = xs.reduce((s, x, i) => s + (f(x) - ys[i]) ** 2, 0) / xs.length;
    truthMse[name] = grid.reduce((s, x) => s + (f(x) - truthFn(x)) ** 2, 0) / grid.length;
  }
  return {xs, ys, grid, truth: grid.map(truthFn), curves, trainMse, truthMse};
}

// A smooth series cut into six daily patches.
export function patchSeries() {
  const rng = mulberry32(91);
  return Array.from({length: 144}, (_, t) =>
    Math.sin(TAU * (t - 6) / 24) + 0.25 * Math.sin(TAU * t / 9) + 0.08 * gauss(rng));
}

// Twelve small series of different shapes, used as a pretraining collection.
export function miniSeries() {
  const out = [];
  for (let s = 0; s < 12; s++) {
    const rng = mulberry32(100 + s);
    const kind = s % 4;
    let rw = 0;
    out.push(Array.from({length: 30}, (_, t) => {
      rw += 0.25 * gauss(rng);
      if (kind === 0) return Math.sin(TAU * t / (8 + s)) + 0.1 * gauss(rng);
      if (kind === 1) return 0.06 * t + 0.25 * Math.sin(TAU * t / 6) + 0.1 * gauss(rng);
      if (kind === 2) return (t > 12 + (s % 5) ? 1 : 0) + 0.12 * gauss(rng);
      return rw;
    }));
  }
  return out;
}

// A new series with a daily cycle; its continuation is shown as a forecast.
export function newSeries() {
  const rng = mulberry32(131);
  const x = Array.from({length: 60}, (_, t) => 1.2 * Math.sin(TAU * (t - 3) / 12) + 0.015 * t + 0.12 * gauss(rng));
  const forecast = Array.from({length: 18}, (_, k) => 1.2 * Math.sin(TAU * (60 + k - 3) / 12) + 0.015 * (60 + k));
  return {x, forecast};
}

export const windowValues = [5, 7, 6, 8, 9, 8, 10, 11, 10];
export const linearExample = {values: [8.0, 8.4, 9.0, 9.6], weights: [0.05, 0.10, 0.25, 0.60], bias: 0.2};
export function linearPrediction() {
  const {values, weights, bias} = linearExample;
  return bias + values.reduce((s, v, i) => s + v * weights[i], 0);
}
