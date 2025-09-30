# 📦 spen_remote

A Flutter plugin to integrate with the **Samsung S Pen Remote SDK**.  
This allows Flutter apps to respond to **S Pen button presses** and **air gestures** (remote controls), making it perfect for games, creative apps, and productivity tools.

---

## ✨ Features

- Connect/disconnect to Samsung S Pen Remote.
- Listen for **button events** (press/release).
- Listen for **air motion gestures** (dx/dy deltas).

⚠️ **Note**: Works only on Samsung devices that support S Pen Remote. On non-Samsung devices, the plugin will do nothing (safe fallback).

---

## Platform support

| Platform | Supported | Notes                                 |
| -------- | --------- | ------------------------------------- |
| Android  | ✅        | Samsung devices with S Pen Remote SDK |
| iOS      | ❌        | No-op implementation (safe fallback)  |
| Web      | ❌        | Not supported                         |
| Desktop  | ❌        | Not supported                         |

---

## 🚀 Getting Started

### 1. Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  spen_remote: ^0.0.1
```

No special Android permissions are required by the SDK itself.

---

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:spen_remote/spen_remote.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to S Pen Remote
  await SpenRemote.connect();

  // Listen for events
  SpenRemote.events.listen((event) {
    if (event.type == 'button') {
      print('Button action: ${event.action}');
      // e.g. if action == 0 -> press down
    } else if (event.type == 'motion') {
      print('Air motion dx=${event.dx}, dy=${event.dy}');
    }
  });

  runApp(const MyApp());
}
```

### SPenEvent (fields)

- **type** — `String`  
  `"button"` or `"motion"`
- **action** — `int?`  
  Button action code (only for `"button"`)
- **dx** — `double?`  
  Motion delta X (only for `"motion"`)
- **dy** — `double?`  
  Motion delta Y (only for `"motion"`)

## Example (game integration)

Simple example: use the S Pen button to fire, air motion to move a crosshair.

```dart
SpenRemote.events.listen((event) {
  if (event.type == 'button' && event.action == 0) {
    game.fire();
  } else if (event.type == 'motion') {
    game.moveCrosshair(event.dx ?? 0, event.dy ?? 0);
  }
});
```

Always provide a fallback to touch input for non-Samsung devices.

---

## Development

Clone and run the example app:

```bash
git clone https://github.com/yourusername/spen_remote.git
cd spen_remote/example
flutter pub get
flutter run
```

---

## Contributing

Contributions welcome — open an issue or PR :)

Some ideas:

- Add method for SingleTap, DoubleTap, LongPress.
- Adding Custom AirGesture.
