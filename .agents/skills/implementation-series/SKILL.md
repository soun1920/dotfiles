---
name: implementation-series
description: |
  "Writing an OS in Rust" や build-your-own-x 系の、動く成果物を一歩ずつ積み上げる実装連載記事を書くスキル。
  以下のような依頼で必ずトリガーする:
  - 「〇〇を自作する記事を書いて」「ゼロから作る〇〇の連載を書いて」
  - 「Writing an OS in Rust みたいな記事にして」「チュートリアル記事にして」
  - 自作OS、自作言語処理系、自作データベース、自作シェル、自作エディタ、自作レイトレーサ、自作VM、自作ブラウザエンジンの解説記事
  - 既存の実装解説記事の推敲・リライト（この型に沿っているかの点検）
  日本語で書く場合は japanese-tech-writing の文体規範を併用する。
  Rust のコードを含む場合は docs-rs で API を確認してから書くこと。
  実在の記事11本から採取した構成が references/exemplars.md にある。書く前に該当する題材のものを読むこと。
---

# 実装連載記事の書き方

読者が記事のとおりに手を動かせば、記事の末尾で手元に動くものが残る。
これが合格条件である。
説明が正しくても、読者の環境でビルドが通らなければその記事は失敗している。

規則の出所は次の11本。
各記事の構成は `references/exemplars.md` に採取してある。
書く前に、題材の近いものを1、2本読む。

| 記事 | 題材 | 特徴的な型 |
| --- | --- | --- |
| [Writing an OS in Rust](https://os.phil-opp.com/) | 自作OS（Rust） | エラー駆動、post-NN ブランチ |
| [Let's Build a Simple Database](https://cstack.github.io/db_tutorial/) | SQLite クローン（C） | 端末セッションの転記、パート末に全文 |
| [Build Your Own Text Editor](https://viewsourcecode.org/snaptoken/kilo/) | エディタ（C） | 2〜8行の step、step ごとの git ブランチ |
| [Crafting Interpreters](https://craftinginterpreters.com/) | 言語処理系（Java/C） | 挿入位置の指定語彙、Challenges、Design Note |
| [Let's Build a Simple Interpreter](https://ruslanspivak.com/lsbasi-part1/) | Pascal 処理系（Python） | 図解、演習、理解度確認 |
| [Ray Tracing in One Weekend](https://raytracing.github.io/) | レイトレーサ（C++） | 番号付きリスティング、画像がマイルストーン |
| [Write your Own Virtual Machine](https://www.jmeiners.com/lc3-vm/) | LC-3 VM（C） | リテラルプログラミング、規模の宣言 |
| [Let's build a browser engine](https://limpet.net/mbrubeck/2014/08/08/toy-layout-engine-1.html) | ブラウザエンジン（Rust） | 非目標の明示、手抜きの正当化 |
| [Write a C Compiler](https://norasandler.com/2017/11/29/Write-a-Compiler.html) | C コンパイラ（言語自由） | 配布テストスイート、疑似コードと BNF |
| [Build Your Own Redis](https://build-your-own.org/redis/) | Redis（C++） | 部構成、Feynman の引用 |
| [Write a hash table in C](https://github.com/jamesroutley/write-a-hash-table) | ハッシュテーブル（C） | 行数と所要時間の宣言、章ごとのディレクトリ |

## 記事の単位

1記事 = 1つの動く成果物。
「標準ライブラリに依存しない実行ファイルを作る」「REPL が起動して `.exit` で抜ける」「PPM 画像が1枚出る」のように、記事の最後に実行して確かめられる状態を単位にする。
概念の分類（「メモリ管理とは」「割り込みの種類」）を単位にしない。

分量が膨らんだら成果物を小さく切り直す。
1記事に2つの成果物を詰めない。

## 連載の第1回

第1回だけは、実装に入る前に読者と契約を結ぶ。
2回目以降にこの節を繰り返さない。

**規模と所要時間を数字で言う。**
LC-3 VM は「The final code is about 250 lines of C」、ハッシュテーブルは「around 200 lines of code, and should take around an hour or two to work through」、レイトレーサは題名で「One Weekend」と言い切っている。
読者が着手を決める材料になる。

**動機を書く。**
Spivak は Steve Yegge の「If you don't know how compilers work, then you don't know how computers work.」を掲げ、続けて学ぶ理由を3つ挙げる。
build-your-own.org は Feynman の「What I cannot create, I do not understand.」を置く。
1段落で足りる。

**非目標を先に書く。**
Brubeck の第1回には「Why a "toy" rendering engine?」と「On Libraries and Shortcuts」の節がある。
robinson はネットワーク処理を持たずローカルファイルしか読めないこと、HTML と CSS の小さな部分集合しか実装しないことを明示する。
手抜きは隠さず、理由を添えて宣言する。

> In a toy program, it's fine to just skip things if you feel like it.

**前提知識を書く。**
「solid programming experience」（Brubeck）、「some familiarity with programming and C syntax」（ハッシュテーブル）、「basic C or C++ と2進数の知識」（LC-3）。
必要な知識だけを挙げ、ないものは調べれば済むと添える。

**言語を指定するか委ねるかを決める。**
指定するなら理由を書く。レイトレーサは C++ を「速度と業界での位置」で推しつつ必須ではないと断る。
委ねるなら、完全な実装ではなく疑似コードと文法規則を出す。Nora Sandler は AST の表現に幅があることを理由に、実装ではなく疑似コードと BNF を出している。

**ソースコードの置き方を決める。**
3つの流儀がある。記事から張るリンクの形が変わるので先に決める。

- 記事ごとのブランチかタグ（phil-opp の `post-01`、kilo の step ブランチ `read`）
- 章ごとのディレクトリ（`01-introduction` から `07-appendix`）
- パートの末尾に全文を1ブロックで置く（cstack）

## 各記事の冒頭

2文で始める。
1文目でこの記事が作るもの、2文目でそれが何を可能にするか。

> The first step in creating our own operating system kernel is to create a Rust executable that does not link the standard library. This makes it possible to run Rust code on the bare metal without an underlying operating system.

前置き、あいさつ、「〇〇は重要な技術です」型の一般論を書かない。

冒頭のブロックに置くもの。

- 対応するソースの場所（ブランチ名、タグ、ディレクトリ）
- 前回の記事へのリンク
- 質問や誤りの報告先（phil-opp は「この記事自体も GitHub で開発している。問題や質問は issue へ」と書いている）

## 進め方は3つ。題材で選ぶ

### エラー駆動（phil-opp 型）

処理系や環境と戦う題材（OS、組み込み、ビルドシステム、リンカ）はこれ。
節の並びがそのままエラーの列になる。

第1回の実際の流れは、`no_std` を付ける → `error: cannot find macro println!` → 消す → `error: #[panic_handler] function required, but not found` → 書く → `language item required, but not found: eh_personality` → unwinding を切る → エントリポイントがない → リンカエラー。

1. 素直に書く。
2. ビルドする。
3. エラー出力を**そのまま**貼る。
4. なぜそのエラーが出るのかを説明する。
5. 直す。
6. 次のエラーへ。

完成品を先に見せない。
`panic_handler` 付きのコードを最初から出すと、読者はそれが要る理由を学ばない。

エラーを再現していないのに再現したように書かない。
長い出力は `...` で省略を明示し、エラーコードと主要な行は残す。

### ステップ駆動（kilo 型）

機能を積む題材（エディタ、データベース、シェル）はこれ。
kilo は1ステップが2行から8行しかない。

- 1ステップ = 1つの機能追加か1つのフラグ変更。`enableRawMode()` を足す、タイムアウトの2行を足す、という粒度。
- 各ステップに名前を付け、その時点のソース全体へのリンクを添える。kilo は step 番号と git ブランチ名（`read`、`atexit`）を対応させている。
- 追加・変更した行がどれかを示す。ハイライト、矢印、差分表示のいずれか。
- ステップごとにビルドが通る状態を保つ。kilo は各ブロックの後に「compiles」の印を置いている。
- 1ステップに説明1つ。何をしたか、なぜ要るか、どう確かめるか。

### テスト駆動（Nora Sandler 型）

読者が自分の言語・自分の設計で実装する題材（コンパイラ、インタプリタ、プロトコル実装）はこれ。
著者は実装ではなく、合格すべきテストと文法を配る。

- テストスクリプトを配布し、呼び出し方と満たすべき挙動を書く。
- 各回で対応する言語の部分集合を BNF で示す。
- 実装は疑似コードにとどめ、データ構造の選択は読者に委ねる。
- 段階（字句解析 → 構文解析 → コード生成 → 統合 → テスト）で節を切る。

読者が自分のコードを検証できる仕組みを、記事の側が用意する。
これが成立すると、コードを1行も配らずに連載が回る。

## コードの示し方

- コードブロックの先頭行に対象ファイルをコメントで書く。`// in src/vga_buffer.rs`、`# in .cargo/config.toml`。設定ファイルもコマンドも同じ。
- 既存ファイルを編集させるときは挿入位置を特定できる語で書く。Crafting Interpreters の語彙が使いやすい。「create new file」「add after `scanTokens()`」「in class Scanner」「replace 1 line」。
- 長い連載ではリスティングにラベルを付ける。レイトレーサは `Listing [main-initial]: [main.cc] Creating your first image` の形で、番号、ファイル名、内容を1行に入れる。後から参照しやすい。
- 変更行を目立たせる。レイトレーサは同じブロックの中で変更部分だけ `highlight` 指定の囲みにして、前後の既存コードを残している。
- 省略は `// ...` で明示する。黙って消さない。
- 節の末尾か記事の末尾で、ファイルの全体を一度は示す。cstack は各パートの最後に「the entire program from this part」を丸ごと置く。断片だけで終えると読者は再現できない。
- コマンドと出力は別のブロックに分ける。読者がコピーできる形にする。
- `unsafe` ブロックには、なぜ安全なのかをコメントか本文で必ず書く。

教える順序とファイル内の並び順が食い違うときは、リテラルプログラミング形式を使う。
LC-3 VM は `@{Memory Storage}` `@{Registers}` のような名前付き断片を本文に散らし、末尾の `lc3.c` で1つに織り合わせる。
各断片には、どこから使われるかの参照が付く。

Rust の API 名、シグネチャ、フィーチャフラグは docs-rs スキルで確認してから書く。
記憶で書かない。

## なぜを書く場所

実装の各ステップに、他の選択肢を潰した理由を1、2文添える。
これを省くと読者は写経するだけになる。

問題を先に起こしてから解を出す。
phil-opp が volatile を導入する箇所はこうなっている。

> The problem is that we only write to the `Buffer` and never read from it again. The compiler doesn't know that we really access VGA buffer memory (instead of normal RAM) ... So it might decide that these writes are unnecessary and can be omitted.

`volatile` クレートを紹介してから「最適化を防ぎます」と書くのではない。
最適化で消える危険を先に見せてから、クレートを出す。

選択肢が本当に割れるときは、両方出して読者に選ばせてよい。
レイトレーサは乱数生成に `std::rand()` と `<random>` の2案を並べている。

自分の方法の欠点も書く。
phil-opp にはリンカ引数を手で並べたあとに「Should You Do This?」という節がある。

読者が自力で補える中間段階は書かない。
`match` の意味や `Vec::push` の説明を挟まない。

## 環境差と前提

- ツールチェーンのバージョンを具体的に書く。「at least Rust nightly `2020-09-30`」「`bootloader` v0.9」のように、動くと確認した下限を示す。
- OS ごとに手順が割れるところは Linux、macOS、Windows のサブ節に分け、そのあと統合手順の節を置いて以後は1コマンドで進めさせる（phil-opp の "Unifying the Build Commands"）。LC-3 VM は Unix 版と Windows 版の端末制御を分け、「If you already included the Unix versions don't add these!」と書き添えている。
- 危険な操作には警告を添える。USB デバイスに書き込ませるなら、デバイス名を間違えるとディスクが飛ぶことを書く。
- 前提を冒頭に全部並べる必要はない。必要になった節で導入してよい。ただしインストール手順は、それを使う節の手前に置く。

## 動かす節

実装の節のあとに、必ず実行して確かめる節を置く。

- 実行コマンド
- 期待される出力

出力の見せ方は題材で決まる。

**端末セッションの転記**（cstack）。成功例と失敗例を同じ転記に入れると、挙動の境界がわかる。

```
~ ./db
db > .tables
Unrecognized command '.tables'.
db > .exit
~
```

**スクリーンショット**（phil-opp の QEMU 画面）。キャプションを付ける。

**画像**（レイトレーサ）。`Image 1: First PPM image` のように番号とキャプションを付け、節の区切りごとに1枚置く。絵が変わることが進捗の証拠になる。

**テストの出力**（phil-opp の testing 回）。成功時と失敗時の両方を見せる。

動かしていないコードを「動きます」と書かない。
検証できない環境なら、その制約を記事に明記する。

## 図

処理の状態が動くものは図にする。
Spivak は入力 `3+5` の上をポインタが進む様子を、トークンの出力と対応させて連続した図で見せる。
文章で「位置を1つ進める」と書くより短く伝わる。

図が要るのは、ポインタや添字が動く処理、木の構造、メモリの配置、座標変換。
関数の呼び出し関係を図にしても効果は薄い。

## 脇道の逃がし方

本筋から外れる話は本文に混ぜない。

- 歴史、語源、人物、余談は脚注か囲み記事に降ろす（Crafting Interpreters の aside、phil-opp の Note ブロック）
- 深い理論には一次資料へのリンクを置いて先に進む。Crafting Interpreters は有限オートマトンと Chomsky 階層に立ち入らず Dragon Book を指す。
- リンク先は一次資料を選ぶ。CPU の挙動なら Intel SDM か AMD APM、フォーマットなら RFC、OS の慣習なら OSDev Wiki。

リンクを読まなくても本文だけで手順が完結するようにする。
リンクは深掘りの入口であって、説明の代わりではない。

## 演習

置くなら本文の確認問題にしない。
記事が扱わなかった判断や拡張を読者に投げる。

- Crafting Interpreters の Challenges：「ネストするブロックコメントを実装せよ。入れ子を数えるべきか」
- Spivak：複数桁の整数、空白の読み飛ばし、減算の対応。加えて用語を問う「理解度確認」を7問。
- Brubeck：3段階の難度で用意し、「Do the exercises that interest you and skip any that don't」と添える

演習を必修にしない。
飛ばしてよいと明示するほうが、読者は先へ進む。

## 終わり方

Summary と What's next? の2節で閉じる。

- **Summary**：その記事で作ったものと導入した依存を数行で並べる。本文の言い換えにしない。
- **What's next?**：次の記事の成果物を1、2文で具体的に書く。「In the next post, we will explore the VGA text buffer in more detail and write a safe interface for it. We will also add support for the `println` macro.」で終わるのが phil-opp の型。「お楽しみに」で終えない。

参考文献を置くなら精選する。
Spivak は5冊、Nora Sandler は Further Reading の節を置く。10冊並べない。

## 検証

記事を書く前にコードを書いて動かす。
順序を逆にしない。

1. ビルドが通ることを確認する。
2. 実行して、記事に貼る出力を実際に得る。
3. 記事に書いたコマンドを、そのままコピーして実行し直す。
4. リポジトリを作り、決めた流儀（ブランチ、タグ、章ディレクトリ）でその回の状態を残す。

環境依存（Linux と macOS でリンカ引数が違う、など）は、確認できたほうだけを断定する。
確認していないほうはその旨を書く。

## やらないこと

- 概念の総覧から始める。「OSとは何か」を3節書いてから実装に入らない。必要な概念は必要になった箇所で最小限だけ導入する。
- コードを全部見せてから解説する。読者は既に読み終わっている。
- 「ここまでで理解できましたか」型の呼びかけ。
- 各節の分量を揃える。難所は長く、定型作業は数行で済ませる。
- 完成リポジトリへのリンクだけを置いて手順を省く。
- Summary で本文を要約し直す。作ったものの列挙にとどめる。
- 手抜きを黙って通す。実装しなかったことは非目標として書く。

## 日本語で書くとき

japanese-tech-writing の文体規範を併用する。
一文一行、太字は一節に一、二箇所、無生物主語の「〜を可能にします」を使わない。

英語の原典は読者を "you" で呼ぶが、日本語では二人称の呼びかけを要所だけにとどめる。
手順は「〜する」「〜しておく」の形で書く。

技術用語は定着した訳語か原語を使い、初出で原語か略語を添える。
フリースタンディングバイナリ、リンカ、割り込みディスクリプタテーブル（IDT）。

## 連載全体の設計

記事を書く前に成果物の列を決める。
各記事の成果物を1行ずつ並べ、前の記事の成果物だけで次が作れるかを確認する。
飛んでいれば記事を1本挟む。

phil-opp の実際の列。

1. フリースタンディングバイナリ（`no_std` でビルドが通る）
2. 最小カーネル（QEMU で起動して画面に文字が出る）
3. VGA テキストモード（`println!` が使える）
4. テスト（QEMU 上で `cargo test` が走る）
5. CPU 例外（ブレークポイント例外を捕まえて実行を続ける）

10回を超えるなら部に分ける。
build-your-own.org の Redis は、第1部（1〜7章）でソケットからイベントループと素朴なキーバリューサーバまで、第2部（8〜14章）でハッシュテーブル、直列化、木、ソート済み集合、タイマ、TTL、スレッドへ進む。

この列を索引ページに置き、各記事から前後にリンクする。

## 点検

書き終えたら機械的に確認する。

1. 冒頭2文で、この記事が作るものと、それが何を可能にするかがわかるか。
2. ソースの参照先（ブランチ、タグ、ディレクトリ）を冒頭に書いたか。
3. 第1回なら、規模、所要時間、前提知識、非目標を書いたか。
4. ツールチェーンのバージョンが具体的に書いてあるか。
5. 貼ったエラー出力とビルド出力は、実際に実行して得たものか。
6. すべてのコードブロックに対象ファイルの表示があるか。
7. 既存ファイルを編集させる箇所で、挿入位置が特定できるか。
8. `unsafe` ごとに安全性の根拠が書いてあるか。
9. 実行して確かめる節があり、期待される出力（転記、画像、テスト結果）が示されているか。
10. 脇道が脚注か囲みに降りているか。
11. What's next? が次の成果物を具体的に書いているか。
