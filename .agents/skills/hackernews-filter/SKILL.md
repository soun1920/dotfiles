---
name: hackernews-filter
description: Hacker Newsの今日のトップ記事をユーザーの興味分野で絞り込むReactアーティファクトを作成するスキル。「HNを絞り込みたい」「Hacker Newsをフィルタリングしたい」「HNで興味ある記事だけ見たい」「今日のHacker News」などのリクエストに対して必ずこのスキルを使うこと。Claude Haiku APIで各記事の関連度を判定し、インタラクティブなUIで結果を表示する。
---

# Hacker News フィルタースキル

ユーザーの興味分野に基づいてHacker Newsのトップ記事を絞り込むReactアーティファクトを生成する。

## 概要

- HN Firebase API でトップ記事を取得
- Claude Haiku API で各記事の関連度を1〜10でスコアリング
- スコアが高い順に表示、閾値以下は非表示
- ユーザーが興味分野をUI上で編集可能

## 実装手順

1. `react` アーティファクトとして実装する
2. 下記の「完全実装テンプレート」をベースに生成する
3. ユーザーが興味分野を指定していれば `DEFAULT_INTERESTS` に反映する

## APIエンドポイント

```
HN Top Stories:  https://hacker-news.firebaseio.com/v0/topstories.json
HN Item:         https://hacker-news.firebaseio.com/v0/item/{id}.json
Anthropic API:   https://api.anthropic.com/v1/messages
```

## Haiku スコアリングプロンプト

```
モデル: claude-haiku-4-5-20251001
max_tokens: 50

システム:
You are a relevance scorer. Given a Hacker News story title and the user's
interest areas, output ONLY a JSON object like {"score": 7, "reason": "短い理由"}.
Score 1-10. No other text.

ユーザーメッセージ:
Title: {title}
Interests: {interests.join(", ")}
```

## 完全実装テンプレート

```jsx
import { useState, useEffect, useCallback } from "react";

const DEFAULT_INTERESTS = ["AI", "機械学習", "Rust", "セキュリティ"];
const HN_TOP_URL = "https://hacker-news.firebaseio.com/v0/topstories.json";
const HN_ITEM_URL = "https://hacker-news.firebaseio.com/v0/item";
const ANTHROPIC_URL = "https://api.anthropic.com/v1/messages";
const FETCH_COUNT = 30;   // 取得する記事数
const SCORE_THRESHOLD = 6; // 表示する最低スコア

// --- スコアリング ---
async function scoreStory(title, interests) {
  const res = await fetch(ANTHROPIC_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 50,
      system:
        'You are a relevance scorer. Given a Hacker News story title and user interest areas, output ONLY a JSON object like {"score":7,"reason":"short reason"}. Score 1-10. No other text.',
      messages: [
        {
          role: "user",
          content: `Title: ${title}\nInterests: ${interests.join(", ")}`,
        },
      ],
    }),
  });
  const data = await res.json();
  try {
    const text = data.content?.[0]?.text ?? '{"score":1,"reason":""}';
    return JSON.parse(text.replace(/```json|```/g, "").trim());
  } catch {
    return { score: 1, reason: "" };
  }
}

// --- HN フェッチ ---
async function fetchTopStories() {
  const ids = await fetch(HN_TOP_URL).then((r) => r.json());
  const top = ids.slice(0, FETCH_COUNT);
  return Promise.all(
    top.map((id) =>
      fetch(`${HN_ITEM_URL}/${id}.json`).then((r) => r.json())
    )
  );
}

export default function App() {
  const [interests, setInterests] = useState(DEFAULT_INTERESTS);
  const [inputVal, setInputVal] = useState("");
  const [threshold, setThreshold] = useState(SCORE_THRESHOLD);
  const [stories, setStories] = useState([]);
  const [status, setStatus] = useState("idle"); // idle | loading | done
  const [progress, setProgress] = useState({ done: 0, total: 0 });

  const run = useCallback(async () => {
    if (interests.length === 0) return;
    setStatus("loading");
    setStories([]);
    setProgress({ done: 0, total: 0 });

    const raw = await fetchTopStories();
    setProgress({ done: 0, total: raw.length });

    const results = [];
    for (const story of raw) {
      if (!story?.title) continue;
      const { score, reason } = await scoreStory(story.title, interests);
      results.push({ ...story, score, reason });
      setProgress((p) => ({ ...p, done: p.done + 1 }));
      setStories([...results].sort((a, b) => b.score - a.score));
    }

    setStatus("done");
  }, [interests]);

  const addInterest = () => {
    const v = inputVal.trim();
    if (v && !interests.includes(v)) setInterests([...interests, v]);
    setInputVal("");
  };

  const removeInterest = (i) =>
    setInterests(interests.filter((_, idx) => idx !== i));

  const visible = stories.filter((s) => s.score >= threshold);

  // ---- スタイル ----
  const css = `
    @import url('https://fonts.googleapis.com/css2?family=Zen+Kaku+Gothic+New:wght@400;700&display=swap');
    :root {
      --bg0:#0a0a0a;--bg1:#141414;--bg2:#1e1e1e;--bg3:#262626;
      --tx:#f5f5f5;--tx2:#a3a3a3;--bd:#404040;
      --sky:#38bdf8;--sky2:#7dd3fc;--skymute:#082f49;
      --r:8px;--transition:0.15s ease;
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{background:var(--bg0);color:var(--tx);font-family:'Zen Kaku Gothic New',sans-serif;font-size:1rem;line-height:1.7}
    .wrap{max-width:860px;margin:0 auto;padding:2rem 1.5rem}
    h1{font-size:1.375rem;font-weight:700;margin-bottom:1.5rem;letter-spacing:0.02em}
    .panel{background:var(--bg1);border:1px solid var(--bd);border-radius:var(--r);padding:1.5rem;margin-bottom:1.5rem}
    .label{font-size:.875rem;color:var(--tx2);margin-bottom:.5rem}
    .tags{display:flex;flex-wrap:wrap;gap:.5rem;margin-bottom:.75rem}
    .tag{display:flex;align-items:center;gap:.25rem;background:var(--skymute);border:1px solid var(--sky);color:var(--sky);border-radius:4px;padding:.2rem .6rem;font-size:.875rem}
    .tag button{background:none;border:none;color:var(--sky);cursor:pointer;font-size:1rem;line-height:1;padding:0 0 0 .2rem}
    .tag button:hover{color:var(--sky2)}
    .row{display:flex;gap:.5rem}
    input{flex:1;background:var(--bg2);color:var(--tx);border:1px solid var(--bd);border-radius:var(--r);padding:.5rem .75rem;font-family:inherit;font-size:1rem;outline:none;transition:border-color var(--transition)}
    input:focus{border-color:var(--sky)}
    .btn{background:var(--sky);color:#0a0a0a;border:none;border-radius:var(--r);padding:.5rem 1rem;font-weight:700;font-size:1rem;cursor:pointer;transition:opacity var(--transition);white-space:nowrap}
    .btn:hover{opacity:.85}
    .btn:disabled{opacity:.4;cursor:not-allowed}
    .btn-run{width:100%;padding:.75rem;font-size:1rem;margin-top:.5rem}
    .slider-row{display:flex;align-items:center;gap:1rem;margin-top:.75rem}
    .slider-row label{font-size:.875rem;color:var(--tx2);white-space:nowrap}
    input[type=range]{flex:1;accent-color:var(--sky)}
    .badge{background:var(--bg3);border:1px solid var(--bd);border-radius:4px;padding:.1rem .5rem;font-size:.875rem;font-family:'Noto Sans Mono',monospace;min-width:2rem;text-align:center}
    .progress{background:var(--bg2);border-radius:4px;height:4px;margin-top:.75rem;overflow:hidden}
    .bar{height:100%;background:var(--sky);transition:width .3s}
    .card{background:var(--bg1);border:1px solid var(--bd);border-radius:var(--r);padding:1rem 1.25rem;margin-bottom:.75rem;display:flex;gap:1rem;align-items:flex-start}
    .score-box{min-width:42px;text-align:center}
    .score-num{font-size:1.375rem;font-weight:700;color:var(--sky);line-height:1}
    .score-label{font-size:.75rem;color:var(--tx2);margin-top:.15rem}
    .card-body{flex:1;min-width:0}
    .card-title{font-weight:700;margin-bottom:.25rem}
    .card-title a{color:var(--tx);text-decoration:none}
    .card-title a:hover{color:var(--sky);text-decoration:underline}
    .card-meta{font-size:.875rem;color:var(--tx2);display:flex;flex-wrap:wrap;gap:.75rem}
    .reason{font-size:.875rem;color:var(--tx2);margin-top:.4rem;font-style:italic}
    .empty{color:var(--tx2);text-align:center;padding:2rem}
    .status{font-size:.875rem;color:var(--tx2);margin-bottom:.75rem}
  `;

  return (
    <>
      <style>{css}</style>
      <div className="wrap">
        <h1>Hacker News フィルター</h1>

        {/* 興味設定 */}
        <div className="panel">
          <p className="label">興味分野</p>
          <div className="tags">
            {interests.map((tag, i) => (
              <span key={tag} className="tag">
                {tag}
                <button onClick={() => removeInterest(i)} aria-label={`${tag}を削除`}>×</button>
              </span>
            ))}
          </div>
          <div className="row">
            <input
              value={inputVal}
              onChange={(e) => setInputVal(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && addInterest()}
              placeholder="分野を追加（Enterで確定）"
            />
            <button className="btn" onClick={addInterest}>追加</button>
          </div>

          {/* 閾値スライダー */}
          <div className="slider-row">
            <label htmlFor="thr">最低スコア</label>
            <input
              id="thr"
              type="range"
              min={1}
              max={10}
              value={threshold}
              onChange={(e) => setThreshold(Number(e.target.value))}
            />
            <span className="badge">{threshold}</span>
          </div>

          <button
            className="btn btn-run"
            onClick={run}
            disabled={status === "loading" || interests.length === 0}
          >
            {status === "loading" ? "取得中..." : "今日の記事を取得"}
          </button>

          {status === "loading" && (
            <div className="progress">
              <div
                className="bar"
                style={{
                  width: progress.total
                    ? `${(progress.done / progress.total) * 100}%`
                    : "0%",
                }}
              />
            </div>
          )}
        </div>

        {/* 結果 */}
        {stories.length > 0 && (
          <div>
            <p className="status">
              {visible.length} 件表示（スコア {threshold} 以上）/ 全 {stories.length} 件評価済み
              {status === "loading" && ` — ${progress.done}/${progress.total} 処理中`}
            </p>
            {visible.length === 0 ? (
              <p className="empty">該当する記事が見つかりません。閾値を下げてみてください。</p>
            ) : (
              visible.map((s) => (
                <div key={s.id} className="card">
                  <div className="score-box">
                    <div className="score-num">{s.score}</div>
                    <div className="score-label">/ 10</div>
                  </div>
                  <div className="card-body">
                    <div className="card-title">
                      <a href={s.url || `https://news.ycombinator.com/item?id=${s.id}`}
                         target="_blank" rel="noopener noreferrer">
                        {s.title}
                      </a>
                    </div>
                    <div className="card-meta">
                      <span>{s.score_hn ?? s.descendants ?? 0} pts</span>
                      <span>by {s.by}</span>
                      <a href={`https://news.ycombinator.com/item?id=${s.id}`}
                         target="_blank" rel="noopener noreferrer"
                         style={{color:"var(--sky)"}}>
                        コメント
                      </a>
                    </div>
                    {s.reason && <p className="reason">{s.reason}</p>}
                  </div>
                </div>
              ))
            )}
          </div>
        )}
      </div>
    </>
  );
}
```

## 使い方のメモ

- ユーザーが「AIとRustに興味がある」のように分野を述べていれば `DEFAULT_INTERESTS` を差し替えて生成する
- `FETCH_COUNT` はデフォルト30件。ユーザーが件数を指定していれば変更する
- HN APIは認証不要・CORS対応済み
- Haiku APIはアーティファクト内で直接呼び出し可能（APIキー注入済み）
