// Gera os ícones do app a partir do símbolo (simbolo-escuro.svg).
// Os PNGs são renderizados pelo Chrome em modo headless (sem dependências do npm).
// Uso: node icones.js   (na pasta design/logo)
const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const CHROME = [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
].find((p) => fs.existsSync(p));
if (!CHROME) throw new Error('Chrome ou Edge não encontrado');

const FUNDO = '#081428';
const SAIDA = path.resolve('icones');
fs.mkdirSync(path.join(SAIDA, 'svg'), { recursive: true });

// Conteúdo do símbolo, sem o <metadata> (C2PA) e sem o retângulo de fundo
// (o fundo de cada ícone é desenhado à parte, para controlar cantos e margens).
const bruto = fs.readFileSync('simbolo-escuro.svg', 'utf8').replace(/<metadata>[\s\S]*?<\/metadata>/g, '');
const interno = bruto.replace(/^[\s\S]*?<svg[^>]*>/, '').replace(/<\/svg>\s*$/, '');
// Área útil do símbolo no viewBox original (0 0 4358 4358)
const CROP = { x: 1064, y: 1192, w: 2469, h: 1979 };

// Temas: o escuro é o padrão; o claro tem fundo névoa e borda azul no ícone
// e na folha, para o branco não se perder em páginas claras.
const TEMAS = {
  escuro: { fundo: FUNDO, borda: null, simbolo: interno },
  claro: {
    fundo: '#eef6f8',
    borda: '#0b4ea2',
    simbolo: interno
      .split('#081428')
      .join('#eef6f8')
      .replace('fill="#ffffff"', 'fill="#ffffff" stroke="#0b4ea2" stroke-width="70" stroke-linejoin="round"')
      .replace('fill="#ffd83a"', 'fill="#ffd83a" stroke="#000000" stroke-width="70" stroke-linejoin="round"'),
  },
};

// Monta um ícone quadrado de lado `lado`.
// ocupa: fração da largura que o símbolo ocupa; raio: canto do fundo (fração do lado, 0 = quadrado).
function icone({ lado, ocupa, raio = 0 }, tema = TEMAS.escuro) {
  const w = lado * ocupa;
  const h = (w * CROP.h) / CROP.w;
  const x = (lado - w) / 2;
  const y = (lado - h) / 2;
  const r = lado * raio;
  // Borda: no mínimo 1 px; o retângulo é recuado meia espessura para a borda não ser cortada.
  // Ícones sem cantos (maskable e Apple) são recortados pelo sistema: neles a borda seria cortada.
  const temBorda = tema.borda && raio > 0;
  const e = temBorda ? Math.max(1, Math.round(lado * 0.04)) : 0;
  const fundo = temBorda
    ? `<rect x="${e / 2}" y="${e / 2}" width="${lado - e}" height="${lado - e}" rx="${Math.max(0, r - e / 2)}" fill="${tema.fundo}" stroke="${tema.borda}" stroke-width="${e}"/>`
    : `<rect width="${lado}" height="${lado}" rx="${r}" fill="${tema.fundo}"/>`;
  return (
    `<svg xmlns="http://www.w3.org/2000/svg" width="${lado}" height="${lado}" viewBox="0 0 ${lado} ${lado}">` +
    fundo +
    `<svg x="${x}" y="${y}" width="${w}" height="${h}" viewBox="${CROP.x} ${CROP.y} ${CROP.w} ${CROP.h}">${tema.simbolo}</svg>` +
    `</svg>`
  );
}

// O retângulo de fundo do símbolo original também é #081428, então pode ficar:
// ele só aparece dentro da área do símbolo, sobre o mesmo fundo.
const ICONES = [
  // PWA (purpose "any"): símbolo grande, cantos levemente arredondados
  { nome: 'icon-192.png', lado: 192, ocupa: 0.74, raio: 0.18 },
  { nome: 'icon-512.png', lado: 512, ocupa: 0.74, raio: 0.18 },
  // PWA (purpose "maskable"): fundo cheio, símbolo dentro do círculo central de 80%
  { nome: 'icon-maskable-192.png', lado: 192, ocupa: 0.58 },
  { nome: 'icon-maskable-512.png', lado: 512, ocupa: 0.58 },
  // Apple: fundo cheio (o iOS arredonda os cantos)
  { nome: 'apple-touch-icon.png', lado: 180, ocupa: 0.7 },
  // Favicons: símbolo quase no limite, para ler na aba do navegador
  { nome: 'favicon-16.png', lado: 16, ocupa: 0.94, raio: 0.2 },
  { nome: 'favicon-32.png', lado: 32, ocupa: 0.9, raio: 0.2 },
  { nome: 'favicon-48.png', lado: 48, ocupa: 0.88, raio: 0.2 },
];

const TODOS = [
  ...ICONES.map((i) => ({ ...i, tema: TEMAS.escuro })),
  ...ICONES.map((i) => ({ ...i, nome: i.nome.replace('.png', '-claro.png'), tema: TEMAS.claro })),
];

// Opcional: `node icones.js maskable` gera só os ícones cujo nome contém o filtro.
const FILTRO = process.argv[2] ? new RegExp(process.argv[2]) : null;

for (const i of TODOS.filter((t) => !FILTRO || FILTRO.test(t.nome))) {
  const svgPath = path.join(SAIDA, 'svg', i.nome.replace('.png', '.svg'));
  fs.writeFileSync(svgPath, icone(i, i.tema));
  const pngPath = path.join(SAIDA, i.nome);
  execFileSync(
    CHROME,
    [
      '--headless=new',
      '--disable-gpu',
      '--hide-scrollbars',
      '--force-device-scale-factor=1',
      '--default-background-color=00000000',
      `--window-size=${i.lado},${i.lado}`,
      `--screenshot=${pngPath}`,
      'file:///' + svgPath.replace(/\\/g, '/'),
    ],
    { stdio: 'ignore' },
  );
  console.log(i.nome, fs.statSync(pngPath).size, 'bytes');
}

// favicon.svg (navegadores atuais): troca sozinho entre a versão clara e a escura,
// conforme o tema do sistema (prefers-color-scheme).
{
  const base = { lado: 48, ocupa: 0.88, raio: 0.2 };
  const corpo = (svg) => svg.replace(/^<svg[^>]*>/, '').replace(/<\/svg>$/, '');
  fs.writeFileSync(
    path.join(SAIDA, 'favicon.svg'),
    `<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">` +
      `<style>.claro{display:none}@media (prefers-color-scheme: light){.claro{display:inline}.escuro{display:none}}</style>` +
      `<g class="escuro">${corpo(icone(base, TEMAS.escuro))}</g>` +
      `<g class="claro">${corpo(icone(base, TEMAS.claro))}</g>` +
      `</svg>`,
  );
}

// favicon.ico com 16, 32 e 48 px (PNG dentro do ICO, aceito pelos navegadores atuais)
const pngs = [16, 32, 48].map((t) => ({ t, dados: fs.readFileSync(path.join(SAIDA, `favicon-${t}.png`)) }));
const cab = Buffer.alloc(6 + 16 * pngs.length);
cab.writeUInt16LE(0, 0);
cab.writeUInt16LE(1, 2);
cab.writeUInt16LE(pngs.length, 4);
let deslocamento = cab.length;
pngs.forEach((p, k) => {
  const o = 6 + 16 * k;
  cab.writeUInt8(p.t, o);
  cab.writeUInt8(p.t, o + 1);
  cab.writeUInt8(0, o + 2);
  cab.writeUInt8(0, o + 3);
  cab.writeUInt16LE(1, o + 4);
  cab.writeUInt16LE(32, o + 6);
  cab.writeUInt32LE(p.dados.length, o + 8);
  cab.writeUInt32LE(deslocamento, o + 12);
  deslocamento += p.dados.length;
});
fs.writeFileSync(path.join(SAIDA, 'favicon.ico'), Buffer.concat([cab, ...pngs.map((p) => p.dados)]));
console.log('favicon.ico ok');
