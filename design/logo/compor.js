// Monta o logotipo (símbolo + nome) a partir dos SVGs do Recraft.
// Uso: node compor.js   (na pasta design/logo)
const fs = require('fs');

const trocarCores = (t, mapa) => {
  for (const [de, para] of mapa) t = t.split(de).join(para);
  return t;
};

// Coloca um SVG dentro de outro, recortando a área útil (crop = viewBox interno).
// Remove o <metadata> (C2PA), que usa um prefixo de namespace declarado só na raiz original.
const aninhar = (arquivo, mapa, crop, x, y, w, h) => {
  const t = trocarCores(fs.readFileSync(arquivo, 'utf8'), mapa).replace(/<metadata>[\s\S]*?<\/metadata>/g, '');
  return t.replace(/<svg[^>]*>/, `<svg x="${x}" y="${y}" width="${w}" height="${h}" viewBox="${crop}" preserveAspectRatio="xMidYMid meet">`);
};

const simbolo = { arquivo: 'simbolo-escuro.svg', mapa: [], crop: '1064 1192 2469 1979' };
const nomes = {
  1: {
    arquivo: 'conceitos/nome-1.svg',
    mapa: [['rgb(252,219,69)', '#ffd83a'], ['rgb(254,254,254)', '#ffffff'], ['rgb(5,18,49)', '#081428']],
    crop: '640 1180 4880 640',
  },
  2: {
    arquivo: 'conceitos/nome-2.svg',
    mapa: [['rgb(254,226,69)', '#ffd83a'], ['rgb(254,254,254)', '#ffffff'], ['rgb(10,11,44)', '#081428'], ['rgb(2,1,2)', '#081428']],
    crop: '920 1220 4320 588',
  },
};

for (const k of [1, 2]) {
  const n = nomes[k];
  const [cw, ch] = n.crop.split(' ').slice(2).map(Number);
  const S = 200;
  const sw = Math.round((S * 2469) / 1979);
  const th = 104;
  const tw = Math.round((th * cw) / ch);
  const pad = 64;
  const gap = 44;
  const W = pad + sw + gap + tw + pad;
  const H = S + 2 * pad;
  const svg =
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}">` +
    `<rect width="${W}" height="${H}" fill="#081428"/>` +
    aninhar(simbolo.arquivo, simbolo.mapa, simbolo.crop, pad, pad, sw, S) +
    aninhar(n.arquivo, n.mapa, n.crop, pad + sw + gap, pad + (S - th) / 2, tw, th) +
    `</svg>`;
  fs.writeFileSync(`logotipo-${k}.svg`, svg);
  console.log(`logotipo-${k}.svg`, W, H);
}
