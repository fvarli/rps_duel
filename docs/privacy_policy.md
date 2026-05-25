# RPS Duel — Privacy Policy

**Effective date:** TODO — fill in on the date you publish this policy.

## TL;DR

RPS Duel is an offline single-player game. It does not collect, transmit, or share any personal data. There is no account, no backend, no analytics, and no advertising.

## What we store on your device

Your gameplay preferences and progress are stored locally on your device using Android's standard app preferences storage (`shared_preferences`):

- Scores and round history
- Selected language
- Selected CPU difficulty
- Daily Challenge progress (today's objective and your progress on it)
- Unlocked achievements

This data **never leaves your device**. The app has no network code that uploads any of it anywhere.

## What we don't do

- No account creation
- No login
- No backend or remote servers
- No analytics or crash reporting
- No advertising
- No third-party tracking SDKs
- No location access
- No camera, microphone, or contacts access
- No in-app purchases
- No notifications

## Permissions the app requests

RPS Duel requests **no runtime permissions**. It needs no network access, no storage access beyond its own private app sandbox, no location, no camera, no microphone, no contacts, and no calendar.

## Clearing your data

You can clear your data at any time:

- **Scores and round history** can be wiped from inside the app: open **Settings → Reset data**.
- **Everything else** (language, difficulty, Daily Challenge progress, unlocked achievements) is wiped when you uninstall the app from your device.

## Children

This app is suitable for all ages and does not collect data from anyone, including children under 13. There are no profiles, no chat, no community features, and no personalized content.

## Changes to this policy

If this policy changes in a future version of the app, the updated version will replace this file in the project repository, and the **Effective date** at the top will reflect the change. There is no in-app mechanism to push policy changes because the app makes no network requests.

## Contact

TODO — add a contact email or website here before publishing. Google Play Console will not accept a policy URL without a working contact path. Examples: `support@<your-domain>` or a "Contact" page on your project website.

## Hosting

This file lives in the project repository at `docs/privacy_policy.md`. Before publishing on the Google Play Store, host it at a public HTTPS URL — for example:

- Push the file to a public GitHub repository and enable **GitHub Pages** for the `docs/` folder, then use `https://<your-username>.github.io/<repo>/privacy_policy.html`, or
- Paste the file content into a public **GitHub Gist** and use the gist's raw URL, or
- Publish it as a page on your project's website.

Paste that public URL into the Play Console listing under **Store presence → Main store listing → Privacy Policy**.
