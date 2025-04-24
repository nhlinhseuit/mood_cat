# Weather Flutter App

## About

## A simple Mood Cat app built with **Flutter**.

## Developer

**Nguyễn Hoàng Linh**

---

## State Management

- **BLoC (flutter_bloc)** is used for state management to ensure separation between UI and business logic.

---

## Architecture

The project follows **Clean Architecture** principles:

- **Data Layer**: handle data models, repositories, remote sources
- **Domain Layer**: define business logic and repository interfaces
- **Presentation Layer**: manage UI, blocs, and widgets

---

## Project Structure

---

## Libraries Used

| Package            | Purpose                       |
| ------------------ | ----------------------------- |
| flutter_bloc       | BLoC pattern (business logic) |
| bloc               | Core bloc package             |
| dio                | Networking (API calls)        |
| freezed_annotation | Data classes (models)         |
| json_annotation    | JSON serialization            |

---

## Technical Approach

- **Clean Architecture**: Apply feature first. Clear separation between Data, Domain, and Presentation.
- **BLoC Pattern**: Reliable state management across the app.
- **Freezed + JSON Annotation**: Immutable models and easy API response parsing.

---

## Running Tests

- Unit tests and Bloc tests are written under the `test/` folder.
- Run tests using:
  ```bash
  flutter test
  ```

---

## How to Run

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
dart run build_runner build
flutter run
```

Lưu ý: Mỗi lần build lại code thì phải vào đây sửa lại vì lỗi kh tự động có toJson

Map<String, dynamic> _$MoodDataToJson(_MoodData instance) => <String, dynamic>{
      'mood': instance.mood,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'user': instance.user.toJson(),
      'createdAt': instance.createdAt,
    };

---
