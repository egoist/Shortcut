# Shortcut

A menubar app that displays shortcuts for current open app. (__it works for every app!__)

__Note: this is my first native Mac app, the code is pretty messy!__

And what I've learnt so far:

- Interface builder and storyboard are not my jam.
- Swift UI is awesome but not mature enough! Especially for macOS apps, many UI components are missing (but you can always use `NSViewRepresentable` to connect `NSView` to your Swift UI interface).
- Electron is [actually not a bad idea](https://jlongster.com/secret-of-good-electron-apps).

So why I'm using Swift UI now?

- I like apps with native UI controls.
- Smaller package size.

## Preview

<img src="https://user-images.githubusercontent.com/8784712/75779219-30978200-5d94-11ea-8f59-4ef4b4d3bffc.png" width="300" alt="preview">

## TODO

Help wanted:

- [ ] Add auto-updater
- [ ] Add app icon
- [ ] Refactor the code

## Download

[Releases](https://github.com/egoist/Shortcut/releases)

## Development

```bash
pod install
open Shortcut.xcworkspace
```

## License

MIT.