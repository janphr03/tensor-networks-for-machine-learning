// Numerical examples shared by the vector figures. No external dependencies.
export const ledger = Array.from({length: 2}, (_, s) =>
  Array.from({length: 3}, (_, t) => [6 * s + 2 * t + 1, 6 * s + 2 * t + 2]));
export const outerU = [1, 2];
export const outerV = [3, 4, 5];
export const dotA = [1, 2, 3];
export const dotB = [4, -1, 2];
export const outer = outerU.map(u => outerV.map(v => u * v));
export const contributions = dotA.map((a, k) => a * dotB[k]);

export function patternMatrix(r = 3) {
  const n = 8;
  const u = [
    Array(n).fill(1 / Math.sqrt(n)),
    Array.from({length: n}, (_, i) => Math.sin(2 * Math.PI * i / n) / 2),
    Array.from({length: n}, (_, i) => Math.cos(4 * Math.PI * i / n) / 2)
  ];
  const v = [
    Array(n).fill(1 / Math.sqrt(n)),
    Array.from({length: n}, (_, j) => Math.cos(2 * Math.PI * j / n) / 2),
    Array.from({length: n}, (_, j) => Math.sin(4 * Math.PI * j / n) / 2)
  ];
  const sigma = [9, 3, 1];
  return Array.from({length: n}, (_, i) => Array.from({length: n}, (_, j) =>
    sigma.slice(0, r).reduce((sum, s, k) => sum + s * u[k][i] * v[k][j], 0)));
}

export const cpFactors = {
  a: [[1, 0], [0, 1], [1, 1], [2, -1]],
  b: [[1, 1], [2, -1], [0, 2], [1, 0]],
  c: [[1, 0], [0, 1], [1, -1], [2, 1]]
};
export function ttExample(i, j, k) {
  let value = 0;
  for (let alpha = 0; alpha < 2; alpha++)
    for (let beta = 0; beta < 2; beta++)
      value += cpFactors.a[i][alpha]
        * (alpha === beta ? cpFactors.b[j][alpha] : 0)
        * cpFactors.c[k][beta];
  return value;
}
export const contractionCosts = {
  left: {intermediate: [40, 30], multiplications: 40 * 2 * 30 + 40 * 30 * 2},
  right: {intermediate: [2, 2], multiplications: 2 * 30 * 2 + 40 * 2 * 2}
};
export const targetCurve = x => 0.3 + 0.6 * x - 0.8 * x * x + 0.45 * x * x * x;
export const trainingData = Array.from({length: 21}, (_, i) => {
  const x = -1 + i / 10;
  return {x, y: targetCurve(x) + 0.025 * Math.sin(17 * i)};
});

function seededRandom(seed) {
  let state = seed >>> 0;
  return () => {
    state = (1664525 * state + 1013904223) >>> 0;
    return state / 4294967296;
  };
}
// A: 2 x 2, B: 2 x 2 x 2, C: 2 x 2. Boundary ranks are one.
const ai = (i, alpha) => i * 2 + alpha;
const bi = (alpha, j, beta) => 4 + alpha * 4 + j * 2 + beta;
const ci = (beta, k) => 12 + beta * 2 + k;
export function tensorPrediction(weights, x) {
  const phi = [1, x];
  const grad = Array(16).fill(0);
  let value = 0;
  for (let i = 0; i < 2; i++)
    for (let j = 0; j < 2; j++)
      for (let k = 0; k < 2; k++)
        for (let alpha = 0; alpha < 2; alpha++)
          for (let beta = 0; beta < 2; beta++) {
            const a = ai(i, alpha), b = bi(alpha, j, beta), c = ci(beta, k);
            const feature = phi[i] * phi[j] * phi[k];
            value += weights[a] * weights[b] * weights[c] * feature;
            grad[a] += weights[b] * weights[c] * feature;
            grad[b] += weights[a] * weights[c] * feature;
            grad[c] += weights[a] * weights[b] * feature;
          }
  return {value, grad};
}
export function trainingObjective(weights) {
  const grad = Array(16).fill(0);
  let loss = 0;
  for (const {x, y} of trainingData) {
    const prediction = tensorPrediction(weights, x);
    const error = prediction.value - y;
    loss += error * error / trainingData.length;
    for (let p = 0; p < weights.length; p++)
      grad[p] += 2 * error * prediction.grad[p] / trainingData.length;
  }
  return {loss, grad};
}
export function trainIllustration(steps = 1800) {
  const random = seededRandom(20261007);
  const weights = Array.from({length: 16}, () => (random() - 0.5) * 0.8);
  const before = [...weights], m = Array(16).fill(0), v = Array(16).fill(0);
  const history = [];
  for (let step = 1; step <= steps; step++) {
    const {loss, grad} = trainingObjective(weights);
    if (step === 1 || step % 100 === 0) history.push({step, loss});
    for (let p = 0; p < weights.length; p++) {
      m[p] = 0.9 * m[p] + 0.1 * grad[p];
      v[p] = 0.999 * v[p] + 0.001 * grad[p] * grad[p];
      const mh = m[p] / (1 - Math.pow(0.9, step));
      const vh = v[p] / (1 - Math.pow(0.999, step));
      weights[p] -= 0.025 * mh / (Math.sqrt(vh) + 1e-8);
    }
  }
  const grid = Array.from({length: 121}, (_, i) => -1 + 2 * i / 120);
  const referenceMse = grid.reduce((sum, x) =>
    sum + (tensorPrediction(weights, x).value - targetCurve(x)) ** 2, 0) / grid.length;
  return {
    before, after: [...weights], steps, history, referenceMse,
    beforeMse: trainingObjective(before).loss,
    afterMse: trainingObjective(weights).loss,
    curves: grid.map(x => ({
      x, truth: targetCurve(x),
      before: tensorPrediction(before, x).value,
      after: tensorPrediction(weights, x).value
    }))
  };
}
