# Mobile App (Flutter android, dart, kotlin)

## Task 1: Block users from seeing YouTube shorts, reels

### Works:
I have explored 4 avenues to block users from seeing YouTube shorts.

1. **VPN service:**
   - Tried to make an app with network layer level permission to monitor device-wide all traffics and control traffics based on keywords in URL.
   - Requires custom VPN using VpnService API, DNS control, HTTP/HTTPS header parsing.
   - Main uncertainty: HTTPS header parsing (e2e encrypted, may violate privacy policy).
   - Decision: Not continuing due to uncertainties.

2. **Accessing YT app UI:**
   - Making an app at the application layer that can run in the background.
   - Detect if YT app is running using UsageStatsManager.
   - Use Accessibility Service to detect YT app's UI element (e.g. shorts tab) and block it (e.g. SYSTEM_ALERT_WINDOW) + mute audio.
   - High uncertainty in detecting UI elements of a 3rd party app like YT.
   - Decision: Not committing time to it for now.

3. **Web view (successful):**
   - Initially tried URL parsing for finding words (e.g. YouTube, shorts).
   - m.youtube doesn't trigger a full page load. Shorts content likely loads dynamically.
   - Blocked Shorts page, Shorts tab, and Shorts section by removing related DOM elements using JS injection.
   - Note: Rarely, audio still plays in the background. May be solved by watching DOM using a setInterval function or working on device audio control. Skipped for now.

4. Future discussion:
   - Would like to discuss and learn more possibilities.

## Task 2: Prevent users from typing bad words, adult search, nasty messages

### Works:
- Explored NLP models' docs: TensorFlow.js toxicity, Hugging Face Transformers, Perspective API, OpenAI moderation API.
- OpenAI moderation API has better accuracy and is free, but likely down for all or some users.
- Decided to use Profanity Cleaner API after research.
- Feature implemented in the YouTube search bar:
  - Fast detection and removal of bad words without affecting typing fluidity.
  - Prevents action submission if a 'bad' search is detected.

## Task 3: Block users from uninstalling the app

### Works:
Explored 3 avenues to block users from uninstalling the app.

1. **Lock screen (successful):**
   - Created app as a device admin app.
   - Upon detecting revocation attempt of admin status, it locks the screen.
   - Makes it harder for unauthorized users to uninstall the app.

2. **Password prompt 1 (partially worked):**
   - Set up app password manager on native side using encrypted shared preferences.
   - Prompts for app password when `OnDisableRequested` function is called.
   - Works erratically and can be bypassed.
   - Decision: Remove implementation for app sanity.

3. **Password prompt 2:**
   - Attempted to detect specific settings page for device admin apps.
   - Goal: Create password screen over/before that page.
   - Couldn't make much progress.

### Related findings:
- Non-device admin apps cannot directly detect uninstallation attempts.
- Apps can register broadcast receiver for ACTION_PACKAGE_REMOVED intent (notifies after uninstallation, not during attempt).
- Android design prevents regular apps from intercepting their own uninstallation process (security feature).

### Future consideration:
Can a regular app have device owner status? Or is it likely a scenario in an enterprise level or system level app?