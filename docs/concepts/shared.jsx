// Shared device chrome — keeps each concept file focused on its visual identity.
// PhoneShell renders the rounded screen, a status bar at the top, and a thin
// home-indicator at the bottom. Concepts pass their own bg + statusBarTint.

function StatusBar({ tint = '#1c1a17', sigStyle = {} }) {
  return (
    <div style={{
      height: 44,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 24px',
      fontSize: 14.5,
      fontWeight: 600,
      color: tint,
      fontFamily: '"DM Sans", system-ui, sans-serif',
      ...sigStyle,
    }}>
      <span style={{ fontVariantNumeric: 'tabular-nums', letterSpacing: -0.2 }}>9:41</span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <svg width="17" height="11" viewBox="0 0 17 11" fill={tint}>
          <rect x="0" y="7" width="3" height="4" rx="0.5"/>
          <rect x="4.5" y="5" width="3" height="6" rx="0.5"/>
          <rect x="9" y="2.5" width="3" height="8.5" rx="0.5"/>
          <rect x="13.5" y="0" width="3" height="11" rx="0.5"/>
        </svg>
        <svg width="15" height="11" viewBox="0 0 15 11" fill="none">
          <path d="M7.5 2.5 C4.5 2.5 2 4.3 0.5 6 L 1.5 7 C 3 5.5 5 4 7.5 4 C 10 4 12 5.5 13.5 7 L 14.5 6 C 13 4.3 10.5 2.5 7.5 2.5 Z M 7.5 6.5 C 6 6.5 4.5 7.5 3.5 8.5 L 7.5 11 L 11.5 8.5 C 10.5 7.5 9 6.5 7.5 6.5 Z" fill={tint}/>
        </svg>
        <svg width="26" height="11" viewBox="0 0 26 11" fill="none">
          <rect x="0.5" y="0.5" width="22" height="10" rx="2.4" stroke={tint} strokeOpacity="0.45"/>
          <rect x="2" y="2" width="16" height="7" rx="1" fill={tint}/>
          <rect x="23.5" y="3.5" width="2" height="4" rx="0.6" fill={tint} fillOpacity="0.55"/>
        </svg>
      </div>
    </div>
  );
}

function HomeIndicator({ tint = '#1c1a17' }) {
  return (
    <div style={{ position: 'absolute', bottom: 8, left: '50%', transform: 'translateX(-50%)', width: 130, height: 4, borderRadius: 2, background: tint, opacity: 0.85 }} />
  );
}

function PhoneShell({ children, bg = '#fff', statusBarTint = '#1c1a17', homeTint, dynamicIsland = false }) {
  return (
    <div style={{
      width: '100%', height: '100%', background: bg,
      position: 'relative', overflow: 'hidden',
      display: 'flex', flexDirection: 'column',
    }}>
      <StatusBar tint={statusBarTint} />
      {dynamicIsland && (
        <div style={{ position: 'absolute', top: 11, left: '50%', transform: 'translateX(-50%)', width: 96, height: 26, borderRadius: 14, background: '#000', zIndex: 2 }} />
      )}
      <div style={{ flex: 1, minHeight: 0, position: 'relative' }}>{children}</div>
      <HomeIndicator tint={homeTint || statusBarTint} />
    </div>
  );
}

// Geometric R/P/S glyphs are now provided by icons.jsx (load order matters
// — icons.jsx must come BEFORE this file). We re-export nothing for them;
// the GlyphRock/Paper/Scissors names are kept as backward-compat shims in
// icons.jsx so existing concept files keep working.

Object.assign(window, {
  StatusBar, HomeIndicator, PhoneShell,
});
