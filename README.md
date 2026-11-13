# EcoMind Parents

Flutter client for parent accounts. Debug and release builds use the public Azure backend
by default: `https://ca-ecomind-api.icybush-bd135296.westus2.azurecontainerapps.io`.

For local development, override the host at build time with
`--dart-define=API_BASE_URL=http://10.0.2.2:8092` (without `/api/v1` or a trailing slash).
Rebuild after changing the host. The API timeout includes the initial Azure cold start.

Password recovery starts from Sign in and handles the shared
`ecomind://authentication/reset-password` email handoff. Successful reset clears this
device's session. The existing server logout contract does not revoke other issued JWTs.

Run `flutter analyze`, `flutter test` and `flutter build apk --debug` to verify the client.
Live IAM tests use private fixture files; do not put passwords or reset links in build
arguments, logs or Git.

The Android integration harness is opt-in and skipped by default:

```bash
flutter test integration_test/password_reset_external_uri_receipt_test.dart -d <device> --dart-define=IAM_CONTROLLED_LINK=true
```

Use `IAM_LIVE=true` instead only when testing a real recovery-email request. Never set
both modes. Stage the private fixture as `flutter-live-fixture.json` in this app's
external files directory; it contains `email` and `newPassword`. While the harness
waits, deliver the approved link through Android's normal implicit `ACTION_VIEW`
handler. Controlled mode makes no email request. Keep the fixture and recordings
outside Git, then remove the staged fixture after testing.

On November 12 the normal debug APK built, analysis passed and 26 unit/widget tests
passed. The integration harness was analyzed but its separate Dart compilation
stalled locally before test execution; no harness runtime pass is claimed. The
installed normal APK was checked separately through Android SDK instrumentation.

### Recovery connection failures

The reset form retains a random confirmation identifier for an unchanged submission. Only
confirmation requests retry once after a transport or server failure, within the existing
120-second budget. The backend acknowledges the original change without consuming the link
again. Exhausted retries show an unconfirmed result and clear the old local session; they do
not claim that the password stayed unchanged. Editing the password starts a new confirmation.
Diagnostics contain only exception type, HTTP status and elapsed time.

The opt-in lost-response check requires a private `flutter-live-fixture.json` in the app's
internal `files` directory, with `email`, `newPassword` and `recoveryLink` for an owned test account.
It creates `files/recovery-test-ready`, then waits up to 90 seconds for the fixture. Stage it
through `adb exec-in run-as pe.greenminds.ecomind_parents` with mode 0600 and an atomic rename;
this avoids external-storage permissions. The harness removes the file immediately after reading it.
It forwards the real request, drops the first successful response, verifies the matching retry
and signs in with the new password. It does not send a recovery email itself.

```sh
flutter test integration_test/password_reset_lost_response_test.dart -d <device> --dart-define=IAM_LOST_RESPONSE=true
```

Remove the fixture after the check. Never pass passwords or recovery links as build defines.
