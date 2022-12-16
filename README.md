![Logo](https://ik.imgkit.net/ikmedia/logo/light_T4buIzohVH.svg)

## Usage

Lets take a look at how to use [ImageKit.io](https://imagekit.io/) Flutter Package.

```dart
  ImageKit.io(
    file,
    privateKey: "PrivateKey", // (Keep Confidential)
    onUploadProgress: (progressValue) {
      if (kDebugMode) {
        print(progressValue);
      }
    },
  ).then((String url) {
    // Get your uploaded Image file link from ImageKit.io
    //then save it anywhere you want. For Example- Firebase, MongoDB etc.
    if (kDebugMode) {
      print(url);
    }
  });
```

## License

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
