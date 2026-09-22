/* ============================================================
   Retro Blaster — Share Flow + Challenge Mode
   Self-contained module. See docs/INTEGRATION.md for wiring.
   Implements issue #4 (share + ?c= challenge links) and the
   client hook for issue #5 (personal rank display).
   ============================================================ */
(function () {
  'use strict';

  var SHARE_BASE = 'https://retroblaster.tatinc.us';
  var CHALLENGE_KEY = 'rb_challenge';

  /* ---------- Challenge deep-link (?c=SCORE) ---------- */
  try {
    var c = new URLSearchParams(location.search).get('c');
    var target = parseInt(c, 10);
    if (target > 0) {
      try { localStorage.setItem(CHALLENGE_KEY, String(target)); } catch (e) {}
    }
  } catch (e) { /* bad URL state — ignore */ }

  function getChallengeScore() {
    try { return parseInt(localStorage.getItem(CHALLENGE_KEY) || '0', 10) || 0; }
    catch (e) { return 0; }
  }

  function clearChallenge() {
    try { localStorage.removeItem(CHALLENGE_KEY); } catch (e) {}
    var b = document.getElementById('challenge-banner');
    if (b) b.remove();
  }

  function renderChallengeBanner() {
    var target = getChallengeScore();
    if (!target) return;
    var b = document.getElementById('challenge-banner');
    if (!b) {
      b = document.createElement('div');
      b.id = 'challenge-banner';
      document.body.appendChild(b);
    }
    b.textContent = '⚡ CHALLENGER MODE — BEAT ' + target.toLocaleString();
    b.style.cssText =
      'position:fixed;top:0;left:0;right:0;z-index:9999;text-align:center;' +
      'padding:8px;background:#ffd23f;color:#0a0a12;' +
      'font:700 14px monospace;letter-spacing:1px';
  }

  /* ---------- Toast ---------- */
  function toast(msg, ms) {
    var t = document.createElement('div');
    t.textContent = msg;
    t.style.cssText =
      'position:fixed;bottom:24px;left:50%;transform:translateX(-50%);' +
      'background:#0a0a12;color:#fff;padding:10px 16px;border-radius:6px;' +
      'z-index:9999;font:600 13px monospace;white-space:pre-wrap;' +
      'max-width:90vw;text-align:center';
    document.body.appendChild(t);
    setTimeout(function () { t.remove(); }, ms || 2600);
  }

  /* ---------- Share text (spoiler-free emoji score line) ---------- */
  function buildShareText(score, wave) {
    var filled = Math.min(10, Math.max(1, Math.round(wave / 1.5)));
    var bars = '';
    for (var i = 0; i < filled; i++) bars += '▮';
    for (var j = filled; j < 10; j++) bars += '▯';
    return '🚀 RETRO BLASTER — ' + score.toLocaleString() + ' PTS — WAVE ' +
      wave + ' ' + bars + '\nThink you can beat me?';
  }

  /* ---------- Share (Web Share API + clipboard fallback) ---------- */
  async function shareScore(score, wave) {
    var url = SHARE_BASE + '/?c=' + score;
    var text = buildShareText(score, wave);
    if (navigator.share) {
      try {
        await navigator.share({ title: 'Retro Blaster', text: text, url: url });
        return;
      } catch (e) {
        if (e && e.name === 'AbortError') return; /* user closed the sheet */
        /* other failures fall through to clipboard */
      }
    }
    var full = text + '\n' + url;
    try {
      await navigator.clipboard.writeText(full);
      toast('Score copied — paste it anywhere! ⚡');
    } catch (e) {
      toast(full); /* last resort: show it for manual copy */
    }
  }

  /* ---------- Injected share button (no styling dependencies) ---------- */
  var shareBtn = null;
  function showShareButton(score, wave) {
    if (!shareBtn) {
      shareBtn = document.createElement('button');
      shareBtn.id = 'rb-share-btn';
      shareBtn.style.cssText =
        'position:fixed;bottom:20px;left:50%;transform:translateX(-50%);' +
        'background:#ffd23f;color:#0a0a12;border:none;border-radius:8px;' +
        'padding:14px 22px;font:700 16px monospace;letter-spacing:1px;' +
        'cursor:pointer;z-index:9998;box-shadow:0 4px 14px rgba(0,0,0,.35)';
      document.body.appendChild(shareBtn);
    }
    shareBtn.style.display = 'block';
    shareBtn.textContent = '⚡ BEAT ' + score.toLocaleString() + ' — SHARE';
    shareBtn.onclick = function () { shareScore(score, wave); };
  }

  /* ---------- Game-over hook ---------- */
  function onGameOver(score, wave) {
    var challenge = getChallengeScore();
    if (challenge > 0 && score > challenge) {
      clearChallenge();
      toast('⚡ CHALLENGE BEAT — ' + score.toLocaleString() + '! Share your revenge.', 4000);
    }
    showShareButton(score, wave);
  }

  /* ---------- Public API ---------- */
  window.RBShare = {
    shareScore: shareScore,
    onGameOver: onGameOver,
    toast: toast,
    getChallengeScore: getChallengeScore,
    clearChallenge: clearChallenge
  };

  /* ---------- Auto-wiring (defensive — see INTEGRATION.md) ----------
     1. Shows the challenger banner if a ?c= link landed here.
     2. Listens for a manual signal:
        window.dispatchEvent(new CustomEvent('rb:gameover',
          { detail: { score: S, wave: W } }))
     3. If the game exposes a global postScore(name), wraps it so the
        share flow fires on score submission. Verify this fires once on
        a real game over; if it double-fires or never fires, use the
        explicit RBShare.onGameOver(score, wave) call instead. */
  function wire() {
    renderChallengeBanner();

    window.addEventListener('rb:gameover', function (e) {
      var d = (e && e.detail) || {};
      onGameOver(d.score || 0, d.wave || 0);
    });

    if (typeof window.postScore === 'function' && !window.postScore.__rbWrapped) {
      var orig = window.postScore;
      window.postScore = function (name) {
        try {
          onGameOver(
            (typeof score !== 'undefined') ? score : 0,
            (typeof wave !== 'undefined') ? wave : 0
          );
        } catch (e) { /* never break the real submission */ }
        return orig.apply(this, arguments);
      };
      window.postScore.__rbWrapped = true;
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', wire);
  } else {
    wire();
  }
})();
