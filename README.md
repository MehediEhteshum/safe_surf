# Mobile App (Flutter android, dart, kotlin)

## Task 1: Block users from seeing YouTube shorts, reels

### Works:
I have explored 3 avenues to block users from seeing YouTube shorts.

1. **Web view (successful):**
   - Initially tried URL parsing for finding words (e.g. YouTube, shorts).
   - m.youtube doesn't trigger a full page load. Shorts content likely loads dynamically without causing an actual navigation event that the WebView is listening for.
   - Finally, blocked Shorts page, Shorts tab, and Shorts section by removing related DOM elements using JS injection.
   - Note: Rarely, audio still plays in the background. May be solved by watching DOM using a setInterval function or working on device audio control. Skipped for now.

2. **Custom VPN service:**
   - Tried to make an app with network layer level permission to monitor device-wide all traffics and control traffics based on keywords in URL.
   - Requires custom VPN using VpnService API, DNS control, HTTP/HTTPS header parsing.
   - Main uncertainty: HTTPS header parsing (e2e encrypted, may violate privacy policy).
   - Decision: Not continuing due to uncertainties.

3. **Accessing YT app UI:**
   - Making an app at the application layer that can run in the background.
   - Detect if YT app is running using UsageStatsManager.
   - Use Accessibility Service to detect YT app's UI element (e.g. shorts tab) and block it (e.g. SYSTEM_ALERT_WINDOW) + mute audio.
   - High uncertainty in detecting UI elements of a 3rd party app like YT.
   - Decision: Not committing time to it for now.

## Task 2: Prevent users from typing bad words, adult search, nasty messages

### Works:
- Explored NLP models' docs: TensorFlow.js toxicity, Hugging Face Transformers, Perspective API, OpenAI moderation API.
- OpenAI moderation API has better accuracy and is free (https://help.openai.com/en/articles/4936833-is-the-moderation-endpoint-free-to-use), but likely down for all or some users including me (https://community.openai.com/t/content-moderation-api-throwing-internal-server-errors/959809/4). I created its API client but it only throws server & quota errors, although it's free.
- **(Successful)** Then, decided to use Profanity Cleaner API instead after some research.
- Feature implemented in the YouTube search bar - (similarly, can be implemented in a chat/message box):
  - Fast detection (low latency) and removal of bad words without affecting typing fluidity.
  - Prevents submission results if a 'bad' search is submitted before detection due to API latency.

## Task 3: Block users from uninstalling the app

### Works:
Explored 4 avenues to block users from uninstalling the app.

1. **Lock screen (successful) - device admin app:**
   - Created app as a device admin app.
   - Upon detecting revocation attempt of its admin status by any user, it locks the screen.
   - Makes it harder for unauthorized users (e.g. children) to uninstall the app. Only the device owner can uninstall the app.

2. **Password prompt 1 (partially worked):**
   - Set up app password manager on native side using encrypted shared preferences.
   - Prompts for app password when `OnDisableRequested` function is called.
   - Works erratically and can be bypassed.
   - Decision: Removed this implementation for app sanity.

3. **Password prompt 2:**
   - I also tried to detect and secure the specific settings page (e.g. Settings -> Security -> ... -> Device Admin Apps -> (specific) Device Admin App page) so that I can create a password screen over/before that page. Couldn't make much progress.

4. **Device owner app:**
   - For test purpose, I made the app as a device owner app in the dev environment via adb commands. This makes the app completely uninstallable and with elevated privileges (as expected). ADB commands: `adb shell dpm set-device-owner com.example.safe_surf/.MyDeviceAdminReceiver` to set it as device owner, and `adb shell dpm remove-active-admin com.example.safe_surf/.MyDeviceAdminReceiver` to remove its device ownership. It can be tested on dev/debug environment.
   - However, in reality, this app might violate app platform policy, require factory reset or special provisioning of the device, and deployment to a private app store. Another solution may be Android Enterprise (https://www.android.com/enterprise/) - which might require special permission devices, enrollments, certifications, etc.

I can imagine some use cases of such an app. It would be interesting to get more insights on its implementation, use cases, etc.
For the purpose of this app, I think the first approach is fair enough.

### Related findings:
- Non-device admin apps cannot directly detect its uninstallation attempts.
- Apps can register broadcast receiver for ACTION_PACKAGE_REMOVED intent (notifies after uninstallation, not during attempt).
- By design, Android does not provide a way for regular + admin apps to prevent or intercept their own uninstallation process. This is a security feature to ensure users have control over the apps installed on their devices.
