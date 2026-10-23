# Como escrever acordes no MusicaliAPP

Este é o conteúdo da página `/ajuda/acordes` (RF68). Ele explica como a cifra é gravada, como o app padroniza o que você digita e quais grafias são aceitas (RN95).

## 1. Como a cifra é guardada

O app grava a cifra em **graus do campo harmônico**, com algarismos de 1 a 7. O grau **1** é a tônica, e o **5** é a dominante, por exemplo. Como o grau não depende da tonalidade, a mesma música aparece em qualquer tom. Você escreve uma vez e a tela mostra em letras no tom que quiser.

A escrita dos acordes segue **um padrão fixo**: letras para as notas, `m` para menor, `7M` para sétima maior, `+` e `-` nas alterações. Tudo que é gravado segue esse padrão.

## 2. Processo de padronização

Quando você salva a cifra, o app faz estes passos:

1. **Separa** cada linha em partes: acordes, letra, marcador de seção (`[Refrão]`) e linhas vazias.
2. **Reconhece** cada acorde pela tabela de formas (seção 3). Variações conhecidas são convertidas para o padrão (seção 4).
3. **Converte** as letras para graus, usando o tom que você escolheu como tom da escrita. Se você escreveu em graus, nada muda.
4. **Grava** só os graus, com as posições dos acordes na letra.
5. **Avisa** sobre o que não reconheceu. Uma linha com um item que o app não entende é tratada como letra, e o aviso mostra o item. Nada é recusado.

O texto original que você digitou não fica guardado. O que fica é o padrão em graus.

## 3. Tabela do padrão

### 3.1 Maiores e menores

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C` | `1` | Maior, sobre o primeiro grau. |
| `Dm`, `Em`, `Am` | `2m`, `3m`, `6m` | Menor. |
| `Eb`, `Bb`, `F#` | `3b`, `7b`, `4#` | Grau alterado: o `b` ou o `#` vem depois do grau. |
| `Cm` em tom menor | `1m` | Em tom menor, o grau 1 é a tônica. |

### 3.2 Sétimas

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C7` | `17` | Dominante: maior com sétima menor. |
| `C7M` | `17M` | Sétima maior. |
| `Cm7` | `1m7` | Menor com sétima. |

### 3.3 Sextas e nonas

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C6` | `16` | Sexta. |
| `C6(9)` | `16(9)` | Sexta com nona. |
| `C9` | `19` | Nona adicionada (`add9`), **sem sétima**. |
| `C7(9)` | `17(9)` | Nona dominante, **com sétima**. |
| `C7M(9)` | `17M(9)` | Nona com sétima maior. |

Atenção: no padrão do app, `C9` é nona adicionada. A nona dominante é sempre `C7(9)`. Em algumas bibliotecas americanas, `C9` quer dizer nona dominante. Aqui não.

### 3.4 Suspensas

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C2` | `12` | Suspensa de segunda (`sus2`). |
| `C4` | `14` | Suspensa de quarta (`sus4`). |
| `C7(4)` | `17(4)` | Suspensa de quarta com sétima. |

### 3.5 Quarta adicionada

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C11` | `111` | Quarta adicionada (`add4`), **sem sétima**. |

Atenção: aqui `C11` quer dizer quarta adicionada, não a undécima dominante. Se o acorde tiver sétima, use `C7(11)`.

### 3.6 Alterações (dentro dos parênteses)

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C7(9-)` | `17(9-)` | Nona bemol. |
| `C7(9+)` | `17(9+)` | Nona sustenido. |
| `C7(5+)` | `17(5+)` | Quinta aumentada. |
| `C7(5-)` | `17(5-)` | Quinta diminuta. |
| `C7(9-/11+/13-)` | `17(9-/11+/13-)` | Várias alterações, em ordem crescente, separadas por `/`. |

Dentro dos parênteses, o número vem **antes** do sinal, e o sinal é `+` (aumentado) ou `-` (diminuto ou bemol). Você também pode digitar `b` e `#` ali (seção 4).

### 3.7 Aumentado e diminuto

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C5+` | `15+` | Aumentado (tríade). |
| `Cm5-` | `1m5-` | Diminuto (tríade). |
| `Cº` | `1º` | Sétima diminuta. |
| `Cm7(5-)` | `1m7(5-)` | Meio-diminuto. |

### 3.8 Baixo

| Em letras (padrão) | Em graus (gravado) | Significado |
|---|---|---|
| `C/E` | `1/3` | Baixo na terça. |
| `Am7/G` | `6m7/5` | Baixo no quinto grau, em tom de C. |
| `Dm6/B` | `2m6/7` | Baixo no sétimo grau, em tom de C. |
| `D9/C#` | `19/7` | Em tom de D, o `C#` é o sétimo grau. |

Obs.: o baixo também é escrito em grau. O acidente vem depois do grau, como no acorde.

## 4. Variações que você pode digitar

Ao digitar, o app aceita estas variações e converte para o padrão. A coluna da direita é o que fica gravado e o que aparece na tela.

### 4.1 Alterações entre parênteses

| Você digita | Gravado | Observação |
|---|---|---|
| `C7(b9)` | `C7(9-)` | `b` no lugar de `-`. |
| `C7(-9)` | `C7(9-)` | Padrão. |
| `C7(9b)` | `C7(9-)` | Sinal depois do número, como o padrão. |
| `C7(#5)` | `C7(5+)` | `#` no lugar de `+`. |
| `C7(+5)` | `C7(5+)` | Padrão. |
| `C7(b9,#11,b13)` | `C7(9-/11+/13-)` | Vírgula ou espaço viram `/`. Misturar `b` e `-` na mesma extensão também funciona. |

### 4.2 Sétimas, sus e add

| Você digita | Gravado |
|---|---|
| `Cmaj7`, `CM7`, `CΔ`, `C^7` | `C7M` |
| `Cmaj9` | `C7M(9)` |
| `Csus`, `Csus4` | `C4` |
| `Csus2` | `C2` |
| `C7sus4` | `C7(4)` |
| `Cadd9`, `Cadd2` | `C9` |
| `Cadd4` | `C11` |

### 4.3 Menor, diminuto e meio-diminuto

| Você digita | Gravado |
|---|---|
| `C-7`, `Cmin7` | `Cm7` |
| `Cdim` | `Cm5-` |
| `Cº`, `C°`, `Cdim7` | `Cº` |
| `Cm7b5`, `Cø` | `Cm7(5-)` |

### 4.4 Outros

| Você digita | Gravado |
|---|---|
| `C+`, `Caug` | `C5+` |
| `C6/9`, `C69` | `C6(9)` |
| `C13` | `C7(13)` |

## 5. O que não é reconhecido

Se o app não entender um acorde, ele não grava um acorde errado. A linha em que o item aparece é tratada como letra, e o editor mostra um aviso com o item. Exemplos:

- `C7alt`, `Cx`, símbolos que não estão nas tabelas;
- uma linha com acordes e uma palavra no meio, como `C Am Senhor G`.

Corrija o item no editor. O aviso some quando a linha vira acordes válidos.

## 6. Perguntas frequentes

**Por que graus e não letras?** Porque uma cifra em graus serve para qualquer tom. Você escreve uma vez e a música aparece em D, Eb ou qualquer outro tom.

**Posso digitar em letras?** Sim, em um tom que você informa como tom da escrita. O app converte para graus. Sempre se grava em graus.

**Por que `C9` não é nona dominante?** No padrão do app, `9` é nona adicionada. A nona dominante é `C7(9)`. Isso é o que a maioria dos músicos brasileiros escreve.

**Por que `b` e `#` às vezes não funcionam?** Fora dos parênteses, `b` e `#` são acidentes da nota (`Bb`, `C#m7`). Dentro dos parênteses, eles viram alteração: `(b9)` é o mesmo que `(-9)`.

**O app mostra o que eu digitei?** Não. Ele mostra o padrão, em letras, no tom que você escolher.

**Quem vê a cifra em outro tom?** Qualquer pessoa. A escolha de tom vale só para quem está vendo e não é gravada.

## 7. Experimente

Um campo onde você digita um acorde e vê:
- se o app reconhece;
- como fica gravado (em graus);
- como aparece no tom que você escolher.

Nada é gravado.

## 8. Exemplo completo

Digitado em letras, no tom de **D**:

```
D      Bm      G       A7
Senhor, tu és fiel
```

Gravado em graus:

```
1      6m      4       57
Senhor, tu és fiel
```

Na tela, no tom de **E**:

```
E      C#m     A       B7
Senhor, tu és fiel
```

A letra não muda. Só os acordes são convertidos.
