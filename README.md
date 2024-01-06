# gsy_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
****
## json_serializable generate

Once you have added the annotations to your code you then need to run the code generator to generate the missing .g.dart generated dart files.

```sh
dart run build_runner build
```

1. One-time code generation

```sh
dart run build_runner build --delete-conflicting-outputs
```

2. Generating code continuously

```sh
dart run build_runner watch --delete-conflicting-outputs
```
