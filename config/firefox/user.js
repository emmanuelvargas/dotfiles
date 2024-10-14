// TODO:
// https://github.com/pyllyukko/user.js/blob/master/user.js
// // Globally useful settings
// // You almost certainly want these
// //
// enable DRM (Netflix, Spotify, etc)
user_pref("media.eme.enabled", true);
// Disable useless warnings
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
// // Disable useless "features"

// disable translation popup
user_pref("browser.translations.automaticallyPopup", false);
// user_pref("extensions.pocket.enabled", false);
// /** Disables Pocket, the default browser extension that stores article/information between devices
// 	* -> Contains sponsord content by default
// 	*/
// user_pref("extensions.pocket.enabled", false);
// user_pref("extensions.pocket.onSaveRecs", false);
// user_pref("browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled", false);
// user_pref("browser.urlbar.suggest.pocket", false);
// user_pref("browser.urlbar.pocket.featureGate", false);
// user_pref("extensions.pocket.showHome", false);
// // Disable containers context menu
// user_pref("privacy.userContext.enabled", false);
// Increase connection count per-domain
// (Trust me you want this)
user_pref("network.http.max-persistent-connections-per-server", 64);
// Disable "you have unsent crash reports" popup that is bugged
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
// // Disable WebRTC popup
// user_pref("privacy.webrtc.legacyGlobalIndicator", false);
// user_pref("privacy.webrtc.hideGlobalIndicator", true);
// Allow many redirects
user_pref("network.http.redirection-limit", 50);
// Disable Ctrl-Q shortcut (*nix only)
user_pref("browser.quitShortcut.disabled", true);
// Disable "Recommended Addons"
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
// Disable startup welcome nag screen
user_pref("browser.aboutwelcome.enabled", false);
// Auto reject cookie banners
user_pref("cookiebanners.service.mode", 2);
// // Don't let websites prevent opening in pdfjs
// user_pref("browser.helperApps.showOpenOptionForPdfJS", true);
// user_pref("browser.download.open_pdf_attachments_inline", true);

// // // Privacy/Security settings
// // // You probably want these, but they may break particularly weird sites
// // //
// // HTTPS only mode
// user_pref("dom.security.https_only_mode", true);
// user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);
// // // Enable GPC (believe it or not, some sites respect this)
// // user_pref("privacy.globalprivacycontrol.functionality.enabled", true);
// // user_pref("privacy.globalprivacycontrol.enabled", true);
// // // Disable largely useless features that help trackers
// // user_pref("dom.battery.enabled", false);
// // user_pref("media.media-capabilities.enabled", false);
// // user_pref("dom.vr.enabled", false);
// // user_pref("dom.storageManager.enabled", false);
// // // Disable largely useless features that increase attack surface
// // user_pref("browser.uitour.enabled", false);
// // // It's slow, stalls your connection, and leaks sites you visit to CAs
// // // Websites that care about security are already stapling OCSP responses
// // user_pref("security.OCSP.enabled", 0);
// // user_pref("security.OCSP.require", false);
// // // CRLite: Does what OCSP does but good
// // user_pref("security.remote_settings.crlite_filters.enabled", true);
// // user_pref("security.pki.crlite_mode", 2);
// // // Broken TLS is unsafe
// // user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
// // user_pref("security.ssl.require_safe_negotiation", true);
// // // Always show punycode to avoid phishing
// // user_pref("network.IDN_show_punycode", true);

// // Personal settings
// //
// always ask for download directory
user_pref("browser.download.useDownloadDir", false);
// Force enable dark mode
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("browser.in-content.dark-mode", true);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
// Enable dark theme
user_pref("extensions.activeThemeID", "default-theme@mozilla.org");
// UI density "Normal"
user_pref("browser.uidensity", 0);
// Restore previous session on startup
user_pref("browser.startup.page", 3);
// Blank new tab page
user_pref("browser.newtabpage.enabled", false);
// Disable annoying backspace keybind
user_pref("browser.backspace_action", 2);
// Allow scripts to close their window
user_pref("dom.allow_scripts_to_close_windows", true);
// Disable popup blocker (never has blocked a popup, always gets in the way)
user_pref("dom.disable_open_during_load", false);
// Allow scripts to close the window (useful for kubelogin)
user_pref("dom.allow_scripts_to_close_windows", true);
// Disable separate title bar
user_pref("browser.tabs.drawInTitlebar", true);
// Disable middle click opening tab from clipboard
user_pref("browser.tabs.searchclipboardfor.middleclick", false);
// Disable "Quarantined Domains"
user_pref("extensions.quarantinedDomains.enabled", false);
// Disable top sites in URL bar recommendations
user_pref("browser.urlbar.suggest.topsites", false);
// Enable actually useful URL bar recommendations
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);
// Better scrolling
user_pref("apz.overscroll.enabled", true);
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", 2.0);
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
user_pref("general.smoothScroll.currentVelocityWeighting", 1.0);
user_pref("general.smoothScroll.stopDecelerationWeighting", 1.0);
user_pref("mousewheel.default.delta_multiplier_y", 300);

user_pref("network.security.ports.banned.override", "6000");
user_pref("identity.sync.tokenserver.uri", "http://192.168.0.100:6000/token/1.0/sync/1.5");


// PREF: Show HTTPS in the URL
user_pref("browser.urlbar.trimHttps", false);
// PREF: restore login manager
user_pref("signon.rememberSignons", true);
// PREF: restore Top Sites on New Tab page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", true); // Shortcuts
user_pref("browser.newtabpage.activity-stream.default.sites", ""); // clear default topsites
// PREF: remove sponsored content on New Tab page
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // Sponsored shortcuts 
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false); // Recommended by Pocket
user_pref("browser.newtabpage.activity-stream.showSponsored", false); // Sponsored Stories

// Disable recommendations in about:addons' Extensions and Themes panes [FF68+] ***/
user_pref("browser.discovery.enabled", false); // [SETTING] Privacy & Security>Firefox Data Collection & Use>...>Allow Firefox to make personalized extension recs.
user_pref("extensions.htmlaboutaddons.discover.enabled", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false); // Disable Extension recommendations ("Recommend extensions as you browse")
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false); // "Recommend features as you browse"
user_pref("extensions.webservice.discoverURL", "");
user_pref("extensions.getAddons.discovery.api_url", "");
user_pref("extensions.getAddons.showPane", false);
// Disable shopping experience [FF116+]
user_pref("browser.shopping.experience2023.enabled", false); // [DEFAULT: false]
// Disable sending crash reports 
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// Disable alerts about passwords breach
user_pref("signon.management.page.breach-alerts.enabled", false);
// Disable PingCentre telemetry (used in several System Add-ons) [FF57+]
user_pref("browser.ping-centre.telemetry", false);