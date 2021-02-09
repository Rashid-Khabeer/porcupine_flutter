# porcupine_flutter

A Flutter Application for using the custom keywords in porcupine, picovoice

## Usage

Change Names with your ppn files
```dart
  final _firstAsset = Platform.isAndroid
      ? 'assets/ppn/first_android.ppn'
      : 'assets/ppn/first_ios.ppn';
  final _secondAsset = Platform.isAndroid
      ? 'assets/ppn/second_android.ppn'
      : 'assets/ppn/second_ios.ppn';
```
