// Concept 4 — Tactile Premium
//
// Design language: warm cream paper background, real "cards" as the
// metaphor for rock/paper/scissors. Cards have soft drop shadows, subtle
// embossed edges, and tactile pressed states. The duel is two cards
// face-up across a stage; the picker is three cards in the thumb zone.
//
// Type: Newsreader (serif, italic for warmth) + Geist (sans for everything
// else). Both Google Fonts.
//
// Colour: cream + clay + sage. No neon, no gradients, no chrome.

const C4 = {
  bg: '#f0e9d8',
  bgWarm: '#ebe3cf',
  paper: '#fbf7ec',
  paperEdge: '#e0d6bd',
  ink: '#1f1c14',
  inkSoft: '#5a5443',
  inkMuted: '#8e8772',
  inkFaint: '#bdb6a0',
  hairline: '#d8d0b8',
  hairlineSoft: '#e6dfca',
  clay: '#a85a3b',
  claySoft: '#efd9cd',
  sage: '#5c7d44',
  sageSoft: '#dde6cd',
  gold: '#b8862a',
  ribbon: '#1f1c14',
};

const c4Font = '"Geist", "DM Sans", system-ui, sans-serif';
const c4Display = '"Newsreader", "Source Serif 4", Georgia, serif';

// Subtle paper noise — a single re-used SVG turbulence layered into the
// background of any C4 surface that wants tactile grain. Cheap on perf.
const c4NoiseURL = "url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='160' height='160'><filter id='n'><feTurbulence type='fractalNoise' baseFrequency='1.4' numOctaves='2' seed='3' stitchTiles='stitch'/><feColorMatrix values='0 0 0 0 0.12 0 0 0 0 0.10 0 0 0 0 0.05 0 0 0 0.06 0'/></filter><rect width='160' height='160' filter='url(%23n)'/></svg>\")";

function C4Paper({ children, deep = false }) {
  return (
    <div style={{
      width: '100%', height: '100%',
      background: deep ? C4.bgWarm : C4.bg,
      backgroundImage: c4NoiseURL,
      position: 'relative',
      display: 'flex', flexDirection: 'column',
      fontFamily: c4Font, color: C4.ink,
    }}>{children}</div>
  );
}

function C4Eyebrow({ children, color = C4.inkMuted, size = 10.5, style = {} }) {
  return <div style={{ fontSize: size, letterSpacing: 1.6, textTransform: 'uppercase', fontWeight: 600, color, ...style }}>{children}</div>;
}

function C4ScoreChip({ you = 3, cpu = 2, ties = 1 }) {
  return (
    <div style={{
      display: 'inline-flex', alignItems: 'baseline', gap: 10,
      padding: '8px 14px',
      background: C4.paper,
      borderRadius: 999,
      boxShadow: `inset 0 0 0 1px ${C4.hairline}, 0 1px 0 ${C4.paperEdge}`,
    }}>
      <span style={{ fontFamily: c4Font, fontSize: 13, fontWeight: 600, color: C4.ink, letterSpacing: -0.2, fontVariantNumeric: 'tabular-nums' }}>{you}</span>
      <span style={{ fontSize: 10.5, color: C4.inkFaint }}>—</span>
      <span style={{ fontFamily: c4Font, fontSize: 13, fontWeight: 600, color: C4.inkSoft, fontVariantNumeric: 'tabular-nums' }}>{cpu}</span>
      <span style={{ fontFamily: c4Font, fontSize: 10, color: C4.inkMuted, letterSpacing: 1, textTransform: 'uppercase', fontWeight: 600 }}>·&nbsp;T{ties}</span>
    </div>
  );
}

// ─── App-bar (top header) ───
// Left slot: menu / back / nothing. Right slot: history / settings.
function C4TopBar({ leading = 'menu', score, trailing = 'history', title = null }) {
  const LeadIcon = () => {
    if (leading === 'back') return <svg width="18" height="14" viewBox="0 0 18 14" fill="none" stroke={C4.ink} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M7 2L2 7l5 5M2 7h14"/></svg>;
    if (leading === 'close') return <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.ink} strokeWidth="1.7" strokeLinecap="round"><path d="M3 3l8 8M11 3l-8 8"/></svg>;
    if (leading === 'menu') return <svg width="20" height="14" viewBox="0 0 20 14" fill="none" stroke={C4.ink} strokeWidth="1.6" strokeLinecap="round"><path d="M2 3h16M2 11h12"/></svg>;
    return null;
  };
  const TrailIcon = () => {
    if (trailing === 'history') return <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke={C4.ink} strokeWidth="1.5" strokeLinecap="round"><circle cx="9" cy="9" r="7"/><path d="M9 5v4l3 1.5"/></svg>;
    if (trailing === 'settings') return <svg width="18" height="18" viewBox="0 0 18 18" fill="none" stroke={C4.ink} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><circle cx="9" cy="9" r="2.4"/><path d="M9 1.5v2M9 14.5v2M3.5 3.5l1.4 1.4M13.1 13.1l1.4 1.4M1.5 9h2M14.5 9h2M3.5 14.5l1.4-1.4M13.1 4.9l1.4-1.4"/></svg>;
    return null;
  };
  return (
    <div style={{ height: 52, padding: '0 20px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flex: '0 0 auto', position: 'relative', zIndex: 2 }}>
      <button style={{ background: 'transparent', border: 'none', padding: 4, cursor: 'pointer', width: 32, height: 32, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <LeadIcon />
      </button>
      {title ? (
        <div style={{ fontFamily: c4Display, fontSize: 18, fontStyle: 'italic', color: C4.ink, letterSpacing: -0.3 }}>{title}</div>
      ) : (
        score && <C4ScoreChip {...score} />
      )}
      <button style={{ background: 'transparent', border: 'none', padding: 4, cursor: 'pointer', width: 32, height: 32, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <TrailIcon />
      </button>
    </div>
  );
}

// ─── The card primitive ───
// A tactile paper card with embossed edge and soft shadow. The duel uses
// this for both YOU and CPU; the picker row uses a compact variant.
//
// `state`: 'idle' | 'lifted' | 'facedown' | 'win' | 'loss' | 'tie'
function C4Card({ kind, label, who, state = 'idle', size = 'lg' }) {
  const isFaceDown = state === 'facedown';
  const isWin = state === 'win';
  const isLoss = state === 'loss';
  const isTie = state === 'tie';
  const isLifted = state === 'lifted';
  const dims = size === 'lg' ? { w: 112, h: 152 } : size === 'md' ? { w: 96, h: 132 } : { w: 84, h: 116 };
  const iconSize = size === 'lg' ? 56 : size === 'md' ? 48 : 40;

  // Background and frame styling per state
  const cardBg = isFaceDown ? C4.ink : C4.paper;
  const ringColor = isWin ? C4.sage : isLoss ? C4.clay : C4.hairline;
  const lift = isLifted || isWin ? 6 : isLoss ? 0 : 2;
  const tilt = isLifted ? -1 : isWin ? 0 : isLoss ? 1.5 : 0;
  const shadow = isWin
    ? `0 ${10}px 28px rgba(92,125,68,0.32), 0 2px 0 ${C4.sage}33, inset 0 0 0 1.5px ${C4.sage}`
    : isLoss
      ? `0 2px 6px rgba(31,28,20,0.06), inset 0 0 0 1px ${C4.hairline}`
      : isFaceDown
        ? `0 ${lift + 2}px 16px rgba(31,28,20,0.18), inset 0 1px 0 rgba(255,255,255,0.08)`
        : `0 ${lift + 1}px 12px rgba(31,28,20,0.10), 0 1px 0 ${C4.paperEdge}, inset 0 0 0 1px ${C4.hairline}`;

  const Icon = kind && RPS_ICON[kind];
  const iconColor = isFaceDown ? C4.paper : isWin ? C4.sage : isLoss ? C4.inkFaint : C4.ink;

  return (
    <div style={{
      width: dims.w, height: dims.h,
      background: cardBg,
      borderRadius: 14,
      boxShadow: shadow,
      transform: `translateY(${-lift}px) rotate(${tilt}deg)`,
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'space-between',
      padding: '14px 10px 12px',
      position: 'relative',
      opacity: isLoss ? 0.7 : 1,
    }}>
      {/* corner pip — kind letter, like a playing card */}
      {!isFaceDown && kind && (
        <React.Fragment>
          <div style={{ position: 'absolute', top: 8, left: 10, fontFamily: c4Display, fontStyle: 'italic', fontSize: 13, color: isWin ? C4.sage : isLoss ? C4.inkFaint : C4.inkSoft, lineHeight: 1 }}>
            {RPS_NAME[kind][0].toLowerCase()}
          </div>
          <div style={{ position: 'absolute', bottom: 8, right: 10, fontFamily: c4Display, fontStyle: 'italic', fontSize: 13, color: isWin ? C4.sage : isLoss ? C4.inkFaint : C4.inkSoft, lineHeight: 1, transform: 'rotate(180deg)' }}>
            {RPS_NAME[kind][0].toLowerCase()}
          </div>
        </React.Fragment>
      )}

      {/* who label */}
      {who && !isFaceDown && (
        <div style={{ fontFamily: c4Font, fontSize: 9, letterSpacing: 1.4, textTransform: 'uppercase', color: isWin ? C4.sage : isLoss ? C4.inkMuted : C4.inkMuted, fontWeight: 600, marginTop: 4 }}>
          {who}
        </div>
      )}

      {/* hero icon, or back-pattern if face-down */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', width: '100%' }}>
        {isFaceDown ? (
          // Card back: small repeating "R P S" monogram in cream on ink
          <div style={{ width: '70%', height: '70%', borderRadius: 6, border: `1.2px dashed ${C4.paperEdge}AA`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 26, color: `${C4.paperEdge}DD`, letterSpacing: 1, lineHeight: 1 }}>r·p·s</div>
          </div>
        ) : Icon ? (
          <Icon size={iconSize} color={iconColor} variant="solid" />
        ) : null}
      </div>

      {/* name */}
      {!isFaceDown && label && (
        <div style={{ fontFamily: c4Display, fontSize: size === 'lg' ? 16 : 14, fontStyle: 'normal', fontWeight: 400, color: isWin ? C4.sage : isLoss ? C4.inkFaint : C4.ink, letterSpacing: -0.2, lineHeight: 1 }}>
          {label}
        </div>
      )}
    </div>
  );
}

// ─── The picker row (bottom-of-screen, three cards) ───
function C4Picker({ picked = null, locked = false, hint }) {
  const Btn = ({ kind }) => {
    const isPicked = kind === picked;
    const lockedAndPicked = locked && isPicked;
    const dim = locked && !isPicked;
    const Icon = RPS_ICON[kind];
    return (
      <button style={{
        flex: 1,
        height: 76,
        background: lockedAndPicked ? C4.ink : C4.paper,
        borderRadius: 16,
        border: 'none',
        boxShadow: lockedAndPicked
          ? `0 6px 18px rgba(31,28,20,0.22), inset 0 1px 0 rgba(255,255,255,0.06)`
          : `0 1px 0 ${C4.paperEdge}, inset 0 0 0 1px ${C4.hairline}, 0 4px 10px rgba(31,28,20,0.06)`,
        opacity: dim ? 0.45 : 1,
        cursor: 'pointer',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 4,
        padding: '8px 6px',
        fontFamily: 'inherit',
        position: 'relative',
        transform: lockedAndPicked ? 'translateY(2px)' : 'translateY(0)',
      }}>
        <Icon size={28} color={lockedAndPicked ? C4.paper : C4.ink} variant="solid" />
        <div style={{ fontFamily: c4Font, fontSize: 11.5, fontWeight: 500, color: lockedAndPicked ? C4.paper : C4.ink, letterSpacing: -0.1 }}>{RPS_NAME[kind]}</div>
      </button>
    );
  };
  return (
    <div style={{ padding: '4px 18px 12px', flex: '0 0 auto' }}>
      <div style={{ display: 'flex', gap: 10 }}>
        <Btn kind="rock" />
        <Btn kind="paper" />
        <Btn kind="scissors" />
      </div>
      {hint && (
        <div style={{ textAlign: 'center', marginTop: 12, fontFamily: c4Display, fontStyle: 'italic', fontSize: 13, color: locked ? C4.inkMuted : C4.inkSoft, letterSpacing: 0.1 }}>
          {hint}
        </div>
      )}
    </div>
  );
}

// ─── The duel stage (middle of screen) ───
function C4DuelStage({ youCard, cpuCard, verdict = null, sub = null, kind = 'idle' }) {
  const verdictColor = kind === 'win' ? C4.sage : kind === 'loss' ? C4.clay : kind === 'tie' ? C4.inkSoft : C4.ink;
  return (
    <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', padding: '12px 20px 20px', minHeight: 0 }}>
      {verdict && (
        <div style={{ textAlign: 'center', marginBottom: 16 }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontWeight: 400, fontSize: 44, lineHeight: 1, color: verdictColor, letterSpacing: -0.8 }}>{verdict}</div>
          {sub && <div style={{ marginTop: 8, fontFamily: c4Font, fontSize: 12.5, color: C4.inkMuted, letterSpacing: 0.1 }}>{sub}</div>}
        </div>
      )}
      <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
        {youCard}
        <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 2 }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 18, color: C4.inkFaint }}>vs</div>
        </div>
        {cpuCard}
      </div>
    </div>
  );
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// SCREENS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// 01 · Idle / pre-selection
function C4Idle() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar score={{ you: 3, cpu: 2, ties: 1 }} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px', textAlign: 'center' }}>
          <C4Eyebrow color={C4.inkMuted}>Round 09</C4Eyebrow>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontWeight: 400, fontSize: 44, lineHeight: 1.05, color: C4.ink, letterSpacing: -0.8, marginTop: 14 }}>
            Make your<br/>move.
          </div>
          <div style={{ marginTop: 16, fontFamily: c4Font, fontSize: 13.5, lineHeight: 1.55, color: C4.inkSoft, maxWidth: 240 }}>
            Pick a card below. We'll both reveal together.
          </div>
          {/* a single inviting illustration — three cards fanned */}
          <div style={{ marginTop: 36, display: 'flex', alignItems: 'center', justifyContent: 'center', height: 130, position: 'relative' }}>
            <div style={{ position: 'absolute', transform: 'translateX(-58px) rotate(-8deg)', opacity: 0.95 }}>
              <C4Card kind="rock" label="Rock" size="sm" />
            </div>
            <div style={{ position: 'relative', zIndex: 2 }}>
              <C4Card kind="paper" label="Paper" size="sm" />
            </div>
            <div style={{ position: 'absolute', transform: 'translateX(58px) rotate(8deg)', opacity: 0.95 }}>
              <C4Card kind="scissors" label="Scissors" size="sm" />
            </div>
          </div>
        </div>
        <C4Picker hint="tap any card to play" />
      </C4Paper>
    </PhoneShell>
  );
}

// 02 · Choice locked / anticipation
function C4Anticipation() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar score={{ you: 3, cpu: 2, ties: 1 }} />
        <C4DuelStage
          verdict={null}
          youCard={<C4Card kind="paper" label="Paper" who="You · locked" state="lifted" />}
          cpuCard={<C4Card who="CPU · choosing…" state="facedown" />}
        />
        <div style={{ textAlign: 'center', padding: '0 24px 8px', fontFamily: c4Display, fontStyle: 'italic', fontSize: 22, color: C4.inkMuted, letterSpacing: -0.3 }}>
          revealing in a moment…
        </div>
        <C4Picker picked="paper" locked hint="choice locked" />
      </C4Paper>
    </PhoneShell>
  );
}

// 03 · Win reveal
function C4WinReveal() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar score={{ you: 4, cpu: 2, ties: 1 }} />
        <C4DuelStage
          kind="win"
          verdict="You win."
          sub={rpsExplain('paper', 'rock', 'win')}
          youCard={<C4Card kind="paper" label="Paper" who="You" state="win" />}
          cpuCard={<C4Card kind="rock" label="Rock" who="CPU" state="loss" />}
        />
        <C4Picker picked="paper" hint="tap any card for the next round" />
      </C4Paper>
    </PhoneShell>
  );
}

// 04 · Lose reveal
function C4LoseReveal() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar score={{ you: 3, cpu: 3, ties: 1 }} />
        <C4DuelStage
          kind="loss"
          verdict="You lose."
          sub={rpsExplain('scissors', 'rock', 'loss')}
          youCard={<C4Card kind="scissors" label="Scissors" who="You" state="loss" />}
          cpuCard={<C4Card kind="rock" label="Rock" who="CPU" state="win" />}
        />
        <C4Picker picked="scissors" hint="shake it off — tap any card" />
      </C4Paper>
    </PhoneShell>
  );
}

// 05 · Tie reveal
function C4TieReveal() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar score={{ you: 3, cpu: 2, ties: 2 }} />
        <C4DuelStage
          kind="tie"
          verdict="A tie."
          sub={rpsExplain('paper', 'paper', 'tie')}
          youCard={<C4Card kind="paper" label="Paper" who="You" state="tie" />}
          cpuCard={<C4Card kind="paper" label="Paper" who="CPU" state="tie" />}
        />
        <C4Picker picked="paper" hint="same move — play it again" />
      </C4Paper>
    </PhoneShell>
  );
}

// 06 · History
function C4HistoryRow({ n, you, cpu, result, time }) {
  const tag = { win: { t: 'Win', c: C4.sage }, loss: { t: 'Loss', c: C4.clay }, tie: { t: 'Tie', c: C4.inkMuted } }[result];
  const YIcon = RPS_ICON[you.toLowerCase()];
  const CIcon = RPS_ICON[cpu.toLowerCase()];
  return (
    <div style={{ padding: '14px 22px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: `1px solid ${C4.hairlineSoft}` }}>
      <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 22, color: C4.inkMuted, fontVariantNumeric: 'tabular-nums', width: 34, textAlign: 'right' }}>
        {String(n).padStart(2, '0')}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
        <YIcon size={22} color={C4.ink} variant="solid" />
        <span style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 13, color: C4.inkFaint }}>vs</span>
        <CIcon size={22} color={C4.inkSoft} variant="solid" />
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c4Font, fontSize: 13.5, color: C4.ink, fontWeight: 500, letterSpacing: -0.1 }}>{you} <span style={{ color: C4.inkMuted, fontWeight: 400 }}>vs</span> {cpu}</div>
        <div style={{ fontFamily: c4Font, fontSize: 11, color: C4.inkMuted, marginTop: 2, letterSpacing: 0.1 }}>{time}</div>
      </div>
      <div style={{ fontFamily: c4Font, fontSize: 11, fontWeight: 600, letterSpacing: 1.2, textTransform: 'uppercase', color: tag.c }}>{tag.t}</div>
    </div>
  );
}

function C4History() {
  const rows = [
    { n: 13, you: 'Paper', cpu: 'Rock', result: 'win', time: 'just now' },
    { n: 12, you: 'Scissors', cpu: 'Rock', result: 'loss', time: 'a moment ago' },
    { n: 11, you: 'Rock', cpu: 'Rock', result: 'tie', time: '2:13 pm' },
    { n: 10, you: 'Scissors', cpu: 'Paper', result: 'win', time: '2:12 pm' },
    { n: 9, you: 'Paper', cpu: 'Scissors', result: 'loss', time: '2:11 pm' },
    { n: 8, you: 'Rock', cpu: 'Scissors', result: 'win', time: '2:10 pm' },
    { n: 7, you: 'Paper', cpu: 'Rock', result: 'win', time: '2:09 pm' },
  ];
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="History" trailing={null} />
        <div style={{ padding: '8px 22px 22px' }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 38, lineHeight: 1.05, color: C4.ink, letterSpacing: -0.6 }}>
            Today.
          </div>
          <div style={{ marginTop: 8, fontFamily: c4Font, fontSize: 13.5, color: C4.inkSoft, letterSpacing: 0.1 }}>
            13 rounds · <span style={{ color: C4.sage, fontWeight: 600 }}>7 wins</span> · <span style={{ color: C4.clay }}>4 losses</span> · <span style={{ color: C4.inkMuted }}>2 ties</span>
          </div>
        </div>
        <div style={{ flex: 1, overflow: 'hidden', background: C4.paper, borderTop: `1px solid ${C4.hairline}` }}>
          {rows.map((r) => <C4HistoryRow key={r.n} {...r} />)}
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// 07 · Empty history
function C4EmptyHistory() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="History" trailing={null} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 40px', textAlign: 'center' }}>
          {/* A single, calm face-down card as illustration */}
          <div style={{ marginBottom: 28 }}>
            <C4Card state="facedown" />
          </div>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 32, lineHeight: 1.05, color: C4.ink, letterSpacing: -0.5 }}>
            No rounds yet.
          </div>
          <div style={{ marginTop: 12, fontFamily: c4Font, fontSize: 14, lineHeight: 1.55, color: C4.inkSoft }}>
            Your first round will land here. We keep the last 100 so you can scroll back.
          </div>
          <button style={{
            marginTop: 28,
            height: 48, padding: '0 28px',
            background: C4.ink, color: C4.paper, border: 'none', borderRadius: 24,
            fontFamily: c4Font, fontSize: 14, fontWeight: 600, letterSpacing: -0.1, cursor: 'pointer',
            boxShadow: `0 6px 16px rgba(31,28,20,0.18)`,
          }}>Play a round</button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// 08 · Settings
function C4SettingsRow({ label, sub, control, danger = false }) {
  return (
    <div style={{ padding: '16px 22px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: `1px solid ${C4.hairlineSoft}` }}>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontFamily: c4Font, fontSize: 14.5, fontWeight: 500, color: danger ? C4.clay : C4.ink, letterSpacing: -0.1 }}>{label}</div>
        {sub && <div style={{ marginTop: 3, fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted, letterSpacing: 0.1 }}>{sub}</div>}
      </div>
      <div>{control}</div>
    </div>
  );
}

function C4Toggle({ on = true }) {
  return (
    <div style={{ width: 40, height: 24, borderRadius: 12, background: on ? C4.ink : C4.hairline, position: 'relative', transition: 'background .15s' }}>
      <div style={{ position: 'absolute', top: 2, left: on ? 18 : 2, width: 20, height: 20, borderRadius: 10, background: C4.paper, boxShadow: '0 1px 3px rgba(0,0,0,0.18)', transition: 'left .15s' }} />
    </div>
  );
}

function C4SegmentedSmall({ value = 'auto' }) {
  const opts = ['light', 'auto', 'dark'];
  return (
    <div style={{ display: 'inline-flex', padding: 2, background: C4.bgWarm, borderRadius: 999, boxShadow: `inset 0 0 0 1px ${C4.hairline}` }}>
      {opts.map((o) => (
        <div key={o} style={{
          padding: '4px 10px', fontFamily: c4Font, fontSize: 11, fontWeight: 600, letterSpacing: 0.2, textTransform: 'capitalize',
          color: o === value ? C4.paper : C4.inkSoft,
          background: o === value ? C4.ink : 'transparent',
          borderRadius: 999,
        }}>{o}</div>
      ))}
    </div>
  );
}

function C4Chevron() {
  return <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.inkMuted} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l5 4-5 4"/></svg>;
}

function C4Settings() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Settings" trailing={null} />
        <div style={{ padding: '4px 22px 18px' }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 32, color: C4.ink, letterSpacing: -0.5 }}>Settings</div>
          <div style={{ marginTop: 4, fontFamily: c4Font, fontSize: 12.5, color: C4.inkMuted }}>Tune the feel of the duel.</div>
        </div>
        <div style={{ flex: 1, background: C4.paper, borderTop: `1px solid ${C4.hairline}`, overflow: 'hidden' }}>
          <C4Eyebrow color={C4.inkMuted} style={{ padding: '20px 22px 8px', letterSpacing: 1.4 }}>Feel</C4Eyebrow>
          <C4SettingsRow label="Sound effects" sub="card flip, reveal, win chime" control={<C4Toggle on />} />
          <C4SettingsRow label="Haptics" sub="tap, lock, reveal" control={<C4Toggle on />} />
          <C4SettingsRow label="Reveal speed" sub="how long the CPU takes" control={<C4SegmentedSmall value="auto" />} />

          <C4Eyebrow color={C4.inkMuted} style={{ padding: '20px 22px 8px', letterSpacing: 1.4 }}>Appearance</C4Eyebrow>
          <C4SettingsRow label="Theme" sub="follows system by default" control={<C4SegmentedSmall value="auto" />} />
          <C4SettingsRow label="Card back" sub="Linen · Default" control={<C4Chevron />} />

          <C4Eyebrow color={C4.inkMuted} style={{ padding: '20px 22px 8px', letterSpacing: 1.4 }}>Data</C4Eyebrow>
          <C4SettingsRow label="Reset match" sub="clears score and history" control={<C4Chevron />} danger />
          <C4SettingsRow label="About" sub="v1.0.0 · made with care" control={<C4Chevron />} />
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// 09 · Reset confirmation
function C4Reset() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        {/* Faded gameplay behind */}
        <div style={{ position: 'absolute', inset: 0, opacity: 0.5, filter: 'blur(0.5px)', pointerEvents: 'none' }}>
          <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
            <C4TopBar score={{ you: 4, cpu: 2, ties: 1 }} />
            <C4DuelStage
              kind="win"
              verdict="You win."
              sub={rpsExplain('paper', 'rock', 'win')}
              youCard={<C4Card kind="paper" label="Paper" who="You" state="win" />}
              cpuCard={<C4Card kind="rock" label="Rock" who="CPU" state="loss" />}
            />
          </div>
        </div>
        <div style={{ position: 'absolute', inset: 0, background: 'rgba(31,28,20,0.36)' }} />
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0,
          background: C4.paper,
          borderTopLeftRadius: 22, borderTopRightRadius: 22,
          padding: '12px 26px 30px',
          boxShadow: '0 -16px 40px rgba(31,28,20,0.18)',
        }}>
          <div style={{ width: 36, height: 4, borderRadius: 2, background: C4.hairline, margin: '0 auto 22px' }} />
          <C4Eyebrow color={C4.clay} style={{ marginBottom: 12 }}>Reset match</C4Eyebrow>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 34, lineHeight: 1.05, letterSpacing: -0.6, color: C4.ink }}>
            Start a<br/>new match?
          </div>
          <div style={{ marginTop: 14, fontFamily: c4Font, fontSize: 14, lineHeight: 1.55, color: C4.inkSoft }}>
            We'll clear your <strong style={{ color: C4.ink, fontWeight: 600 }}>4 — 2</strong> score and today's 13 rounds. This can't be undone.
          </div>
          <button style={{
            marginTop: 22, width: '100%', height: 52, borderRadius: 26,
            background: C4.ink, color: C4.paper, border: 'none',
            fontFamily: c4Font, fontSize: 14.5, fontWeight: 600, letterSpacing: -0.1, cursor: 'pointer',
            boxShadow: `0 6px 18px rgba(31,28,20,0.2)`,
          }}>Start a new match</button>
          <button style={{
            marginTop: 6, width: '100%', height: 48, borderRadius: 24,
            background: 'transparent', color: C4.inkSoft, border: 'none',
            fontFamily: c4Font, fontSize: 13.5, fontWeight: 500, cursor: 'pointer',
          }}>Keep playing</button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// 10 · First-launch onboarding
function C4OnboardCard({ kind, beats, n }) {
  const Icon = RPS_ICON[kind];
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 14, padding: '12px 0' }}>
      <div style={{ width: 56, height: 56, borderRadius: 14, background: C4.paper, boxShadow: `inset 0 0 0 1px ${C4.hairline}, 0 2px 6px rgba(31,28,20,0.06)`, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <Icon size={30} color={C4.ink} variant="solid" />
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 20, color: C4.ink, letterSpacing: -0.2, lineHeight: 1 }}>{RPS_NAME[kind]}</div>
        <div style={{ marginTop: 6, fontFamily: c4Font, fontSize: 12.5, color: C4.inkSoft, lineHeight: 1.5 }}>beats {beats}</div>
      </div>
      <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 14, color: C4.inkFaint }}>0{n}</div>
    </div>
  );
}

function C4Onboarding() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <div style={{ height: 52 }} />
        <div style={{ flex: 1, padding: '8px 28px 0', display: 'flex', flexDirection: 'column' }}>
          <C4Eyebrow color={C4.clay}>Welcome</C4Eyebrow>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontWeight: 400, fontSize: 46, lineHeight: 1.02, letterSpacing: -1, marginTop: 12, color: C4.ink }}>
            A quiet<br/>game of <span style={{ color: C4.clay }}>three</span>.
          </div>
          <div style={{ marginTop: 14, fontFamily: c4Font, fontSize: 14, lineHeight: 1.55, color: C4.inkSoft, maxWidth: 280 }}>
            Pick a card. We pick one back. The winner shows itself in a heartbeat. Tap again.
          </div>
          <div style={{ marginTop: 28 }}>
            <C4OnboardCard kind="rock" beats="Scissors" n={1} />
            <div style={{ height: 1, background: C4.hairlineSoft }} />
            <C4OnboardCard kind="paper" beats="Rock" n={2} />
            <div style={{ height: 1, background: C4.hairlineSoft }} />
            <C4OnboardCard kind="scissors" beats="Paper" n={3} />
          </div>
          <div style={{ flex: 1 }} />
          {/* dot indicator + CTA */}
          <div style={{ paddingBottom: 24 }}>
            <div style={{ display: 'flex', justifyContent: 'center', gap: 6, marginBottom: 18 }}>
              <div style={{ width: 18, height: 5, borderRadius: 3, background: C4.ink }} />
              <div style={{ width: 5, height: 5, borderRadius: 3, background: C4.hairline }} />
              <div style={{ width: 5, height: 5, borderRadius: 3, background: C4.hairline }} />
            </div>
            <button style={{
              width: '100%', height: 54, borderRadius: 27,
              background: C4.ink, color: C4.paper, border: 'none',
              fontFamily: c4Font, fontSize: 15, fontWeight: 600, letterSpacing: -0.1, cursor: 'pointer',
              boxShadow: `0 8px 22px rgba(31,28,20,0.22)`,
            }}>Get started</button>
          </div>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

Object.assign(window, {
  C4Onboarding, C4Idle, C4Anticipation,
  C4WinReveal, C4LoseReveal, C4TieReveal,
  C4History, C4EmptyHistory,
  C4Settings, C4Reset,
});
