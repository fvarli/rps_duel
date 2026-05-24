// Concept 4 — Tactile Premium · extended screen inventory
// Production screens beyond the core 10: splash, language/theme/mode select,
// home dashboard, profile, achievements, ad reward, remove ads, multiplayer
// lobby, offline, error fallback. Same tokens + primitives as concept4.jsx.

// All tokens (C4) and primitives (C4Paper, C4Card, C4Picker, C4TopBar,
// C4Eyebrow, C4ScoreChip, RPSIcon) come from concept4.jsx + icons.jsx.

// ─── 11 · Splash ───
function C4Splash() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 24 }}>
          {/* logo lockup: three small cards fanned */}
          <div style={{ position: 'relative', height: 96, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ position: 'absolute', transform: 'translateX(-44px) rotate(-10deg)', width: 56, height: 78, background: C4.paper, borderRadius: 10, boxShadow: '0 4px 10px rgba(31,28,20,0.10), inset 0 0 0 1px ' + C4.hairline, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <IconRock size={28} color={C4.ink} />
            </div>
            <div style={{ position: 'relative', zIndex: 2, width: 56, height: 78, background: C4.paper, borderRadius: 10, boxShadow: '0 6px 14px rgba(31,28,20,0.14), inset 0 0 0 1px ' + C4.hairline, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <IconPaper size={28} color={C4.ink} />
            </div>
            <div style={{ position: 'absolute', transform: 'translateX(44px) rotate(10deg)', width: 56, height: 78, background: C4.paper, borderRadius: 10, boxShadow: '0 4px 10px rgba(31,28,20,0.10), inset 0 0 0 1px ' + C4.hairline, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <IconScissors size={28} color={C4.ink} />
            </div>
          </div>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 30, color: C4.ink, letterSpacing: -0.5, lineHeight: 1, textAlign: 'center' }}>
            rock · paper<br/>· scissors
          </div>
        </div>
        <div style={{ paddingBottom: 32, textAlign: 'center', fontFamily: c4Font, fontSize: 11, color: C4.inkMuted, letterSpacing: 1.2, textTransform: 'uppercase' }}>
          warming up
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 12 · Language select ───
function C4LangRow({ name, native, flag, active = false }) {
  return (
    <button style={{
      width: '100%', padding: '16px 20px', display: 'flex', alignItems: 'center', gap: 16,
      background: active ? C4.paper : 'transparent',
      border: 'none',
      borderTop: `1px solid ${C4.hairlineSoft}`,
      cursor: 'pointer', textAlign: 'left',
      fontFamily: 'inherit',
    }}>
      <div style={{ width: 36, height: 36, borderRadius: 18, background: C4.paper, boxShadow: `inset 0 0 0 1px ${C4.hairline}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18 }}>
        {flag}
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c4Font, fontSize: 15, fontWeight: 500, color: C4.ink, letterSpacing: -0.1 }}>{name}</div>
        <div style={{ marginTop: 2, fontFamily: c4Display, fontStyle: 'italic', fontSize: 13, color: C4.inkMuted }}>{native}</div>
      </div>
      {active && (
        <svg width="18" height="14" viewBox="0 0 18 14" fill="none" stroke={C4.clay} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round"><path d="M1 7l5 5L17 1"/></svg>
      )}
    </button>
  );
}
function C4LanguageSelect() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <div style={{ height: 52 }} />
        <div style={{ padding: '8px 22px 18px' }}>
          <C4Eyebrow color={C4.clay}>Step 1 of 3</C4Eyebrow>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 40, lineHeight: 1.05, color: C4.ink, letterSpacing: -0.7, marginTop: 12 }}>
            Choose your<br/>language.
          </div>
          <div style={{ marginTop: 12, fontFamily: c4Font, fontSize: 13.5, color: C4.inkSoft, lineHeight: 1.55 }}>
            You can change this any time in Settings.
          </div>
        </div>
        <div style={{ flex: 1, background: 'transparent', overflow: 'hidden' }}>
          <C4LangRow name="English" native="English" flag="🇬🇧" />
          <C4LangRow name="Turkish" native="Türkçe" flag="🇹🇷" active />
          <C4LangRow name="Spanish" native="Español" flag="🇪🇸" />
          <div style={{ borderTop: `1px solid ${C4.hairlineSoft}` }} />
        </div>
        <div style={{ padding: '12px 22px 24px' }}>
          <button style={{
            width: '100%', height: 52, borderRadius: 26,
            background: C4.ink, color: C4.paper, border: 'none',
            fontFamily: c4Font, fontSize: 14.5, fontWeight: 600, cursor: 'pointer',
            boxShadow: `0 6px 16px rgba(31,28,20,0.18)`,
          }}>Continue</button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 13 · Theme select ───
function C4ThemeCard({ name, sub, bg, ink, accent, active = false, locked = false, lockType }) {
  return (
    <div style={{
      flex: 1, padding: '18px 14px', borderRadius: 14, background: bg, position: 'relative',
      boxShadow: active ? `0 6px 18px rgba(31,28,20,0.22), inset 0 0 0 2px ${C4.ink}` : `0 2px 6px rgba(31,28,20,0.10), inset 0 0 0 1px ${C4.hairline}`,
      display: 'flex', flexDirection: 'column', gap: 12, minHeight: 130,
    }}>
      <div style={{ display: 'flex', gap: 6 }}>
        <IconRock size={16} color={ink} variant="solid" />
        <IconPaper size={16} color={ink} variant="solid" />
        <IconScissors size={16} color={ink} variant="solid" />
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 600, color: ink, letterSpacing: -0.2 }}>{name}</div>
        <div style={{ marginTop: 4, fontFamily: c4Font, fontSize: 11, color: ink, opacity: 0.7, lineHeight: 1.45 }}>{sub}</div>
      </div>
      {locked && (
        <div style={{ display: 'inline-flex', alignSelf: 'flex-start', alignItems: 'center', gap: 4, fontFamily: c4Font, fontSize: 10, fontWeight: 600, letterSpacing: 1.2, textTransform: 'uppercase', color: accent }}>
          <svg width="10" height="10" viewBox="0 0 10 10" fill="none" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"><rect x="2" y="4.5" width="6" height="4.5" rx="0.6"/><path d="M3.5 4.5V3.2a1.5 1.5 0 0 1 3 0v1.3"/></svg>
          {lockType}
        </div>
      )}
      {active && (
        <div style={{ position: 'absolute', top: 10, right: 10, width: 22, height: 22, borderRadius: 11, background: C4.ink, color: C4.paper, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <svg width="11" height="9" viewBox="0 0 11 9" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M1 4.5l4 4L10 1"/></svg>
        </div>
      )}
    </div>
  );
}
function C4ThemeSelect() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Choose a theme" trailing={null} />
        <div style={{ padding: '4px 22px 16px' }}>
          <C4Eyebrow color={C4.clay}>Step 3 of 3</C4Eyebrow>
          <div style={{ marginTop: 8, fontFamily: c4Font, fontSize: 13.5, color: C4.inkSoft, lineHeight: 1.5 }}>
            Tactile is included. The others unlock with a short ad or one-time purchase.
          </div>
        </div>
        <div style={{ flex: 1, padding: '0 22px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          <C4ThemeCard name="Tactile Premium" sub="cream paper · cards" bg={C4.paper} ink={C4.ink} accent={C4.clay} active />
          <C4ThemeCard name="Premium Minimal" sub="warm off-white · serif italic" bg="#f4f1eb" ink="#1c1a17" accent="#b85c38" locked lockType="Watch ad" />
          <C4ThemeCard name="Competitive Arena" sub="dark navy · esports energy" bg="#0c1117" ink="#f0f4fa" accent="#ff6b35" locked lockType="Watch ad" />
          <C4ThemeCard name="Modern Futuristic" sub="neon HUD · sci-fi" bg="#060912" ink="#7df9ff" accent="#7df9ff" locked lockType="$2.99" />
        </div>
        <div style={{ padding: '20px 22px 24px' }}>
          <button style={{
            width: '100%', height: 52, borderRadius: 26,
            background: C4.ink, color: C4.paper, border: 'none',
            fontFamily: c4Font, fontSize: 14.5, fontWeight: 600, cursor: 'pointer',
            boxShadow: `0 6px 16px rgba(31,28,20,0.18)`,
          }}>Start playing</button>
          <button style={{ width: '100%', height: 44, marginTop: 4, background: 'transparent', color: C4.inkMuted, border: 'none', fontFamily: c4Font, fontSize: 13, fontWeight: 500, cursor: 'pointer' }}>I'll pick later</button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 14 · Home dashboard ───
function C4Home() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading={null} score={{ you: 3, cpu: 2, ties: 1 }} trailing="settings" />
        <div style={{ padding: '12px 22px 20px' }}>
          <C4Eyebrow>Welcome back</C4Eyebrow>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 36, lineHeight: 1.05, color: C4.ink, letterSpacing: -0.6, marginTop: 8 }}>
            Ready for a round?
          </div>
        </div>

        {/* Big primary CTA — Quick play */}
        <div style={{ padding: '0 22px' }}>
          <button style={{
            width: '100%', padding: '22px 22px', background: C4.ink, color: C4.paper, border: 'none', borderRadius: 22,
            display: 'flex', alignItems: 'center', gap: 18, cursor: 'pointer',
            fontFamily: 'inherit',
            boxShadow: `0 8px 22px rgba(31,28,20,0.22)`,
          }}>
            <div style={{ display: 'flex', gap: 6 }}>
              <IconRock size={26} color={C4.paper} variant="solid" />
              <IconPaper size={26} color={C4.paper} variant="solid" />
              <IconScissors size={26} color={C4.paper} variant="solid" />
            </div>
            <div style={{ flex: 1, textAlign: 'left' }}>
              <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 22, letterSpacing: -0.4 }}>Quick play</div>
              <div style={{ fontFamily: c4Font, fontSize: 12, color: 'rgba(251,247,236,0.7)', marginTop: 2 }}>vs CPU · last theme</div>
            </div>
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l5 5-5 5"/></svg>
          </button>
        </div>

        {/* Tiles */}
        <div style={{ padding: '14px 22px 0', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          {[
            { label: 'Modes', sub: 'vs CPU · 2P', icon: 'modes' },
            { label: 'Themes', sub: '1 of 4 unlocked', icon: 'themes' },
            { label: 'History', sub: '13 rounds today', icon: 'clock' },
            { label: 'Profile', sub: '7-day streak', icon: 'profile' },
          ].map((t, i) => (
            <button key={i} style={{
              padding: '16px 14px', background: C4.paper, color: C4.ink, border: 'none', borderRadius: 14,
              boxShadow: `inset 0 0 0 1px ${C4.hairline}, 0 2px 6px rgba(31,28,20,0.06)`,
              cursor: 'pointer', textAlign: 'left', fontFamily: 'inherit',
              display: 'flex', flexDirection: 'column', gap: 6, minHeight: 90,
            }}>
              <div style={{ width: 24, height: 24, display: 'flex', alignItems: 'center', justifyContent: 'center', color: C4.clay }}>
                {t.icon === 'modes' && <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="6" cy="10" r="3"/><circle cx="14" cy="10" r="3"/></svg>}
                {t.icon === 'themes' && <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="3" width="9" height="11" rx="1.4"/><rect x="6" y="6" width="9" height="11" rx="1.4" fill="none"/></svg>}
                {t.icon === 'clock' && <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"><circle cx="10" cy="10" r="7"/><path d="M10 6v4l3 1.5"/></svg>}
                {t.icon === 'profile' && <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="10" cy="7" r="3"/><path d="M3 17a7 7 0 0 1 14 0"/></svg>}
              </div>
              <div style={{ flex: 1 }} />
              <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 600, letterSpacing: -0.1 }}>{t.label}</div>
              <div style={{ fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted }}>{t.sub}</div>
            </button>
          ))}
        </div>

        {/* Promo card */}
        <div style={{ padding: '14px 22px 22px' }}>
          <div style={{ padding: '14px 16px', background: C4.bgWarm, borderRadius: 14, display: 'flex', alignItems: 'center', gap: 14, boxShadow: `inset 0 0 0 1px ${C4.hairlineSoft}` }}>
            <div style={{ width: 36, height: 36, borderRadius: 18, background: C4.clay, color: C4.paper, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M3 6h10v8H3z"/><path d="M3 6l5-3 5 3"/></svg>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 15, color: C4.ink, letterSpacing: -0.2 }}>Try the Arena theme</div>
              <div style={{ fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted, marginTop: 2 }}>Watch a short ad to unlock</div>
            </div>
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.inkMuted} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l4 4-4 4"/></svg>
          </div>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 15 · Mode select ───
function C4ModeRow({ label, sub, icon, locked, badge }) {
  return (
    <button style={{
      width: '100%', padding: '18px 20px', display: 'flex', alignItems: 'center', gap: 16,
      background: C4.paper, border: 'none', borderRadius: 14, boxShadow: `inset 0 0 0 1px ${C4.hairline}, 0 1px 0 ${C4.paperEdge}`,
      cursor: 'pointer', textAlign: 'left', fontFamily: 'inherit', opacity: locked ? 0.7 : 1,
    }}>
      <div style={{ width: 44, height: 44, borderRadius: 22, background: C4.bgWarm, display: 'flex', alignItems: 'center', justifyContent: 'center', color: C4.ink }}>
        {icon}
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ fontFamily: c4Font, fontSize: 15, fontWeight: 600, color: C4.ink, letterSpacing: -0.1 }}>{label}</div>
          {badge && <div style={{ fontFamily: c4Font, fontSize: 9.5, fontWeight: 700, letterSpacing: 1.2, textTransform: 'uppercase', padding: '2px 6px', borderRadius: 4, background: C4.bgWarm, color: C4.clay }}>{badge}</div>}
        </div>
        <div style={{ marginTop: 4, fontFamily: c4Font, fontSize: 12, color: C4.inkMuted }}>{sub}</div>
      </div>
      {locked ? (
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.inkMuted} strokeWidth="1.6" strokeLinecap="round"><rect x="3" y="6.5" width="8" height="6" rx="1"/><path d="M5 6.5V4.5a2 2 0 0 1 4 0v2"/></svg>
      ) : (
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.inkMuted} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l4 4-4 4"/></svg>
      )}
    </button>
  );
}
function C4ModeSelect() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Pick a mode" trailing={null} />
        <div style={{ padding: '4px 22px 20px' }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 32, color: C4.ink, letterSpacing: -0.5 }}>How would you like to play?</div>
        </div>
        <div style={{ flex: 1, padding: '0 22px', display: 'flex', flexDirection: 'column', gap: 10 }}>
          <C4ModeRow label="vs CPU" sub="Quick session against the computer" icon={<RPSIcon kind="paper" size={22} color={C4.ink} variant="solid" />} />
          <C4ModeRow label="Pass & play (2P)" sub="Share the phone with a friend" icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={C4.ink} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="7" cy="11" r="3"/><circle cx="15" cy="11" r="3"/></svg>} />
          <C4ModeRow label="Online · quick match" sub="Coming in v1.2" icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={C4.ink} strokeWidth="1.7" strokeLinecap="round"><path d="M11 18v-3M3 14a8 8 0 0 1 16 0M6 14a5 5 0 0 1 10 0M9 14a2 2 0 0 1 4 0"/></svg>} locked badge="Soon" />
          <C4ModeRow label="Friend match" sub="Coming in v1.2" icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={C4.ink} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="8" r="3"/><path d="M4 19a7 7 0 0 1 14 0"/></svg>} locked badge="Soon" />
        </div>
        <div style={{ height: 24 }} />
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 16 · Profile + Stats ───
function C4StatTile({ label, value, sub }) {
  return (
    <div style={{ padding: '14px 14px', background: C4.paper, borderRadius: 12, boxShadow: `inset 0 0 0 1px ${C4.hairline}` }}>
      <div style={{ fontFamily: c4Font, fontSize: 10, color: C4.inkMuted, letterSpacing: 1.4, textTransform: 'uppercase', fontWeight: 600 }}>{label}</div>
      <div style={{ marginTop: 8, fontFamily: c4Display, fontStyle: 'italic', fontSize: 30, color: C4.ink, letterSpacing: -0.6, lineHeight: 1, fontVariantNumeric: 'tabular-nums' }}>{value}</div>
      {sub && <div style={{ marginTop: 6, fontFamily: c4Font, fontSize: 11, color: C4.inkMuted }}>{sub}</div>}
    </div>
  );
}
function C4Profile() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Profile" trailing="settings" />
        <div style={{ padding: '8px 22px 20px', textAlign: 'center' }}>
          {/* Avatar */}
          <div style={{ width: 84, height: 84, borderRadius: 42, background: C4.paper, boxShadow: `inset 0 0 0 1px ${C4.hairline}, 0 4px 12px rgba(31,28,20,0.08)`, margin: '0 auto', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 36, color: C4.ink, lineHeight: 1 }}>g</div>
          </div>
          <div style={{ marginTop: 14, fontFamily: c4Display, fontStyle: 'italic', fontSize: 26, color: C4.ink, letterSpacing: -0.4 }}>Guest player</div>
          <div style={{ marginTop: 4, fontFamily: c4Font, fontSize: 12, color: C4.inkMuted, letterSpacing: 0.2 }}>Joined today · 1 theme owned</div>
        </div>

        <div style={{ flex: 1, padding: '0 22px', overflow: 'hidden' }}>
          <C4Eyebrow style={{ marginBottom: 10 }}>Stats — last 30 days</C4Eyebrow>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <C4StatTile label="Win rate" value="62%" sub="↑ 4% vs. last week" />
            <C4StatTile label="Best streak" value="7" sub="rounds · today 2:01 pm" />
            <C4StatTile label="Rounds played" value="86" sub="across 4 sessions" />
            <C4StatTile label="Top pick" value="Paper" sub="42% of plays" />
          </div>

          <button style={{
            marginTop: 22, width: '100%', padding: '14px 16px',
            background: C4.paper, color: C4.ink, border: 'none', borderRadius: 14,
            boxShadow: `inset 0 0 0 1px ${C4.hairline}`,
            display: 'flex', alignItems: 'center', gap: 12, cursor: 'pointer', fontFamily: 'inherit', textAlign: 'left',
          }}>
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke={C4.gold} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="9" r="5"/><path d="M7.5 13l-1 7 4.5-2 4.5 2-1-7"/></svg>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 600, color: C4.ink }}>Achievements</div>
              <div style={{ fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted, marginTop: 2 }}>4 of 24 unlocked</div>
            </div>
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.inkMuted} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l4 4-4 4"/></svg>
          </button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 17 · Achievements ───
function C4AchievementRow({ name, sub, unlocked, icon }) {
  return (
    <div style={{ padding: '14px 18px', display: 'flex', alignItems: 'center', gap: 14, borderBottom: `1px solid ${C4.hairlineSoft}`, opacity: unlocked ? 1 : 0.55 }}>
      <div style={{ width: 44, height: 44, borderRadius: 22, background: unlocked ? C4.bgWarm : 'transparent', boxShadow: unlocked ? 'none' : `inset 0 0 0 1px ${C4.hairline}`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: unlocked ? C4.gold : C4.inkMuted }}>
        {icon}
      </div>
      <div style={{ flex: 1 }}>
        <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 500, color: C4.ink, letterSpacing: -0.1 }}>{name}</div>
        <div style={{ marginTop: 2, fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted }}>{sub}</div>
      </div>
      {unlocked && <div style={{ fontFamily: c4Font, fontSize: 10.5, fontWeight: 600, letterSpacing: 1.2, textTransform: 'uppercase', color: C4.sage }}>Unlocked</div>}
    </div>
  );
}
function C4Achievements() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Achievements" trailing={null} />
        <div style={{ padding: '4px 22px 18px' }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 32, color: C4.ink, letterSpacing: -0.5 }}>4 of 24</div>
          <div style={{ marginTop: 4, fontFamily: c4Font, fontSize: 12.5, color: C4.inkMuted }}>Keep playing to unlock more</div>
        </div>
        <div style={{ background: C4.paper, flex: 1, overflow: 'hidden', borderTop: `1px solid ${C4.hairline}` }}>
          <C4AchievementRow name="First blood" sub="Win your very first round" unlocked icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="9" r="5"/><path d="M7.5 13l-1 7 4.5-2 4.5 2-1-7"/></svg>} />
          <C4AchievementRow name="Three in a row" sub="Win three rounds without a loss" unlocked icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M11 3l2.5 5L19 9l-4 4 1 5.5L11 16l-5 2.5L7 13 3 9l5.5-1z"/></svg>} />
          <C4AchievementRow name="The classic" sub="Win with each of the three at least once" unlocked icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round"><circle cx="6" cy="11" r="3"/><circle cx="11" cy="11" r="3"/><circle cx="16" cy="11" r="3"/></svg>} />
          <C4AchievementRow name="Best of seven" sub="Win a Bo7 match" unlocked icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3h12v5a6 6 0 0 1-12 0z"/><path d="M9 13h4v5H9z"/><path d="M11 15v3"/></svg>} />
          <C4AchievementRow name="Lucky thirteen" sub="Play 13 rounds in a single session" icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round"><text x="11" y="14" textAnchor="middle" fontSize="11" fill="currentColor" fontFamily="JetBrains Mono">13</text><circle cx="11" cy="11" r="8"/></svg>} />
          <C4AchievementRow name="Comeback kid" sub="Win after being 3 rounds behind" icon={<svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round"><path d="M3 11a8 8 0 1 0 4-7M3 4v5h5"/></svg>} />
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 18 · Ad reward modal ───
function C4AdReward() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <div style={{ position: 'absolute', inset: 0, opacity: 0.5, filter: 'blur(0.5px)', pointerEvents: 'none' }}>
          <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
            <C4TopBar leading="back" title="Choose a theme" trailing={null} />
            <div style={{ flex: 1 }} />
          </div>
        </div>
        <div style={{ position: 'absolute', inset: 0, background: 'rgba(31,28,20,0.36)' }} />
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0,
          background: C4.paper, borderTopLeftRadius: 22, borderTopRightRadius: 22,
          padding: '12px 26px 30px', boxShadow: '0 -16px 40px rgba(31,28,20,0.18)',
        }}>
          <div style={{ width: 36, height: 4, borderRadius: 2, background: C4.hairline, margin: '0 auto 22px' }} />
          <div style={{ width: 56, height: 56, borderRadius: 28, background: C4.clay, color: C4.paper, display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: 16 }}>
            <svg width="26" height="26" viewBox="0 0 26 26" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M5 9h16v12H5z"/><path d="M5 9l8-5 8 5"/><path d="M11 14h4"/></svg>
          </div>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 30, color: C4.ink, letterSpacing: -0.5, lineHeight: 1.05 }}>
            Unlock <span style={{ color: C4.clay }}>Competitive&nbsp;Arena</span>
          </div>
          <div style={{ marginTop: 12, fontFamily: c4Font, fontSize: 14, color: C4.inkSoft, lineHeight: 1.55 }}>
            Watch a short ad (≤ 30s) to unlock this theme permanently. No purchase needed.
          </div>
          <div style={{ marginTop: 16, padding: '12px 14px', background: C4.bgWarm, borderRadius: 12, display: 'flex', gap: 10, alignItems: 'center', fontFamily: c4Font, fontSize: 12, color: C4.inkSoft, lineHeight: 1.5 }}>
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke={C4.gold} strokeWidth="1.6" strokeLinecap="round"><circle cx="8" cy="8" r="6"/><path d="M8 5v3M8 11v.01"/></svg>
            Ads are off forever if you have Remove Ads.
          </div>
          <button style={{
            marginTop: 22, width: '100%', height: 52, borderRadius: 26,
            background: C4.ink, color: C4.paper, border: 'none',
            fontFamily: c4Font, fontSize: 14.5, fontWeight: 600, cursor: 'pointer',
            boxShadow: `0 6px 18px rgba(31,28,20,0.22)`,
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          }}>
            <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor"><path d="M3 2v12l11-6z"/></svg>
            Watch ad to unlock
          </button>
          <button style={{ marginTop: 6, width: '100%', height: 46, background: 'transparent', color: C4.inkSoft, border: 'none', fontFamily: c4Font, fontSize: 13.5, fontWeight: 500, cursor: 'pointer' }}>
            Buy theme · $1.99
          </button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 19 · Remove ads / Store ───
function C4Store() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Store" trailing={null} />
        <div style={{ padding: '4px 22px 24px' }}>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 32, color: C4.ink, letterSpacing: -0.5 }}>A quieter game.</div>
          <div style={{ marginTop: 4, fontFamily: c4Font, fontSize: 13, color: C4.inkMuted }}>One-time purchases. No subscriptions.</div>
        </div>

        {/* Remove ads hero */}
        <div style={{ padding: '0 22px' }}>
          <div style={{
            padding: '20px 20px', borderRadius: 16, background: C4.ink, color: C4.paper,
            display: 'flex', flexDirection: 'column', gap: 14,
            boxShadow: `0 8px 22px rgba(31,28,20,0.22)`,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"/><path d="M5 5l12 12"/></svg>
                <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 22, letterSpacing: -0.3 }}>Remove ads</div>
              </div>
              <div style={{ fontFamily: c4Font, fontSize: 16, fontWeight: 600 }}>$3.99</div>
            </div>
            <div style={{ fontFamily: c4Font, fontSize: 13, color: 'rgba(251,247,236,0.78)', lineHeight: 1.55 }}>
              Removes interstitials forever. Rewarded ads remain available if you want to unlock things.
            </div>
            <button style={{
              marginTop: 4, height: 46, background: C4.paper, color: C4.ink, border: 'none', borderRadius: 23,
              fontFamily: c4Font, fontSize: 14, fontWeight: 600, cursor: 'pointer',
            }}>Buy</button>
          </div>
        </div>

        {/* Theme packs */}
        <div style={{ padding: '24px 22px 0' }}>
          <C4Eyebrow style={{ marginBottom: 12 }}>Theme packs</C4Eyebrow>
          {[
            { name: 'Competitive Arena', price: '$1.99 · or watch ad', accent: '#ff6b35' },
            { name: 'Premium Minimal', price: '$1.99 · or watch ad', accent: '#b85c38' },
            { name: 'Modern Futuristic', price: '$2.99 · includes Remove Ads', accent: '#7df9ff' },
          ].map((t, i) => (
            <div key={i} style={{ padding: '14px 16px', display: 'flex', alignItems: 'center', gap: 14, background: C4.paper, borderRadius: 12, marginBottom: 8, boxShadow: `inset 0 0 0 1px ${C4.hairline}` }}>
              <div style={{ width: 36, height: 36, borderRadius: 8, background: t.accent, boxShadow: `0 2px 6px ${t.accent}66` }} />
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 600, color: C4.ink, letterSpacing: -0.1 }}>{t.name}</div>
                <div style={{ marginTop: 2, fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted }}>{t.price}</div>
              </div>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke={C4.inkMuted} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><path d="M5 3l4 4-4 4"/></svg>
            </div>
          ))}
        </div>

        <div style={{ flex: 1 }} />
        <div style={{ padding: '14px 22px 18px', textAlign: 'center' }}>
          <button style={{ background: 'transparent', color: C4.inkMuted, border: 'none', fontFamily: c4Font, fontSize: 12, fontWeight: 500, cursor: 'pointer', textDecoration: 'underline' }}>Restore purchases</button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 20 · Multiplayer lobby (Phase 3 preview) ───
function C4MPLobby() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading="back" title="Friend match" trailing={null} />
        <div style={{ padding: '4px 22px 18px' }}>
          <C4Eyebrow color={C4.clay}>Pre-match</C4Eyebrow>
          <div style={{ marginTop: 8, fontFamily: c4Display, fontStyle: 'italic', fontSize: 32, color: C4.ink, letterSpacing: -0.5, lineHeight: 1.05 }}>Both players ready?</div>
        </div>
        <div style={{ flex: 1, padding: '0 22px', display: 'flex', flexDirection: 'column', gap: 12 }}>
          {/* You */}
          <div style={{ padding: '16px 18px', background: C4.paper, borderRadius: 14, boxShadow: `inset 0 0 0 2px ${C4.sage}`, display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{ width: 40, height: 40, borderRadius: 20, background: C4.bgWarm, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: c4Display, fontStyle: 'italic', fontSize: 18, color: C4.ink }}>g</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 600, color: C4.ink }}>Guest player <span style={{ color: C4.inkMuted, fontWeight: 400 }}>(you)</span></div>
              <div style={{ marginTop: 2, fontFamily: c4Font, fontSize: 11.5, color: C4.sage, fontWeight: 600, letterSpacing: 0.4, textTransform: 'uppercase' }}>Ready</div>
            </div>
          </div>
          <div style={{ textAlign: 'center', fontFamily: c4Display, fontStyle: 'italic', fontSize: 16, color: C4.inkFaint }}>vs</div>
          {/* Opponent */}
          <div style={{ padding: '16px 18px', background: C4.paper, borderRadius: 14, boxShadow: `inset 0 0 0 1px ${C4.hairline}`, display: 'flex', alignItems: 'center', gap: 14 }}>
            <div style={{ width: 40, height: 40, borderRadius: 20, background: C4.bgWarm, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: c4Display, fontStyle: 'italic', fontSize: 18, color: C4.ink }}>m</div>
            <div style={{ flex: 1 }}>
              <div style={{ fontFamily: c4Font, fontSize: 14, fontWeight: 600, color: C4.ink }}>mehmet</div>
              <div style={{ marginTop: 2, fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted, letterSpacing: 0.4, textTransform: 'uppercase', display: 'flex', alignItems: 'center', gap: 6 }}>
                <div style={{ width: 6, height: 6, borderRadius: 3, background: C4.inkMuted, opacity: 0.5 }} />
                Waiting…
              </div>
            </div>
          </div>

          {/* Match settings card */}
          <div style={{ marginTop: 8, padding: '14px 16px', background: C4.bgWarm, borderRadius: 12, boxShadow: `inset 0 0 0 1px ${C4.hairlineSoft}` }}>
            <C4Eyebrow style={{ marginBottom: 8 }}>Match</C4Eyebrow>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '4px 0' }}>
              <div style={{ fontFamily: c4Font, fontSize: 13, color: C4.inkSoft }}>Best of</div>
              <div style={{ fontFamily: c4Font, fontSize: 13.5, fontWeight: 600, color: C4.ink }}>5 rounds</div>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '4px 0' }}>
              <div style={{ fontFamily: c4Font, fontSize: 13, color: C4.inkSoft }}>Theme</div>
              <div style={{ fontFamily: c4Font, fontSize: 13.5, fontWeight: 600, color: C4.ink }}>Tactile Premium</div>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '4px 0' }}>
              <div style={{ fontFamily: c4Font, fontSize: 13, color: C4.inkSoft }}>Room code</div>
              <div style={{ fontFamily: 'JetBrains Mono, monospace', fontSize: 13.5, fontWeight: 600, color: C4.clay, letterSpacing: 2 }}>RPS-749</div>
            </div>
          </div>
        </div>

        <div style={{ padding: '16px 22px 22px' }}>
          <button style={{ width: '100%', height: 46, background: 'transparent', color: C4.inkSoft, border: `1px solid ${C4.hairline}`, borderRadius: 23, fontFamily: c4Font, fontSize: 13.5, fontWeight: 500, cursor: 'pointer' }}>Cancel match</button>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 21 · Offline state ───
function C4Offline() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <C4TopBar leading={null} score={{ you: 3, cpu: 2, ties: 1 }} trailing="settings" />
        {/* Offline banner */}
        <div style={{ margin: '0 22px', padding: '10px 14px', background: C4.bgWarm, borderRadius: 10, display: 'flex', alignItems: 'center', gap: 10, boxShadow: `inset 0 0 0 1px ${C4.hairlineSoft}` }}>
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" stroke={C4.clay} strokeWidth="1.6" strokeLinecap="round"><path d="M3 5a10 10 0 0 1 10 0M5 8a6 6 0 0 1 6 0M7 11a2 2 0 0 1 2 0M8 14v.01M2 2l12 12"/></svg>
          <div style={{ flex: 1, fontFamily: c4Font, fontSize: 12.5, color: C4.inkSoft }}>You're offline. <span style={{ color: C4.clay, fontWeight: 600 }}>vs CPU still works.</span></div>
        </div>

        <div style={{ flex: 1, padding: '20px 22px', display: 'flex', flexDirection: 'column' }}>
          <C4Eyebrow>Available offline</C4Eyebrow>
          <button style={{
            marginTop: 12, padding: '22px', background: C4.ink, color: C4.paper, border: 'none', borderRadius: 22,
            display: 'flex', alignItems: 'center', gap: 18, cursor: 'pointer', fontFamily: 'inherit',
            boxShadow: `0 8px 22px rgba(31,28,20,0.22)`,
          }}>
            <div style={{ display: 'flex', gap: 6 }}>
              <IconRock size={26} color={C4.paper} variant="solid" />
              <IconPaper size={26} color={C4.paper} variant="solid" />
              <IconScissors size={26} color={C4.paper} variant="solid" />
            </div>
            <div style={{ flex: 1, textAlign: 'left' }}>
              <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 22 }}>Quick play vs CPU</div>
              <div style={{ fontFamily: c4Font, fontSize: 12, color: 'rgba(251,247,236,0.7)', marginTop: 2 }}>Tactile theme</div>
            </div>
          </button>

          <div style={{ marginTop: 16, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <div style={{ padding: '14px', background: C4.paper, borderRadius: 12, boxShadow: `inset 0 0 0 1px ${C4.hairline}` }}>
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke={C4.ink} strokeWidth="1.6" strokeLinecap="round"><circle cx="10" cy="10" r="7"/><path d="M10 6v4l3 1.5"/></svg>
              <div style={{ marginTop: 10, fontFamily: c4Font, fontSize: 13.5, fontWeight: 600, color: C4.ink }}>History</div>
              <div style={{ marginTop: 2, fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted }}>Last 100 rounds</div>
            </div>
            <div style={{ padding: '14px', background: C4.paper, borderRadius: 12, boxShadow: `inset 0 0 0 1px ${C4.hairline}` }}>
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none" stroke={C4.ink} strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"><circle cx="10" cy="10" r="2.4"/><path d="M10 1v2M10 17v2M3 3l1.5 1.5M15.5 15.5L17 17M1 10h2M17 10h2"/></svg>
              <div style={{ marginTop: 10, fontFamily: c4Font, fontSize: 13.5, fontWeight: 600, color: C4.ink }}>Settings</div>
              <div style={{ marginTop: 2, fontFamily: c4Font, fontSize: 11.5, color: C4.inkMuted }}>Sound, theme</div>
            </div>
          </div>

          <div style={{ flex: 1 }} />

          <div style={{ padding: '16px', background: 'transparent', borderRadius: 12, boxShadow: `inset 0 0 0 1px ${C4.hairlineSoft}` }}>
            <C4Eyebrow style={{ marginBottom: 6 }}>Unavailable offline</C4Eyebrow>
            <ul style={{ margin: 0, paddingLeft: 18, fontFamily: c4Font, fontSize: 12, color: C4.inkMuted, lineHeight: 1.65 }}>
              <li>Watch-ad theme unlock</li>
              <li>Online &amp; friend match</li>
              <li>Achievement sync</li>
            </ul>
          </div>
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

// ─── 22 · Error fallback ───
function C4Error() {
  return (
    <PhoneShell bg={C4.bg}>
      <C4Paper>
        <div style={{ height: 52 }} />
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '0 32px', textAlign: 'center' }}>
          {/* a torn paper illustration — using a clip-path */}
          <div style={{ width: 86, height: 110, position: 'relative', marginBottom: 28 }}>
            <div style={{ position: 'absolute', inset: 0, background: C4.paper, borderRadius: 12, boxShadow: `inset 0 0 0 1px ${C4.hairline}, 0 4px 10px rgba(31,28,20,0.08)`, clipPath: 'polygon(0 0, 100% 0, 100% 30%, 80% 35%, 100% 40%, 100% 100%, 0 100%)' }} />
            <div style={{ position: 'absolute', inset: 0, color: C4.inkFaint, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: c4Display, fontStyle: 'italic', fontSize: 32 }}>?</div>
          </div>
          <div style={{ fontFamily: c4Display, fontStyle: 'italic', fontSize: 36, lineHeight: 1.05, color: C4.ink, letterSpacing: -0.6 }}>
            Something tore.
          </div>
          <div style={{ marginTop: 14, fontFamily: c4Font, fontSize: 13.5, lineHeight: 1.55, color: C4.inkSoft, maxWidth: 280 }}>
            We couldn't load the game. Your scores are safe — we just need to start again.
          </div>
          <button style={{
            marginTop: 28, width: 220, height: 50, borderRadius: 25,
            background: C4.ink, color: C4.paper, border: 'none',
            fontFamily: c4Font, fontSize: 14, fontWeight: 600, cursor: 'pointer',
            boxShadow: `0 6px 16px rgba(31,28,20,0.18)`,
          }}>Try again</button>
          <button style={{
            marginTop: 6, width: 220, height: 44, background: 'transparent', color: C4.inkSoft, border: 'none',
            fontFamily: c4Font, fontSize: 13, fontWeight: 500, cursor: 'pointer',
          }}>Report a problem</button>
        </div>
        <div style={{ padding: '0 22px 22px', textAlign: 'center', fontFamily: 'JetBrains Mono, monospace', fontSize: 10.5, color: C4.inkFaint, letterSpacing: 0.3 }}>
          err: theme_pack_load_failed · v1.0.0
        </div>
      </C4Paper>
    </PhoneShell>
  );
}

Object.assign(window, {
  C4Splash, C4LanguageSelect, C4ThemeSelect, C4Home, C4ModeSelect,
  C4Profile, C4Achievements, C4AdReward, C4Store, C4MPLobby,
  C4Offline, C4Error,
});
