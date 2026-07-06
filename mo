<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1, user-scalable=no">
<title>めんこオセロ</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Yusei+Magic&family=Zen+Maru+Gothic:wght@400;500;700;900&display=swap" rel="stylesheet">
<style>
  :root{
    --cream:#EFE6D3;
    --cream2:#E6DAC0;
    --ink:#262220;
    --ink-soft:#4a423b;
    --paper:#FBF6EA;
    --board:#5C4632;
    --board-dark:#4A3826;
    --board-line:#3E2F22;
    --red:#B23A3A;
    --red-dark:#8f2e2e;
    --gold:#C79A45;
    --gold-dark:#a17c34;
    --indigo:#3B5578;
    --indigo-dark:#2c405b;
    --shadow:rgba(38,34,32,0.35);
  }
  *{box-sizing:border-box;}
  html,body{margin:0;padding:0;}
  body{
    background:
      radial-gradient(ellipse at top left, rgba(255,255,255,0.25), transparent 60%),
      var(--cream);
    background-image:
      radial-gradient(rgba(140,106,70,0.07) 1px, transparent 1px),
      linear-gradient(var(--cream), var(--cream));
    background-size: 14px 14px, 100% 100%;
    font-family:'Zen Maru Gothic', sans-serif;
    color:var(--ink);
    min-height:100vh;
    display:flex;
    flex-direction:column;
    align-items:center;
    padding: 18px 12px 40px;
  }
  h1,h2,h3{ font-family:'Yusei Magic', sans-serif; font-weight:400; margin:0; }

  .titlebar{ display:flex; align-items:baseline; gap:10px; margin-bottom:4px; }
  .titlebar h1{ font-size:28px; color:var(--ink); letter-spacing:1px; }
  .titlebar .sub{ font-size:12px; color:var(--ink-soft); opacity:0.75; }
  .stamp-deco{
    display:inline-block; width:22px; height:22px; border-radius:4px;
    background:var(--red); color:#fff; font-size:12px; line-height:22px; text-align:center;
    transform:rotate(-8deg); box-shadow:1px 1px 3px var(--shadow); font-family:'Zen Maru Gothic';
    font-weight:700;
  }

  .screen{ width:100%; max-width:980px; display:flex; flex-direction:column; align-items:center; }
  .hidden{ display:none !important; }

  .panel{
    background:var(--paper);
    border:2px solid var(--ink);
    border-radius:14px;
    box-shadow: 4px 4px 0 var(--shadow);
    padding:22px 26px;
  }

  #startScreen .panel{ max-width:520px; text-align:center; margin-top:30px; }
  #startScreen p.desc{ font-size:13.5px; line-height:1.9; color:var(--ink-soft); margin:14px 0 22px; text-align:left; }
  #startScreen p.desc b{ color:var(--ink); }
  .mode-buttons{ display:flex; gap:14px; justify-content:center; flex-wrap:wrap; }
  .big-btn{
    font-family:'Zen Maru Gothic'; font-weight:700; font-size:15px;
    background:var(--ink); color:var(--paper); border:none; border-radius:10px;
    padding:14px 22px; cursor:pointer; box-shadow:3px 3px 0 var(--shadow);
    transition:transform .1s ease;
  }
  .big-btn:hover{ transform:translateY(-2px); }
  .big-btn:active{ transform:translateY(1px); box-shadow:1px 1px 0 var(--shadow); }
  .big-btn.alt{ background:var(--red); }
  .rules-toggle{
    margin-top:16px; font-size:12px; color:var(--ink-soft); text-decoration:underline; cursor:pointer;
    background:none; border:none; font-family:'Zen Maru Gothic';
  }
  .side-pick{ display:flex; gap:10px; justify-content:center; margin:14px 0 6px; }
  .side-pick button{
    font-family:'Zen Maru Gothic'; font-size:13px; padding:8px 14px; border-radius:8px;
    border:2px solid var(--ink); background:var(--paper); cursor:pointer;
  }
  .side-pick button.active{ background:var(--ink); color:var(--paper); }

  #gameScreen{ gap:14px; }
  .status-bar{
    width:100%; max-width:760px; display:flex; align-items:center; justify-content:space-between;
    background:var(--paper); border:2px solid var(--ink); border-radius:10px;
    padding:10px 16px; box-shadow:3px 3px 0 var(--shadow); font-size:14px; gap:10px; flex-wrap:wrap;
  }
  .turn-indicator{ display:flex; align-items:center; gap:8px; font-weight:700; font-size:15px; }
  .turn-dot{ width:18px; height:18px; border-radius:50%; border:2px solid var(--ink); }
  .turn-dot.black{ background:var(--ink); }
  .turn-dot.white{ background:var(--paper); }
  .scores{ display:flex; gap:14px; font-size:13px; color:var(--ink-soft); }
  .score-chip{ display:flex; align-items:center; gap:5px; }
  .icon-btn{
    background:none; border:2px solid var(--ink); border-radius:8px; padding:5px 10px;
    font-family:'Zen Maru Gothic'; font-size:12px; cursor:pointer; color:var(--ink);
  }
  .icon-btn:hover{ background:var(--cream2); }
  .guide-toggle{
    display:flex; align-items:center; gap:5px; font-size:12px; color:var(--ink-soft); cursor:pointer;
    user-select:none;
  }
  .guide-toggle input{ accent-color:var(--ink); width:14px; height:14px; cursor:pointer; }

  .main-area{ display:flex; gap:18px; align-items:flex-start; justify-content:center; flex-wrap:wrap; width:100%; }

  .board-wrap{
    background:linear-gradient(160deg, var(--board), var(--board-dark));
    padding:14px; border-radius:14px; box-shadow:5px 5px 0 var(--shadow), inset 0 0 0 3px rgba(0,0,0,0.15);
    position:relative;
  }
  .board{
    display:grid;
    grid-template-columns:repeat(8, minmax(32px, 46px));
    grid-template-rows:repeat(8, minmax(32px, 46px));
    gap:2px;
    background:var(--board-line);
    border:2px solid var(--board-line);
    border-radius:4px;
  }
  .cell{
    background:var(--board);
    display:flex; align-items:center; justify-content:center;
    position:relative;
    cursor:default;
  }
  .cell.legal{ cursor:pointer; }
  .cell.legal::before{
    content:''; position:absolute; width:22%; height:22%; border-radius:50%;
    background:rgba(255,255,255,0.55); box-shadow:0 0 6px rgba(255,255,255,0.5);
  }
  .cell.legal.needsel::before{ background:rgba(178,58,58,0.55); }
  .cell.lastmove::after{
    content:''; position:absolute; inset:3px; border:2px solid rgba(199,154,69,0.85); border-radius:3px; pointer-events:none;
  }
  .cell.preview-menko .piece{ outline:3px dashed var(--red); outline-offset:2px; }
  .cell.preview-sandwich .piece{ outline:3px dashed var(--indigo); outline-offset:2px; }
  .cell.preview-target::before{
    background:rgba(199,154,69,0.85); box-shadow:0 0 8px rgba(199,154,69,0.9);
  }

  .piece{
    position:relative; border-radius:50%;
    display:flex; align-items:center; justify-content:center;
    transition: transform .35s ease;
  }
  .piece.black{ background:radial-gradient(circle at 35% 30%, #46403a, var(--ink) 70%); border:1px solid #000; }
  .piece.white{ background:radial-gradient(circle at 35% 30%, #ffffff, var(--paper) 70%); border:1px solid #cfc4ab; }
  .piece.w-light{ width:62%; height:62%; box-shadow:1px 1px 2px var(--shadow); }
  .piece.w-normal{ width:74%; height:74%; box-shadow:2px 2px 3px var(--shadow); }
  .piece.w-heavy{ width:86%; height:86%; box-shadow:0 4px 5px var(--shadow), 0 0 0 2px rgba(0,0,0,0.08) inset; }

  .wt-label{ font-size:12px; font-weight:700; font-family:'Zen Maru Gothic'; user-select:none; pointer-events:none; }
  .piece.black .wt-label{ color:#efe7d8; }
  .piece.white .wt-label{ color:#3a332c; }

  .piece.flipping{ animation: flipAnim .5s ease; }
  @keyframes flipAnim{
    0%{ transform:scaleX(1); }
    45%{ transform:scaleX(0.05); }
    55%{ transform:scaleX(0.05); }
    100%{ transform:scaleX(1); }
  }
  .piece.impact{ animation: impactAnim .5s ease; }
  @keyframes impactAnim{
    0%{ transform:scale(1); box-shadow:0 0 0 0 rgba(178,58,58,0.65); }
    30%{ transform:scale(1.3); box-shadow:0 0 0 10px rgba(178,58,58,0); }
    55%{ transform:scale(0.85); }
    100%{ transform:scale(1); box-shadow:0 0 0 0 rgba(178,58,58,0); }
  }
  .impact-ring{
    position:absolute; inset:-6px; border-radius:50%; border:3px solid var(--red);
    animation: ringAnim .5s ease forwards; pointer-events:none;
  }
  @keyframes ringAnim{
    0%{ opacity:1; transform:scale(0.4); }
    100%{ opacity:0; transform:scale(1.6); }
  }

  .stamp{
    position:absolute; top:-6px; right:-6px; width:18px; height:18px; border-radius:3px;
    color:#fff; font-size:10px; font-weight:700; display:flex; align-items:center; justify-content:center;
    transform:rotate(-12deg); box-shadow:1px 1px 2px rgba(0,0,0,0.4); font-family:'Zen Maru Gothic';
    border:1px solid rgba(255,255,255,0.4);
  }
  .stamp.weak{ background:var(--indigo); }
  .stamp.mid{ background:var(--gold); }
  .stamp.strong{ background:var(--red); }

  .hands{ display:flex; flex-direction:column; gap:12px; width:230px; }
  .hand-panel{
    background:var(--paper); border:2px solid var(--ink); border-radius:12px; padding:12px;
    box-shadow:3px 3px 0 var(--shadow); opacity:0.55; transition:opacity .2s ease;
  }
  .hand-panel.active{ opacity:1; }
  .hand-title{ display:flex; align-items:center; gap:8px; font-weight:700; font-size:13px; margin-bottom:8px; }
  .hand-title .turn-dot{ width:14px; height:14px; }
  .type-row{ margin-bottom:8px; }
  .type-label{ font-size:11px; color:var(--ink-soft); margin-bottom:3px; display:flex; justify-content:space-between; }
  .chips{ display:flex; gap:5px; flex-wrap:wrap; }
  .chip{
    border:1.5px solid var(--ink); border-radius:7px; background:#fff; cursor:pointer;
    font-family:'Zen Maru Gothic'; font-size:10.5px; padding:4px 6px; min-width:34px; text-align:center;
    display:flex; flex-direction:column; align-items:center; line-height:1.3;
  }
  .chip .n{ font-weight:700; font-size:12px; }
  .chip.disabled{ opacity:0.3; cursor:not-allowed; }
  .chip.selected{ background:var(--ink); color:var(--paper); border-color:var(--ink); }
  .chip.selected .n{ color:var(--paper); }
  .type-normal .chip{ border-color:#999; }
  .type-weak .chip{ border-color:var(--indigo); }
  .type-mid .chip{ border-color:var(--gold-dark); }
  .type-strong .chip{ border-color:var(--red-dark); }

  .hint-msg{ min-height:20px; font-size:12.5px; color:var(--red-dark); text-align:center; font-weight:700; }

  .modal-bg{
    position:fixed; inset:0; background:rgba(38,34,32,0.55); display:flex; align-items:center; justify-content:center;
    z-index:50; padding:20px;
  }
  .modal{
    background:var(--paper); border:2px solid var(--ink); border-radius:14px; padding:26px 28px;
    max-width:480px; width:100%; box-shadow:5px 5px 0 var(--shadow); max-height:85vh; overflow-y:auto;
  }
  .modal h2{ font-size:20px; margin-bottom:12px; }
  .modal .rule-block{ font-size:13px; line-height:1.85; color:var(--ink-soft); margin-bottom:10px; }
  .modal .rule-block b{ color:var(--ink); }
  .legend-row{ display:flex; align-items:center; gap:8px; margin:6px 0; font-size:12.5px; }
  .legend-swatch{ width:16px; height:16px; border-radius:3px; }
  .modal-close{ margin-top:14px; }
  .win-emoji{ font-size:38px; text-align:center; margin-bottom:4px; }

  @media (max-width:720px){
    .board{ grid-template-columns:repeat(8, minmax(28px, 38px)); grid-template-rows:repeat(8, minmax(28px, 38px)); }
    .hands{ width:100%; flex-direction:row; flex-wrap:wrap; }
    .hand-panel{ flex:1; min-width:260px; }
    .main-area{ flex-direction:column; align-items:center; }
  }
</style>
</head>
<body>

<div class="titlebar">
  <span class="stamp-deco">強</span>
  <h1>めんこオセロ</h1>
  <span class="sub">menko × othello</span>
</div>

<div class="screen" id="startScreen">
  <div class="panel">
    <h2 style="font-size:18px; margin-bottom:6px;">対戦モードを選んでください</h2>
    <p class="desc">
      基本ルールは普通のオセロ。加えて各プレイヤーは <b>弱・中・強</b> の「めんこ駒」を計6枚持つ（弱＝軽い・普通・重いを1枚ずつ／中＝普通・重いを1枚ずつ／強＝重いを1枚）。
      通常駒は挟める場所にしか置けないが、<b>めんこ駒は挟みが無くても、隣接する相手駒を反転できる場所ならどこでも置ける</b>。
      置くとまず周囲8マス（斜め含む）の相手駒のうち条件を満たす重さの駒が<b>1枚ずつ</b>反転し（弱＝軽いのみ／中＝軽い・普通／強＝すべて）、
      そのあとで通常のサンドイッチ反転（連鎖含む）が続く。
    </p>
    <div class="mode-buttons">
      <button class="big-btn" id="btnPvp">👥 対人モード</button>
      <button class="big-btn alt" id="btnAi">🤖 AI対戦モード</button>
    </div>
    <div id="sideChooser" class="hidden">
      <p style="font-size:12px; color:var(--ink-soft); margin:14px 0 4px;">あなたの色を選択：</p>
      <div class="side-pick">
        <button id="pickBlack" class="active">● くろ（先手）</button>
        <button id="pickWhite">○ しろ（後手）</button>
      </div>
      <button class="big-btn" id="btnStartAi" style="margin-top:10px;">対局開始</button>
    </div>
    <button class="rules-toggle" id="btnRulesFull">くわしいルールを見る</button>
  </div>
</div>

<div class="screen hidden" id="gameScreen">
  <div class="status-bar">
    <div class="turn-indicator">
      <span class="turn-dot" id="turnDot"></span>
      <span id="turnText">くろ の番</span>
    </div>
    <div class="scores">
      <div class="score-chip"><span class="turn-dot black" style="width:12px;height:12px;"></span> <span id="scoreBlack">2</span></div>
      <div class="score-chip"><span class="turn-dot white" style="width:12px;height:12px;"></span> <span id="scoreWhite">2</span></div>
    </div>
    <label class="guide-toggle"><input type="checkbox" id="guideToggle" checked> 反転ガイド表示</label>
    <div style="display:flex; gap:8px;">
      <button class="icon-btn" id="btnHelp">?ルール</button>
      <button class="icon-btn" id="btnRestart">↺ 最初から</button>
    </div>
  </div>

  <div class="hint-msg" id="hintMsg">駒を選んでから、光っているマスに置いてください</div>

  <div class="main-area">
    <div class="hands" id="handsWrap"></div>
    <div class="board-wrap">
      <div class="board" id="board"></div>
    </div>
  </div>
</div>

<div class="modal-bg hidden" id="helpModal">
  <div class="modal">
    <h2>ルール詳細</h2>
    <div class="rule-block">
      <b>①置ける場所：</b>通常駒は、通常のオセロと同じく縦・横・斜めに一直線で相手を挟める場所にしか置けない。一方<b>めんこ駒（弱・中・強）は、挟みが無くても、隣接する相手駒をめんこ効果で反転できる場所ならどこでも置ける</b>（もちろん挟める場所にも置ける）。
    </div>
    <div class="rule-block">
      <b>②めんこ駒の効果（発動順）：</b>めんこ駒を置くと、まず置いたマスの周囲8マス（斜め含む）にある相手駒のうち下記の重さ条件を満たす駒が<b>1枚ずつ順番に</b>衝撃エフェクトとともに反転する：
      <div class="legend-row"><span class="legend-swatch" style="background:var(--indigo);"></span> 弱めんこ → 軽い駒のみ反転</div>
      <div class="legend-row"><span class="legend-swatch" style="background:var(--gold);"></span> 中めんこ → 軽い・普通の駒を反転</div>
      <div class="legend-row"><span class="legend-swatch" style="background:var(--red);"></span> 強めんこ → 重さ問わず全て反転</div>
    </div>
    <div class="rule-block">
      <b>③サンドイッチ反転：</b>めんこの反転が終わったあとに、通常の挟み反転が1枚ずつ反転する。めんこで反転した駒自身も新たな挟みの起点になり、そこからさらに連鎖的に反転することがある。
    </div>
    <div class="rule-block">
      <b>駒の重さ：</b>軽い・普通・重いは駒に表記されており固定。めんこ駒は計6枚（弱＝軽い・普通・重い各1枚／中＝普通・重い各1枚／強＝重い1枚）。重い駒は弱・中めんこでは反転しないため、防御的に重要な場所へ置くと粘り強くなる。
    </div>
    <div class="rule-block">
      <b>反転ガイド：</b>駒を選んでからマスにカーソルを合わせると、その場所に置いた場合に反転する駒（赤の破線＝めんこで反転／青の破線＝サンドイッチで反転）が事前にわかる。画面上部のチェックでON/OFF切り替え可能。
    </div>
    <div class="rule-block">
      <b>勝敗：</b>置けるマスがなくなったら終了（片方だけ置けない場合はパス）。最終的に盤上の自分の色の駒数が多い方が勝ち。
    </div>
    <button class="big-btn modal-close" id="closeHelp">閉じる</button>
  </div>
</div>

<div class="modal-bg hidden" id="rulesModal">
  <div class="modal">
    <h2>くわしいルール</h2>
    <div class="rule-block"><b>①置ける場所：</b>通常駒は挟める場所のみ。めんこ駒は挟みが無くても、隣接する相手駒をめんこ効果で反転できる場所ならどこでも置ける。</div>
    <div class="rule-block"><b>②めんこ：</b>弱／中／強のめんこ駒を置くと、まず隣接8マスの相手駒が重さ条件で1枚ずつ反転（衝撃エフェクト）。<br>
      弱→軽いのみ／中→軽い・普通／強→全部。</div>
    <div class="rule-block"><b>③サンドイッチ：</b>めんこ反転のあとに、通常の挟み反転（連鎖含む）が1枚ずつ行われる。</div>
    <div class="rule-block">各プレイヤーはめんこ駒を計6枚（弱＝軽い・普通・重い各1枚／中＝普通・重い各1枚／強＝重い1枚）、残り26枚は通常駒（軽い15・普通8・重い3）。</div>
    <div class="rule-block">駒にカーソルを合わせると反転ガイドが出る（ON/OFF切り替え可）。</div>
    <button class="big-btn modal-close" id="closeRules">閉じる</button>
  </div>
</div>

<div class="modal-bg hidden" id="winModal">
  <div class="modal" style="text-align:center;">
    <div class="win-emoji">🏆</div>
    <h2 id="winTitle">くろの勝ち！</h2>
    <p id="winDetail" style="font-size:14px; color:var(--ink-soft); margin:10px 0 18px;"></p>
    <button class="big-btn" id="btnPlayAgain">もう一度あそぶ</button>
  </div>
</div>

<script>
(function(){
  "use strict";
  const N = 8;
  const DIRS = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]];
  const TYPE_LABEL = {normal:'通常', weak:'弱', mid:'中', strong:'強'};
  const WEIGHT_LABEL = {light:'軽', normal:'普', heavy:'重'};
  const WEIGHT_CHAR = {light:'軽', normal:'普', heavy:'重'};
  const STAMP_CHAR = {weak:'弱', mid:'中', strong:'強'};

  let state = null;

  function inBounds(r,c){ return r>=0 && r<N && c>=0 && c<N; }

  function shuffle(arr){
    for(let i=arr.length-1;i>0;i--){
      const j = Math.floor(Math.random()*(i+1));
      [arr[i],arr[j]]=[arr[j],arr[i]];
    }
    return arr;
  }

  // Menko pieces per color (6 total): weak has one of every weight (light/normal/heavy),
  // mid has normal + heavy only, strong has heavy only.
  // Remaining weights (light15/normal8/heavy3) are distributed among the 26 normal-type pieces.
  function buildPool(){
    let pool = [];
    pool.push({type:'weak', weight:'light'});
    pool.push({type:'weak', weight:'normal'});
    pool.push({type:'weak', weight:'heavy'});
    pool.push({type:'mid', weight:'normal'});
    pool.push({type:'mid', weight:'heavy'});
    pool.push({type:'strong', weight:'heavy'});

    let normalWeights = [];
    for(let i=0;i<15;i++) normalWeights.push('light');
    for(let i=0;i<8;i++) normalWeights.push('normal');
    for(let i=0;i<3;i++) normalWeights.push('heavy');
    shuffle(normalWeights);
    for(let i=0;i<26;i++) pool.push({type:'normal', weight:normalWeights[i]});
    return pool;
  }

  function inventoryFromPool(pool){
    const inv = {
      normal:{light:0,normal:0,heavy:0},
      weak:{light:0,normal:0,heavy:0},
      mid:{light:0,normal:0,heavy:0},
      strong:{light:0,normal:0,heavy:0}
    };
    for(const p of pool){ inv[p.type][p.weight]++; }
    return inv;
  }

  function newGame(mode, humanColor){
    const board = Array.from({length:N}, () => Array(N).fill(null));
    const poolBlack = buildPool();
    const poolWhite = buildPool();

    function takeNormal(pool){
      const idx = pool.findIndex(p => p.type==='normal');
      return pool.splice(idx,1)[0];
    }
    const b1 = takeNormal(poolBlack), b2 = takeNormal(poolBlack);
    const w1 = takeNormal(poolWhite), w2 = takeNormal(poolWhite);

    board[3][3] = {color:'white', type:w1.type, weight:w1.weight};
    board[3][4] = {color:'black', type:b1.type, weight:b1.weight};
    board[4][3] = {color:'black', type:b2.type, weight:b2.weight};
    board[4][4] = {color:'white', type:w2.type, weight:w2.weight};

    state = {
      board, mode, humanColor: humanColor||'black',
      turn:'black',
      inventory:{ black:inventoryFromPool(poolBlack), white:inventoryFromPool(poolWhite) },
      selected:null,
      lastMove:null,
      animating:false,
      animatingCell:null,
      guideEnabled:true,
      over:false
    };
  }

  function computeStandardFlips(board, r, c, color){
    const flips = [];
    for(const [dr,dc] of DIRS){
      let rr=r+dr, cc=c+dc;
      const line=[];
      while(inBounds(rr,cc) && board[rr][cc] && board[rr][cc].color!==color){
        line.push([rr,cc]); rr+=dr; cc+=dc;
      }
      if(line.length>0 && inBounds(rr,cc) && board[rr][cc] && board[rr][cc].color===color){
        flips.push(...line);
      }
    }
    return flips;
  }

  function weightQualifies(type, weight){
    if(type==='weak') return weight==='light';
    if(type==='mid') return weight==='light'||weight==='normal';
    if(type==='strong') return true;
    return false;
  }

  function computeMenkoFlips(board, r, c, color, type){
    const flips = [];
    for(const [dr,dc] of DIRS){
      const rr=r+dr, cc=c+dc;
      if(inBounds(rr,cc) && board[rr][cc] && board[rr][cc].color!==color){
        if(weightQualifies(type, board[rr][cc].weight)) flips.push([rr,cc]);
      }
    }
    return flips;
  }

  // Plan a move WITHOUT mutating the real board. `board` must NOT yet contain
  // a piece at (r,c). Returns an ordered array of flip steps.
  //
  // Normal pieces: plain standard Othello flip - a single pass from the
  // placement cell only, no cascade.
  //
  // Menko pieces: menko flips happen first (kind:'menko'), then sandwich flips
  // (kind:'sandwich'). A menko-flipped disc can create a NEW sandwich anywhere
  // on the board along its own 8 directions - not only along the placement
  // cell's rays - so every menko-flipped cell (and every cell later flipped by
  // a sandwich) is re-checked as its own origin, cascading outward until no
  // more flips occur.
  function planMove(board, r, c, color, type, weight){
    const work = board.map(row => row.map(cell => cell ? {...cell} : null));
    work[r][c] = {color, type, weight};
    const plan = [];

    if(type === 'normal'){
      const sFlips = computeStandardFlips(work, r, c, color);
      for(const [fr,fc] of sFlips){
        work[fr][fc].color = color;
        plan.push({r:fr, c:fc, kind:'sandwich'});
      }
      return plan;
    }

    const queued = new Set();
    const queue = [];
    function enqueue(rr,cc){
      const key = rr+','+cc;
      if(!queued.has(key)){ queued.add(key); queue.push([rr,cc]); }
    }

    const mFlips = computeMenkoFlips(work, r, c, color, type);
    for(const [fr,fc] of mFlips){
      work[fr][fc].color = color;
      plan.push({r:fr, c:fc, kind:'menko'});
    }
    for(const [fr,fc] of mFlips) enqueue(fr,fc);
    enqueue(r,c);

    let iter = 0;
    while(queue.length > 0 && iter < 300){
      const [orr,occ] = queue.shift();
      const sFlips = computeStandardFlips(work, orr, occ, color);
      for(const [fr,fc] of sFlips){
        if(work[fr][fc].color !== color){
          work[fr][fc].color = color;
          plan.push({r:fr, c:fc, kind:'sandwich'});
          enqueue(fr,fc);
        }
      }
      iter++;
    }
    return plan;
  }

  // Normal pieces: legal only where a standard sandwich exists.
  // Menko pieces (weak/mid/strong): ALSO legal at any empty cell adjacent to an
  // opponent piece that the menko effect would flip, even with no sandwich.
  function isLegalForPiece(board, r, c, color, type){
    if(board[r][c]) return false;
    if(computeStandardFlips(board, r, c, color).length > 0) return true;
    if(type !== 'normal' && computeMenkoFlips(board, r, c, color, type).length > 0) return true;
    return false;
  }

  function legalCellsForType(board, color, type){
    const moves = [];
    for(let r=0;r<N;r++) for(let c=0;c<N;c++){
      if(isLegalForPiece(board, r, c, color, type)) moves.push([r,c]);
    }
    return moves;
  }

  // Whether `color` has ANY legal move at all, across every piece type they still hold.
  function hasAnyLegalMove(board, color, inventory){
    for(const type of ['normal','weak','mid','strong']){
      const holds = ['light','normal','heavy'].some(w => inventory[type][w] > 0);
      if(!holds) continue;
      for(let r=0;r<N;r++) for(let c=0;c<N;c++){
        if(isLegalForPiece(board, r, c, color, type)) return true;
      }
    }
    return false;
  }

  function cloneBoard(board){
    return board.map(row => row.map(cell => cell? {...cell} : null));
  }

  function countDiscs(board){
    let black=0, white=0;
    for(let r=0;r<N;r++) for(let c=0;c<N;c++){
      if(board[r][c]){ if(board[r][c].color==='black') black++; else white++; }
    }
    return {black, white};
  }

  function opponent(color){ return color==='black' ? 'white' : 'black'; }

  /* ---------------- rendering ---------------- */

  const boardEl = document.getElementById('board');
  const handsWrap = document.getElementById('handsWrap');
  const hintMsg = document.getElementById('hintMsg');

  function render(){
    renderBoard();
    renderHands();
    renderStatus();
  }

  function renderBoard(){
    boardEl.innerHTML = '';
    // Legality now depends on which piece is selected (menko pieces have wider
    // placement options than normal pieces), so nothing is highlighted until
    // the player has picked a piece from their hand.
    const moves = (state.over || state.animating || !state.selected)
      ? []
      : legalCellsForType(state.board, state.turn, state.selected.type);
    const moveSet = new Set(moves.map(m=>m.join(',')));

    for(let r=0;r<N;r++){
      for(let c=0;c<N;c++){
        const cell = document.createElement('div');
        cell.className = 'cell';
        cell.dataset.r = r; cell.dataset.c = c;
        const key = r+','+c;
        if(moveSet.has(key)){
          cell.classList.add('legal');
          cell.addEventListener('click', ()=>onCellClick(r,c));
          if(state.guideEnabled){
            cell.addEventListener('mouseenter', ()=>onCellHover(r,c));
            cell.addEventListener('mouseleave', ()=>clearPreview());
          }
        }
        if(state.lastMove && state.lastMove[0]===r && state.lastMove[1]===c){
          cell.classList.add('lastmove');
        }
        const data = state.board[r][c];
        if(data){
          const piece = document.createElement('div');
          piece.className = `piece ${data.color} w-${data.weight}`;
          if(state.animatingCell && state.animatingCell.r===r && state.animatingCell.c===c){
            piece.classList.add(state.animatingCell.kind==='menko' ? 'impact' : 'flipping');
            if(state.animatingCell.kind==='menko'){
              const ring = document.createElement('div');
              ring.className = 'impact-ring';
              piece.appendChild(ring);
            }
          }
          const label = document.createElement('span');
          label.className = 'wt-label';
          label.textContent = WEIGHT_CHAR[data.weight];
          piece.appendChild(label);
          if(data.type !== 'normal'){
            const stamp = document.createElement('div');
            stamp.className = `stamp ${data.type}`;
            stamp.textContent = STAMP_CHAR[data.type];
            piece.appendChild(stamp);
          }
          cell.appendChild(piece);
        }
        boardEl.appendChild(cell);
      }
    }
  }

  function renderHands(){
    handsWrap.innerHTML = '';
    const colors = ['black','white'];
    for(const color of colors){
      const panel = document.createElement('div');
      panel.className = 'hand-panel' + (state.turn===color && !state.over ? ' active' : '');

      const title = document.createElement('div');
      title.className = 'hand-title';
      title.innerHTML = `<span class="turn-dot ${color}"></span> ${color==='black'?'くろ':'しろ'} の持ち駒`;
      panel.appendChild(title);

      const isSelectable = (state.turn===color) && !state.over && !state.animating && (state.mode==='pvp' || color===state.humanColor);

      for(const type of ['normal','weak','mid','strong']){
        const row = document.createElement('div');
        row.className = `type-row type-${type}`;
        const label = document.createElement('div');
        label.className = 'type-label';
        label.innerHTML = `<span>${TYPE_LABEL[type]}${type!=='normal' ? 'めんこ':''}</span>`;
        row.appendChild(label);
        const chips = document.createElement('div');
        chips.className = 'chips';
        for(const weight of ['light','normal','heavy']){
          const count = state.inventory[color][type][weight];
          const chip = document.createElement('div');
          const sel = state.selected && state.selected.color===color && state.selected.type===type && state.selected.weight===weight;
          chip.className = 'chip' + (count===0?' disabled':'') + (sel?' selected':'');
          chip.innerHTML = `<span>${WEIGHT_LABEL[weight]}</span><span class="n">${count}</span>`;
          if(count>0 && isSelectable){
            chip.addEventListener('click', ()=>{
              state.selected = {color, type, weight};
              hintMsg.textContent = '光っているマスにカーソルを合わせると反転ガイドが出ます';
              render();
            });
          }
          chips.appendChild(chip);
        }
        row.appendChild(chips);
        panel.appendChild(row);
      }
      handsWrap.appendChild(panel);
    }
  }

  function renderStatus(){
    const {black, white} = countDiscs(state.board);
    document.getElementById('scoreBlack').textContent = black;
    document.getElementById('scoreWhite').textContent = white;
    const dot = document.getElementById('turnDot');
    const txt = document.getElementById('turnText');
    dot.className = 'turn-dot ' + state.turn;
    txt.textContent = (state.turn==='black' ? 'くろ' : 'しろ') + ' の番' + (state.mode==='ai' && state.turn!==state.humanColor && !state.over ? '（AI思考中…）' : '');
  }

  /* ---------------- hover preview (flip guide) ---------------- */

  function clearPreview(){
    document.querySelectorAll('.cell.preview-menko, .cell.preview-sandwich, .cell.preview-target')
      .forEach(el => el.classList.remove('preview-menko','preview-sandwich','preview-target'));
  }

  function onCellHover(r,c){
    if(!state.selected || state.animating || state.over || !state.guideEnabled) return;
    clearPreview();
    const {type, weight, color} = state.selected;
    const plan = planMove(state.board, r, c, color, type, weight);
    const target = boardEl.querySelector(`.cell[data-r="${r}"][data-c="${c}"]`);
    if(target) target.classList.add('preview-target');
    for(const step of plan){
      const el = boardEl.querySelector(`.cell[data-r="${step.r}"][data-c="${step.c}"]`);
      if(el) el.classList.add(step.kind==='menko' ? 'preview-menko' : 'preview-sandwich');
    }
  }

  /* ---------------- interaction ---------------- */

  function onCellClick(r,c){
    if(state.over || state.animating) return;
    if(state.mode==='ai' && state.turn!==state.humanColor) return;
    if(!state.selected || state.selected.color!==state.turn){
      hintMsg.textContent = '先に置く駒を選んでください（右のパネル）';
      return;
    }
    const {type, weight} = state.selected;
    if(state.inventory[state.turn][type][weight]<=0) return;
    if(!isLegalForPiece(state.board, r, c, state.turn, type)) return;
    clearPreview();
    doMove(r,c,state.turn,type,weight);
  }

  function doMove(r,c,color,type,weight){
    const plan = planMove(state.board, r, c, color, type, weight);
    state.inventory[color][type][weight]--;
    state.board[r][c] = {color, type, weight};
    state.lastMove = [r,c];
    state.selected = null;
    state.animating = true;
    render();

    let idx = 0;
    function step(){
      if(idx >= plan.length){
        state.animating = false;
        state.animatingCell = null;
        render();
        advanceTurn();
        return;
      }
      const s = plan[idx];
      state.board[s.r][s.c].color = color;
      state.animatingCell = {r:s.r, c:s.c, kind:s.kind};
      render();
      idx++;
      setTimeout(step, s.kind==='menko' ? 320 : 260);
    }
    setTimeout(step, 350);
  }

  function advanceTurn(){
    const next = opponent(state.turn);
    const nextCanMove = hasAnyLegalMove(state.board, next, state.inventory[next]);
    const curCanMove = hasAnyLegalMove(state.board, state.turn, state.inventory[state.turn]);

    if(nextCanMove){
      state.turn = next;
      render();
      maybeAiMove();
    } else if(curCanMove){
      hintMsg.textContent = (next==='black'?'くろ':'しろ') + 'は置けるマスがないためパスします';
      render();
      maybeAiMove();
    } else {
      endGame();
    }
  }

  function endGame(){
    state.over = true;
    render();
    const {black, white} = countDiscs(state.board);
    const modal = document.getElementById('winModal');
    const title = document.getElementById('winTitle');
    const detail = document.getElementById('winDetail');
    if(black===white){
      title.textContent = '引き分け！';
    } else {
      const winner = black>white ? 'くろ':'しろ';
      title.textContent = winner + ' の勝ち！';
    }
    detail.textContent = `くろ ${black} － しろ ${white}`;
    modal.classList.remove('hidden');
  }

  /* ---------------- AI ---------------- */

  const POS_WEIGHT = [
    [120,-20,20,5,5,20,-20,120],
    [-20,-40,-5,-5,-5,-5,-40,-20],
    [20,-5,15,3,3,15,-5,20],
    [5,-5,3,3,3,3,-5,5],
    [5,-5,3,3,3,3,-5,5],
    [20,-5,15,3,3,15,-5,20],
    [-20,-40,-5,-5,-5,-5,-40,-20],
    [120,-20,20,5,5,20,-20,120]
  ];

  function pickWeightForType(inv, type){
    for(const w of ['light','normal','heavy']){
      if(inv[type][w]>0) return w;
    }
    return null;
  }

  function aiChooseMove(){
    const color = state.turn;
    const inv = state.inventory[color];

    let best = null;
    for(const type of ['normal','weak','mid','strong']){
      const weight = pickWeightForType(inv, type);
      if(weight===null) continue;
      for(let r=0;r<N;r++) for(let c=0;c<N;c++){
        if(!isLegalForPiece(state.board, r, c, color, type)) continue;
        const plan = planMove(state.board, r, c, color, type, weight);
        let score = plan.length*15 + POS_WEIGHT[r][c];
        if(type!=='normal') score -= 3;
        score += Math.random()*2;
        if(!best || score>best.score){
          best = {r,c,type,weight,score};
        }
      }
    }
    return best;
  }

  function maybeAiMove(){
    if(state.over) return;
    if(state.mode!=='ai') return;
    if(state.turn===state.humanColor) return;
    hintMsg.textContent = 'AIが考えています…';
    render();
    setTimeout(()=>{
      const mv = aiChooseMove();
      if(mv){
        doMove(mv.r, mv.c, state.turn, mv.type, mv.weight);
      }
    }, 550);
  }

  /* ---------------- screen wiring ---------------- */

  const startScreen = document.getElementById('startScreen');
  const gameScreen = document.getElementById('gameScreen');
  const sideChooser = document.getElementById('sideChooser');
  let chosenSide = 'black';

  document.getElementById('btnPvp').addEventListener('click', ()=>{
    newGame('pvp');
    startScreen.classList.add('hidden');
    gameScreen.classList.remove('hidden');
    hintMsg.textContent = '駒を選んでから、光っているマスに置いてください';
    document.getElementById('guideToggle').checked = true;
    render();
  });

  document.getElementById('btnAi').addEventListener('click', ()=>{
    sideChooser.classList.remove('hidden');
  });

  document.getElementById('pickBlack').addEventListener('click', ()=>{
    chosenSide='black';
    document.getElementById('pickBlack').classList.add('active');
    document.getElementById('pickWhite').classList.remove('active');
  });
  document.getElementById('pickWhite').addEventListener('click', ()=>{
    chosenSide='white';
    document.getElementById('pickWhite').classList.add('active');
    document.getElementById('pickBlack').classList.remove('active');
  });

  document.getElementById('btnStartAi').addEventListener('click', ()=>{
    newGame('ai', chosenSide);
    startScreen.classList.add('hidden');
    gameScreen.classList.remove('hidden');
    hintMsg.textContent = '駒を選んでから、光っているマスに置いてください';
    document.getElementById('guideToggle').checked = true;
    render();
    maybeAiMove();
  });

  document.getElementById('guideToggle').addEventListener('change', (e)=>{
    if(state){
      state.guideEnabled = e.target.checked;
      if(!state.guideEnabled) clearPreview();
      render();
    }
  });

  document.getElementById('btnHelp').addEventListener('click', ()=>{
    document.getElementById('helpModal').classList.remove('hidden');
  });
  document.getElementById('closeHelp').addEventListener('click', ()=>{
    document.getElementById('helpModal').classList.add('hidden');
  });
  document.getElementById('btnRulesFull').addEventListener('click', ()=>{
    document.getElementById('rulesModal').classList.remove('hidden');
  });
  document.getElementById('closeRules').addEventListener('click', ()=>{
    document.getElementById('rulesModal').classList.add('hidden');
  });

  document.getElementById('btnRestart').addEventListener('click', ()=>{
    gameScreen.classList.add('hidden');
    startScreen.classList.remove('hidden');
    sideChooser.classList.add('hidden');
  });

  document.getElementById('btnPlayAgain').addEventListener('click', ()=>{
    document.getElementById('winModal').classList.add('hidden');
    gameScreen.classList.add('hidden');
    startScreen.classList.remove('hidden');
    sideChooser.classList.add('hidden');
  });

})();
</script>
</body>
</html>
