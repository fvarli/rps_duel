# Play Store launch package — v1.0.0

Everything an operator needs to fill out the Google Play Console submission for **RPS Duel** v1.0.0. Copy-paste the localized strings directly into the Play Console form fields.

For the technical release workflow (keystore, AAB build, signing verification) see [`release_android.md`](release_android.md). This file is the **listing copy**, not the build guide.

---

## 1. App identity

| Field | Value |
|---|---|
| **App name** (installed app label) | `RPS Duel` |
| **Store title** (Play Console listing) | `RPS Duel: Rock Paper Scissors` |
| **Package id** | `com.lunexa.games.rpsduel` |
| **Default language** | English (en-US) |
| **Category** | Games → Casual |
| **Tags / keywords** | `rock paper scissors, rps, casual game, offline game, duel, quick game` |
| **Contains ads?** | No |
| **In-app purchases?** | No |
| **Target audience** | 13+ (recommend "All ages" for content but use the audience step's actual age bands) |

---

## 2. Short description (≤80 chars, per locale)

> Play Console limit: 80 characters. All three are well under.

| Locale | Copy | Length |
|---|---|---|
| `en-US` | `Fast 30-second rock-paper-scissors vs CPU. Streaks, achievements, offline.` | 74 |
| `tr-TR` | `30 saniyelik taş-kağıt-makas. CPU'ya karşı çevrim dışı, hızlı oyun.` | 67 |
| `es-ES` | `Duelos de piedra-papel-tijera contra la CPU. Sin conexión, sin anuncios.` | 73 |

---

## 3. Full description (≤4000 chars, per locale)

### English (`en-US`)

```
RPS Duel is a clean, fast take on rock-paper-scissors — built for thirty-second moments. Tap your move, watch the CPU think, the result lands. That's the whole loop.

Why play
- 30-second rounds, designed for waiting in line, killing 5 minutes, or warming up your brain
- Three CPU difficulties: Easy, Normal, Hard
- Live scoreboard, current streak, best streak, win rate, last-five-rounds history
- Daily Challenge: a new objective each local day (e.g. win 3 with Scissors)
- Four achievements to collect — First Win, Streak 3, Scissors Specialist, 10 Rounds

Built with respect for your time and your device
- 100% offline — works on a plane, in a tunnel, anywhere
- No advertising
- No analytics, no third-party tracking
- No account or login required
- No in-app purchases
- All your data lives on your device (scores, history, language, difficulty, daily challenge, achievements). Uninstalling wipes it all.

Three languages
- English
- Türkçe (Turkish)
- Español (Spanish)

Switch in-app from Settings → Language. The UI adapts in real time.

Polished, tactile interface
- Material 3 design system
- Custom warm "Tactile Premium" theme — cream surfaces, sage and clay accents
- Light cross-fade and resize animations on every interaction

That's it. No fluff, no friction, no funnels. Tap. Reveal. Repeat.
```

### Türkçe (`tr-TR`)

```
RPS Duel — taş-kağıt-makas oyununun temiz ve hızlı bir yorumu. Otuz saniyelik anlar için yapıldı. Hamleni seç, CPU düşünürken izle, sonuç gelsin. Tüm döngü bundan ibaret.

Neden oynamalı
- Sırada beklerken, 5 dakika öldürürken veya beynini ısıtırken için tasarlanmış 30 saniyelik turlar
- Üç CPU zorluk seviyesi: Kolay, Normal, Zor
- Anlık skor tablosu, mevcut seri, en iyi seri, galibiyet yüzdesi, son beş turun geçmişi
- Günlük Görev: her yerel gün için yeni bir hedef (örn. Makas ile 3 galibiyet)
- Dört başarım: İlk Galibiyet, 3'lü Seri, Makas Uzmanı, 10 Tur

Zamanına ve cihazına saygıyla tasarlandı
- %100 çevrim dışı — uçakta, tünelde, her yerde çalışır
- Reklam yok
- Analitik yok, üçüncü taraf takip yok
- Hesap veya giriş gerekmez
- Uygulama içi satın alma yok
- Tüm verilerin cihazında kalır (skorlar, geçmiş, dil, zorluk, günlük görev, başarımlar). Uygulamayı kaldırınca hepsi silinir.

Üç dil
- İngilizce
- Türkçe
- İspanyolca

Uygulama içinden Ayarlar → Dil ile değiştir. Arayüz anında uyum sağlar.

Cilalı, dokunsal arayüz
- Material 3 tasarım sistemi
- Özel sıcak "Tactile Premium" tema — krem yüzeyler, adaçayı ve kil tonları
- Her etkileşimde hafif geçiş animasyonları

Hepsi bu. Doldurma yok, sürtünme yok, hunilere itme yok. Dokun. Aç. Tekrarla.
```

### Español (`es-ES`)

```
RPS Duel es una versión limpia y rápida de piedra-papel-tijera, hecha para los momentos de treinta segundos. Toca tu jugada, mira pensar a la CPU, el resultado llega. Ese es todo el ciclo.

Por qué jugar
- Rondas de 30 segundos, ideales para hacer cola, matar 5 minutos o calentar la mente
- Tres dificultades de la CPU: Fácil, Normal, Difícil
- Marcador en vivo, racha actual, mejor racha, porcentaje de victorias, historial de las últimas cinco rondas
- Reto diario: un objetivo nuevo cada día local (p. ej. ganar 3 con Tijera)
- Cuatro logros: Primera Victoria, Racha de 3, Especialista en Tijera, 10 Rondas

Hecho con respeto por tu tiempo y tu dispositivo
- 100% sin conexión — funciona en un avión, en un túnel, en cualquier lugar
- Sin publicidad
- Sin análisis, sin rastreo de terceros
- Sin cuenta ni inicio de sesión
- Sin compras dentro de la aplicación
- Todos tus datos viven en tu dispositivo (puntajes, historial, idioma, dificultad, reto diario, logros). Desinstalar lo borra todo.

Tres idiomas
- Inglés
- Türkçe (turco)
- Español

Cambia dentro de la app en Ajustes → Idioma. La interfaz se adapta al instante.

Interfaz pulida y táctil
- Sistema de diseño Material 3
- Tema cálido personalizado "Tactile Premium" — superficies crema, acentos salvia y arcilla
- Animaciones suaves de fundido y redimensionado en cada interacción

Eso es todo. Sin relleno, sin fricción, sin embudos. Toca. Revela. Repite.
```

---

## 4. Release notes — v1.0.0 (≤500 chars, per locale)

> Paste these into Play Console → Production release → "Release notes" for each locale.

### English (`en-US`)
```
First release. Play rock-paper-scissors vs CPU on Easy / Normal / Hard. Daily Challenge, four achievements, win streaks, full history. Three languages: English / Türkçe / Español. Fully offline, no ads, no tracking.
```

### Türkçe (`tr-TR`)
```
İlk sürüm. CPU'ya karşı Kolay / Normal / Zor seviyelerde taş-kağıt-makas. Günlük görev, dört başarım, galibiyet serileri, tüm geçmiş. Üç dil: İngilizce / Türkçe / İspanyolca. Tamamen çevrim dışı, reklamsız, takipsiz.
```

### Español (`es-ES`)
```
Primera versión. Juega piedra-papel-tijera contra la CPU en Fácil / Normal / Difícil. Reto diario, cuatro logros, rachas de victorias e historial completo. Tres idiomas: inglés / turco / español. Totalmente sin conexión, sin anuncios, sin rastreo.
```

---

## 5. Content rating notes

Pre-answers for the Play Console content-rating questionnaire (IARC). Expected output: **Everyone / PEGI 3 / ESRB E / USK 0**.

- Violence: **None.** The "duel" is an abstract rock-paper-scissors hand-game with no characters, no blood, no weapons.
- Sexual content: **None.**
- Profanity: **None.**
- Drugs / alcohol: **None.**
- Gambling: **None.** No simulated gambling, no loot boxes, no real-money mechanics, no random rewards purchased with currency.
- User-generated content: **None.** No chat, no profile, no messaging, no community features.
- Location sharing: **No.**
- Personal-info sharing: **No.**
- Digital purchases: **No.** No in-app purchases of any kind.

---

## 6. Data Safety form pre-answers

Every answer the Play Console Data Safety form asks for, pre-filled for this version. **Every answer is "No".**

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **No** |
| Does your app encrypt user data in transit? | N/A (no data collected or transmitted) |
| Do you provide a way for users to request that their data is deleted? | **Yes — all data is local on device. Users can wipe scores/history via Settings → Reset data, and uninstalling the app wipes everything else (language, difficulty, daily challenge, achievements).** |
| Does the developer commit to follow the Play Families Policy? | Not opting into Families (rating is "Everyone" but not Designed for Families program). |
| Has your app been independently validated against a global security standard? | **No** |
| Personal info collected? | **No** |
| Financial info collected? | **No** |
| Health and fitness info? | **No** |
| Messages collected? | **No** |
| Photos / videos collected? | **No** |
| Audio files collected? | **No** |
| Files and docs collected? | **No** |
| Calendar collected? | **No** |
| Contacts collected? | **No** |
| App activity collected? | **No** |
| Web browsing history collected? | **No** |
| App info and performance collected (crashes / diagnostics)? | **No** |
| Device or other IDs collected? | **No** |

Privacy policy URL field: paste the hosted URL of `docs/privacy_policy.md` (see [`privacy_policy.md`](privacy_policy.md) for hosting notes).

---

## 7. Screenshot capture checklist

Operator step. Capture on a real Android device or emulator. Recommended dimensions: 1080×1920 (portrait) or 1080×2400 to match modern phones. Aim for 4–8 phone screenshots; Play Console allows up to 8.

| # | Frame | What to show |
|---|---|---|
| 1 | Home / game idle | Initial state, score 0-0-0, three RPS buttons enabled. |
| 2 | CPU choosing | Mid-thinking beat (`cpuThinking` phase) — CPU side showing the thinking indicator. |
| 3 | Reveal / win state | A completed round with player win — both moves visible, score updated, "You win!" copy. |
| 4 | Settings sheet | Settings bottom sheet open, all four rows visible (Difficulty / Language / Reset data / About). |
| 5 | Difficulty picker | Difficulty picker sheet with the three options. |
| 6 | Daily Challenge + Achievements visible | Scroll position that shows the Daily Challenge card and the Achievements card together on one frame. |
| 7 | Turkish language UI | Same game screen as #1 or #3 but with the app set to Türkçe. |
| 8 | Spanish language UI | Same game screen as #1 or #3 but with the app set to Español. |

---

## 8. Feature graphic concept (1024×500)

Play Console requires a feature graphic for the listing header.

**Concept** (designer / operator implementation step — no asset committed):

- **Background:** Tactile Premium cream (`#F0E9D8`) with a subtle warm grain.
- **Left/center title block:**
  - Primary line: `RPS Duel` in a bold display weight, sage (`#5C7D44`).
  - Subtitle: `Rock Paper Scissors, reimagined` in a lighter weight, clay (`#A85A3B`).
- **Right side:** the three RPS tokens (circle for rock, rounded square for paper, scissors X) arranged in a loose triangle. Same minimalist white-on-color treatment as the launcher icon, but scaled up.
- **No screenshots inside the graphic** — keep it clean. Phone screenshots live in their own slot.
- **No store badges / no version numbers / no review quotes.**

The launcher icon palette and three-token mark come from `scripts/generate_app_icon.py` — reuse the same token shapes for visual consistency.

---

## 9. Pre-publish checklist

Operator checklist for the actual Play Console submission. Tick as you go.

- [ ] AAB built and verified upload-signed (see [`release_android.md`](release_android.md) §3-§4).
- [ ] Pasted short descriptions (EN/TR/ES) into Play Console.
- [ ] Pasted full descriptions (EN/TR/ES) into Play Console.
- [ ] Pasted v1.0.0 release notes (EN/TR/ES) into Play Console.
- [ ] Uploaded 4–8 phone screenshots (§7 above).
- [ ] Uploaded the 1024×500 feature graphic.
- [ ] Uploaded the 512×512 app icon (already generated for the launcher; reuse).
- [ ] Selected category Games → Casual.
- [ ] Filled in Content Rating questionnaire using the pre-answers in §5.
- [ ] Filled in Data Safety form using the pre-answers in §6.
- [ ] Hosted `docs/privacy_policy.md` at a public HTTPS URL and pasted the URL.
- [ ] Filled in contact email + website (Play Console requires both).
- [ ] Enrolled in Play App Signing on first upload.
- [ ] Reviewed the release in Internal Testing track before promoting to Production.
