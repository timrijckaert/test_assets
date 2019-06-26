# test_assets

A small package that will help you to access your `assets/` folder during testing.  
Code was originally copied from the original [Github Issue](https://github.com/flutter/flutter/issues/12999#issuecomment-450677379).

## How to use?

```dart
Future<void> _pumpTag(final WidgetTester tester) async {
    await tester.runAsync(() => DiskAssetBundle.loadGlob(['fonts/**.ttf'])); //relative to your /assets folder
    return tester.pumpWidget(
      YourWidgetUnderTest()
    );
  }
```
