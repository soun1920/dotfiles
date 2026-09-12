# 実例の構成

実際の記事を読んで採取した構成。
新しく記事を書くときは、題材に近いものを1、2本選んで骨格を借りる。

## Writing an OS in Rust / A Freestanding Rust Binary

https://os.phil-opp.com/freestanding-rust-binary/

冒頭2文。

> The first step in creating our own operating system kernel is to create a Rust executable that does not link the standard library. This makes it possible to run Rust code on the bare metal without an underlying operating system.

冒頭ブロックに公開日、GitHub リポジトリ（「この記事自体も GitHub で開発している。問題や質問は issue へ」）、対応ブランチ `post-01`。

節の並び。

- Introduction
- Disabling the Standard Library / The `no_std` Attribute
- Panic Implementation
- Unwinding / Disabling Unwinding
- Entry Point / Overwriting the Entry Point
- Linker Errors / Building for a Bare Metal Target / Linker Arguments（Linux, Windows, macOS, Unifying the Build Commands, Should You Do This?）
- Summary
- Making `rust-analyzer` happy / The two meanings of "target"
- What's next?

この並びは、そのままエラーの列になっている。
`error: cannot find macro println! in this scope` を貼ってから panic の節へ、`error: #[panic_handler] function required, but not found` を貼ってから実装へ、という順で進む。
エラーはコードブロックの直後に置き、原因の説明、修正の順で続く。

コードブロックは `// main.rs`、`// in main.rs`、`# in .cargo/config.toml` のようにファイルをコメントで示す。
差分ではなくファイル全体を出す。

OS ごとにリンカ引数の節を分け、そのあと `.cargo/config.toml` に畳んで1つのコマンドに統合する。
さらに「Should You Do This?」で、その手順の欠点を自分で検討する。

## Writing an OS in Rust / A Minimal Rust Kernel

https://os.phil-opp.com/minimal-rust-kernel/

前提を冒頭に列挙せず、必要な節で導入する。
ただしバージョンは具体的に書く（`build-std-features` は Rust nightly `2020-09-30` 以降、`bootloader` は v0.9）。
`rustup component add rust-src`、`rustup component add llvm-tools-preview`、`cargo install bootimage` はそれを使う節の手前に置く。

節の並び。

1. The Boot Process（BIOS Boot / The Multiboot Standard / UEFI）
2. A Minimal Kernel（Installing Rust Nightly / Target Specification / Putting it Together / Building our Kernel / ... / Printing to Screen）
3. Running our Kernel（Creating a Bootimage / How does it work? / Booting it in QEMU / Real Machine / Using `cargo run`）
4. What's next?

コマンドは `>` プロンプト付きのブロック、設定ファイルはコメントヘッダ付き、JSON のターゲット仕様は全文を出してからフィールドごとに説明する。
QEMU のスクリーンショットを1枚、キャプション付きで置く。

注記の使い分け。

- **Note:** ブロック：バージョン制約、歴史的経緯
- 太字の警告：USB デバイスへの書き込みでデバイス名を間違えるとディスクが飛ぶ
- 「this is not the way we want to do things in Rust!」：一時的に書いた unsafe コードを後で直すという予告

末尾は次回の内容を1文で書き、前後の記事へのリンクを置く。

## Writing an OS in Rust / VGA Text Mode

https://os.phil-opp.com/vga-text-mode/

冒頭2文。

> The VGA text mode is a simple way to print text to the screen. In this post, we create an interface that makes its usage safe and simple by encapsulating all unsafety in a separate module.

節の並びは、ハードウェアの説明 → モジュールを作る（Colors / Text Buffer / Printing / Volatile / Formatting Macros / Newlines）→ グローバルな入口（Lazy Statics / Spinlocks / Safety / A println Macro / Hello World using println / Printing Panic Messages）→ Summary → What's next?。

コードは `// in src/vga_buffer.rs` を先頭に置き、メソッドを1つずつ足す。
未実装は `// TODO` で残し、後の節で埋める。

設計判断は問題を先に出す。
volatile の節は、書き込むだけで読み出さないので最適化で消える危険がある、と説明してから `volatile` クレートを出す。

「Try it out!」で一時的な `print_something()` を書かせ、QEMU のスクリーンショットで結果を見せる。

## Writing an OS in Rust / Testing

https://os.phil-opp.com/testing/

冒頭は1文。「This post explores unit and integration testing in `no_std` executables.」
ブランチは `post-04`。

節の並び。

1. Requirements
2. Testing in Rust（Custom Test Frameworks）
3. Exiting QEMU（I/O Ports / Using the Exit Device / Success Exit Code）
4. Printing to the Console（Serial Port / QEMU Arguments / Error Messages / Hiding QEMU / Timeouts / Automatic Printing）
5. Testing the VGA Buffer
6. Integration Tests（Library Creation / Completing Tests / Future Tests / Panic Tests / No Harness Tests）
7. Summary / What's Next

ここでもまず失敗させる。
`cargo test` を走らせると `test` クレートがないというエラーが出る。
「the test crate depends on the standard library, it is not available for our bare metal target」と原因を説明してから、カスタムテストフレームワークへ進む。

テスト出力は成功時（`Running 1 tests` / `trivial assertion... [ok]`）と失敗時の両方を見せる。

## Let's Build a Simple Database

https://cstack.github.io/db_tutorial/parts/part1.html

冒頭は問いで始まる。「データはどんな形式で保存されているのか」「データベースはどう動くのか」。
SQLite のクローンを作る、という目標をそこで示す。

Part 1 の節は2つだけ。Sqlite、Making a Simple REPL。
差分ではなく関数の全体を順に出し、パートの最後に「このパートのプログラム全体」を1ブロックで置く。

端末セッションの転記で動作を見せる。
失敗する入力と成功する入力を同じ転記に入れている。

```
~ ./db
db > .tables
Unrecognized command '.tables'.
db > .exit
~
```

末尾は「we've got a working REPL」と成果を確認し、「In the next part, we'll start developing our command language.」で次を予告する。

## Build Your Own Text Editor（kilo / snaptoken）

https://viewsourcecode.org/snaptoken/kilo/

1ステップが小さい。
2行から8行、機能なら1つから4つ。
step 5 は `enableRawMode()` を1つ足すだけ、step 10 はフラグの代入を1つ変えるだけ、step 16 はタイムアウトの2行だけ。

各ステップに番号と git ブランチ名が対応する（step 3 は `read` ブランチ）。
ブランチのリンクからその時点のファイル全体を読める。
追加・変更した行はハイライトと矢印で示し、コードブロックの後に「compiles」の印を置いてビルドが通る状態を保証する。

ステップ1つに説明1つ。
そのフラグが何をするか、なぜ要るか、どう確かめるか。

第1章はコンパイラの導入で、Windows、macOS、Linux に節を分ける。
Windows は WSL か Cygwin かの選択と落とし穴に最も紙幅を割いている。

## Crafting Interpreters

https://craftinginterpreters.com/scanning.html

章の冒頭にエピグラフ（引用）を置き、その章の工程が何をするかを述べる。
用語の揺れ（scanning と lexing）もここで片付ける。

コードの挿入位置を語彙で指定する。

- create new file
- add after `<メソッド名>`
- in class `<クラス名>`
- replace 1 line

ファイルパスはイタリックの見出しで示し、同じファイルへの追加をまとめる。

脇道は aside（囲み）と脚注に降ろす。
Lex の作者、UNIX の終了コード、maximal munch の原則。
理論に立ち入りすぎない。有限オートマトンと Chomsky 階層は Dragon Book を指して先へ進む。

章末に2つ置く。

- **Challenges**：本文が扱わなかった設計判断を調べさせる問い。「Python と Haskell の字句の変則性を調べよ」「ネストするブロックコメントを実装せよ」
- **Design Note**：セミコロン自動挿入を Lua、Go、Python、JavaScript で比較するような、言語設計の主観的な判断を扱う長めの囲み

理論は章の前半にまとめ、後半は実装を速く進める。
lookahead や maximal munch のような語は、コードが必要とした時点で導入する。

## Let's Build a Simple Interpreter

https://ruslanspivak.com/lsbasi-part1/

冒頭にエピグラフ。

> If you don't know how compilers work, then you don't know how computers work.（Steve Yegge）

続けて学ぶ理由を3つ挙げる。技能が伸びること、魔法に見えていたものが解けること、自分の言語を作れること。
そのあとインタプリタとコンパイラの定義、連載の目標（Pascal のインタプリタ）、Pascal の階乗プログラムの例、そして最初の電卓の実装へ進む。

コードは完全なファイルを載せ、「calc1.py に保存するか GitHub から落とせ」と添える。
手で打つことは強制しない。

図解が特徴。
入力 `3+5` の上を位置ポインタが進む様子を、生成されるトークンと対応させて連続した図で見せる。

章末は3層。

- 演習3問（複数桁の整数、空白の読み飛ばし、減算）
- 「Check your understanding」7問（用語の定義と区別を問う）
- 推薦図書5冊

最後に、やり遂げる誓約書の様式を置く（署名して日付を入れる形）。

## Ray Tracing in One Weekend

https://raytracing.github.io/books/RayTracingInOneWeekend.html

題名で所要時間を宣言する。
序文は到達点を正直に区切る。「not a full-featured ray tracer, but it does have the indirect lighting」。
C++ は必須ではないが速度と業界での位置から推す、と書く。

リスティングに構造化したラベルを付ける。

```
Listing [main-initial]: [main.cc] Creating your first image
```

番号、ファイル名、内容が1行に入る。
変更行は同じブロックの中で `highlight` 指定の囲みにして、前後の既存コードを残す。

画像がマイルストーンになる。
`Image 1: First PPM image` のように番号とキャプションを付け、節ごとに1枚置く。
概念図（レイと球の交差）と描画結果の両方に同じ様式を使う。

版とその日付を先頭に置く（Version 4.0.2, 2025-04-25）。

代替案は両方出す。乱数生成は `std::rand()` と `<random>` の2案を並べ、読者に選ばせる。
C++ に不慣れな読者への補足は括弧で挟み、本筋を切らない。

## Write your Own Virtual Machine

https://www.jmeiners.com/lc3-vm/

規模を冒頭で宣言する。「The final code is about 250 lines of C」。
前提は基本的な C か C++ と2進数の知識。

リテラルプログラミング形式。
`@{Memory Storage}` `@{Registers}` のような名前付き断片を本文に散らし、各断片にどこから使われるかの参照（Used by [1]）を付ける。
末尾の `lc3.c` で全断片を織り合わせる（srcweave による tangle）。
教える順序とファイル内の並び順が食い違う題材で効く。

節の並びは実行の流れに沿う。
ハードウェアの土台（メモリ、レジスタ、命令セット、条件フラグ）→ アセンブリの例 → 主ループ → 命令を1つずつ（ADD、LDI）→ 命令とトラップの一覧 → プログラムの読み込みとメモリマップドレジスタ → 端末制御 → 実行とデバッグ。

概念とコードを隣接させる。
条件フラグは `FL_POS = 1 << 0` を定義してすぐ `update_flags()` で使う。
符号拡張は「正なら0、負なら1で埋める」という説明と実装を同時に出す。

環境差は節で分ける。
「Linux/macOS/UNIX」と「Windows」に端末制御の実装を分け、「If you already included the Unix versions don't add these!」と注意を書く。
コードには `/* unix only */` `/* windows only */` のコメントを入れる。

末尾に25以上の言語での移植版を並べ、貢献を募る。

## Let's build a browser engine

https://limpet.net/mbrubeck/2014/08/08/toy-layout-engine-1.html

冒頭1文で誘う。

> I'm building a toy HTML rendering engine, and I think you should too.

全7回であること、必要な前提（solid programming experience）をそこで示す。

非目標に節を割く。

- You're building a what?
- Why a "toy" rendering engine?
- Try this at home
- On Programming Languages
- On Libraries and Shortcuts
- First Step: The DOM
- Exercises
- References

ネットワーク処理がなくローカルファイルしか読めないこと、HTML と CSS の小さな部分集合しか実装しないことを明示する。
手抜きの正当化も書く。

> In a toy program, it's fine to just skip things if you feel like it.

演習は3段階の難度で用意し、「Do the exercises that interest you and skip any that don't」と添える。
末尾は次回の内容（HTML をパースして DOM の木にする）を1文で書き、Part 2 へリンクする。

## Write a C Compiler

https://norasandler.com/2017/11/29/Write-a-Compiler.html

冒頭で得られるもの（AST、アセンブリ、低レイヤの理解）を挙げ、自作コンパイラ nqcc と Ghuloum の漸進的手法を下敷きにしていると明かす。

読者は自分の言語で実装する。
著者はコードではなくテストスクリプトを配り、呼び出し方と満たすべき挙動を指定する。
検証の仕組みを著者側が用意することで、実装の自由を確保している。

節の並び。

- Preliminaries
- Week 1: Integers
- Lexing
- Parsing
- Code Generation
- (Optional) Pretty printing
- Putting it all together
- Testing
- Up Next
- Further Reading

文法は BNF で示す。
実装は疑似コードにとどめる。理由も書いてある。AST の表現には多くの選び方があるため。

末尾は次回（3つの単項演算子）を予告し、フィードバックの窓口を並べる。

## Build Your Own Redis

https://build-your-own.org/redis/

序文に Feynman の「What I cannot create, I do not understand.」を置く。
ネットワークプログラミング、データ構造、低レイヤの C の3つが同時に学べる題材だと述べ、本物の Redis は大きいので小さな段階に分けると断る。

部で分ける。

- 第1部（1〜7章）：ソケット、TCP、プロトコル、イベントループ、素朴なキーバリューサーバ
- 第2部（8〜14章）：ハッシュテーブル、直列化、二分木、ソート済み集合、タイマ、TTL、スレッド

10回を超える連載で部に割る例として使える。

## Write a hash table in C

https://github.com/jamesroutley/write-a-hash-table

規模と所要時間を最初に言う。

> The full implementation is around 200 lines of code, and should take around an hour or two to work through.

前提は「some familiarity with programming and C syntax」。詰まってもたいてい検索で解決すると添える。

得られるものを3つに絞って並べる。基本的なデータ構造の理解、ハッシュテーブルを使う場面の判断、C のコードに触れること。
C を選ぶ理由（標準のハッシュテーブルがなく、低レイヤに触れられる）も書く。

章は7つ。
Introduction、Hash table structure、Hash functions、Handling collisions、Hash table methods、Resizing tables、Appendix（別の衝突解決法）。

ソースは章ごとのディレクトリ（`01-introduction` から `07-appendix`）に分ける。
記事のブランチ方式に代わる置き方として使える。
