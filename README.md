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
