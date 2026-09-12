---
name: my-ui-style
description: デジタル庁デザインシステム（DADS）の設計原則に準拠しつつ、ユーザー独自のミニマル3色（黒・白・琥珀）美学を適用したUIスタイルスキル。Webサイト、ランディングページ、ダッシュボード、管理画面、Reactコンポーネント、HTMLアーティファクトなど、あらゆるUI作成時に必ず参照すること。UIやフロントエンドの見た目・スタイルに関わるリクエストがあれば常にこのスキルをトリガーする。「画面を作って」「UIを作って」「ダッシュボード」「ランディングページ」「コンポーネント」「アプリ」「Webページ」などのキーワードで発動する。
---

# My UI Style — DADS準拠 3色ミニマル

デジタル庁デザインシステム（DADS）v2の設計原則・アクセシビリティ要件をベースに、
**黒・白・琥珀（Amber）** の3色構成でUIを構築するガイドライン。

参照元: https://design.digital.go.jp/dads/foundations/

---

## 1. デザイン原則

- **アクセシビリティファースト**: WCAG 2.2 AA準拠を常に意識する
- **3色の規律**: 使用する色はモノトーン（黒〜白のグレー階調）＋ Amber系アクセントのみ
- **引き算の美学**: 要素は必要最小限。装飾よりも余白と構造で伝える
- **一貫性**: カラー・フォント・スペーシング・角丸はシステム全体で統一する
- **機能優先**: 美しさと使いやすさが衝突したら、使いやすさを優先する
- **色だけで情報を区別しない**: アイコン・テキスト・形状を併用すること（WCAG 1.4.1）

---

## 2. カラーシステム — 3色構成

### 3色の定義

| 役割 | 色 | 用途 |
|------|-----|------|
| **Black** | グレースケール暗部 | 背景、テキスト（ライトモード）、ボーダー |
| **White** | グレースケール明部 | 背景（ライトモード）、テキスト（ダークモード） |
| **Amber** | Tailwind amber-500 `#f59e0b` 基準 | プライマリーアクション、進捗、ハイライト、アクセント |

Amberはアクセントとして **控えめに** 使用する。画面の大部分はモノトーンで構成し、
Amberはユーザーの注意を引くべきポイント（CTAボタン、アクティブ状態、進捗表示等）にのみ適用する。

### コントラスト要件（必須）

- テキストと背景: **4.5:1以上**（サイズに関わらず）
- 非テキスト要素（ボーダー、アイコン等）と背景: **3:1以上**
- フォーカスインジケーター: 背景に対して **3:1以上**

### ダークモード（デフォルト）

```css
:root {
  /* 背景の階層 */
  --color-bg-primary:    #0a0a0a;
  --color-bg-secondary:  #141414;
  --color-bg-tertiary:   #1e1e1e;
  --color-bg-elevated:   #262626;

  /* テキストの階層 */
  --color-text-body:      #f5f5f5;
  --color-text-description: #a3a3a3;
  --color-text-placeholder: #737373;
  --color-text-disabled:    #525252;

  /* ボーダー */
  --color-border-default:  #404040;
  --color-border-subtle:   #262626;
  --color-border-divider:  #1e1e1e;

  /* Amberアクセント（ダークモード用） */
  --color-accent:         #f59e0b;  /* amber-500 — vs #0a0a0a → 8.4:1 */
  --color-accent-hover:   #fbbf24;  /* amber-400 */
  --color-accent-muted:   #92400e;  /* amber-800 — 背景アクセント用 */
  --color-accent-subtle:  #451a03;  /* amber-950 — 非常に控えめな背景 */
  --color-accent-on:      #0a0a0a;  /* Amberボタン上のテキスト色 */

  /* セマンティックカラー（DADS機能カラー準拠） */
  --color-success:   #22c55e;
  --color-error:     #ef4444;
  --color-warning:   #f59e0b;  /* Amberと統一 */
  --color-info:      #60a5fa;

  /* フォーカスインジケーター */
  --color-focus-ring: #f59e0b;
}
```

### ライトモード

```css
[data-theme="light"] {
  --color-bg-primary:    #ffffff;
  --color-bg-secondary:  #fafafa;
  --color-bg-tertiary:   #f5f5f5;
  --color-bg-elevated:   #ffffff;

  --color-text-body:        #0a0a0a;
  --color-text-description: #525252;
  --color-text-placeholder: #737373;
  --color-text-disabled:    #a3a3a3;

  --color-border-default:  #d4d4d4;
  --color-border-subtle:   #e5e5e5;
  --color-border-divider:  #f0f0f0;

  /* Amberアクセント（ライトモード用 — コントラスト確保のため暗め） */
  --color-accent:         #b45309;  /* amber-700 — vs #ffffff → 4.8:1 */
  --color-accent-hover:   #92400e;  /* amber-800 */
  --color-accent-muted:   #fef3c7;  /* amber-100 — 背景アクセント用 */
  --color-accent-subtle:  #fffbeb;  /* amber-50 — 非常に控えめな背景 */
  --color-accent-on:      #ffffff;  /* Amberボタン上のテキスト色 */

  --color-success:   #16a34a;
  --color-error:     #dc2626;
  --color-warning:   #b45309;
  --color-info:      #2563eb;

  --color-focus-ring: #b45309;
}
```

### カラー運用ルール

- **画面の90%以上はモノトーン** で構成する。Amberは差し色として限定的に使う
- Amberの使用箇所: CTAボタン、プログレス/インジケーター、アクティブタブ、フォーカスリング、リンクホバー
- Amberを背景に使う場合は `accent-muted` または `accent-subtle` を使い、文字のコントラストを確保する
- セマンティックカラー（成功・エラー・情報）はAmberと混同しないよう注意。WarningのみAmberと統一可
- ダークモードでは明るいamber-500、ライトモードでは暗いamber-700を使い、コントラスト要件を満たす

---

## 3. タイポグラフィ

DADSはNoto Sans JPを採用しているが、本スキルではユーザー好みのZenフォントに置換する。
DADSの構造的ルール（ウェイト、サイズ体系、行高、letter-spacing）はそのまま準拠する。

### フォントファミリー

```css
@import url('https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+New:wght@400;700&family=Zen+Maru+Gothic:wght@400;500;700&family=Noto+Sans+Mono:wght@400;700&display=swap');

:root {
  --font-heading: 'Zen Maru Gothic', sans-serif;
  --font-body:    'Zen Kaku Gothic New', sans-serif;
  --font-mono:    'Noto Sans Mono', monospace;
}
```

- **見出し（h1〜h3）**: `var(--font-heading)` — Zen Maru Gothicの柔らかい丸みで親しみやすさを出す
- **本文・UI要素**: `var(--font-body)` — Zen Kaku Gothic Newのクリーンな視認性
- **コード・数値データ**: `var(--font-mono)` — Noto Sans Mono（DADSと同一）

### フォントウェイト（DADS準拠: 2段階のみ）

- **Normal (N)**: `font-weight: 400` — 本文、説明テキスト
- **Bold (B)**: `font-weight: 700` — 見出し、強調

### フォントサイズ体系（DADS準拠）

```css
/* Display: ヘッドコピー、視覚的インパクト */
--text-display-lg:  4rem;    /* 64px */
--text-display-md:  3rem;    /* 48px */

/* Standard: 見出し・本文 (16px〜45px) */
--text-heading-xl:  2.8125rem; /* 45px */
--text-heading-lg:  2.25rem;   /* 36px */
--text-heading-md:  1.75rem;   /* 28px */
--text-heading-sm:  1.375rem;  /* 22px */
--text-body-lg:     1.125rem;  /* 18px */
--text-body:        1rem;      /* 16px — 本文基準 */

/* 制限付き小サイズ */
--text-sm:          0.875rem;  /* 14px — フッター等の制約がある場合のみ */
/* 14px未満は原則使用禁止 */
```

**重要ルール**:
- 本文・UIテキストは **16px (1rem) 以上** を基本とする
- 14px は領域的な制約がある場合（フッター、データテーブル内等）にのみ許容
- **14px未満の使用は原則禁止**

### テキストスタイル（DADS 5種に対応）

| スタイル | 用途 | フォント | line-height | letter-spacing |
|----------|------|----------|-------------|----------------|
| **Display** | ヘッドコピー、ヒーロー | --font-heading | 1.2〜1.3 | 0 |
| **Standard** | 見出し・本文 | --font-heading (見出し), --font-body (本文) | 見出し: 1.3〜1.4, 本文: 1.7〜1.8 | 0〜0.02em |
| **Dense** | データテーブル、管理画面 | --font-body | 1.4〜1.5 | 0 |
| **Oneline** | ボタンラベル、UIパーツ | --font-body | 1.0 | 0 |
| **Mono** | コード、数値 | --font-mono | 1.5 | 0 |

### letter-spacing ルール（DADS準拠）

- Display / Dense / Oneline: `letter-spacing: 0`
- Standard 見出し: `letter-spacing: 0.01em`
- Standard 本文: `letter-spacing: 0.02em`

---

## 4. レイアウト（DADS準拠: 12カラムグリッド）

### グリッドシステム

```css
.grid-container {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 2rem;
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 var(--spacing-6);
}
```

- **カラム**: 12列。1〜4カラムレイアウトに対応
- **ガター**: 本文フォントサイズの2倍（32px）を基本とする
- **一行あたり推奨文字数**: 40文字
- **読み物コンテンツ**: `max-width: 40em`

### ブレークポイント（DADS準拠）

```css
--bp-mobile:   520px;   /* 0 〜 520px:  モバイル */
--bp-tablet:   960px;   /* 521 〜 960px: タブレット */
                         /* 961px〜:     デスクトップ */
```

- モバイルファーストで記述する
- グリッドカラム: モバイル1列 → タブレット2列 → デスクトップ3〜4列

---

## 5. 余白（DADS準拠: 8px基準）

基準単位 **8px**。大サイズはフィボナッチ数列的に拡大、小サイズは2で割る。

```css
--spacing-1:   0.25rem;  /*  4px */
--spacing-2:   0.5rem;   /*  8px */
--spacing-3:   1rem;     /* 16px */
--spacing-4:   1.5rem;   /* 24px */
--spacing-5:   2.5rem;   /* 40px */
--spacing-6:   4rem;     /* 64px */
--spacing-7:   6.5rem;   /* 104px */
--spacing-8:   10.5rem;  /* 168px */
```

### 余白の運用ルール

- セクション間: `--spacing-6` (64px) 以上
- カード内パディング: `--spacing-4` (24px)
- 見出し上の余白: `--spacing-5` (40px) 以上
- 見出しと本文の間: `--spacing-3` (16px)
- コンテナの左右パディング: `--spacing-3` (モバイル) 〜 `--spacing-4` (デスクトップ)

---

## 6. 角の形状（DADS準拠: 短辺に応じた可変ルール）

| 短辺のサイズ | 角丸半径 | 適用例 |
|-------------|---------|--------|
| 〜40px | `4px` | チップ、小バッジ、小ボタン |
| 41〜119px | `8px` | ボタン、インプット、小カード |
| 120px〜 | `12px` | カード、モーダル、大きなコンテナ |

```css
--radius-sm: 4px;
--radius-md: 8px;
--radius-lg: 12px;
```

---

## 7. エレベーション（DADS準拠）

影だけに頼らず **ボーダーを併用** してコンポーネントの境界を示す。

```css
--elevation-1: 0 1px 2px rgba(0, 0, 0, 0.15);
--elevation-2: 0 2px 8px rgba(0, 0, 0, 0.2);
--elevation-3: 0 4px 16px rgba(0, 0, 0, 0.25);
```

- 通常のカードやコンテナ: **影は使わず、ボーダーで区切る**
- ドロワー、モーダル: `elevation-2` ＋ `border` の併用

---

## 8. UIコンポーネント規約

### ボタン

```css
/* プライマリーボタン — Amberアクセント */
.btn-primary {
  background: var(--color-accent);
  color: var(--color-accent-on);
  border: none;
  border-radius: var(--radius-md);
  padding: var(--spacing-2) var(--spacing-3);
  font-family: var(--font-body);
  font-weight: 700;
  font-size: 1rem;
  line-height: 1;
  cursor: pointer;
  transition: opacity 0.15s ease;
}
.btn-primary:hover { opacity: 0.85; }
.btn-primary:focus-visible {
  outline: 2px solid var(--color-focus-ring);
  outline-offset: 2px;
}

/* セカンダリーボタン — モノトーン */
.btn-secondary {
  background: transparent;
  color: var(--color-text-body);
  border: 1px solid var(--color-border-default);
  border-radius: var(--radius-md);
  padding: var(--spacing-2) var(--spacing-3);
  font-family: var(--font-body);
  font-weight: 700;
  font-size: 1rem;
  line-height: 1;
  cursor: pointer;
  transition: background 0.15s ease;
}
.btn-secondary:hover { background: var(--color-bg-tertiary); }
.btn-secondary:focus-visible {
  outline: 2px solid var(--color-focus-ring);
  outline-offset: 2px;
}
```

### インプット

```css
input, textarea, select {
  background: var(--color-bg-secondary);
  color: var(--color-text-body);
  border: 1px solid var(--color-border-default);
  border-radius: var(--radius-md);
  padding: var(--spacing-2);
  font-family: var(--font-body);
  font-size: 1rem;
  outline: none;
  transition: border-color 0.15s ease;
}
input:focus, textarea:focus, select:focus {
  border-color: var(--color-accent);
  box-shadow: 0 0 0 2px var(--color-accent);
}
```

### カード

```css
.card {
  background: var(--color-bg-secondary);
  border: 1px solid var(--color-border-default);
  border-radius: var(--radius-lg);
  padding: var(--spacing-4);
}
```

---

## 9. アクセシビリティ要件（DADS準拠）

- **フォーカスインジケーター**: Amberリングですべてのインタラクティブ要素に適用
- **色だけで区別しない**: エラー表示は色＋アイコン＋テキストの3点セット
- **コントラスト比**: テキスト4.5:1以上、非テキスト3:1以上
- **タッチターゲット**: 最小44×44 CSS px
- **フォームラベル**: 必ず `<label>` を関連付ける。placeholder だけに頼らない

---

## 10. アニメーション

- トランジションは `0.15s ease` を基本とする
- `prefers-reduced-motion: reduce` を必ず考慮し、該当時はアニメーションを無効化する
- 過剰なアニメーションは禁止。hover時の色変化・opacity変化程度にとどめる

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 11. 禁止事項

以下は **絶対に使わない**:

- Amber系以外の彩度のある色（セマンティックカラーを除く）
- `box-shadow` を多用した浮遊デザイン
- 派手なグラデーション背景
- Inter, Roboto, Arial などの汎用フォント
- 紫系グラデーション
- 絵文字をUIの装飾として使用すること
- 14px未満のフォントサイズ
- placeholderテキストに依存した入力フォーム
- 色だけで情報を伝える表現

---

## 12. React (JSX) での適用テンプレート

```jsx
import { useState } from "react";

const App = () => {
  const [theme, setTheme] = useState('dark');

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+New:wght@400;700&family=Zen+Maru+Gothic:wght@400;500;700&family=Noto+Sans+Mono:wght@400;700&display=swap');
        /* CSS変数はここに定義（セクション2参照） */

        @media (prefers-reduced-motion: reduce) {
          *, *::before, *::after {
            animation-duration: 0.01ms !important;
            transition-duration: 0.01ms !important;
          }
        }
      `}</style>
      <div data-theme={theme} style={{
        background: 'var(--color-bg-primary)',
        color: 'var(--color-text-body)',
        fontFamily: "var(--font-body)",
        fontSize: '1rem',
        lineHeight: 1.7,
        letterSpacing: '0.02em',
        minHeight: '100vh',
        transition: 'background 0.2s ease, color 0.2s ease',
      }}>
        {/* content */}
      </div>
    </>
  );
};
```

---

## 13. チェックリスト（出力前に確認）

- [ ] 使用色はモノトーン + Amber系のみか（セマンティックカラーを除く）
- [ ] フォントは Zen Maru Gothic / Zen Kaku Gothic New / Noto Sans Mono か
- [ ] カラーパレットはCSS変数で定義されているか
- [ ] デフォルトがダークモードになっているか
- [ ] ダークモードのアクセントは amber-500、ライトモードは amber-700 か
- [ ] テキストのコントラスト比 4.5:1 以上を確保しているか
- [ ] 非テキスト要素のコントラスト比 3:1 以上を確保しているか
- [ ] 本文フォントサイズは 16px (1rem) 以上か
- [ ] すべてのインタラクティブ要素に `:focus-visible` スタイルがあるか
- [ ] 余白は 8px 基準のスケールで設定されているか
- [ ] 角丸はコンポーネントの短辺に応じて可変しているか
- [ ] 色だけで情報を伝えていないか
- [ ] `prefers-reduced-motion` に対応しているか
