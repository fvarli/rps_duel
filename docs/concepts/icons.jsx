// Shared icon set for all concepts.
// Real recognizable Rock / Paper / Scissors objects, drawn as flat icons.
// Two visual variants:
//   variant="solid"   → filled silhouette (use as primary, in colored
//                        backgrounds, or for the "winner" state)
//   variant="outline" → stroked line icon (use on cards, in inactive states)
//
// Sizing: every icon renders at 32×32 viewBox; pass `size` for pixel size.
// Stroke weights are designed for 24–120px range without tuning.

// ─── ROCK ───
// An irregular boulder/pebble with two facet lines for volume. Asymmetric on
// purpose — a perfectly round circle reads as "ball", not "rock".
function IconRock({ size = 32, color = 'currentColor', variant = 'solid', strokeWidth }) {
  const sw = strokeWidth ?? (variant === 'solid' ? 0 : 2);
  // Outer silhouette path
  const outer = 'M9 22 C5 17 6 11 11 7 C15 4 22 4 25 9 C28 13 28 19 25 23 C22 27 12 27 9 22 Z';
  // Two interior facet lines — drawn even in solid mode at low opacity for
  // depth, so the rock doesn't read as a flat blob.
  const facetA = 'M13 12 L17 9 L22 12';
  const facetB = 'M11 18 L17 16';
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {variant === 'solid' ? (
        <React.Fragment>
          <path d={outer} fill={color} />
          <path d={facetA} stroke={`${color}`} strokeOpacity="0.22" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round" fill="none" />
          <path d={facetB} stroke={`${color}`} strokeOpacity="0.22" strokeWidth="1.4" strokeLinecap="round" fill="none" />
        </React.Fragment>
      ) : (
        <React.Fragment>
          <path d={outer} stroke={color} strokeWidth={sw} strokeLinejoin="round" fill="none" />
          <path d={facetA} stroke={color} strokeOpacity="0.55" strokeWidth={sw * 0.75} strokeLinecap="round" strokeLinejoin="round" fill="none" />
          <path d={facetB} stroke={color} strokeOpacity="0.55" strokeWidth={sw * 0.75} strokeLinecap="round" fill="none" />
        </React.Fragment>
      )}
    </svg>
  );
}

// ─── PAPER ───
// A rectangular sheet with a folded top-right corner and three text lines.
// The corner-fold detail is what makes it read as "paper" and not "card".
function IconPaper({ size = 32, color = 'currentColor', variant = 'solid', strokeWidth }) {
  const sw = strokeWidth ?? (variant === 'solid' ? 0 : 2);
  // Sheet outline — corner is folded inward from (22,4) to (28,10)
  const sheet = 'M7 4 H22 L28 10 V27 a1 1 0 0 1 -1 1 H8 a1 1 0 0 1 -1 -1 Z';
  // The fold triangle
  const fold = 'M22 4 V10 H28';
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      {variant === 'solid' ? (
        <React.Fragment>
          <path d={sheet} fill={color} />
          {/* the fold reads as a slightly darker triangle within the sheet */}
          <path d="M22 4 L28 10 L22 10 Z" fill={color} fillOpacity="0.25" stroke={color} strokeOpacity="0.6" strokeWidth="1.2" strokeLinejoin="round" />
          <line x1="11" y1="15" x2="24" y2="15" stroke={color} strokeOpacity="0.3" strokeWidth="1.4" strokeLinecap="round" />
          <line x1="11" y1="19" x2="22" y2="19" stroke={color} strokeOpacity="0.3" strokeWidth="1.4" strokeLinecap="round" />
          <line x1="11" y1="23" x2="20" y2="23" stroke={color} strokeOpacity="0.3" strokeWidth="1.4" strokeLinecap="round" />
        </React.Fragment>
      ) : (
        <React.Fragment>
          <path d={sheet} stroke={color} strokeWidth={sw} strokeLinejoin="round" fill="none" />
          <path d={fold} stroke={color} strokeWidth={sw} strokeLinejoin="round" fill="none" />
          <line x1="11" y1="16" x2="24" y2="16" stroke={color} strokeOpacity="0.65" strokeWidth={sw * 0.75} strokeLinecap="round" />
          <line x1="11" y1="20" x2="22" y2="20" stroke={color} strokeOpacity="0.65" strokeWidth={sw * 0.75} strokeLinecap="round" />
          <line x1="11" y1="24" x2="20" y2="24" stroke={color} strokeOpacity="0.65" strokeWidth={sw * 0.75} strokeLinecap="round" />
        </React.Fragment>
      )}
    </svg>
  );
}

// ─── SCISSORS ───
// Two crossed blades pivoting through a center bolt, with two open finger
// rings at the bottom. Classic dressmaker shears silhouette.
function IconScissors({ size = 32, color = 'currentColor', variant = 'solid', strokeWidth }) {
  const sw = strokeWidth ?? (variant === 'solid' ? 0 : 2);
  if (variant === 'solid') {
    return (
      <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
        {/* finger rings — hollow circles */}
        <circle cx="9" cy="24" r="4" stroke={color} strokeWidth="2.2" fill="none" />
        <circle cx="23" cy="24" r="4" stroke={color} strokeWidth="2.2" fill="none" />
        {/* blades — two crossing tapered paths */}
        <path d="M11.5 21 L26 6.5 L28 8 L13.5 22.5 Z" fill={color} />
        <path d="M20.5 21 L6 6.5 L4 8 L18.5 22.5 Z" fill={color} />
        {/* pivot bolt */}
        <circle cx="16" cy="16" r="1.4" fill={color} />
      </svg>
    );
  }
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      <circle cx="9" cy="24" r="4" stroke={color} strokeWidth={sw} fill="none" />
      <circle cx="23" cy="24" r="4" stroke={color} strokeWidth={sw} fill="none" />
      <path d="M12 21 L27 7" stroke={color} strokeWidth={sw} strokeLinecap="round" />
      <path d="M20 21 L5 7" stroke={color} strokeWidth={sw} strokeLinecap="round" />
      <circle cx="16" cy="16" r="1.2" fill={color} />
    </svg>
  );
}

// Convenience map by kind ('rock' | 'paper' | 'scissors').
const RPS_ICON = { rock: IconRock, paper: IconPaper, scissors: IconScissors };
const RPS_NAME = { rock: 'Rock', paper: 'Paper', scissors: 'Scissors' };

// Helper: render the icon for a kind string.
function RPSIcon({ kind, ...rest }) {
  const Icon = RPS_ICON[kind];
  return Icon ? <Icon {...rest} /> : null;
}

// Outcome resolver — keeps result logic in one place so all four concepts
// stay consistent in copy and rules.
function rpsResolve(you, cpu) {
  if (you === cpu) return 'tie';
  if ((you === 'rock' && cpu === 'scissors')
   || (you === 'scissors' && cpu === 'paper')
   || (you === 'paper' && cpu === 'rock')) return 'win';
  return 'loss';
}

// Human-readable "Paper covers Rock" etc.
function rpsExplain(you, cpu, result) {
  if (result === 'tie') return `Both played ${RPS_NAME[you]}.`;
  const winner = result === 'win' ? you : cpu;
  const loser = result === 'win' ? cpu : you;
  const verb = {
    'rock_scissors': 'crushes',
    'scissors_paper': 'cuts',
    'paper_rock': 'covers',
  }[`${winner}_${loser}`];
  return `${RPS_NAME[winner]} ${verb} ${RPS_NAME[loser]}.`;
}

Object.assign(window, { IconRock, IconPaper, IconScissors, RPSIcon, RPS_ICON, RPS_NAME, rpsResolve, rpsExplain });

// Back-compat shims so the existing C1/C2/C3 code that references
// Glyph* keeps working until each file is migrated.
window.GlyphRock = (p) => <IconRock {...p} variant={p.filled === false ? 'outline' : 'solid'} />;
window.GlyphPaper = (p) => <IconPaper {...p} variant={p.filled === false ? 'outline' : 'solid'} />;
window.GlyphScissors = (p) => <IconScissors {...p} variant={p.filled === false ? 'outline' : 'solid'} />;
