# Product audit — RPS Duel

> Audit date: 2026-05-27. Audited against the v1.0.1+2 closed-testing build (the version live on the Play Console internal track at the time of audit). Outputs of this audit drove the v1.0.2+3 polish pass.

## Audit method

Read-only review of every file under `lib/`, the three ARB locale files, the AndroidManifest, `values/styles.xml` + `values-night/styles.xml`, `pubspec.yaml`, `android/app/build.gradle.kts`, and the full `test/` tree. iOS / web / Linux platform code was not in scope. No runtime profiling — Flutter DevTools traces and a real-device timeline were not collected.

The audit covered ten dimensions: replay UX, button hierarchy, gameplay state clarity, animation rough edges, safe area / notch, tablet / responsive layout, unnecessary rebuilds, startup path, haptic feedback, image / asset usage.

---

## Findings

### F1. No haptic feedback anywhere in `lib/` — addressed in 1.0.2

Severity: addressable now (high impact, zero risk).

`grep -r 'HapticFeedback\|Vibration\|SystemSound' lib/` returned zero matches. For a game whose brand theme is "Tactile Premium," the lack of tactile feedback on the primary action (move tap) and the moment of greatest player attention (result reveal) is the clearest gap.

Action: `lib/ui/haptics.dart` wrapper added; `MoveButton.onPressed` fires `Haptics.tap()`, `GameScreen._handleStateChanged` fires `Haptics.win/loss/tie` on transition into `DuelPhase.reveal`. Wrapped in a small class so a future settings toggle ("disable haptics") has one place to land.

### F2. Player-selected and CPU-thinking phases share one widget — investigated, no action

Severity: minor (false alarm from initial pass).

`GameScreen._phaseChild` at `lib/ui/game/game_screen.dart:75-97` renders the same `Text(l10n.phaseThinking)` for both `DuelPhase.playerSelected` and `DuelPhase.cpuThinking`. The initial framing assumed both phases would show ambiguous "Thinking..." text — but the actual locale strings already attribute it to the CPU:

| Locale | `phaseThinking` |
|---|---|
| en | `CPU is choosing…` |
| tr | `CPU seçiyor…` |
| es | `La CPU está eligiendo…` |

Additionally, the `playerSelected` → `cpuThinking` transition is sub-frame: the controller emits `playerSelected` and then arms a `Future.delayed(cpuThinkingDelay)` whose completion sets `cpuThinking`. The user sees one continuous "CPU is choosing" string for ~500 ms, not a flicker of ambiguous text. **No action needed.** Findings kept here only so a future audit doesn't re-flag it.

### F3. `_ScoreCard` and `MoveButton` not called as `const` — investigated, no action

Severity: minor (false alarm).

Both widgets define `const` constructors, but their actual call sites use runtime values:
- `_ScoreCard(label: l10n.scoreLabelPlayer, value: state.playerScore)` — `l10n` from `AppLocalizations.of(context)`, `value` from controller state. Neither is a compile-time constant.
- `MoveButton(emoji: '🪨', label: l10n.moveRock, onPressed: isIdle ? () => _select(MoveChoice.rock) : null)` — runtime closure and runtime conditional.

The `const` keyword cannot be applied. Existing `const SizedBox`, `const Icon`, `const Padding`, `const ValueKey` instantiations throughout `game_screen.dart` are already optimal. **No action needed.**

### F4. Layout shift under "Next Round" button — addressed in 1.0.2

Severity: addressable now (low risk, visible polish).

`game_screen.dart` previously used `if (isReveal) ...[Button, SizedBox(8)]` between the move row and Reset Game. When `isReveal` flipped, the Reset Game button jumped ~56 px vertically. Reset Game now sits at the same offset in both states; the slot above it is always reserved (`SizedBox(height: 56)` with the button as its child only during reveal).

### F5. `LocaleStorage.open()` blocks first frame — deferred

Severity: defer.

`lib/main.dart` awaits `LocaleStorage.open()` before `runApp()`. In principle this delays first paint; in practice `shared_preferences.getInstance()` + a single `getString` on a modern device is sub-frame. Deferring would require restructuring the locale source into a `FutureBuilder` root and accepting a brief locale flash, which is worse for users than the current implementation. **Defer until / unless real cold-start telemetry shows it matters.**

### F6. No landscape variant, no edge-to-edge cutout — deferred

Severity: defer.

`AndroidManifest.xml` does not lock orientation, but the game screen uses `ConstrainedBox(maxWidth: 460)` and offers no landscape-specific layout. The default `windowLayoutInDisplayCutoutMode` is in effect, so the app does not draw under notches.

Both choices are intentional in the current visual direction (portrait phone-first, safe area respected). Edge-to-edge + cutout `shortEdges` would change the visual identity slightly; landscape would require a second composition. **Defer to a future visual-direction phase.**

### F7. AAB is not minified — deferred

Severity: defer.

`android/app/build.gradle.kts` does not set `minifyEnabled` or `proguardFiles`. The release AAB is ~41.7 MB. R8 + Flutter plugin interactions are notoriously brittle (reflection in plugins, missing keep rules) and the size win for an app of this scope is modest. **Defer until a future audit specifically scoped to bundle-size optimization with regression coverage.**

---

## What was clean (no findings)

- **Safe area handling** — `SafeArea` wraps the game screen (`game_screen.dart:272`) and every bottom sheet (`settings_sheet.dart:20`, `difficulty_picker_sheet.dart:24`, `language_picker_sheet.dart:21`). No notch / gesture-zone conflict.
- **Button hierarchy** — primary move buttons (96 px, `FilledButton` with full theme treatment), secondary action buttons (48 px tonal/outlined). Visual emphasis is clearly differentiated. No competing CTAs.
- **Animation timing** — `AnimatedSize` 220 ms + `AnimatedSwitcher` 220 ms on the duel surface; `AnimatedSwitcher` 180 ms on score digits. Curves match the rest of the app. No frame drops observed during widget tests.
- **Image weight** — zero `Image.asset`, `AssetImage`, `Lottie`, or `Rive` references in `lib/`. UI uses emoji and Material icons. Nothing to optimize.
- **AndroidManifest config-changes** — `orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode` is comprehensive; the app handles rotation and locale change without re-creating the activity.

---

## Polish opportunities ranked

| Rank | Finding | Impact | Risk | Effort | Disposition |
|---|---|---|---|---|---|
| 1 | F1 — haptics | High (brand fit) | Zero | XS | Shipped in 1.0.2 |
| 2 | F4 — layout shift | Medium (visible) | Low | XS | Shipped in 1.0.2 |
| 3 | F6 — edge-to-edge / landscape | Medium | Medium | M | Deferred — visual-direction adjacent |
| 4 | F7 — R8 / minify | Low (size) | High | L | Deferred — needs regression coverage |
| 5 | F5 — deferred locale load | Low (cold-start) | Medium | S | Deferred — sub-frame in practice |

---

## Verification

The 1.0.2 changes were verified by:
- `flutter analyze` — 0 issues.
- `flutter test` — 73/73 passing (no test text needed adjustment after the changes).
- Visual diff on the layout-shift fix — Reset Game now sits at a constant vertical offset in both idle and reveal states.

Haptics fire via platform channel and are not asserted in widget tests; in-tester hand-verification on a physical Android device is the appropriate check (see `play_store_closed_test_plan.md` for the test script).
