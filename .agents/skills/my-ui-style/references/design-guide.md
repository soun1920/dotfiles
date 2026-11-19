# UI 詳細ガイド

Material Design 3（M3）のトークン体系と部品の仕様をもとに、水色を種色にした配色で UI を作るためのローカル規約。
適用範囲は ../SKILL.md を優先する。
M3 の仕様そのものを確認するときは一次資料（https://m3.material.io/）を読む。
WCAG の適合を主張するときは実際の画面で確認する。

---

## 1. 方針

- M3 の役割名（color role）でトークンを定義し、部品からは役割名だけを参照する。部品に16進の色を直接書かない。
- 色の階層は影ではなく surface container の明度差で表す。影は浮いている部品（メニュー、FAB、ダイアログ）に限る。
- 操作に対する反応は M3 の状態レイヤー（hover・focus・pressed で重ねる半透明の層）で統一する。
- 日本語の読みやすさを M3 の既定値より優先する（書体、行の高さ、最小の文字サイズ）。
- 色だけで情報を区別しない。アイコン・テキスト・形状を併用する（WCAG 1.4.1）。

---

## 2. 色

### 生成条件

- 種色: `#4FC3F7`（水色）
- 方式: M3 の既定である Tonal Spot、標準コントラスト
- 生成: `@material/material-color-utilities` 0.3.0 の `SchemeTonalSpot`

primary は水色、secondary は灰色がかった青、tertiary は薄い紫になる。
tertiary は M3 が種色の色相を回して自動で作る補助色である。
使う場面は primary・secondary と区別したい少数の要素（別系統のタグなど）に限る。

種色を変える場合は、同じライブラリで再生成し、2節の値をまとめて差し替える。
一部の値だけを手で調整すると、on-* 色との組み合わせでコントラストが崩れる。

### ダーク（既定）

```css
:root {
  --md-sys-color-primary: #8ecff2;
  --md-sys-color-on-primary: #003548;
  --md-sys-color-primary-container: #004d67;
  --md-sys-color-on-primary-container: #c2e8ff;
  --md-sys-color-secondary: #b5c9d7;
  --md-sys-color-on-secondary: #20333d;
  --md-sys-color-secondary-container: #364954;
  --md-sys-color-on-secondary-container: #d1e5f3;
  --md-sys-color-tertiary: #c9c2ea;
  --md-sys-color-on-tertiary: #312c4c;
  --md-sys-color-tertiary-container: #474364;
  --md-sys-color-on-tertiary-container: #e5deff;
  --md-sys-color-error: #ffb4ab;
  --md-sys-color-on-error: #690005;
  --md-sys-color-error-container: #93000a;
  --md-sys-color-on-error-container: #ffdad6;
  --md-sys-color-surface-dim: #0f1417;
  --md-sys-color-surface: #0f1417;
  --md-sys-color-surface-bright: #353a3d;
  --md-sys-color-surface-container-lowest: #0a0f12;
  --md-sys-color-surface-container-low: #171c1f;
  --md-sys-color-surface-container: #1b2023;
  --md-sys-color-surface-container-high: #262b2e;
  --md-sys-color-surface-container-highest: #313539;
  --md-sys-color-on-surface: #dfe3e7;
  --md-sys-color-on-surface-variant: #c0c7cd;
  --md-sys-color-outline: #8a9297;
  --md-sys-color-outline-variant: #40484d;
  --md-sys-color-inverse-surface: #dfe3e7;
  --md-sys-color-inverse-on-surface: #2c3134;
  --md-sys-color-inverse-primary: #196584;
  --md-sys-color-scrim: #000000;
  --md-sys-color-shadow: #000000;
  color-scheme: dark;
}
```

### ライト

```css
[data-theme="light"] {
  --md-sys-color-primary: #196584;
  --md-sys-color-on-primary: #ffffff;
  --md-sys-color-primary-container: #c2e8ff;
  --md-sys-color-on-primary-container: #004d67;
  --md-sys-color-secondary: #4e616d;
  --md-sys-color-on-secondary: #ffffff;
  --md-sys-color-secondary-container: #d1e5f3;
  --md-sys-color-on-secondary-container: #364954;
  --md-sys-color-tertiary: #5f5a7d;
  --md-sys-color-on-tertiary: #ffffff;
  --md-sys-color-tertiary-container: #e5deff;
  --md-sys-color-on-tertiary-container: #474364;
  --md-sys-color-error: #ba1a1a;
  --md-sys-color-on-error: #ffffff;
  --md-sys-color-error-container: #ffdad6;
  --md-sys-color-on-error-container: #93000a;
  --md-sys-color-surface-dim: #d6dade;
  --md-sys-color-surface: #f6fafe;
  --md-sys-color-surface-bright: #f6fafe;
  --md-sys-color-surface-container-lowest: #ffffff;
  --md-sys-color-surface-container-low: #f0f4f8;
  --md-sys-color-surface-container: #eaeef2;
  --md-sys-color-surface-container-high: #e5e9ed;
  --md-sys-color-surface-container-highest: #dfe3e7;
  --md-sys-color-on-surface: #171c1f;
  --md-sys-color-on-surface-variant: #40484d;
  --md-sys-color-outline: #71787d;
  --md-sys-color-outline-variant: #c0c7cd;
  --md-sys-color-inverse-surface: #2c3134;
  --md-sys-color-inverse-on-surface: #edf1f5;
  --md-sys-color-inverse-primary: #8ecff2;
  --md-sys-color-scrim: #000000;
  --md-sys-color-shadow: #000000;
  color-scheme: light;
}
```

### 確認済みのコントラスト

| 組み合わせ | ダーク | ライト |
|---|---|---|
| primary / surface | 10.91:1 | 6.19:1 |
| on-primary / primary | 7.71:1 | 6.49:1 |
| on-surface-variant / surface-container-highest | 7.24:1 | 7.23:1 |
| outline / surface（非文字） | 5.86:1 | 4.27:1 |
| secondary（フォーカスリング） / surface | 10.86:1 | 6.15:1 |

outline-variant は区切り線などの装飾用で、3:1 に届かない。
入力欄や操作部品の境界には outline を使う。

### 役割の使い分け

| 役割 | 使う場所 |
|---|---|
| primary / on-primary | 画面で最も重要な操作（filled ボタン、選択中の表示） |
| primary-container / on-primary-container | 強調したいが primary ほど強くない面（FAB、選択中のカード） |
| secondary-container / on-secondary-container | tonal ボタン、選択中のチップ、ナビゲーションの選択表示 |
| surface / on-surface | 画面の背景と本文 |
| surface-container-low〜highest | カード、シート、ダイアログなど背景から一段上がる面。上の階層ほど high 側を使う |
| on-surface-variant | 説明文、アイコン、補助的なラベル |
| outline | 入力欄と outlined ボタンの境界 |
| outline-variant | 区切り線、outlined カードの境界 |
| error / error-container | エラー表示。必ずアイコンと文言を併記する |

- 面の色と文字の色は必ず対（surface と on-surface、primary-container と on-primary-container）で使う。
- 成功・警告の色は M3 の役割に無い。必要になったら同じライブラリで種色から追加のパレットを作り、ハードコードした緑・黄を使わない。

---

## 3. タイポグラフィ

M3 の書体既定は Roboto だが、日本語の表示を優先して Zen 系の書体に置き換える。
型の名前（Display / Headline / Title / Body / Label）とサイズの段階は M3 に合わせ、行の高さは日本語向けに広げる。

```css
@import url('https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+New:wght@400;500;700&family=Zen+Maru+Gothic:wght@500;700&family=Noto+Sans+Mono:wght@400;700&display=swap');

:root {
  --md-ref-typeface-brand: 'Zen Maru Gothic', sans-serif;     /* Display, Headline */
  --md-ref-typeface-plain: 'Zen Kaku Gothic New', sans-serif; /* Title, Body, Label */
  --md-ref-typeface-mono:  'Noto Sans Mono', monospace;
}
```

| トークン | サイズ | 行の高さ | 太さ | 書体 | 用途 |
|---|---|---|---|---|---|
| display-large | 57px | 1.15 | 500 | brand | ヒーローの見出し |
| display-medium | 45px | 1.2 | 500 | brand | |
| display-small | 36px | 1.25 | 500 | brand | |
| headline-large | 32px | 1.3 | 700 | brand | ページ見出し（h1） |
| headline-medium | 28px | 1.35 | 700 | brand | 節の見出し（h2） |
| headline-small | 24px | 1.4 | 700 | brand | 小見出し（h3） |
| title-large | 22px | 1.4 | 500 | plain | アプリバー、ダイアログの題 |
| title-medium | 16px | 1.5 | 500 | plain | カードの題、リストの主行 |
| title-small | 14px | 1.5 | 500 | plain | 表の見出し |
| body-large | 16px | 1.75 | 400 | plain | 本文の基準 |
| body-medium | 14px | 1.7 | 400 | plain | 補足、表のセル |
| label-large | 14px | 1.25 | 500 | plain | ボタン、タブ、チップ |

- 本文は body-large（16px）を基準にする。
- M3 の body-small（12px）、label-medium（12px）、label-small（11px）は日本語では読みにくいので使わず、14px を下限にする。
- letter-spacing は M3 の欧文向けの値を使わず、見出しは 0、本文は 0.02em にする。
- 数値の列やコードは mono 書体と `font-variant-numeric: tabular-nums` を使う。

---

## 4. レイアウト

M3 のウィンドウ幅の区分（window size class）で配置を切り替える。
モバイルを先に書き、`min-width` で広げる。

| 区分 | 幅 | 左右の余白 | ナビゲーション | 列数 |
|---|---|---|---|---|
| compact | 〜599px | 16px | 下部のナビゲーションバー | 1 |
| medium | 600〜839px | 24px | ナビゲーションレール | 1〜2 |
| expanded | 840〜1199px | 24px | ナビゲーションレール | 2 |
| large | 1200〜1599px | 24px | レールまたは常設ドロワー | 2〜3 |
| extra-large | 1600px〜 | 24px | 常設ドロワー | 3 |

- 区画（pane）の間は 24px 空ける。
- 読み物の本文は `max-width: 40em` に収める。
- ナビゲーションの行き先は 3〜5 個にする。それ以上はドロワーかページ内の構造で扱う。

---

## 5. 余白

M3 は 4px の格子を基準にする。部品の内側は 4px 単位、配置は 8px 単位で決める。

```css
:root {
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
  --space-12: 48px;
  --space-16: 64px;
}
```

- カードの内側: 16px
- リストの行: 上下 8〜12px、左右 16px
- 見出しと本文の間: 8〜16px
- セクションの間: 48px 以上

---

## 6. 形状

M3 の角丸の段階（shape scale）を使う。

```css
:root {
  --md-sys-shape-corner-none: 0;
  --md-sys-shape-corner-extra-small: 4px;
  --md-sys-shape-corner-small: 8px;
  --md-sys-shape-corner-medium: 12px;
  --md-sys-shape-corner-large: 16px;
  --md-sys-shape-corner-extra-large: 28px;
  --md-sys-shape-corner-full: 9999px;
}
```

| 段階 | 部品 |
|---|---|
| extra-small | 入力欄、メニュー、ツールチップ |
| small | チップ、スナックバー |
| medium | カード |
| large | FAB、ナビゲーションドロワーの端 |
| extra-large | ダイアログ、ボトムシート上端 |
| full | ボタン、ナビゲーションの選択表示（active indicator）、スイッチ |

---

## 7. エレベーション

M3 では高さを主に面の色（surface container の段階）で表す。
影は、内容の上に重なる部品だけに付ける。

```css
:root {
  --md-sys-elevation-level1: 0 1px 2px 0 rgb(0 0 0 / .3), 0 1px 3px 1px rgb(0 0 0 / .15);
  --md-sys-elevation-level2: 0 1px 2px 0 rgb(0 0 0 / .3), 0 2px 6px 2px rgb(0 0 0 / .15);
  --md-sys-elevation-level3: 0 1px 3px 0 rgb(0 0 0 / .3), 0 4px 8px 3px rgb(0 0 0 / .15);
}
```

| 部品 | 面の色 | 影 |
|---|---|---|
| 画面の背景 | surface | なし |
| filled カード | surface-container-highest | なし |
| outlined カード | surface ＋ outline-variant の枠 | なし |
| elevated カード | surface-container-low | level1 |
| ナビゲーションバー・レール | surface-container | なし |
| メニュー | surface-container | level2 |
| FAB | primary-container | level3 |
| ダイアログ | surface-container-high | level3 |

---

## 8. 状態レイヤー

hover・focus・押下の反応は、部品の文字色（content color）を薄く重ねて表す。
部品ごとに hover 用の色を作らない。

| 状態 | 重ねる不透明度 |
|---|---|
| hover | 8% |
| focus | 10% |
| pressed | 10% |
| dragged | 16% |

```css
.state-layer { position: relative; isolation: isolate; overflow: hidden; }
.state-layer::before {
  content: "";
  position: absolute;
  inset: 0;
  background: currentColor;
  opacity: 0;
  pointer-events: none;
  transition: opacity var(--md-sys-motion-duration-short4) var(--md-sys-motion-easing-standard);
  z-index: -1;
}
.state-layer:hover::before { opacity: .08; }
.state-layer:focus-visible::before,
.state-layer:active::before { opacity: .10; }
```

無効状態は、文字を on-surface の 38%、面を on-surface の 12% にする。
セレクタは部品の色の規則（`.btn-filled` など）より詳細度を高くして、書く順序に関係なく効くようにする。

```css
:is(button, input, select, textarea, .btn, .chip):is(:disabled, [aria-disabled="true"]) {
  color: color-mix(in srgb, var(--md-sys-color-on-surface) 38%, transparent);
  background: color-mix(in srgb, var(--md-sys-color-on-surface) 12%, transparent);
  box-shadow: none;
  cursor: not-allowed;
}
```

### フォーカスリング

M3 のフォーカスリングは secondary 色、太さ 3px、外側へ 2px 離す。

```css
:focus-visible {
  outline: 3px solid var(--md-sys-color-secondary);
  outline-offset: 2px;
}
```

---

## 9. 部品

### ボタン

M3 のボタンは高さ 40px、角は full、文字は label-large。
押せる範囲は 48×48px 以上を確保する。
一画面に filled ボタンは原則 1 個にし、操作の重要度で種類を選ぶ。

| 種類 | 重要度 | 面 | 文字 |
|---|---|---|---|
| filled | 最も高い | primary | on-primary |
| tonal | 中 | secondary-container | on-secondary-container |
| elevated | 中（背景と分けたいとき） | surface-container-low ＋ level1 | primary |
| outlined | 中〜低 | 透明 ＋ outline の枠 | primary |
| text | 低 | 透明 | primary |

```css
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  min-height: 40px;
  min-width: 48px;
  padding: 0 var(--space-6);
  border: none;
  border-radius: var(--md-sys-shape-corner-full);
  font: 500 14px/1.25 var(--md-ref-typeface-plain);
  cursor: pointer;
  /* 状態レイヤーは 8節の .state-layer を併用する */
}
.btn-filled   { background: var(--md-sys-color-primary); color: var(--md-sys-color-on-primary); }
.btn-tonal    { background: var(--md-sys-color-secondary-container); color: var(--md-sys-color-on-secondary-container); }
.btn-elevated { background: var(--md-sys-color-surface-container-low); color: var(--md-sys-color-primary); box-shadow: var(--md-sys-elevation-level1); }
.btn-outlined { background: transparent; color: var(--md-sys-color-primary); border: 1px solid var(--md-sys-color-outline); }
.btn-text     { background: transparent; color: var(--md-sys-color-primary); padding: 0 var(--space-3); }
.btn > svg    { width: 18px; height: 18px; margin-inline-start: calc(var(--space-2) * -1); }
```

### 入力欄（outlined text field）

M3 の浮動ラベルは使わず、入力欄の上に `<label>` を置く。
ラベルが常に見えるので、入力後も何の欄か分かる。

```css
.field { display: grid; gap: var(--space-1); }
.field label { font: 500 14px/1.5 var(--md-ref-typeface-plain); color: var(--md-sys-color-on-surface-variant); }
.field :is(input, textarea, select) {
  min-height: 56px;
  padding: 0 var(--space-4);
  background: transparent;
  color: var(--md-sys-color-on-surface);
  border: 1px solid var(--md-sys-color-outline);
  border-radius: var(--md-sys-shape-corner-extra-small);
  font: 400 16px/1.5 var(--md-ref-typeface-plain);
}
.field textarea { padding-block: var(--space-4); }
.field :is(input, textarea, select):hover { border-color: var(--md-sys-color-on-surface); }
.field :is(input, textarea, select):focus {
  outline: none;
  border-color: var(--md-sys-color-primary);
  box-shadow: inset 0 0 0 1px var(--md-sys-color-primary); /* 枠を 2px に見せる */
}
.field .supporting { font: 400 14px/1.5 var(--md-ref-typeface-plain); color: var(--md-sys-color-on-surface-variant); }
.field[data-invalid] :is(input, textarea, select) { border-color: var(--md-sys-color-error); }
.field[data-invalid] .supporting { color: var(--md-sys-color-error); }
```

エラー時は supporting text にアイコンと理由を書き、`aria-describedby` で入力欄と結ぶ。

### カード

```css
.card { border-radius: var(--md-sys-shape-corner-medium); padding: var(--space-4); color: var(--md-sys-color-on-surface); }
.card-filled   { background: var(--md-sys-color-surface-container-highest); }
.card-outlined { background: var(--md-sys-color-surface); border: 1px solid var(--md-sys-color-outline-variant); }
.card-elevated { background: var(--md-sys-color-surface-container-low); box-shadow: var(--md-sys-elevation-level1); }
```

既定は filled か outlined にし、elevated は背景の上で浮かせたいときだけ使う。

### チップ

高さ 32px、角は small、文字は label-large。
選択式のチップ（filter chip）は、選択中に secondary-container の面とチェックのアイコンを付け、色だけで状態を示さない。

```css
.chip {
  display: inline-flex; align-items: center; gap: var(--space-2);
  min-height: 32px; padding: 0 var(--space-4);
  border: 1px solid var(--md-sys-color-outline);
  border-radius: var(--md-sys-shape-corner-small);
  background: transparent; color: var(--md-sys-color-on-surface-variant);
  font: 500 14px/1.25 var(--md-ref-typeface-plain);
}
.chip[aria-pressed="true"] {
  border-color: transparent;
  background: var(--md-sys-color-secondary-container);
  color: var(--md-sys-color-on-secondary-container);
}
```

### ナビゲーション

- ナビゲーションバー（compact）: 高さ 80px、面は surface-container、各項目はアイコン 24px ＋ ラベル。
- ナビゲーションレール（medium 以上）: 幅 80px、面は surface-container。
- 選択中の項目は、アイコンの背後に secondary-container の角丸 full の表示（幅 64px・高さ 32px）を置き、ラベルを太くする。`aria-current="page"` を付ける。

---

## 10. アクセシビリティ

- 押せる範囲は 48×48px 以上（M3 の値）。見た目が 40px のボタンも周囲の余白で 48px を確保する。
- すべての操作部品に 8節のフォーカスリングを出す。`outline: none` だけで消さない。
- エラーは色・アイコン・文言の3つで示す。
- 入力欄には必ず `<label>` を関連付ける。placeholder だけに頼らない。
- ネイティブの `<button>`、`<input>`、`<select>`、`<dialog>` を使い、キーボード操作を保つ。

---

## 11. モーション

M3 のイージングと時間のトークンを使う。

```css
:root {
  --md-sys-motion-easing-standard: cubic-bezier(0.2, 0, 0, 1);
  --md-sys-motion-easing-emphasized-decelerate: cubic-bezier(0.05, 0.7, 0.1, 1);
  --md-sys-motion-easing-emphasized-accelerate: cubic-bezier(0.3, 0, 0.8, 0.15);
  --md-sys-motion-duration-short4: 200ms;
  --md-sys-motion-duration-medium2: 300ms;
  --md-sys-motion-duration-long2: 500ms;
}

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

| 動き | 時間 | イージング |
|---|---|---|
| 状態レイヤー、色の変化 | short4 | standard |
| 展開・折りたたみ、メニュー | medium2 | 開く: emphasized-decelerate、閉じる: emphasized-accelerate |
| 画面遷移、ダイアログ | long2 | emphasized-decelerate |

---

## 12. 使わないもの

- 2節のトークン以外の色を部品に直接書くこと
- 状態ごとに作った hover 色（8節の状態レイヤーを使う）
- 影の多用。通常のカードや区画に影を付けること
- 派手なグラデーション背景、紫系のグラデーション
- Inter、Arial などの汎用書体、日本語表示での Roboto
- 絵文字を UI の装飾に使うこと
- 14px 未満の文字
- placeholder だけに頼った入力欄
- 色だけで情報を伝える表現

---

## 13. React (JSX) での適用例

```jsx
import { useState } from "react";

const App = () => {
  const [theme, setTheme] = useState("dark");

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+New:wght@400;500;700&family=Zen+Maru+Gothic:wght@500;700&family=Noto+Sans+Mono:wght@400;700&display=swap');
        /* 2節の色、3節の書体、5節の余白、6節の形状、7節の影、11節のモーションのトークンをここに置く */
      `}</style>
      <div data-theme={theme} style={{
        background: "var(--md-sys-color-surface)",
        color: "var(--md-sys-color-on-surface)",
        fontFamily: "var(--md-ref-typeface-plain)",
        fontSize: "1rem",
        lineHeight: 1.75,
        letterSpacing: "0.02em",
        minHeight: "100vh",
      }}>
        {/* content */}
      </div>
    </>
  );
};
```

---

## 14. 出力前の確認

- [ ] 色は `--md-sys-color-*` のトークンだけを参照しているか
- [ ] 面と文字を対（surface / on-surface など）で使っているか
- [ ] 既定がダークで、`data-theme="light"` でライトに切り替わるか
- [ ] 背景の階層を surface container の段階で表し、影は浮く部品だけか
- [ ] ボタンの種類を操作の重要度で選び、filled は原則 1 個か
- [ ] 角丸は 6節の段階に沿っているか
- [ ] hover・focus・押下は状態レイヤーで表しているか
- [ ] すべての操作部品にフォーカスリングがあるか
- [ ] 押せる範囲は 48×48px 以上か
- [ ] 文字は 14px 以上、本文は 16px か
- [ ] 色だけで情報を伝えていないか
- [ ] `prefers-reduced-motion` に対応しているか
