// Monta o logotipo do MusicaliAPP em SVG, com as cores da paleta (docs/design.md).
// Base: o nome gerado no Recraft (conceitos/nome-1.svg) e o símbolo (simbolo-escuro.svg).
// Mudanças: letras um pouco mais encorpadas, os pingos dos "i" viram colcheias azuis
// e "APP" vai num selo azul arredondado.
// Uso: node logotipo.js   (na pasta design/logo)
const fs = require('fs');

const COR = {
  fundo: '#081428',
  letra: '#ffffff',
  nota: '#5cc0ff', // celeste do modo escuro
  selo: '#2a6fc9', // azul primário
};

const semMetadata = (t) => t.replace(/<metadata>[\s\S]*?<\/metadata>/g, '');
const fonte = semMetadata(fs.readFileSync('conceitos/nome-1.svg', 'utf8'));
const paths = [...fonte.matchAll(/<path[^>]*\sd="([^"]*)"[^>]*>/g)].map((m) => m[1]);

// Índices das peças em nome-1.svg (conferidos pelas caixas de cada caminho).
const MUSICALI = [1, 10, 11, 15, 12, 8, 13, 14]; // M u s i(haste) c a l i(haste)
const MIOLO_A = 9; // miolo do "a"
const APP = [6, 4, 2]; // A P P
const MIOLOS_APP = [7, 5, 3];
const PINGOS = [
  [2412, 1248],
  [3791, 1247],
]; // centros dos pingos dos "i"

// Colcheia com a cabeça centrada em (cx, cy).
const colcheia = (cx, cy) =>
  `<g transform="translate(${cx} ${cy})" fill="${COR.nota}">` +
  `<ellipse cx="0" cy="0" rx="72" ry="54" transform="rotate(-22)"/>` +
  `<rect x="44" y="-250" width="40" height="250" rx="12"/>` +
  `<path d="M 74 -250 C 130 -215 190 -175 168 -78 C 150 -128 118 -150 74 -158 Z"/>` +
  `</g>`;

const ENGROSSA = 22; // contorno extra nas letras (mesma cor), para dar mais peso

// Selo do APP
const s = 0.5; // escala das letras do APP
const app = { x0: 3893, y0: 1221, w: 1618, h: 603 };
const selo = { x: 4090, y: 1250, w: Math.round(app.w * s + 300), h: 570 };
const appX = selo.x + 150 - app.x0 * s;
const appY = selo.y + (selo.h - app.h * s) / 2 - app.y0 * s;

const nome =
  `<g fill="${COR.letra}" stroke="${COR.letra}" stroke-width="${ENGROSSA}" stroke-linejoin="round">` +
  MUSICALI.map((i) => `<path d="${paths[i]}"/>`).join('') +
  `</g>` +
  `<path d="${paths[MIOLO_A]}" fill="${COR.fundo}"/>` +
  // Pingos dos "i": círculos azuis (a colcheia acima ficou guardada, mas não é usada).
  PINGOS.map(([x, y]) => `<circle cx="${x}" cy="${y}" r="${62 + ENGROSSA / 2}" fill="${COR.nota}"/>`).join('') +
  `<rect x="${selo.x}" y="${selo.y}" width="${selo.w}" height="${selo.h}" rx="${Math.round(selo.h * 0.32)}" fill="${COR.selo}"/>` +
  `<g transform="translate(${appX} ${appY}) scale(${s})">` +
  `<g fill="${COR.letra}" stroke="${COR.letra}" stroke-width="${ENGROSSA / s}" stroke-linejoin="round">` +
  APP.map((i) => `<path d="${paths[i]}"/>`).join('') +
  `</g>` +
  MIOLOS_APP.map((i) => `<path d="${paths[i]}" fill="${COR.selo}"/>`).join('') +
  `</g>`;

// Área útil do nome (coordenadas de nome-1.svg)
const cropNome = { x: 640, y: 980, w: selo.x + selo.w + 60 - 640, h: 900 };

// 1) Só o nome, sobre o fundo escuro
fs.writeFileSync(
  'nome.svg',
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="${cropNome.x} ${cropNome.y} ${cropNome.w} ${cropNome.h}">` +
    `<rect x="${cropNome.x}" y="${cropNome.y}" width="${cropNome.w}" height="${cropNome.h}" fill="${COR.fundo}"/>` +
    nome +
    `</svg>`,
);

// 2) Logotipo horizontal: símbolo + nome
const simbolo = semMetadata(fs.readFileSync('simbolo-escuro.svg', 'utf8'));
const cropSimbolo = '1064 1192 2469 1979';
const S = 200; // altura do símbolo
const sw = Math.round((S * 2469) / 1979);
const th = Math.round(S * 0.82); // altura do bloco do nome
const tw = Math.round((th * cropNome.w) / cropNome.h);
const pad = 64;
const gap = 40;
const W = pad + sw + gap + tw + pad;
const H = S + 2 * pad;
const logotipo =
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}" width="${W}" height="${H}">` +
  `<title>MusicaliAPP</title>` +
  `<rect width="${W}" height="${H}" fill="${COR.fundo}"/>` +
  simbolo.replace(/<svg[^>]*>/, `<svg x="${pad}" y="${pad}" width="${sw}" height="${S}" viewBox="${cropSimbolo}" preserveAspectRatio="xMidYMid meet">`) +
  `<svg x="${pad + sw + gap}" y="${pad + (S - th) / 2}" width="${tw}" height="${th}" viewBox="${cropNome.x} ${cropNome.y} ${cropNome.w} ${cropNome.h}">${nome}</svg>` +
  `</svg>`;
fs.writeFileSync('logotipo-azul.svg', logotipo);
console.log('nome.svg', cropNome.w, cropNome.h, '| logotipo-azul.svg', W, H);
