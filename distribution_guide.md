# Distributing Your macOS App

Congratulations on building your System Monitor app! Distributing a macOS app involves a few choices, especially for system tools that require deep access to the OS.

## Option 1: Direct Distribution (Recommended for this App)
**Best for:** System tools, utilities, and apps that need broad permissions.

Because your app uses low-level APIs (`libproc`) to read process information, it conflicts with the **App Sandbox** requirement of the Mac App Store. The Sandbox prevents your app from seeing other running processes.

**Pros:**
*   Full functionality (Process Manager works perfectly).
*   No review process delay.
*   You keep 100% of revenue (if you charge).

**Cons:**
*   Users must download it from your website/GitHub.
*   Requires "Notarization" to avoid security warnings.

### Steps to Distribute Directly:
1.  **Apple Developer Account**: You need a paid membership ($99/year) to sign and notarize.
2.  **Hardened Runtime**:
    *   In Xcode, go to **Signing & Capabilities**.
    *   Ensure **Hardened Runtime** is added.
    *   Ensure **App Sandbox** is **REMOVED**.
3.  **Archive**:
    *   Select "Any Mac (Apple Silicon, Intel)" as the destination.
    *   Go to **Product > Archive**.
4.  **Distribute App**:
    *   Once archived, click **Distribute App**.
    *   Select **Direct Distribution** (or "Developer ID").
    *   Follow the prompts to **Upload** to Apple for Notarization.
    *   Once notarized (usually takes a few minutes), you can export the `.app` file.
5.  **Share**: Zip the `.app` file and upload it to your website or GitHub Releases.

---

## Option 2: Mac App Store
**Best for:** Maximum reach, trust, and simple installation.

**The Challenge:** The App Store **requires** App Sandbox. As you saw, enabling Sandbox breaks the Process Manager's ability to see other apps. To publish on the App Store, you would likely need to:
*   **Remove the Process Manager feature**, OR
*   Request a temporary entitlement exception (very difficult for general utilities), OR
*   Use significantly restricted APIs (which may not provide the data you want).

**Pros:**
*   Trusted by users.
*   Automatic updates.
*   Easy installation.

**Cons:**
*   **Sandboxing breaks your Process Manager**.
*   30% (or 15%) commission fee.
*   Strict review process.

### Steps to Submit to App Store (If you accept the limitations):
1.  **Enable Sandbox**: In Xcode > Signing & Capabilities, add **App Sandbox**.
2.  **Archive**: Product > Archive.
3.  **Distribute**: Select **App Store Connect**.
4.  **Submit**: Follow the prompts to upload and then fill out the listing details on [App Store Connect](https://appstoreconnect.apple.com).

## Summary Recommendation
For a "Task Manager" style app, **Direct Distribution** is the standard path (used by apps like iStat Menus, CleanMyMac, etc.) because it allows the app to actually function as intended without being crippled by the Sandbox.
