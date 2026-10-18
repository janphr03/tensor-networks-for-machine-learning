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
{
  let b='';
  b+=text(235,30,'No previous training',24,C.ink);
  b+=text(725,30,'Prior training on other datasets',24,C.teal);
  b+='<line x1="480" y1="20" x2="480" y2="505" stroke="#D7E0E9" stroke-width="2"/>';
  const shapes=[[0.1,0.3,0.4,0.7,0.9],[0.2,0.8,0.2,0.8,0.2],[0.8,0.5,0.7,0.3,0.4]];
  [530,665,800].forEach((x,k)=>{
    b+=`<rect x="${x}" y="55" width="115" height="95" rx="5" fill="${C.pale}" stroke="${C.blue}" stroke-width="1.5"/>`;
    b+=text(x+57,82,'Dataset '+['A','B','C'][k],18,C.blue);
    b+=`<polyline points="${shapes[k].map((v,i)=>`${x+12+i*22},${139-v*40}`).join(' ')}" fill="none" stroke="${C.blue}" stroke-width="2"/>`;
  });
  b+=arrow(725,160,725,200,C.gray)+text(825,188,'Pretraining',20,C.teal);
  b+=text(235,180,'Random initialization',22,C.gray);
  const networks=[
    {x:85,color:C.gray,weights:['0.08','−0.21','0.13'],label:'Random weights'},
    {x:575,color:C.teal,weights:['0.20','0.30','0.50'],label:'Learned weights'},
  ];
  networks.forEach(net=>{
    [235,305,375].forEach(y=>{
      b+=arrow(net.x+24,y,net.x+245,305,net.color,2);
    });
    [235,305,375].forEach((y,i)=>{
      b+=`<circle cx="${net.x}" cy="${y}" r="19" fill="${C.pale}" stroke="${C.blue}" stroke-width="2"/>`;
      const labelY=[261,305,349][i];
      b+=`<rect x="${net.x+36}" y="${labelY-16}" width="148" height="32" rx="4" fill="white"/>`;
      b+=`<text x="${net.x+110}" y="${labelY+7}" font-size="21" text-anchor="middle" fill="${net.color}">w<tspan baseline-shift="sub" font-size="14">${i+1}</tspan> = ${net.weights[i]}</text>`;
    });
    b+=`<circle cx="${net.x+265}" cy="305" r="20" fill="${C.pale}" stroke="${net.color}" stroke-width="2"/>`;
    b+=text(net.x+145,430,net.label,24,net.color);
  });
  b+=text(235,477,'Next: train on our task’s data',21,C.ink);
  b+=text(725,477,'Next: zero-shot use or fine-tuning',21,C.teal);
  save('14-training-starting-points',505,'Random initial weights compared with weights learned from three other time-series datasets',b);
}
