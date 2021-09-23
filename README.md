# Habit Run (FLUTTER 2.0.x)

### Setup hasura

Open README in hasura directory for setup.

### Edit config

`lib/common/graphql/config.dart` edit hasura's GraphQL Endpoint.  
For demo, we are using `https://habit-run-stag.herokuapp.com/v1/graphql`.

### Update key for MAP & facebook login

- `android/app/src/main/AndroidManifest.xml`

- `android/app/src/main/main/res/values/strings.xml`

### RUN

```
flutter clean

flutter pub get
```

For production flavor, run

``
flutter run -t lib/main.dart
``

### With
- [Flutter_bloc](https://bloclibrary.dev/#/)
