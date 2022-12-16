## Usage

Lets take a look at how to use `ImageKit.io`

### counter_cubit.dart

```dart
  ImageKit.io(
    file,
    privateKey: "PrivateKey", // (Keep Confidential)
    onUploadProgress: (progressValue) {
      if (kDebugMode) {
        print(progressValue);
      }
    },
  ).then((value) {
    // Get your uploaded Image file link from ImageKit.io
    //then save it anywhere you want. For Example- Firebase, MongoDB etc.
    if (kDebugMode) {
      print(value);
    }
  });
```