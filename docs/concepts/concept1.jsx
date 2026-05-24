// Concept 1 — Premium Minimal
// Restraint, but the screen lives for the duel. Score is whispered in the
// header. The hero is the face-off: YOU icon · vs · CPU icon, with the
// verdict landing in serif italic underneath.
//
// Full screen inventory: onboarding, idle, anticipation, win/lose/tie
// reveals, history, empty history, settings, reset.

const C1 = {
  bg: '#f4f1eb',
  surface: '#fffdf9',
  ink: '#1c1a17',
  inkSoft: '#5a554c',
  inkMuted: '#8a857c',
  inkFaint: '#c4bfb5',
  hairline: '#e6e1d8',
  hairlineSoft: '#efeae0',
  accent: '#b85c38',
  accentSoft: '#f0d9cd',
  win: '#2a7a4c',
  loss: '#b85c38',
  tie: '#8a857c',
};

const c1Font = '"DM Sans", system-ui, sans-serif';
const c1Display = '"Instrument Serif", "Cormorant Garamond", Georgia, serif';

function C1Eyebrow({ children, color = C1.inkMuted, size = 10.5, style = {} }) {
  return <div style={{ fontSize: size, letterSpacing: 1.8, textTransform: 'uppercase', fontWeight: 600, color, ...style }}>{children}</div>;
}

function C1MiniHeader({ you = 3, cpu = 2, ties = 1, leading = 'menu', trailing = 'history', title = null }) {
  const Lead = () => {
    if (leading === 'back') return <svg width="18" height="16" viewBox="0 0 18 16" fill="none" stroke={C1.ink} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M8 2L2 8l6 6M2 8h14"/></svg>;
    return <svg width="20" height="14" viewBox="0 0 20 14" fill="none" stroke={C1.ink} strokeWidth="1.6" strokeLinecap="round"><path d="M2 3h16M2 11h12"/></svg>;
  };
  const Trail = () => {
    if (trailing === 'settings') return <svg width="16" height="16" viewBox="0 0 18 18" fill="none" stroke={C1.ink} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><circle cx="9" cy="9" r="2.4"/><path d="M9 1.5v2M9 14.5v2M3.5 3.5l1.4 1.4M13.1 13.1l1.4 1.4M1.5 9h2M14.5 9h2M3.5 14.5l1.4-1.4M13.1 4.9l1.4-1.4"/></svg>;
    if (trailing === 'history') return <svg width="16" height="16" viewBox="0 0 18 18" fill="none" stroke={C1.ink} strokeWidth="1.5" strokeLinecap="round"><circle cx="9" cy="9" r="7"/><path d="M9 5v4l3 1.5"/></svg>;
    return null;
  };
  return (
    <div style={{ height: 52, padding: '0 22px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flex: '0 0 auto' }}>
      <Lead />
      {title ? (
        <div style={{ fontFamily: c1Display, fontStyle: 'italic', fontSize: 18, color: C1.ink, letterSpacing: -0.3 }}>{title}</div>
      ) : (
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, fontFamily: c1Font }}>
          <span style={{ fontSize: 14, fontWeight: 600, color: C1.ink, fontVariantNumeric: 'tabular-nums', letterSpacing: -0.2 }}>{you}</span>
          <span style={{ fontSize: 11, color: C1.inkFaint }}>—</span>
          <span style={{ fontSize: 14, fontWeight: 600, color: C1.ink, fontVariantNumeric: 'tabular-nums' }}>{cpu}</span>
          <span style={{ fontSize: 11, color: C1.inkMuted, letterSpacing: 1.2, textTransform: 'uppercase', fontWeight: 600 }}>·&nbsp;T{ties}</span>
        </div>
      )}
      <Trail />
    </div>
  );
}

// One half of the duel: a labelled icon. `state` drives emphasis:
// 'win' → accent, 'loss' → faint, 'tie' → neutral, 'locked' → picked
// committed pre-reveal, 'waiting' → CPU thinking.
function C1DuelColumn({ who, kind, state }) {
  const isWaiting = state === 'waiting';
  const isLocked = state === 'locked';
  const isWin = state === 'win';
  const isLoss = state === 'loss';
  const iconColor = isWin ? C1.accent : isLoss ? C1.inkFaint : isLocked ? C1.ink : C1.inkSoft;
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 18, opacity: isLoss ? 0.7 : 1 }}>
      <C1Eyebrow color={isLocked ? C1.accent : C1.inkMuted}>{who}{isLocked ? ' · locked' : ''}</C1Eyebrow>
      <div style={{ width: 112, height: 112, display: 'flex', alignItems: 'center', justifyContent: 'center', position: 'relative' }}>
        {isWaiting ? (
          <div style={{ display: 'flex', gap: 10 }}>
            <div style={{ width: 10, height: 10, borderRadius: 5, background: C1.inkFaint }} />
            <div style={{ width: 10, height: 10, borderRadius: 5, background: C1.inkMuted }} />
            <div style={{ width: 10, height: 10, borderRadius: 5, background: C1.ink }} />
          </div>
        ) : kind ? (
          <RPSIcon kind={kind} size={104} color={iconColor} variant="solid" />
        ) : null}
        {isWin && (
          <div style={{ position: 'absolute', top: -4, right: -8, width: 22, height: 22, borderRadius: 11, background: C1.accent, color: C1.surface, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <svg width="11" height="9" viewBox="0 0 11 9" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M1 4.5l4 4L10 1"/></svg>
          </div>
        )}
      </div>
      <div style={{ fontFamily: c1Display, fontSize: 22, lineHeight: 1, color: isLoss ? C1.inkMuted : C1.ink, fontStyle: 'italic', fontWeight: 400 }}>
        {isWaiting ? <span style={{ color: C1.inkFaint }}>thinking…</span> : (kind ? RPS_NAME[kind] : '')}
      </div>
    </div>
  );
}

function C1Verdict({ result, you, cpu }) {
  const text = { win: 'You win.', loss: 'You lose.', tie: "It's a tie." }[result];
  return (
    <div style={{ textAlign: 'center', padding: '0 24px' }}>
      <div style={{ fontFamily: c1Display, fontStyle: 'italic', fontWeight: 400, fontSize: 60, lineHeight: 1, color: C1.ink, letterSpacing: -1 }}>{text}</div>
      <div style={{ marginTop: 12, fontSize: 12.5, color: C1.inkMuted, fontWeight: 500, letterSpacing: 0.2 }}>{rpsExplain(you, cpu, result)}</div>
    </div>
  );
}

function C1ActionRow({ lastPlayed = null, locked = false, hint }) {
  const Btn = ({ kind }) => {
    const isLast = kind === lastPlayed;
    const lockedAndPicked = locked && isLast;
    const dim = locked && !isLast;
    return (
      <div style={{
        flex: 1,
        background: lockedAndPicked ? C1.ink : C1.surface,
        borderRadius: 18,
        padding: '18px 12px 16px',
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 12,
        boxShadow: lockedAndPicked
          ? '0 8px 22px rgba(28,26,23,0.22)'
          : 'inset 0 0 0 1px ' + C1.hairline,
        opacity: dim ? 0.35 : 1,
        position: 'relative',
      }}>
        <RPSIcon kind={kind} size={30} color={lockedAndPicked ? C1.surface : C1.ink} variant="solid" />
        <div style={{ fontSize: 13.5, fontWeight: 500, letterSpacing: -0.1, color: lockedAndPicked ? C1.surface : C1.ink }}>{RPS_NAME[kind]}</div>
        {isLast && !locked && <div style={{ position: 'absolute', top: 10, right: 10, width: 6, height: 6, borderRadius: 3, background: C1.accent }} />}
      </div>
    );
  };
  return (
    <div style={{ padding: '0 20px 6px', flex: '0 0 auto' }}>
      <div style={{ display: 'flex', gap: 10 }}>
        <Btn kind="rock" /><Btn kind="paper" /><Btn kind="scissors" />
      </div>
      <div style={{ textAlign: 'center', marginTop: 14, fontSize: 12, color: C1.inkMuted, fontWeight: 500 }}>{hint}</div>
    </div>
  );
}

// ─── Idle ───
function C1Idle() {
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <C1MiniHeader you={3} cpu={2} ties={1} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', padding: '0 32px', textAlign: 'center' }}>
          <C1Eyebrow>Round 09</C1Eyebrow>
          <div style={{ fontFamily: c1Display, fontStyle: 'italic', fontSize: 46, lineHeight: 1.05, color: C1.ink, letterSpacing: -0.8, marginTop: 14 }}>
            Make your<br/>move.
          </div>
          <div style={{ marginTop: 14, fontSize: 13.5, color: C1.inkMuted, maxWidth: 250, lineHeight: 1.5 }}>
            Pick rock, paper, or scissors. We'll both reveal together.
          </div>
          {/* three icons softly arranged */}
          <div style={{ marginTop: 40, display: 'flex', gap: 40, opacity: 0.5 }}>
            <RPSIcon kind="rock" size={40} color={C1.inkMuted} variant="solid" />
            <RPSIcon kind="paper" size={40} color={C1.inkMuted} variant="solid" />
            <RPSIcon kind="scissors" size={40} color={C1.inkMuted} variant="solid" />
          </div>
        </div>
        <C1ActionRow hint="Tap any to play" />
      </div>
    </PhoneShell>
  );
}

// ─── Reveal (win / loss / tie) ───
function C1Reveal({ result = 'win', you = 'paper', cpu = 'rock', score = { you: 3, cpu: 2, ties: 1 } }) {
  const youState = result === 'win' ? 'win' : result === 'loss' ? 'loss' : 'tie';
  const cpuState = result === 'loss' ? 'win' : result === 'win' ? 'loss' : 'tie';
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <C1MiniHeader {...score} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '24px 0 28px' }}>
          <div style={{ display: 'flex', alignItems: 'center', padding: '0 8px' }}>
            <C1DuelColumn who="You" kind={you} state={youState} />
            <div style={{ width: 40, fontFamily: c1Display, fontStyle: 'italic', fontSize: 22, color: C1.inkFaint, textAlign: 'center', alignSelf: 'flex-start', paddingTop: 60 }}>vs</div>
            <C1DuelColumn who="CPU" kind={cpu} state={cpuState} />
          </div>
          <C1Verdict result={result} you={you} cpu={cpu} />
        </div>
        <C1ActionRow lastPlayed={you} hint="Tap any to play the next round" />
      </div>
    </PhoneShell>
  );
}

const C1Gameplay = () => <C1Reveal result="win" you="paper" cpu="rock" score={{ you: 3, cpu: 2, ties: 1 }} />;
const C1LoseReveal = () => <C1Reveal result="loss" you="scissors" cpu="rock" score={{ you: 3, cpu: 3, ties: 1 }} />;
const C1TieReveal = () => <C1Reveal result="tie" you="paper" cpu="paper" score={{ you: 3, cpu: 2, ties: 2 }} />;

// ─── Anticipation ───
function C1Anticipation() {
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <C1MiniHeader you={3} cpu={2} ties={1} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'space-between', padding: '24px 0 28px' }}>
          <div style={{ display: 'flex', alignItems: 'center', padding: '0 8px' }}>
            <C1DuelColumn who="You" kind="paper" state="locked" />
            <div style={{ width: 40, fontFamily: c1Display, fontStyle: 'italic', fontSize: 22, color: C1.inkFaint, textAlign: 'center', alignSelf: 'flex-start', paddingTop: 60 }}>vs</div>
            <C1DuelColumn who="CPU" state="waiting" />
          </div>
          <div style={{ textAlign: 'center', padding: '0 24px' }}>
            <div style={{ fontFamily: c1Display, fontStyle: 'italic', fontWeight: 400, fontSize: 40, lineHeight: 1, color: C1.inkMuted, letterSpacing: -0.4 }}>Waiting…</div>
            <div style={{ marginTop: 10, fontSize: 12.5, color: C1.inkMuted, fontWeight: 500 }}>CPU is choosing</div>
          </div>
        </div>
        <C1ActionRow lastPlayed="paper" locked hint="Choice locked · revealing in a moment" />
      </div>
    </PhoneShell>
  );
}

// ─── History ───
function C1HistoryRow({ n, you, cpu, result, time }) {
  const tag = { win: { t: 'Win', c: C1.win }, loss: { t: 'Loss', c: C1.loss }, tie: { t: 'Tie', c: C1.tie } }[result];
  const verb = { win: 'beat', loss: 'lost to', tie: 'tied' }[result];
  return (
    <div style={{ padding: '16px 24px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: `1px solid ${C1.hairlineSoft}` }}>
      <div style={{ fontFamily: c1Display, fontSize: 24, color: C1.inkMuted, fontVariantNumeric: 'tabular-nums', width: 30 }}>
        {String(n).padStart(2, '0')}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
        <RPSIcon kind={you.toLowerCase()} size={20} color={C1.ink} variant="solid" />
        <span style={{ fontFamily: c1Display, fontStyle: 'italic', fontSize: 11, color: C1.inkFaint }}>vs</span>
        <RPSIcon kind={cpu.toLowerCase()} size={20} color={C1.inkSoft} variant="solid" />
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 13.5, fontWeight: 500, color: C1.ink, letterSpacing: -0.1 }}>
          {you} <span style={{ color: C1.inkMuted, fontWeight: 400 }}>{verb}</span> {cpu}
        </div>
        <div style={{ fontSize: 11.5, color: C1.inkMuted, marginTop: 2 }}>{time}</div>
      </div>
      <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: 0.6, color: tag.c, textTransform: 'uppercase' }}>{tag.t}</div>
    </div>
  );
}

function C1History() {
  const rows = [
    { n: 13, you: 'Paper', cpu: 'Rock', result: 'win', time: '2:14 pm' },
    { n: 12, you: 'Scissors', cpu: 'Rock', result: 'loss', time: '2:13 pm' },
    { n: 11, you: 'Rock', cpu: 'Rock', result: 'tie', time: '2:13 pm' },
    { n: 10, you: 'Scissors', cpu: 'Paper', result: 'win', time: '2:12 pm' },
    { n: 9, you: 'Paper', cpu: 'Scissors', result: 'loss', time: '2:11 pm' },
    { n: 8, you: 'Rock', cpu: 'Scissors', result: 'win', time: '2:10 pm' },
    { n: 7, you: 'Paper', cpu: 'Rock', result: 'win', time: '2:09 pm' },
  ];
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <C1MiniHeader you={3} cpu={2} ties={1} leading="back" title="History" trailing={null} />
        <div style={{ padding: '4px 24px 18px' }}>
          <div style={{ fontFamily: c1Display, fontSize: 34, lineHeight: 1.05, color: C1.ink, letterSpacing: -0.6, fontWeight: 400 }}>
            <span style={{ fontStyle: 'italic' }}>Today's</span> rounds
          </div>
          <div style={{ marginTop: 8, fontSize: 13, color: C1.inkMuted }}>
            13 rounds · <span style={{ color: C1.accent, fontWeight: 600 }}>7 wins</span>
          </div>
        </div>
        <div style={{ background: C1.surface, flex: 1, overflow: 'hidden' }}>
          {rows.map((r) => <C1HistoryRow key={r.n} {...r} />)}
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Empty history ───
function C1EmptyHistory() {
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <C1MiniHeader leading="back" title="History" trailing={null} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 36px', textAlign: 'center' }}>
          <div style={{ display: 'flex', gap: 18, opacity: 0.45, marginBottom: 28 }}>
            <RPSIcon kind="rock" size={32} color={C1.inkMuted} variant="outline" strokeWidth={1.6} />
            <RPSIcon kind="paper" size={32} color={C1.inkMuted} variant="outline" strokeWidth={1.6} />
            <RPSIcon kind="scissors" size={32} color={C1.inkMuted} variant="outline" strokeWidth={1.6} />
          </div>
          <div style={{ fontFamily: c1Display, fontStyle: 'italic', fontSize: 36, lineHeight: 1.05, color: C1.ink, letterSpacing: -0.6 }}>
            No rounds yet.
          </div>
          <div style={{ marginTop: 12, fontSize: 13.5, color: C1.inkSoft, lineHeight: 1.55, maxWidth: 270 }}>
            Your first round will land here. We keep the last 100 so you can scroll back.
          </div>
          <button style={{
            marginTop: 28, height: 48, padding: '0 26px',
            background: C1.ink, color: C1.surface, border: 'none', borderRadius: 24,
            fontFamily: c1Font, fontSize: 14, fontWeight: 600, cursor: 'pointer',
          }}>Play a round</button>
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Settings ───
function C1Toggle({ on = true }) {
  return (
    <div style={{ width: 40, height: 24, borderRadius: 12, background: on ? C1.ink : C1.hairline, position: 'relative' }}>
      <div style={{ position: 'absolute', top: 2, left: on ? 18 : 2, width: 20, height: 20, borderRadius: 10, background: C1.surface, boxShadow: '0 1px 3px rgba(0,0,0,0.18)' }} />
    </div>
  );
}
function C1SettingRow({ label, sub, control, danger = false, divider = true }) {
  return (
    <div style={{ padding: '16px 24px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: divider ? `1px solid ${C1.hairlineSoft}` : 'none' }}>
      <div style={{ flex: 1 }}>
        <div style={{ fontSize: 14.5, fontWeight: 500, color: danger ? C1.accent : C1.ink, letterSpacing: -0.1 }}>{label}</div>
        {sub && <div style={{ marginTop: 3, fontSize: 11.5, color: C1.inkMuted }}>{sub}</div>}
      </div>
      {control}
    </div>
  );
}
const C1Chev = () => <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C1.inkMuted} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l5 4-5 4"/></svg>;
function C1Settings() {
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <C1MiniHeader leading="back" title="Settings" trailing={null} />
        <div style={{ padding: '4px 24px 18px' }}>
          <div style={{ fontFamily: c1Display, fontSize: 34, color: C1.ink, letterSpacing: -0.6, fontStyle: 'italic' }}>Settings</div>
        </div>
        <div style={{ background: C1.surface, flex: 1, overflow: 'hidden' }}>
          <C1Eyebrow style={{ padding: '18px 24px 8px' }}>Feel</C1Eyebrow>
          <C1SettingRow label="Sounds" sub="reveal, win, tap" control={<C1Toggle on />} />
          <C1SettingRow label="Haptics" sub="tap and reveal feedback" control={<C1Toggle on />} />
          <C1Eyebrow style={{ padding: '18px 24px 8px' }}>Appearance</C1Eyebrow>
          <C1SettingRow label="Theme" sub="Follows system" control={<C1Chev />} />
          <C1Eyebrow style={{ padding: '18px 24px 8px' }}>Data</C1Eyebrow>
          <C1SettingRow label="Reset match" sub="Clears score and history" control={<C1Chev />} danger />
          <C1SettingRow label="About" sub="v1.0.0" control={<C1Chev />} divider={false} />
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Onboarding (first launch) ───
function C1Onboarding() {
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column', fontFamily: c1Font, color: C1.ink }}>
        <div style={{ height: 52 }} />
        <div style={{ flex: 1, padding: '8px 28px 0', display: 'flex', flexDirection: 'column' }}>
          <C1Eyebrow color={C1.accent}>Welcome</C1Eyebrow>
          <div style={{ fontFamily: c1Display, fontSize: 46, lineHeight: 1.02, letterSpacing: -1, marginTop: 14, color: C1.ink }}>
            <span style={{ fontStyle: 'italic' }}>A quiet game</span><br/>of <span style={{ color: C1.accent, fontStyle: 'italic' }}>three</span>.
          </div>
          <div style={{ marginTop: 16, fontSize: 14, lineHeight: 1.55, color: C1.inkSoft, maxWidth: 280 }}>
            Pick rock, paper, or scissors. We pick one back. The winner shows itself.
          </div>
          <div style={{ marginTop: 32, display: 'flex', flexDirection: 'column', gap: 14 }}>
            {[
              ['rock', 'Scissors'],
              ['paper', 'Rock'],
              ['scissors', 'Paper'],
            ].map(([k, b]) => (
              <div key={k} style={{ display: 'flex', alignItems: 'center', gap: 16, padding: '8px 0' }}>
                <RPSIcon kind={k} size={36} color={C1.ink} variant="solid" />
                <div style={{ fontFamily: c1Display, fontSize: 22, color: C1.ink, letterSpacing: -0.3, fontStyle: 'italic' }}>{RPS_NAME[k]}</div>
                <div style={{ flex: 1 }} />
                <div style={{ fontSize: 12.5, color: C1.inkMuted }}>beats {b}</div>
              </div>
            ))}
          </div>
          <div style={{ flex: 1 }} />
          <div style={{ paddingBottom: 24 }}>
            <div style={{ display: 'flex', justifyContent: 'center', gap: 6, marginBottom: 18 }}>
              <div style={{ width: 18, height: 5, borderRadius: 3, background: C1.ink }} />
              <div style={{ width: 5, height: 5, borderRadius: 3, background: C1.hairline }} />
            </div>
            <button style={{
              width: '100%', height: 54, borderRadius: 27, background: C1.ink, color: C1.surface, border: 'none',
              fontFamily: c1Font, fontSize: 15, fontWeight: 600, cursor: 'pointer',
            }}>Start playing</button>
          </div>
        </div>
      </div>
    </PhoneShell>
  );
}

// ─── Reset confirmation ───
function C1Reset() {
  return (
    <PhoneShell bg={C1.bg}>
      <div style={{ width: '100%', height: '100%', position: 'relative', fontFamily: c1Font, color: C1.ink }}>
        <div style={{ position: 'absolute', inset: 0, opacity: 0.35, filter: 'blur(0.5px)', pointerEvents: 'none' }}>
          <div style={{ width: '100%', height: '100%', display: 'flex', flexDirection: 'column' }}>
            <C1MiniHeader />
            <div style={{ flex: 1, display: 'flex', alignItems: 'center', padding: '0 8px' }}>
              <C1DuelColumn who="You" kind="paper" state="win" />
              <div style={{ width: 40 }} />
              <C1DuelColumn who="CPU" kind="rock" state="loss" />
            </div>
          </div>
        </div>
        <div style={{ position: 'absolute', inset: 0, background: 'rgba(28,26,23,0.32)' }} />
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0,
          background: C1.surface, borderTopLeftRadius: 24, borderTopRightRadius: 24,
          padding: '12px 28px 32px',
          boxShadow: '0 -12px 40px rgba(28,26,23,0.18)',
        }}>
          <div style={{ width: 36, height: 4, borderRadius: 2, background: C1.hairline, margin: '0 auto 22px' }} />
          <C1Eyebrow color={C1.accent} style={{ marginBottom: 14 }}>Reset match</C1Eyebrow>
          <div style={{ fontFamily: c1Display, fontStyle: 'italic', fontSize: 38, lineHeight: 1, letterSpacing: -0.6, color: C1.ink }}>
            Start a<br/>new match?
          </div>
          <div style={{ marginTop: 18, fontSize: 14, lineHeight: 1.55, color: C1.inkSoft }}>
            You'll clear your <strong style={{ color: C1.ink }}>3 — 2</strong> score and today's 13 rounds. This can't be undone.
          </div>
          <button style={{ marginTop: 24, width: '100%', height: 56, borderRadius: 28, background: C1.ink, color: C1.surface, border: 'none', fontFamily: c1Font, fontSize: 15.5, fontWeight: 600, cursor: 'pointer' }}>Start a new match</button>
          <button style={{ marginTop: 8, width: '100%', height: 52, borderRadius: 26, background: 'transparent', color: C1.inkSoft, border: 'none', fontFamily: c1Font, fontSize: 14.5, fontWeight: 500, cursor: 'pointer' }}>Keep playing</button>
        </div>
      </div>
    </PhoneShell>
  );
}

Object.assign(window, {
  C1Onboarding, C1Idle, C1Anticipation,
  C1Gameplay, C1Reveal, C1LoseReveal, C1TieReveal,
  C1History, C1EmptyHistory, C1Settings, C1Reset,
});
