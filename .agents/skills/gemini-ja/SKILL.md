---
name: gemini-ja
description: Gemini 3.8 に japanese-writing skill を適用させて日本語の原稿を書く・推敲する。ユーザーが「gemini で」「gemini に書かせて」と明示したときだけ使う。
---

# Gemini で日本語を書く

Antigravity CLI（`agy`）を非対話で呼び、Gemini 側の `/japanese-writing` skill で書かせる。
`~/.gemini/antigravity-cli/skills` は `~/.agents/skills` へのリンクなので、skill の実体は Claude と共通である。

## 手順

1. 依頼内容と、推敲なら対象の本文（またはファイルの絶対パス）を用意する。Gemini は会話を見ないので、必要な文脈はすべてプロンプトに入れる。
2. 次の形で実行する。ファイルを直接編集させたくない場合は、出力だけ返すよう指示する。

```bash
agy -p "/japanese-writing <依頼>。<本文またはパス>。結果の本文だけを出力してください。" --model "Gemini 3.8 Flash (High)"
```

3. 返ってきた文をそのままユーザーに示す。こちらで書き直さない。気になる点があれば、Gemini の出力とは分けて述べる。

## 注意

- 既定は `--model "Gemini 3.8 Flash (High)"`。別のモデルは `agy models` で確認する。
- ファイルを書き換えさせるときは、対象の絶対パスを明示し、事前に内容を確認してから許可する（`--dangerously-skip-permissions` は使わない）。
- 長い原稿は時間がかかるので、`--print-timeout` は付けず、必要ならバックグラウンドで実行する。
