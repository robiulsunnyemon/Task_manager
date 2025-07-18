
# AI Task Manager 📋

A smart Flutter-based task management app with priority sorting, statistics tracking, and offline support. Built with Material 3 design principles.

![App Screenshot](https://example.com/screenshot.png) <!-- Replace with actual screenshot URL -->

## Features ✨

- 🎯 **Task Management**: Create, edit, and delete tasks
- ⏰ **Deadline Tracking**: Set due dates with calendar picker
- 🔼 **Priority Levels**: Low/Medium/High priority tagging
- 📊 **Real-time Stats**: Completion progress and task analytics
- 🌗 **Dark/Light Mode**: System-aware theme switching
- 🔍 **Search & Filters**: Find tasks by keyword, priority, or category
- 📱 **Offline Support**: Local data persistence with SharedPreferences

## Tech Stack 🛠️

- **Flutter** (v3.x)
- **Dart** (v3.x)
- **SharedPreferences** (local storage)
- **intl** (date formatting)
- **Material 3** design system

## Installation ⚙️

1. **Clone the repository**:
   ```bash
   git clone https://github.com/robiulsunnyemon/Task_manager.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## Configuration ⚡

Add these permissions to `AndroidManifest.xml` for full functionality:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

## Folder Structure 📂

```
lib/
├── models/          # Data models (Task, Category, etc.)
├── screens/         # Main app screens
├── widgets/         # Reusable UI components
├── services/        # Business logic & storage
└── main.dart        # App entry point
```

## Contributing 🤝

Pull requests are welcome! For major changes, please open an issue first.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📜

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

