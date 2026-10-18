import fs from 'node:fs';

// Introductory diagrams: shared inputs, one concept per illustration, no visual titles.
const out = new URL('../figures/forecasting/', import.meta.url);
const C = {ink:'#173552', blue:'#2166AC', teal:'#008C82', orange:'#C45D24', gray:'#617185', pale:'#F5F8FB'};
const esc = s => String(s).replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
const text = (x,y,s,size=23,color=C.ink) => `<text x="${x}" y="${y}" font-size="${size}" text-anchor="middle" fill="${color}">${esc(s)}</text>`;
const arrow = (x1,y1,x2,y2,color=C.gray,width=2) => `<path d="M${x1},${y1} L${x2},${y2}" fill="none" stroke="${color}" stroke-width="${width}" marker-end="url(#arrow)"/>`;
const box = (x,y,w,h,s,color=C.ink) => `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="6" fill="${C.pale}" stroke="${color}" stroke-width="2"/>`+text(x+w/2,y+h/2+8,s,24,color);
function save(name,height,description,body) {
  fs.writeFileSync(new URL(name+'.svg',out),`<svg xmlns="http://www.w3.org/2000/svg" width="960" height="${height}" viewBox="0 0 960 ${height}" role="img"><title>${esc(description)}</title><defs><marker id="arrow" markerUnits="userSpaceOnUse" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8" fill="${C.gray}"/></marker></defs><rect width="960" height="${height}" fill="white"/><g font-family="Arial, Helvetica, sans-serif">${body}</g></svg>`);
}

{
  let b = text(170,32,'Past readings (°C)',22,C.blue)+text(450,32,'Illustrative weights',22)+text(800,32,'Forecast (°C)',22,C.orange);
  [12,13,15].forEach((v,i)=>{
    const y=55+i*65;
    b+=box(115,y,110,44,v,C.blue)+arrow(240,y+22,350,y+22);
    b+=box(365,y,170,44,'× '+[0.2,0.3,0.5][i]);
    b+=arrow(550,y+22,650,142);
  });
  b+=box(660,115,95,54,'Sum')+arrow(765,142,800,142)+box(810,115,125,54,'13.8',C.orange);
  b+=text(480,267,'0.2 × 12 + 0.3 × 13 + 0.5 × 15 = 13.8',24);
  save('10-simple-weighted-model',290,'Three weighted readings form a linear forecast',b);
}
{
  let b = text(480,30,'Input: 12, 13, 15 °C',23,C.blue);
  b+=box(265,55,430,56,'Latest reading > 14 °C?');
  b+=arrow(370,115,225,185)+arrow(590,115,735,185);
  b+=text(190,153,'No',21)+text(770,153,'Yes (15 > 14)',21,C.teal);
  b+=box(90,195,270,54,'Predict 13 °C',C.gray)+box(600,195,270,54,'Predict 16 °C',C.orange);
  save('11-simple-decision-tree',275,'An illustrative learned split gives different predictions',b);
}
{
  let b=text(130,28,'Input readings',22,C.blue)+text(480,28,'Intermediate units',22)+text(820,28,'Output',22,C.orange);
  const inputs=[65,135,205], units=[100,175];
  for(const y of inputs) for(const z of units) b+=arrow(180,y+20,410,z+10);
  for(const z of units) b+=arrow(550,z+10,740,145);
  [12,13,15].forEach((v,i)=>{b+=box(80,inputs[i],100,40,v,C.blue);});
  units.forEach(y=>{b+=box(415,y-15,135,50,'Unit');});
  b+=box(750,117,175,56,'Forecast',C.orange);
  b+=text(480,285,'Each unit: weighted combination + nonlinear function',22);
  save('12-simple-feedforward',310,'A small feed-forward network with intermediate units',b);
}
{
  let b='';
  const xs=[45,285,525];
  xs.forEach((x,i)=>{
    b+=box(x,25,150,44,[12,13,15][i]+' °C',C.blue)+arrow(x+75,75,x+75,115);
    b+=box(x,125,150,54,'Same unit');
    if(i<2) b+=arrow(x+155,152,x+235,152)+text(x+195,130,'State',18,C.teal);
  });
  b+=arrow(685,152,745,152)+box(755,125,175,54,'Forecast',C.orange);
  b+=text(480,230,'Earlier → later: update the state at each reading',22);
  save('12-simple-recurrent',255,'The same recurrent unit updates a state across three readings',b);
}
{
  let b='';
  const xs=[40,265,490,745], w=170;
  const shapes=[[0.1,0.25,0.45,0.7,0.9],[0.9,0.7,0.5,0.3,0.1],[0.5,0.5,0.5,0.5,0.5]];
  const windows=[
    {y:120,caption:'Window A',current:0,weights:[0.7,0.2,0.1]},
    {y:385,caption:'Window B: different current input',current:2,weights:[0.1,0.2,0.7]},
  ];
  windows.forEach(row=>{
    b+=text(225,row.y-95,row.caption,22,C.ink);
    row.weights.forEach((weight,i)=>{
      const start=xs[3]+w/2, end=xs[i]+w/2;
      const lift=[90,65,42][i];
      b+=`<path d="M${start},${row.y} C${start},${row.y-lift} ${end},${row.y-lift} ${end},${row.y}" fill="none" stroke="${weight>0.5?C.teal:'#AAB8C5'}" stroke-width="${1+weight*7}" marker-end="url(#arrow)"/>`;
    });
    xs.forEach((x,i)=>{
      const selected=i===3||row.weights[i]>0.5;
      const color=selected?C.teal:C.blue;
      b+=`<rect x="${x}" y="${row.y}" width="${w}" height="95" rx="6" fill="${C.pale}" stroke="${color}" stroke-width="2"/>`;
      b+=text(x+w/2,row.y+26,i===3?'Current pattern':'Earlier interval '+(i+1),19,color);
      const shape=shapes[i===3?row.current:i];
      const pts=shape.map((v,j)=>`${x+22+j*31},${row.y+80-v*35}`).join(' ');
      b+=`<polyline points="${pts}" fill="none" stroke="${color}" stroke-width="3"/>`;
      b+=text(x+w/2,row.y+125,i===3?'Position being updated':'Weight: '+row.weights[i].toFixed(1),19,color);
    });
  });
  b+=text(480,555,'Different current input → different influence of earlier intervals',23,C.ink);
  b+=text(480,586,'Thicker link = greater attention weight (illustrative)',21,C.gray);
  save('13-simple-attention',610,'Attention can select different past information for different input windows',b);
}
for (const scenario of [
  {name:'14-task-training',source:['This task\'s','training data'],model:'Trained model',action:'Train',note:'Parameters fitted on this task\'s training data'},
  {name:'14-simple-pretraining',source:['Many other','time series'],model:'Pretrained model',action:'Pretrain',note:'Zero-shot: no parameter updates on this task'},
]) {
  let b=`<rect x="25" y="35" width="235" height="70" rx="6" fill="${C.pale}" stroke="${C.blue}" stroke-width="2"/>`;
  b+=text(142,62,scenario.source[0],23,C.blue)+text(142,90,scenario.source[1],23,C.blue);
  b+=arrow(270,70,385,70)+text(327,48,scenario.action,20);
  b+=box(395,35,250,70,scenario.model,C.teal)+arrow(655,70,745,70);
  b+=box(755,35,180,70,'Forecast',C.orange);
  b+=text(142,184,'Current readings:',22,C.blue);
  b+=box(25,200,235,48,'12, 13, 15 °C',C.blue);
  b+=`<path d="M270,224 L520,224 L520,115" fill="none" stroke="${C.gray}" stroke-width="2" marker-end="url(#arrow)"/>`;
  save(scenario.name,260,'Training experience and current input serve different roles',b);
}
