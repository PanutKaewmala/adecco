More information go to https://flutter.dev/docs/deployment/android

1. Put command to create keystore:
`keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`

2. Enter keystore password 2 times:
- `123Codium`

3. What is your first and last name?
- `Klaokamol Ruangtrakul`

4. What is the name of your organizational unit?
- `ahead`

5. What is the name of your organization?
- `codium`

6. What is the name of your City or Locality?
- `Pathum Wan`

7. What is the name of your State or Province?
- `bangkok`

8. What is the two-letter country code for this unit?
- `66`

9. Is CN=atthana p, OU=company, O=codium, L=thailand, ST=bangkok, C=66 correct?
- `y`

10. Modify local.properties as well with these 2 lines.

ndk.dir=/Users/admin/Library/Android/sdk/ndk/23.1.7779620 (use ndk last version form your android studio)
