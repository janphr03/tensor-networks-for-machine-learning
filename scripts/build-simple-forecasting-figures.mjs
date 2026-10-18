import fs from 'node:fs';
import {fileURLToPath} from 'node:url';

// Small, code-native diagrams for the introductory section. All data are invented.
const out = new URL('../figures/forecasting/', import.meta.url);
const blue = '#2166AC', orange = '#C45D24', ink = '#173552', gray = '#617185';
const text = (x, y, s, size = 22, color = ink, anchor = 'start') =>
  `<text x="${x}" y="${y}" font-size="${size}" fill="${color}" text-anchor="${anchor}">${s}</text>`;
const line = (x1,y1,x2,y2,color = '#D7E0E9',width = 2) =>
  `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="${color}" stroke-width="${width}"/>`;
const path = (points, color = blue) => `<polyline points="${points.map(p => p.join(',')).join(' ')}" fill="none" stroke="${color}" stroke-width="4" stroke-linejoin="round"/>`;
function save(name, height, title, body) {
  fs.writeFileSync(new URL(name + '.svg', out), `<svg xmlns="http://www.w3.org/2000/svg" width="960" height="${height}" viewBox="0 0 960 ${height}" role="img"><title>${title}</title><rect width="960" height="${height}" fill="white"/><g font-family="Arial, Helvetica, sans-serif">${body}</g></svg>`);
}

const values = [12,13,15,16,15,14,13,12];
{
  let b = text(40,36,'One observation per hour',26);
  const px = i => 100 + i * 112, py = v => 250 - (v - 10) * 27;
  b += text(40,72,'Temperature (°C)',19,gray);
  for (const v of [10,12,14,16]) b += line(90,py(v),900,py(v)) + text(76,py(v)+7,v,19,gray,'end');
  b += path(values.map((v,i) => [px(i),py(v)]));
  values.forEach((v,i) => {
    b += `<circle cx="${px(i)}" cy="${py(v)}" r="6" fill="${blue}"/>`;
    b += text(px(i),py(v)-14,v,21,ink,'middle') + text(px(i),282,i+1,20,gray,'middle');
  });
  b += text(900,314,'Hour',20,gray,'end');
  save('01-simple-time-series',330,'Eight invented hourly temperature readings',b);
}
{
  let b = '';
  const samples = [
    ['Trend','A long-term direction',Array.from({length:25},(_,i)=>i/24),blue],
    ['Seasonality','A repeating pattern',Array.from({length:49},(_,i)=>0.5+0.4*Math.sin(i*Math.PI/8)), '#008C82'],
    ['Irregular variation','Uneven fluctuations',[0.4,0.7,0.2,0.55,0.5,0.8,0.3,0.45,0.65,0.25,0.6,0.4,0.75,0.5,0.35,0.55,0.2,0.6,0.45,0.7,0.4,0.5,0.3,0.6,0.45],gray],
  ];
  samples.forEach(([title,desc,vals,color],k) => {
    const x = 35+k*315;
    b += text(x,36,title,23) + text(x,66,desc,19,gray);
    b += line(x,220,x+270,220) + path(vals.map((v,i)=>[x+i/(vals.length-1)*270,205-v*110]),color);
    b += text(x+270,250,'Time',19,gray,'end');
  });
  save('02-simple-patterns',275,'Three separate schematic time-series patterns',b);
}
{
  let b = text(40,36,'Use the known past to predict the unknown future',26);
  b += text(280,85,'Input window: 4 known values',22,blue,'middle');
  b += text(755,85,'Horizon: 2 future values',22,orange,'middle');
  [15,14,13,12,'?','?'].forEach((v,i) => {
    const x = i < 4 ? 40+i*125 : 645+(i-4)*140;
    const color = i < 4 ? blue : orange;
    b += `<rect x="${x}" y="112" width="108" height="70" rx="5" fill="${i < 4 ? '#E8F0F8' : '#FCEDE3'}" stroke="${color}" stroke-width="2"/>`;
    b += text(x+54,157,v,30,color,'middle') + text(x+54,213,'Hour '+(i+5),20,gray,'middle');
  });
  b += line(565,100,565,225,ink,2);
  b += text(565,262,'Forecast origin: after hour 8',21,ink,'middle');
  save('04-simple-window',290,'Four past inputs and two future targets',b);
}
{
  let b = text(40,38,'Two measurements at each time',26);
  const px = i => 100+i*90, py = v => 255-(v-8)*15;
  b += text(40,62,'Temperature (°C)',20,gray);
  [8,12,16,20].forEach(v => {
    b += line(90,py(v),750,py(v)) + text(76,py(v)+6,v,19,gray,'end');
  });
  b += line(90,75,90,255,gray) + line(90,255,750,255,gray);
  const tracks = [
    {label: 'Location A', vals: values, color: blue},
    {label: 'Location B', vals: [16,17,18,19,18,17,16,16], color: '#008C82'},
  ];
  tracks.forEach(track => {
    b += path(track.vals.map((v,i) => [px(i),py(v)]),track.color);
    track.vals.forEach((v,i) => {
      b += `<circle cx="${px(i)}" cy="${py(v)}" r="5" fill="${track.color}"/>`;
    });
    b += line(735,py(track.vals[7]),775,py(track.vals[7]),track.color);
    b += text(785,py(track.vals[7])+7,track.label,22,track.color);
  });
  values.forEach((_,i) => { b += text(px(i),284,i+1,20,gray,'middle'); });
  b += text(750,316,'Hour',20,gray,'end');
  save('01-simple-multivariate',335,'Temperatures at two locations in one coordinate system',b);
}
// Each pattern has its own diagram and labelled axes.
const cycleKnots = [[0,80],[2,120],[4,85],[6,115],[9,75],[13,125],[16,90]];
const cyclePoints = [];
for (let k = 0; k < cycleKnots.length-1; k++) {
  const [a,va] = cycleKnots[k], [b,vb] = cycleKnots[k+1];
  for (let j = 0; j <= 24; j++) {
    const s = j/24;
    cyclePoints.push([a+(b-a)*s,va+(vb-va)*(1-Math.cos(Math.PI*s))/2]);
  }
}
const monthly = [80,75,78,82,85,88,90,92,95,100,110,125];
const patterns = [
  {name:'trend', points:[65,70,78,82,91,96,105,110].map((v,i)=>[i+1,v]), min:1,max:8,ticks:[1,2,3,4,5,6,7,8],xlabel:'Year',color:blue},
  {name:'seasonality', points:Array.from({length:36},(_,i)=>[i+1,monthly[i%12]]), min:1,max:36,ticks:[1,12,24,36],xlabel:'Month (12, 24, 36 = December)',color:'#008C82'},
  {name:'cycles',points:cyclePoints,min:0,max:16,ticks:[0,2,6,10,13,16],xlabel:'Year',color:orange},
];
for (const pattern of patterns) {
  const px = t => 100+(t-pattern.min)/(pattern.max-pattern.min)*790;
  const py = v => 170-(v-60)/70*120;
  let b = text(35,27,'Demand index',20,gray);
  [60,90,120].forEach(v => {
    b += line(90,py(v),900,py(v)) + text(76,py(v)+6,v,19,gray,'end');
  });
  b += line(90,40,90,170,gray) + line(90,170,900,170,gray);
  b += path(pattern.points.map(([t,v])=>[px(t),py(v)]),pattern.color);
  pattern.ticks.forEach(t => { b += text(px(t),197,t,19,gray,'middle'); });
  b += text(900,228,pattern.xlabel,20,gray,'end');
  save('02-pattern-'+pattern.name,245,'Schematic '+pattern.name+' in an invented demand index',b);
}
console.log('Built 7 introductory forecasting figures in ' + fileURLToPath(out));
