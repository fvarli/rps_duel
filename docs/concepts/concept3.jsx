// Concept 3 — Modern Futuristic
// The HUD ring IS the duel — both players' choices land inside it and the
// verdict glows in the centre. Score reduced to a tiny inline chip.
//
// Full screen inventory: onboarding, idle, anticipation, win/lose/tie
// reveals, history, empty history, settings, reset.

const C3 = {
  bg: '#060912',
  bg2: '#0a1326',
  surface: 'rgba(125,249,255,0.05)',
  hairline: 'rgba(125,249,255,0.18)',
  hairlineSoft: 'rgba(125,249,255,0.08)',
  ink: '#f6fbff',
  inkSoft: 'rgba(232,246,255,0.82)',
  inkMuted: 'rgba(232,246,255,0.58)',
  cyan: '#7df9ff',
  cyanDim: 'rgba(125,249,255,0.32)',
  magenta: '#ff5fb4',
  magentaDim: 'rgba(255,95,180,0.3)',
  win: '#7df9ff',
  loss: '#ff5fb4',
  tie: 'rgba(232,246,255,0.5)',
};

const c3Font = '"Space Grotesk", system-ui, sans-serif';
const c3Mono = '"Space Mono", "JetBrains Mono", ui-monospace, monospace';

function C3GridBg() {
  return (
    <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', pointerEvents: 'none' }} aria-hidden>
      <defs>
        <pattern id="c3grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <circle cx="0.5" cy="0.5" r="0.5" fill="rgba(125,249,255,0.16)" />
        </pattern>
        <radialGradient id="c3glow" cx="50%" cy="42%" r="62%">
          <stop offset="0%" stopColor="rgba(125,249,255,0.18)" />
          <stop offset="55%" stopColor="rgba(125,249,255,0.04)" />
          <stop offset="100%" stopColor="rgba(125,249,255,0)" />
        </radialGradient>
      </defs>
      <rect width="100%" height="100%" fill="url(#c3grid)" />
      <rect width="100%" height="100%" fill="url(#c3glow)" />
    </svg>
  );
}

function C3Header({ you = 3, cpu = 2, ties = 1, leading = 'menu', trailing = 'live', title }) {
  const Lead = () => (
    leading === 'back'
      ? <div style={{ width: 30, height: 30, border: `1px solid ${C3.hairline}`, display: 'flex', alignItems: 'center', justifyContent: 'center', clipPath: 'polygon(6px 0, 100% 0, 100% calc(100% - 6px), calc(100% - 6px) 100%, 0 100%, 0 6px)' }}>
          <svg width="13" height="11" viewBox="0 0 13 11" fill="none" stroke={C3.cyan} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><path d="M6 1L1 5.5l5 4.5M1 5.5h11"/></svg>
        </div>
      : <div style={{ width: 30, height: 30, border: `1px solid ${C3.hairline}`, display: 'flex', alignItems: 'center', justifyContent: 'center', clipPath: 'polygon(6px 0, 100% 0, 100% calc(100% - 6px), calc(100% - 6px) 100%, 0 100%, 0 6px)' }}>
          <svg width="13" height="9" viewBox="0 0 13 9" fill="none" stroke={C3.cyan} strokeWidth="1.5" strokeLinecap="round"><path d="M1 2h11M1 7h7"/></svg>
        </div>
  );
  return (
    <div style={{ height: 50, padding: '0 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flex: '0 0 auto', position: 'relative', zIndex: 3 }}>
      <Lead />
      {title ? (
        <div style={{ fontFamily: c3Mono, fontSize: 11, letterSpacing: 2.4, color: C3.cyan, textTransform: 'uppercase' }}>{title}</div>
      ) : (
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, fontFamily: c3Mono }}>
          <span style={{ fontSize: 14, color: C3.cyan, textShadow: `0 0 8px ${C3.cyanDim}` }}>{String(you).padStart(2, '0')}</span>
          <span style={{ fontSize: 10, color: C3.inkMuted }}>—</span>
          <span style={{ fontSize: 14, color: C3.ink }}>{String(cpu).padStart(2, '0')}</span>
          <span style={{ fontSize: 9.5, color: C3.inkMuted, marginLeft: 2, letterSpacing: 1.2 }}>T{ties}</span>
        </div>
      )}
      {trailing === 'live' ? (
        <div style={{ display: 'flex', alignItems: 'center', gap: 5 }}>
          <div style={{ width: 6, height: 6, borderRadius: 3, background: C3.cyan, boxShadow: `0 0 6px ${C3.cyan}` }} />
          <div style={{ fontFamily: c3Mono, fontSize: 10, color: C3.inkSoft, letterSpacing: 1.4 }}>LIVE</div>
        </div>
      ) : <div style={{ width: 30 }} />}
    </div>
  );
}

// The big ring. state: 'idle' | 'locked' | 'win' | 'loss' | 'tie'
function C3Ring({ state = 'win', you, cpu }) {
  const size = 280;
  const r = size / 2 - 10;
  const c = size / 2;

  const cfg = {
    idle: { color: C3.cyan, verdict: 'AWAITING', sub: 'pick a move' },
    locked: { color: C3.cyan, verdict: 'STAND BY', sub: 'awaiting cpu' },
    win: { color: C3.cyan, verdict: 'VICTORY', sub: '+1 score' },
    loss: { color: C3.magenta, verdict: 'DEFEAT', sub: '+1 cpu' },
    tie: { color: C3.inkSoft, verdict: 'PARITY', sub: 'no change' },
  }[state];
  const winColor = cfg.color;
  const isLocked = state === 'locked';
  const isIdle = state === 'idle';

  const circ = 2 * Math.PI * r;
  const arcLen = isLocked || isIdle ? circ * 0.18 : circ * 0.78;
  const arcOff = isLocked || isIdle ? circ * 0.85 : circ * 0.2;

  const youColor = state === 'loss' ? C3.inkSoft : C3.cyan;
  const cpuColor = state === 'loss' ? C3.magenta : C3.inkSoft;
  const youBg = state === 'win' || state === 'locked' || state === 'tie' ? 'rgba(125,249,255,0.08)' : 'transparent';
  const cpuBg = state === 'loss' ? 'rgba(255,95,180,0.08)' : 'transparent';

  return (
    <div style={{ flex: 1, position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '8px 0' }}>
      <div style={{ position: 'relative', width: size, height: size }}>
        <svg width={size} height={size} style={{ position: 'absolute', inset: 0, filter: `drop-shadow(0 0 10px ${C3.cyanDim})` }}>
          <circle cx={c} cy={c} r={r} fill="none" stroke={C3.hairlineSoft} strokeWidth="1" />
          <circle cx={c} cy={c} r={r} fill="none" stroke={winColor} strokeWidth="2.4"
            strokeDasharray={`${arcLen} ${circ}`} strokeDashoffset={arcOff} strokeLinecap="round" />
          <circle cx={c} cy={c} r={r - 18} fill="none" stroke={C3.hairlineSoft} strokeWidth="0.8" strokeDasharray="2 4" />
          {Array.from({ length: 60 }).map((_, i) => {
            const a = (i / 60) * Math.PI * 2 - Math.PI / 2;
            const major = i % 5 === 0;
            const x1 = c + Math.cos(a) * (r - 6);
            const y1 = c + Math.sin(a) * (r - 6);
            const x2 = c + Math.cos(a) * (r - (major ? 14 : 10));
            const y2 = c + Math.sin(a) * (r - (major ? 14 : 10));
            return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} stroke={C3.hairline} strokeWidth={major ? 1 : 0.5} />;
          })}
        </svg>
        <div style={{ position: 'absolute', top: -4, left: '50%', transform: 'translateX(-50%)', fontFamily: c3Mono, fontSize: 9, color: C3.cyan, letterSpacing: 1.4, background: C3.bg, padding: '0 6px' }}>N · 12</div>
        <div style={{ position: 'absolute', bottom: -4, left: '50%', transform: 'translateX(-50%)', fontFamily: c3Mono, fontSize: 9, color: C3.inkMuted, letterSpacing: 1.4, background: C3.bg, padding: '0 6px' }}>S</div>

        <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 14 }}>
          <div style={{ fontFamily: c3Mono, fontSize: 10, color: C3.inkMuted, letterSpacing: 2.4, textTransform: 'uppercase' }}>Round 09</div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
              <div style={{
                width: 60, height: 60,
                border: `1px solid ${state === 'loss' ? C3.hairline : C3.cyan}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                background: youBg,
                boxShadow: youBg !== 'transparent' ? `0 0 16px ${C3.cyanDim}, inset 0 0 14px ${C3.cyanDim}` : 'none',
              }}>
                {you ? <RPSIcon kind={you} size={30} color={youColor} variant="outline" strokeWidth={1.7} /> : (
                  <div style={{ display: 'flex', gap: 4 }}>{[0,1,2].map(i => <div key={i} style={{ width: 5, height: 5, borderRadius: 3, background: C3.inkMuted, opacity: 0.4 + i * 0.25 }} />)}</div>
                )}
              </div>
              <div style={{ fontFamily: c3Mono, fontSize: 9, color: state === 'loss' ? C3.inkMuted : C3.cyan, letterSpacing: 1.6 }}>YOU</div>
            </div>
            <div style={{ fontFamily: c3Font, fontSize: 24, fontWeight: 700, color: winColor, letterSpacing: -0.4, textShadow: `0 0 16px ${winColor}99`, lineHeight: 1 }}>
              {cfg.verdict}
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
              <div style={{
                width: 60, height: 60,
                border: `1px solid ${state === 'win' || state === 'locked' || state === 'idle' || state === 'tie' ? C3.hairline : C3.magenta}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                background: cpuBg,
                boxShadow: cpuBg !== 'transparent' ? `0 0 16px ${C3.magentaDim}, inset 0 0 14px ${C3.magentaDim}` : 'none',
              }}>
                {cpu ? <RPSIcon kind={cpu} size={30} color={cpuColor} variant="outline" strokeWidth={1.7} /> : (
                  <div style={{ display: 'flex', gap: 4 }}>{[0,1,2].map(i => <div key={i} style={{ width: 5, height: 5, borderRadius: 3, background: C3.inkMuted, opacity: 0.4 + i * 0.25 }} />)}</div>
                )}
              </div>
              <div style={{ fontFamily: c3Mono, fontSize: 9, color: state === 'loss' ? C3.magenta : C3.inkMuted, letterSpacing: 1.6 }}>CPU</div>
            </div>
          </div>

          <div style={{ fontFamily: c3Mono, fontSize: 9.5, color: C3.inkMuted, letterSpacing: 1.8, textTransform: 'uppercase', marginTop: 2 }}>{cfg.sub}</div>
        </div>
      </div>
    </div>
  );
}

function C3ActionRow({ lastPlayed, locked = false, hint }) {
  const Btn = ({ kind, idx }) => {
    const isLast = kind === lastPlayed;
    const lockedAndPicked = locked && isLast;
    const dim = locked && !isLast;
    return (
      <div style={{
        flex: 1,
        padding: '14px 8px 12px',
        background: lockedAndPicked ? 'rgba(125,249,255,0.16)' : C3.surface,
        border: `1px solid ${lockedAndPicked ? C3.cyan : C3.hairline}`,
        boxShadow: lockedAndPicked ? `0 0 16px ${C3.cyanDim}, inset 0 0 14px rgba(125,249,255,0.08)` : 'none',
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8, position: 'relative',
        opacity: dim ? 0.32 : 1,
        clipPath: 'polygon(8px 0, 100% 0, 100% calc(100% - 8px), calc(100% - 8px) 100%, 0 100%, 0 8px)',
      }}>
        <div style={{ position: 'absolute', top: 7, left: 9, fontFamily: c3Mono, fontSize: 8.5, color: lockedAndPicked ? C3.cyan : C3.inkMuted, letterSpacing: 1.2 }}>0{idx}</div>
        <RPSIcon kind={kind} size={28} color={lockedAndPicked ? C3.cyan : C3.ink} variant="outline" strokeWidth={1.6} />
        <div style={{ fontFamily: c3Mono, fontSize: 10.5, fontWeight: 700, letterSpacing: 1.8, textTransform: 'uppercase', color: lockedAndPicked ? C3.cyan : C3.ink }}>{RPS_NAME[kind]}</div>
      </div>
    );
  };
  return (
    <div style={{ padding: '8px 16px 14px', flex: '0 0 auto', position: 'relative', zIndex: 2 }}>
      <div style={{ display: 'flex', gap: 8 }}>
        <Btn kind="rock" idx={1} /><Btn kind="paper" idx={2} /><Btn kind="scissors" idx={3} />
      </div>
      <div style={{ textAlign: 'center', marginTop: 12, fontFamily: c3Mono, fontSize: 10, color: locked ? C3.inkMuted : C3.cyan, letterSpacing: 1.8, textTransform: 'uppercase' }}>
        {hint || '▌ Tap any to commit next round'}
      </div>
    </div>
  );
}

const C3Frame = ({ children }) => (
  <PhoneShell bg={C3.bg} statusBarTint={C3.ink} homeTint={C3.cyan}>
    <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c3Font, color: C3.ink, position: 'relative', background: `linear-gradient(180deg, ${C3.bg2} 0%, ${C3.bg} 60%)` }}>
      <C3GridBg />
      <div style={{ position: 'relative', zIndex: 2, display: 'flex', flexDirection: 'column', height: '100%' }}>{children}</div>
    </div>
  </PhoneShell>
);

// ─── Idle ───
function C3Idle() {
  return (
    <C3Frame>
      <C3Header you={3} cpu={2} ties={1} />
      <C3Ring state="idle" />
      <C3ActionRow hint="▌ Pick a move to commit" />
    </C3Frame>
  );
}

// ─── Reveal ───
function C3Reveal({ result = 'win', you = 'paper', cpu = 'rock', score = { you: 3, cpu: 2, ties: 1 } }) {
  return (
    <C3Frame>
      <C3Header {...score} />
      <C3Ring state={result} you={you} cpu={cpu} />
      <C3ActionRow lastPlayed={you} />
    </C3Frame>
  );
}
const C3Gameplay = () => <C3Reveal result="win" />;
const C3LoseReveal = () => <C3Reveal result="loss" you="scissors" cpu="rock" score={{ you: 3, cpu: 3, ties: 1 }} />;
const C3TieReveal = () => <C3Reveal result="tie" you="paper" cpu="paper" score={{ you: 3, cpu: 2, ties: 2 }} />;

// ─── Anticipation ───
function C3Anticipation() {
  return (
    <C3Frame>
      <C3Header you={3} cpu={2} ties={1} />
      <C3Ring state="locked" you="paper" cpu={null} />
      <C3ActionRow lastPlayed="paper" locked hint="▌ Locked · cpu choosing" />
    </C3Frame>
  );
}

// ─── History ───
function C3LogRow({ n, you, cpu, result, time }) {
  const cfg = { win: { c: C3.cyan, t: 'WIN' }, loss: { c: C3.magenta, t: 'LOSS' }, tie: { c: C3.tie, t: 'TIE' } }[result];
  return (
    <div style={{ padding: '12px 18px', display: 'flex', alignItems: 'center', gap: 12, borderBottom: `1px solid ${C3.hairlineSoft}` }}>
      <div style={{ fontFamily: c3Mono, fontSize: 10, color: C3.inkMuted, width: 28, letterSpacing: 1.2 }}>{String(n).padStart(3, '0')}</div>
      <div style={{ fontFamily: c3Mono, fontSize: 10.5, color: C3.inkSoft, width: 42 }}>{time}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, flex: 1 }}>
        <RPSIcon kind={you.toLowerCase()} size={16} color={C3.cyan} variant="outline" strokeWidth={1.5} />
        <span style={{ fontFamily: c3Mono, fontSize: 10.5, color: C3.cyan, letterSpacing: 1.2, textTransform: 'uppercase' }}>{you}</span>
        <span style={{ fontFamily: c3Mono, fontSize: 9, color: C3.inkMuted, letterSpacing: 1.2 }}>vs</span>
        <RPSIcon kind={cpu.toLowerCase()} size={16} color={C3.inkSoft} variant="outline" strokeWidth={1.5} />
        <span style={{ fontFamily: c3Mono, fontSize: 10.5, color: C3.inkSoft, letterSpacing: 1.2, textTransform: 'uppercase' }}>{cpu}</span>
      </div>
      <div style={{ fontFamily: c3Mono, fontSize: 9.5, fontWeight: 700, color: cfg.c, letterSpacing: 1.6, padding: '2px 6px', border: `1px solid ${cfg.c}`, textShadow: `0 0 6px ${cfg.c}66` }}>{cfg.t}</div>
    </div>
  );
}

function C3History() {
  const rows = [
    { n: 13, you: 'Paper', cpu: 'Rock', result: 'win', time: '14:14' },
    { n: 12, you: 'Scissors', cpu: 'Rock', result: 'loss', time: '14:13' },
    { n: 11, you: 'Rock', cpu: 'Rock', result: 'tie', time: '14:13' },
    { n: 10, you: 'Scissors', cpu: 'Paper', result: 'win', time: '14:12' },
    { n: 9, you: 'Rock', cpu: 'Scissors', result: 'win', time: '14:11' },
    { n: 8, you: 'Paper', cpu: 'Rock', result: 'win', time: '14:10' },
    { n: 7, you: 'Rock', cpu: 'Paper', result: 'loss', time: '14:09' },
    { n: 6, you: 'Scissors', cpu: 'Paper', result: 'win', time: '14:08' },
    { n: 5, you: 'Paper', cpu: 'Scissors', result: 'loss', time: '14:07' },
  ];
  return (
    <C3Frame>
      <C3Header leading="back" title="▌ ROUND LOG" trailing={null} you={3} cpu={2} ties={1} />
      <div style={{ padding: '12px 18px 14px', display: 'flex', alignItems: 'baseline', gap: 10, borderBottom: `1px solid ${C3.hairline}` }}>
        <div style={{ fontFamily: c3Mono, fontSize: 22, color: C3.cyan, letterSpacing: 0, textShadow: `0 0 10px ${C3.cyanDim}` }}>13 rds</div>
        <div style={{ fontFamily: c3Mono, fontSize: 10.5, color: C3.inkSoft, letterSpacing: 1.2 }}>· <span style={{ color: C3.cyan }}>7W</span> · <span style={{ color: C3.magenta }}>4L</span> · <span style={{ color: C3.inkSoft }}>2T</span></div>
      </div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        {rows.map((r) => <C3LogRow key={r.n} {...r} />)}
      </div>
    </C3Frame>
  );
}

// ─── Empty history ───
function C3EmptyHistory() {
  return (
    <C3Frame>
      <C3Header leading="back" title="▌ ROUND LOG" trailing={null} />
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px', textAlign: 'center', gap: 22 }}>
        <div style={{ display: 'flex', gap: 22, opacity: 0.35 }}>
          <RPSIcon kind="rock" size={36} color={C3.inkMuted} variant="outline" strokeWidth={1.8} />
          <RPSIcon kind="paper" size={36} color={C3.inkMuted} variant="outline" strokeWidth={1.8} />
          <RPSIcon kind="scissors" size={36} color={C3.inkMuted} variant="outline" strokeWidth={1.8} />
        </div>
        <div style={{ fontFamily: c3Font, fontSize: 26, fontWeight: 700, letterSpacing: -0.5, color: C3.ink, textTransform: 'uppercase' }}>
          Archive empty
        </div>
        <div style={{ fontFamily: c3Mono, fontSize: 11, color: C3.inkSoft, lineHeight: 1.65, maxWidth: 260, letterSpacing: 0.3 }}>
          // No rounds logged. Commit a move to begin the transmission.
        </div>
        <button style={{
          marginTop: 8, height: 46, padding: '0 24px',
          background: 'transparent', color: C3.cyan, border: `1px solid ${C3.cyan}`,
          fontFamily: c3Mono, fontSize: 11.5, fontWeight: 600, letterSpacing: 2, textTransform: 'uppercase', cursor: 'pointer',
          clipPath: 'polygon(8px 0, 100% 0, 100% calc(100% - 8px), calc(100% - 8px) 100%, 0 100%, 0 8px)',
        }}>▌ Begin first round</button>
      </div>
    </C3Frame>
  );
}

// ─── Settings ───
function C3Toggle({ on = true }) {
  return (
    <div style={{ width: 38, height: 22, border: `1px solid ${on ? C3.cyan : C3.hairline}`, position: 'relative', background: on ? 'rgba(125,249,255,0.1)' : 'transparent', boxShadow: on ? `0 0 8px ${C3.cyanDim}` : 'none' }}>
      <div style={{ position: 'absolute', top: 1, left: on ? 18 : 1, width: 18, height: 18, background: on ? C3.cyan : C3.inkMuted, boxShadow: on ? `0 0 6px ${C3.cyan}` : 'none' }} />
    </div>
  );
}
function C3SettingRow({ label, sub, control, danger = false, divider = true }) {
  return (
    <div style={{ padding: '14px 18px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: divider ? `1px solid ${C3.hairlineSoft}` : 'none' }}>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c3Mono, fontSize: 12, fontWeight: 600, color: danger ? C3.magenta : C3.ink, letterSpacing: 1.4, textTransform: 'uppercase' }}>{label}</div>
        {sub && <div style={{ marginTop: 3, fontFamily: c3Mono, fontSize: 10.5, color: C3.inkMuted, letterSpacing: 0.4 }}>{sub}</div>}
      </div>
      {control}
    </div>
  );
}
const C3Chev = ({ color = C3.cyan }) => <svg width="13" height="13" viewBox="0 0 13 13" fill="none" stroke={color} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l4 3.5L5 10"/></svg>;
function C3Settings() {
  return (
    <C3Frame>
      <C3Header leading="back" title="▌ SETTINGS" trailing={null} />
      <div style={{ padding: '14px 18px 14px', borderBottom: `1px solid ${C3.hairline}` }}>
        <div style={{ fontFamily: c3Mono, fontSize: 10, color: C3.cyan, letterSpacing: 2, textTransform: 'uppercase' }}>// SYSTEM PARAMETERS</div>
      </div>
      <div style={{ flex: 1, overflow: 'hidden' }}>
        <div style={{ padding: '12px 18px 4px', fontFamily: c3Mono, fontSize: 9.5, color: C3.inkMuted, letterSpacing: 1.8, textTransform: 'uppercase' }}>// FEEL</div>
        <C3SettingRow label="Sound FX" sub="lock · reveal · commit" control={<C3Toggle on />} />
        <C3SettingRow label="Haptics" sub="tap · pulse · resolve" control={<C3Toggle on />} />
        <C3SettingRow label="Reveal latency" sub="cpu thinking window" control={<div style={{ fontFamily: c3Mono, fontSize: 11, color: C3.cyan, padding: '4px 8px', border: `1px solid ${C3.hairline}` }}>~ 0.6s</div>} />
        <div style={{ padding: '12px 18px 4px', fontFamily: c3Mono, fontSize: 9.5, color: C3.inkMuted, letterSpacing: 1.8, textTransform: 'uppercase' }}>// HUD</div>
        <C3SettingRow label="Glow intensity" sub="ring + verdict halo" control={<div style={{ fontFamily: c3Mono, fontSize: 11, color: C3.cyan, padding: '4px 8px', border: `1px solid ${C3.hairline}` }}>NORMAL</div>} />
        <C3SettingRow label="Color profile" sub="cyan · magenta · monochrome" control={<C3Chev />} />
        <div style={{ padding: '12px 18px 4px', fontFamily: c3Mono, fontSize: 9.5, color: C3.inkMuted, letterSpacing: 1.8, textTransform: 'uppercase' }}>// DATA</div>
        <C3SettingRow label="Purge archive" sub="cannot be undone" control={<C3Chev color={C3.magenta} />} danger />
        <C3SettingRow label="About" sub="v1.0.0 · build 24" divider={false} control={<C3Chev />} />
      </div>
    </C3Frame>
  );
}

// ─── Onboarding ───
function C3Onboarding() {
  return (
    <C3Frame>
      <div style={{ height: 50 }} />
      <div style={{ flex: 1, padding: '8px 22px 0', display: 'flex', flexDirection: 'column' }}>
        <div style={{ fontFamily: c3Mono, fontSize: 11, color: C3.cyan, letterSpacing: 2.4, textTransform: 'uppercase' }}>▌ INIT // r·p·s</div>
        <div style={{ fontFamily: c3Font, fontSize: 52, fontWeight: 700, lineHeight: 0.95, letterSpacing: -1.5, marginTop: 14, color: C3.ink, textTransform: 'uppercase' }}>
          A duel<br/>in <span style={{ color: C3.cyan, textShadow: `0 0 20px ${C3.cyanDim}` }}>three</span><br/>states.
        </div>
        <div style={{ marginTop: 18, fontFamily: c3Mono, fontSize: 11.5, color: C3.inkSoft, lineHeight: 1.65, letterSpacing: 0.3, maxWidth: 290 }}>
          Commit a move. CPU commits in parallel. The ring resolves. Replay.
        </div>
        <div style={{ marginTop: 36, display: 'flex', flexDirection: 'column', gap: 0 }}>
          {[
            ['rock', 'SCISSORS', '01'],
            ['paper', 'ROCK', '02'],
            ['scissors', 'PAPER', '03'],
          ].map(([k, b, n]) => (
            <div key={k} style={{ padding: '14px 0', display: 'flex', alignItems: 'center', gap: 16, borderBottom: `1px solid ${C3.hairlineSoft}` }}>
              <div style={{ width: 48, height: 48, border: `1px solid ${C3.hairline}`, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'rgba(125,249,255,0.05)' }}>
                <RPSIcon kind={k} size={26} color={C3.cyan} variant="outline" strokeWidth={1.7} />
              </div>
              <div style={{ fontFamily: c3Mono, fontSize: 13, fontWeight: 700, letterSpacing: 1.8, color: C3.ink, textTransform: 'uppercase' }}>{RPS_NAME[k]}</div>
              <div style={{ flex: 1, fontFamily: c3Mono, fontSize: 10, color: C3.inkMuted, letterSpacing: 1.2, textTransform: 'uppercase' }}>defeats {b}</div>
              <div style={{ fontFamily: c3Mono, fontSize: 10, color: C3.cyan }}>{n}</div>
            </div>
          ))}
        </div>
        <div style={{ flex: 1 }} />
        <div style={{ paddingBottom: 22 }}>
          <button style={{
            width: '100%', height: 52, background: C3.cyan, color: C3.bg, border: 'none',
            fontFamily: c3Mono, fontSize: 12, fontWeight: 700, letterSpacing: 2.2, textTransform: 'uppercase', cursor: 'pointer',
            boxShadow: `0 0 18px ${C3.cyanDim}`,
            clipPath: 'polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px)',
          }}>▌ Initialize</button>
        </div>
      </div>
    </C3Frame>
  );
}

// ─── Reset ───
function C3Reset() {
  return (
    <C3Frame>
      <div style={{ position: 'absolute', inset: 0, opacity: 0.38, filter: 'blur(2px)' }}>
        <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
          <C3Header />
          <C3Ring state="win" you="paper" cpu="rock" />
        </div>
      </div>
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(6,9,18,0.78)' }} />

      <div style={{
        position: 'absolute', left: 18, right: 18, top: '50%', transform: 'translateY(-50%)',
        background: C3.bg, border: `1px solid ${C3.magenta}`,
        boxShadow: `0 0 28px ${C3.magentaDim}, inset 0 0 22px rgba(255,95,180,0.05)`,
        padding: '24px 22px',
        clipPath: 'polygon(14px 0, 100% 0, 100% calc(100% - 14px), calc(100% - 14px) 100%, 0 100%, 0 14px)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16 }}>
          <div style={{ width: 6, height: 6, background: C3.magenta, boxShadow: `0 0 8px ${C3.magenta}` }} />
          <div style={{ fontFamily: c3Mono, fontSize: 10, fontWeight: 700, letterSpacing: 2.2, textTransform: 'uppercase', color: C3.magenta }}>// CAUTION · DESTRUCTIVE</div>
        </div>
        <div style={{ fontFamily: c3Font, fontSize: 30, fontWeight: 700, letterSpacing: -0.5, color: C3.ink, lineHeight: 1.05, marginBottom: 12, textShadow: `0 0 18px ${C3.magentaDim}` }}>
          Purge session<br/>archive?
        </div>
        <div style={{ fontFamily: c3Mono, fontSize: 11.5, lineHeight: 1.65, color: C3.inkSoft, letterSpacing: 0.3, marginBottom: 20 }}>
          All locally-stored round data will be erased. <span style={{ color: C3.magenta }}>03 — 02</span> and 13 rounds → 00. This action cannot be reversed.
        </div>
        <button style={{
          width: '100%', height: 52, background: C3.magenta, color: C3.bg, border: 'none',
          fontFamily: c3Mono, fontSize: 12, fontWeight: 700, letterSpacing: 2.2, textTransform: 'uppercase', cursor: 'pointer',
          boxShadow: `0 0 16px ${C3.magentaDim}`,
          clipPath: 'polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px)',
        }}>▌ Confirm purge</button>
        <button style={{
          marginTop: 10, width: '100%', height: 46, background: 'transparent', color: C3.cyan,
          border: `1px solid ${C3.cyan}`,
          fontFamily: c3Mono, fontSize: 11.5, fontWeight: 600, letterSpacing: 2, textTransform: 'uppercase', cursor: 'pointer',
          clipPath: 'polygon(8px 0, 100% 0, 100% calc(100% - 8px), calc(100% - 8px) 100%, 0 100%, 0 8px)',
        }}>Abort</button>
      </div>
    </C3Frame>
  );
}

Object.assign(window, {
  C3Onboarding, C3Idle, C3Anticipation,
  C3Gameplay, C3Reveal, C3LoseReveal, C3TieReveal,
  C3History, C3EmptyHistory, C3Settings, C3Reset,
});
