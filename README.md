# AI Voice Task Maker

AI Voice Task Maker is a Flutter app that uses voice commands and LLM (Large Language Model) integration to create, update, and delete tasks. The app allows users to manage their tasks via natural language and voice interaction, backed by Firebase and OpenAI.

---

## 🌟 Features

* **Voice Command Recognition**: Create, update, and delete tasks using your voice.
* **Natural Language Parsing**: Powered by GPT to understand and extract task details from speech.
* **Smart Task Matching**: Uses string similarity to match spoken titles with existing tasks.
* **Task Management**: Add, update, and delete tasks in a user-specific Firestore subcollection.
* **Modern UI**: Includes shimmer effects and loading states for a better user experience.

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/ai_voice_task_maker.git
cd ai_voice_task_maker
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

* Add your Firebase project.
* Add `google-services.json` for Android and `GoogleService-Info.plist` for iOS in their respective folders.

### 4. Configure environment variables

Create a `.env` file in the project root:

```
OPENAI_API_KEY=your_openai_key_here
FB_OPTIONS_KEY=your_Android_firebase_API_key_here
```

### 5. Run the app

```bash
flutter run
```

---

## 🧐 LLM Integration

The app uses OpenAI to convert spoken commands into actionable tasks:

1. Speech is converted to text via `speech_to_text`.
2. The text is sent to OpenAI's GPT model.
3. The response is parsed as JSON to extract:

   * `action` (create, update, delete)
   * `title`
   * `description`
   * `datetime`
4. The controller interprets and performs the appropriate task operation.

---

## 📊 State Management

The app uses **GetX** for reactive state management:

* Observables for reactive UI updates (`RxBool`, `RxList`)
* GetX Controllers for business logic and side effects
* Minimal boilerplate for clean architecture and testability

Example:

```dart
final isLoading = false.obs;

Obx(() => isLoading.value
  ? CircularProgressIndicator()
  : TaskListView());
```

---

## 📁 Code Structure

```
lib/
├─ controllers/
│  ├─ login_controller.dart
│  └─ task_controller.dart
├─ models/
│  └─ task_model.dart
├─ services/
│  ├─ auth_service.dart
│  ├─ firebase_service.dart
│  ├─ llm_service.dart
│  └─ speech_service.dart
├─ utils/
│  ├─ assets.dart
│  ├─ custom_colors.dart
│  ├─ permisson_manager.dart
│  ├─ task_logic.dart
│  └─ text_styles.dart
├─ views/
│  ├─ home_page.dart
│  ├─ login_page.dart
│  └─ splash_page.dart
├─ widgets/
│  ├─ empty_list.dart
│  ├─ shimmer_container.dart
│  ├─ shimmer_list.dart
│  ├─ shimmer_widget.dart
│  └─ task_card.dart
├─ firebase_options.dart
├─ headers.dart
├─ main.dart
└─ pages.dart
```

---

## 🚀 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

