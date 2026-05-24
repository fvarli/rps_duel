// Concept 2 — Competitive Arena
// Energy through typography and contrast. The duel takes the whole screen
// — winner half flooded with accent, loser half pushed back, a bold stamp
// lands across the middle. Score is reduced to a single inline chip.
//
// Full screen inventory: onboarding, idle, anticipation, win/lose/tie
// reveals, history, empty history, settings, reset.

const C2 = {
  bg: '#0c1117',
  bg2: '#111927',
  surface: '#161e2a',
  hairline: '#1f2a3a',
  hairlineSoft: 'rgba(255,255,255,0.06)',
  ink: '#f0f4fa',
  inkSoft: '#aab7c8',
  inkMuted: '#6b7a8e',
  inkDim: '#3d4a5e',
  accent: '#ff6b35',
  accentDim: 'rgba(255,107,53,0.18)',
  win: '#4ade80',
  loss: '#f87171',
  tie: '#94a3b8',
};

const c2Font = '"Space Grotesk", system-ui, sans-serif';
const c2Mono = '"JetBrains Mono", "SF Mono", ui-monospace, monospace';

function C2Header({ you = 3, cpu = 2, ties = 1, streak = 3, leading = 'menu', trailing = 'history', title }) {
  const Lead = () => (
    leading === 'back'
      ? <svg width="20" height="16" viewBox="0 0 20 16" fill="none" stroke={C2.ink} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M9 2L2 8l7 6M2 8h16"/></svg>
      : <svg width="22" height="14" viewBox="0 0 22 14" fill="none" stroke={C2.ink} strokeWidth="1.8" strokeLinecap="round"><path d="M2 3h18M2 11h14"/></svg>
  );
  const Trail = () => {
    if (trailing === 'settings') return <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke={C2.ink} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="9" cy="9" r="2.4"/><path d="M9 1.5v2M9 14.5v2M3.5 3.5l1.4 1.4M13.1 13.1l1.4 1.4M1.5 9h2M14.5 9h2M3.5 14.5l1.4-1.4M13.1 4.9l1.4-1.4"/></svg>;
    if (trailing === 'history') return (
      <div style={{ display: 'flex', alignItems: 'center', gap: 4, padding: '4px 8px', background: C2.accentDim, borderRadius: 4 }}>
        <span style={{ fontSize: 11 }}>🔥</span>
        <div style={{ fontFamily: c2Mono, fontSize: 11, fontWeight: 700, color: C2.accent, letterSpacing: 0.4 }}>W{streak}</div>
      </div>
    );
    return null;
  };
  return (
    <div style={{ height: 52, padding: '0 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flex: '0 0 auto', position: 'relative', zIndex: 3 }}>
      <Lead />
      {title ? (
        <div style={{ fontFamily: c2Font, fontSize: 13.5, fontWeight: 700, letterSpacing: 1.4, textTransform: 'uppercase', color: C2.ink }}>{title}</div>
      ) : (
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, fontFamily: c2Mono }}>
          <span style={{ fontSize: 16, fontWeight: 700, color: C2.ink, fontVariantNumeric: 'tabular-nums' }}>{String(you).padStart(2, '0')}</span>
          <span style={{ fontSize: 11, color: C2.inkDim }}>—</span>
          <span style={{ fontSize: 16, fontWeight: 700, color: C2.ink, fontVariantNumeric: 'tabular-nums' }}>{String(cpu).padStart(2, '0')}</span>
          <span style={{ fontSize: 10, color: C2.inkMuted, marginLeft: 4, letterSpacing: 1.2 }}>T{ties}</span>
        </div>
      )}
      <Trail />
    </div>
  );
}

// Big icon + label half-screen panel.
function C2DuelHalf({ who, kind, state, side = 'left' }) {
  const isWin = state === 'win';
  const isLoss = state === 'loss';
  const isTie = state === 'tie';
  const isLocked = state === 'locked';
  const isWaiting = state === 'waiting';
  const isIdle = state === 'idle';

  const bg = isWin ? C2.accent : isLocked ? C2.surface : isTie ? C2.surface : 'transparent';
  const iconColor = isWin ? C2.bg : isLoss ? C2.inkDim : isTie ? C2.inkSoft : isLocked ? C2.accent : C2.ink;
  const whoColor = isWin ? C2.bg : isLoss ? C2.inkDim : C2.inkMuted;
  const nameColor = isWin ? C2.bg : isLoss ? C2.inkDim : C2.ink;

  const hash = isWin && (
    <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', opacity: 0.16, pointerEvents: 'none' }} aria-hidden>
      <defs>
        <pattern id={`c2hash-${side}`} width="14" height="14" patternUnits="userSpaceOnUse" patternTransform="rotate(-22)">
          <line x1="0" y1="0" x2="0" y2="14" stroke="#0c1117" strokeWidth="1.2" />
        </pattern>
      </defs>
      <rect width="100%" height="100%" fill={`url(#c2hash-${side})`} />
    </svg>
  );

  return (
    <div style={{
      flex: 1, position: 'relative', background: bg,
      borderRight: side === 'left' ? `1px solid ${C2.hairline}` : 'none',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      padding: '32px 16px', gap: 18, overflow: 'hidden',
    }}>
      {hash}
      <div style={{ position: 'relative', zIndex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 18 }}>
        <div style={{ fontFamily: c2Mono, fontSize: 10, letterSpacing: 2, textTransform: 'uppercase', color: whoColor, fontWeight: 700 }}>
          {who}{isLocked ? ' · locked' : ''}
        </div>
        <div style={{ width: 96, height: 96, display: 'flex', alignItems: 'center', justifyContent: 'center', position: 'relative' }}>
          {isWaiting || isIdle ? (
            <div style={{ display: 'flex', gap: 8 }}>
              {[0,1,2].map(i => <div key={i} style={{ width: 12, height: 12, borderRadius: 6, background: C2.inkMuted, opacity: 0.4 + i * 0.25 }} />)}
            </div>
          ) : kind ? (
            isLocked
              ? <RPSIcon kind={kind} size={86} color={glyphColorLocked(iconColor)} variant="outline" strokeWidth={3} />
              : <RPSIcon kind={kind} size={88} color={iconColor} variant="solid" />
          ) : null}
        </div>
        <div style={{ fontFamily: c2Font, fontSize: 18, fontWeight: 700, letterSpacing: 0.6, textTransform: 'uppercase', color: nameColor }}>
          {isWaiting ? '???' : isIdle ? '—' : kind ? RPS_NAME[kind] : ''}
        </div>
      </div>
    </div>
  );
}
function glyphColorLocked(c) { return c; } // keep palette local; alias for clarity

// Stamp across the middle of the screen at reveal.
function C2Stamp({ kind = 'won' }) {
  const cfg = {
    won: { text: 'Round Won', tint: C2.accent, sub: '+1 your score' },
    lost: { text: 'Round Lost', tint: C2.loss, sub: '+1 cpu score' },
    tie: { text: 'Tie Round', tint: C2.tie, sub: 'no score change' },
    wait: { text: 'CPU thinking', tint: C2.inkMuted, sub: 'revealing in a moment' },
  }[kind];
  return (
    <div style={{
      position: 'absolute', left: 0, right: 0, top: '50%', transform: 'translateY(-50%)',
      pointerEvents: 'none', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6,
    }}>
      <div style={{
        background: cfg.tint, color: C2.bg, padding: '14px 28px',
        fontFamily: c2Font, fontSize: 30, fontWeight: 800, letterSpacing: -0.6, textTransform: 'uppercase',
        clipPath: 'polygon(14px 0, 100% 0, calc(100% - 14px) 100%, 0 100%)',
        boxShadow: '0 12px 30px rgba(0,0,0,0.4)',
      }}>{cfg.text}</div>
      <div style={{ fontFamily: c2Mono, fontSize: 10.5, fontWeight: 700, letterSpacing: 2, textTransform: 'uppercase', color: cfg.tint, background: 'rgba(12,17,23,0.85)', padding: '4px 10px', borderRadius: 2 }}>{cfg.sub}</div>
    </div>
  );
}

function C2ActionRow({ lastPlayed, locked = false, hint }) {
  const Btn = ({ kind, idx }) => {
    const isLast = kind === lastPlayed;
    const lockedAndPicked = locked && isLast;
    const dim = locked && !isLast;
    return (
      <div style={{
        flex: 1,
        background: lockedAndPicked ? C2.accent : C2.surface,
        border: `1px solid ${lockedAndPicked ? C2.accent : C2.hairline}`,
        padding: '16px 8px 14px',
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8,
        opacity: dim ? 0.35 : 1,
        clipPath: 'polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px)',
        position: 'relative',
      }}>
        <div style={{ position: 'absolute', top: 8, left: 10, fontFamily: c2Mono, fontSize: 9, color: lockedAndPicked ? C2.bg : C2.inkMuted, fontWeight: 700 }}>0{idx}</div>
        <RPSIcon kind={kind} size={30} color={lockedAndPicked ? C2.bg : C2.ink} variant="solid" />
        <div style={{ fontFamily: c2Font, fontSize: 12, fontWeight: 700, letterSpacing: 1.4, textTransform: 'uppercase', color: lockedAndPicked ? C2.bg : C2.ink }}>{RPS_NAME[kind]}</div>
      </div>
    );
  };
  return (
    <div style={{ padding: '16px 14px 8px', borderTop: `1px solid ${C2.hairline}`, background: C2.bg }}>
      <div style={{ display: 'flex', gap: 8 }}>
        <Btn kind="rock" idx={1} /><Btn kind="paper" idx={2} /><Btn kind="scissors" idx={3} />
      </div>
      <div style={{ textAlign: 'center', marginTop: 12, fontFamily: c2Mono, fontSize: 10.5, fontWeight: 700, letterSpacing: 1.8, textTransform: 'uppercase', color: locked ? C2.inkMuted : C2.accent }}>
        {hint || '▌ Tap any to play next round'}
      </div>
    </div>
  );
}

// ─── Idle ───
function C2Idle() {
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink, background: `radial-gradient(140% 50% at 50% 0%, ${C2.bg2} 0%, ${C2.bg} 60%)` }}>
        <C2Header you={3} cpu={2} ties={1} streak={3} />
        <div style={{ flex: 1, position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 24px', gap: 24, textAlign: 'center' }}>
          <div style={{ fontFamily: c2Mono, fontSize: 10.5, color: C2.accent, letterSpacing: 2, textTransform: 'uppercase', fontWeight: 700 }}>Round 09</div>
          <div style={{ fontFamily: c2Font, fontSize: 56, fontWeight: 800, color: C2.ink, letterSpacing: -1.5, lineHeight: 0.95, textTransform: 'uppercase' }}>
            Make<br/>your<br/>move
          </div>
          <div style={{ display: 'flex', gap: 16, opacity: 0.5 }}>
            <RPSIcon kind="rock" size={36} color={C2.inkSoft} variant="solid" />
            <RPSIcon kind="paper" size={36} color={C2.inkSoft} variant="solid" />
            <RPSIcon kind="scissors" size={36} color={C2.inkSoft} variant="solid" />
          </div>
        </div>
        <C2ActionRow hint="▌ Tap any to commit" />
      </div>
    </PhoneShell>
  );
}

// ─── Reveal ───
function C2Reveal({ result = 'win', you = 'paper', cpu = 'rock', score = { you: 3, cpu: 2, ties: 1 } }) {
  const youState = result === 'win' ? 'win' : result === 'loss' ? 'loss' : 'tie';
  const cpuState = result === 'loss' ? 'win' : result === 'win' ? 'loss' : 'tie';
  const stampKind = result === 'win' ? 'won' : result === 'loss' ? 'lost' : 'tie';
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink, background: `radial-gradient(140% 50% at 50% 0%, ${C2.bg2} 0%, ${C2.bg} 60%)` }}>
        <C2Header {...score} streak={result === 'win' ? 3 : 0} />
        <div style={{ flex: 1, position: 'relative', display: 'flex' }}>
          <C2DuelHalf who="You" kind={you} state={youState} side="left" />
          <C2DuelHalf who="CPU" kind={cpu} state={cpuState} side="right" />
          <C2Stamp kind={stampKind} />
        </div>
        <C2ActionRow lastPlayed={you} />
      </div>
    </PhoneShell>
  );
}

const C2Gameplay = () => <C2Reveal result="win" you="paper" cpu="rock" score={{ you: 3, cpu: 2, ties: 1 }} />;
const C2LoseReveal = () => <C2Reveal result="loss" you="scissors" cpu="rock" score={{ you: 3, cpu: 3, ties: 1 }} />;
const C2TieReveal = () => <C2Reveal result="tie" you="paper" cpu="paper" score={{ you: 3, cpu: 2, ties: 2 }} />;

// ─── Anticipation ───
function C2Anticipation() {
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink, background: `radial-gradient(140% 50% at 50% 0%, ${C2.bg2} 0%, ${C2.bg} 60%)` }}>
        <C2Header you={3} cpu={2} ties={1} streak={3} />
        <div style={{ flex: 1, position: 'relative', display: 'flex' }}>
          <C2DuelHalf who="You" kind="paper" state="locked" side="left" />
          <C2DuelHalf who="CPU" state="waiting" side="right" />
          <C2Stamp kind="wait" />
        </div>
        <C2ActionRow lastPlayed="paper" locked hint="▌ Locked · CPU choosing" />
      </div>
    </PhoneShell>
  );
}

// ─── History ───
function C2HistoryRow({ n, you, cpu, result, time }) {
  const cfg = { win: { c: C2.win, t: 'W' }, loss: { c: C2.loss, t: 'L' }, tie: { c: C2.tie, t: 'T' } }[result];
  return (
    <div style={{ padding: '14px 20px', display: 'flex', alignItems: 'center', gap: 12, borderBottom: `1px solid ${C2.hairline}` }}>
      <div style={{ width: 24, height: 24, borderRadius: 4, background: cfg.c, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: c2Mono, fontSize: 12, fontWeight: 700, color: C2.bg }}>{cfg.t}</div>
      <div style={{ fontFamily: c2Mono, fontSize: 12, color: C2.inkMuted, width: 24, fontVariantNumeric: 'tabular-nums' }}>{String(n).padStart(2, '0')}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, flex: 1 }}>
        <RPSIcon kind={you.toLowerCase()} size={20} color={C2.ink} variant="solid" />
        <span style={{ fontFamily: c2Font, fontSize: 13, fontWeight: 500, color: C2.ink }}>{you}</span>
        <span style={{ fontFamily: c2Mono, fontSize: 11, color: C2.inkDim }}>vs</span>
        <RPSIcon kind={cpu.toLowerCase()} size={20} color={C2.inkSoft} variant="solid" />
        <span style={{ fontFamily: c2Font, fontSize: 13, fontWeight: 500, color: C2.inkSoft }}>{cpu}</span>
      </div>
      <div style={{ fontFamily: c2Mono, fontSize: 11, color: C2.inkMuted }}>{time}</div>
    </div>
  );
}

function C2History() {
  const rows = [
    { n: 13, you: 'Paper', cpu: 'Rock', result: 'win', time: '2:14' },
    { n: 12, you: 'Scissors', cpu: 'Rock', result: 'loss', time: '2:13' },
    { n: 11, you: 'Rock', cpu: 'Rock', result: 'tie', time: '2:13' },
    { n: 10, you: 'Scissors', cpu: 'Paper', result: 'win', time: '2:12' },
    { n: 9, you: 'Rock', cpu: 'Scissors', result: 'win', time: '2:11' },
    { n: 8, you: 'Paper', cpu: 'Rock', result: 'win', time: '2:10' },
    { n: 7, you: 'Rock', cpu: 'Paper', result: 'loss', time: '2:09' },
    { n: 6, you: 'Scissors', cpu: 'Paper', result: 'win', time: '2:08' },
  ];
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink }}>
        <C2Header leading="back" title="Match History" you={3} cpu={2} ties={1} streak={3} />
        <div style={{ padding: '14px 20px 16px', display: 'flex', alignItems: 'baseline', gap: 12, borderBottom: `1px solid ${C2.hairline}` }}>
          <div style={{ fontFamily: c2Font, fontSize: 28, fontWeight: 700, color: C2.ink, letterSpacing: -0.6 }}>13 rounds</div>
          <div style={{ fontFamily: c2Mono, fontSize: 11.5, color: C2.inkMuted, letterSpacing: 0.6 }}>· <span style={{ color: C2.win, fontWeight: 700 }}>7W</span> · <span style={{ color: C2.loss, fontWeight: 700 }}>4L</span> · <span style={{ color: C2.tie, fontWeight: 700 }}>2T</span></div>
        </div>
        <div style={{ background: C2.bg2, flex: 1, overflow: 'hidden' }}>
          {rows.map((r) => <C2HistoryRow key={r.n} {...r} />)}
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Empty history ───
function C2EmptyHistory() {
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink, background: `radial-gradient(140% 50% at 50% 0%, ${C2.bg2} 0%, ${C2.bg} 60%)` }}>
        <C2Header leading="back" title="Match History" />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px', textAlign: 'center', gap: 22 }}>
          <div style={{ display: 'flex', gap: 22, opacity: 0.32 }}>
            <RPSIcon kind="rock" size={42} color={C2.inkMuted} variant="outline" strokeWidth={2} />
            <RPSIcon kind="paper" size={42} color={C2.inkMuted} variant="outline" strokeWidth={2} />
            <RPSIcon kind="scissors" size={42} color={C2.inkMuted} variant="outline" strokeWidth={2} />
          </div>
          <div style={{ fontFamily: c2Font, fontSize: 32, fontWeight: 800, letterSpacing: -0.6, lineHeight: 1, textTransform: 'uppercase' }}>No matches<br/>yet</div>
          <div style={{ fontFamily: c2Mono, fontSize: 11.5, color: C2.inkSoft, lineHeight: 1.6, maxWidth: 260, letterSpacing: 0.3 }}>
            Play your first round and we'll start tracking your run.
          </div>
          <button style={{
            marginTop: 8, height: 48, padding: '0 24px',
            background: C2.accent, color: C2.bg, border: 'none',
            fontFamily: c2Font, fontSize: 12, fontWeight: 700, letterSpacing: 1.4, textTransform: 'uppercase', cursor: 'pointer',
            clipPath: 'polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px)',
          }}>▌ Play a round</button>
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Settings ───
function C2Toggle({ on = true }) {
  return (
    <div style={{ width: 38, height: 22, borderRadius: 11, background: on ? C2.accent : C2.hairline, position: 'relative' }}>
      <div style={{ position: 'absolute', top: 2, left: on ? 18 : 2, width: 18, height: 18, borderRadius: 9, background: C2.ink, boxShadow: '0 1px 3px rgba(0,0,0,0.4)' }} />
    </div>
  );
}
function C2SegRow({ value, options = ['fast', 'normal', 'slow'] }) {
  return (
    <div style={{ display: 'inline-flex', padding: 2, background: C2.bg, border: `1px solid ${C2.hairline}` }}>
      {options.map(o => (
        <div key={o} style={{
          padding: '4px 10px', fontFamily: c2Mono, fontSize: 10.5, fontWeight: 700, letterSpacing: 1.2, textTransform: 'uppercase',
          color: o === value ? C2.bg : C2.inkSoft, background: o === value ? C2.accent : 'transparent',
        }}>{o}</div>
      ))}
    </div>
  );
}
function C2SettingRow({ label, sub, control, danger = false, divider = true }) {
  return (
    <div style={{ padding: '16px 20px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: divider ? `1px solid ${C2.hairline}` : 'none' }}>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c2Font, fontSize: 13, fontWeight: 700, color: danger ? C2.loss : C2.ink, letterSpacing: 0.6, textTransform: 'uppercase' }}>{label}</div>
        {sub && <div style={{ marginTop: 3, fontFamily: c2Mono, fontSize: 11, color: C2.inkMuted, letterSpacing: 0.3 }}>{sub}</div>}
      </div>
      {control}
    </div>
  );
}
function C2Settings() {
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink }}>
        <C2Header leading="back" title="Settings" />
        <div style={{ padding: '18px 20px 16px', borderBottom: `1px solid ${C2.hairline}` }}>
          <div style={{ fontFamily: c2Mono, fontSize: 10, color: C2.accent, letterSpacing: 2, textTransform: 'uppercase' }}>// Tune the arena</div>
        </div>
        <div style={{ background: C2.bg2, flex: 1, overflow: 'hidden' }}>
          <div style={{ padding: '12px 20px 4px', fontFamily: c2Mono, fontSize: 10, color: C2.inkMuted, letterSpacing: 1.6, textTransform: 'uppercase' }}>Feel</div>
          <C2SettingRow label="Sound FX" sub="reveal · stamp · click" control={<C2Toggle on />} />
          <C2SettingRow label="Haptics" sub="commit · lock · reveal" control={<C2Toggle on />} />
          <C2SettingRow label="Reveal speed" sub="cpu thinking time" control={<C2SegRow value="normal" />} />
          <div style={{ padding: '12px 20px 4px', fontFamily: c2Mono, fontSize: 10, color: C2.inkMuted, letterSpacing: 1.6, textTransform: 'uppercase' }}>Data</div>
          <C2SettingRow label="Reset match" sub="zeroes score & history" control={<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke={C2.loss} strokeWidth="1.6" strokeLinecap="round"><path d="M4 2l4 4-4 4"/></svg>} danger />
          <C2SettingRow label="About" sub="v1.0.0 · build 24" divider={false} control={<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke={C2.inkMuted} strokeWidth="1.6" strokeLinecap="round"><path d="M4 2l4 4-4 4"/></svg>} />
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Onboarding ───
function C2Onboarding() {
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c2Font, color: C2.ink, background: `radial-gradient(140% 50% at 50% 0%, ${C2.bg2} 0%, ${C2.bg} 60%)` }}>
        <div style={{ height: 52 }} />
        <div style={{ flex: 1, padding: '8px 24px 0', display: 'flex', flexDirection: 'column' }}>
          <div style={{ fontFamily: c2Mono, fontSize: 11, color: C2.accent, letterSpacing: 2.4, textTransform: 'uppercase', fontWeight: 700 }}>▌ Welcome</div>
          <div style={{ fontFamily: c2Font, fontSize: 56, fontWeight: 800, lineHeight: 0.92, letterSpacing: -1.5, marginTop: 14, textTransform: 'uppercase' }}>
            Pick.<br/>Lock.<br/><span style={{ color: C2.accent }}>Win.</span>
          </div>
          <div style={{ marginTop: 18, fontFamily: c2Mono, fontSize: 12, color: C2.inkSoft, lineHeight: 1.65, letterSpacing: 0.3, maxWidth: 290 }}>
            Rock, paper, or scissors. CPU picks at the same time. Whoever wins, wins loud. Bring a streak.
          </div>
          <div style={{ marginTop: 36, display: 'flex', flexDirection: 'column', gap: 0 }}>
            {[
              ['rock', 'Scissors', '01'],
              ['paper', 'Rock', '02'],
              ['scissors', 'Paper', '03'],
            ].map(([k, b, n]) => (
              <div key={k} style={{ padding: '14px 0', display: 'flex', alignItems: 'center', gap: 18, borderBottom: `1px solid ${C2.hairline}` }}>
                <RPSIcon kind={k} size={32} color={C2.ink} variant="solid" />
                <div style={{ fontFamily: c2Font, fontSize: 16, fontWeight: 700, letterSpacing: 0.6, textTransform: 'uppercase' }}>{RPS_NAME[k]}</div>
                <div style={{ flex: 1, fontFamily: c2Mono, fontSize: 11, color: C2.inkMuted, letterSpacing: 1.2, textTransform: 'uppercase' }}>beats {b}</div>
                <div style={{ fontFamily: c2Mono, fontSize: 11, color: C2.accent }}>{n}</div>
              </div>
            ))}
          </div>
          <div style={{ flex: 1 }} />
          <div style={{ paddingBottom: 22 }}>
            <button style={{
              width: '100%', height: 54, background: C2.accent, color: C2.bg, border: 'none',
              fontFamily: c2Font, fontSize: 14, fontWeight: 800, letterSpacing: 1.6, textTransform: 'uppercase', cursor: 'pointer',
              clipPath: 'polygon(12px 0, 100% 0, 100% calc(100% - 12px), calc(100% - 12px) 100%, 0 100%, 0 12px)',
            }}>▌ Enter the arena</button>
          </div>
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Reset ───
function C2Reset() {
  return (
    <PhoneShell bg={C2.bg} statusBarTint={C2.ink}>
      <div style={{ width: '100%', height: '100%', position: 'relative', fontFamily: c2Font, color: C2.ink }}>
        <div style={{ position: 'absolute', inset: 0, opacity: 0.28, filter: 'blur(1px)' }}>
          <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column' }}>
            <C2Header you={3} cpu={2} ties={1} streak={3} />
            <div style={{ flex: 1, position: 'relative', display: 'flex' }}>
              <C2DuelHalf who="You" kind="paper" state="win" side="left" />
              <C2DuelHalf who="CPU" kind="rock" state="loss" side="right" />
            </div>
          </div>
        </div>
        <div style={{ position: 'absolute', inset: 0, background: 'rgba(6,9,14,0.65)', backdropFilter: 'blur(2px)' }} />
        <div style={{
          position: 'absolute', left: 16, right: 16, top: '50%', transform: 'translateY(-50%)',
          background: C2.surface, border: `1px solid ${C2.hairline}`, overflow: 'hidden',
        }}>
          <div style={{ height: 4, background: C2.loss }} />
          <div style={{ padding: '22px 22px 24px' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 14 }}>
              <div style={{ width: 28, height: 28, borderRadius: 6, background: 'rgba(248,113,113,0.18)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C2.loss} strokeWidth="1.8" strokeLinecap="round"><path d="M7 4v3M7 10v.01"/><circle cx="7" cy="7" r="6"/></svg>
              </div>
              <div style={{ fontFamily: c2Mono, fontSize: 11, fontWeight: 700, letterSpacing: 1.4, textTransform: 'uppercase', color: C2.loss }}>Reset Match</div>
            </div>
            <div style={{ fontFamily: c2Font, fontSize: 28, fontWeight: 700, letterSpacing: -0.6, lineHeight: 1.1, marginBottom: 12 }}>Clear score and history?</div>
            <div style={{ fontFamily: c2Font, fontSize: 14, lineHeight: 1.55, color: C2.inkSoft }}>
              You'll lose your <strong style={{ color: C2.accent, fontFamily: c2Mono }}>W3</strong> streak, the <strong style={{ color: C2.ink, fontFamily: c2Mono }}>3 — 2</strong> score, and 13 rounds of history.
            </div>
            <div style={{ marginTop: 22, display: 'flex', flexDirection: 'column', gap: 10 }}>
              <button style={{
                height: 52, background: C2.loss, color: C2.bg, border: 'none',
                fontFamily: c2Font, fontSize: 13.5, fontWeight: 700, letterSpacing: 1.4, textTransform: 'uppercase', cursor: 'pointer',
                clipPath: 'polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px)',
              }}>Yes — reset match</button>
              <button style={{
                height: 46, background: 'transparent', color: C2.inkSoft, border: `1px solid ${C2.hairline}`,
                fontFamily: c2Font, fontSize: 13, fontWeight: 600, letterSpacing: 1.2, textTransform: 'uppercase', cursor: 'pointer',
              }}>Keep playing</button>
            </div>
          </div>
        </div>
      </div>
    </PhoneShell>
  );
}

Object.assign(window, {
  C2Onboarding, C2Idle, C2Anticipation,
  C2Gameplay, C2Reveal, C2LoseReveal, C2TieReveal,
  C2History, C2EmptyHistory, C2Settings, C2Reset,
});
