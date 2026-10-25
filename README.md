TubeLens 🎬

Understand your YouTube performance. Make smarter content decisions.

TubeLens is a cross-platform YouTube analytics application built with Flutter. It aims to help creators explore video performance, compare videos, understand channel insights, and make data-driven content decisions through a modern analytics dashboard.

This repository contains the Flutter frontend for TubeLens.

✨ Features

- Cross-platform experience — Flutter interface for mobile and web.
- Video analytics — Explore video performance through the connected backend.
- Video comparison — Compare videos to identify performance differences.
- Creator insights — Visualize analytics to make content data easier to understand.
- Upload-time insights — Explore upload activity and suggested posting times.
- Modern dashboard — Search, navigation, and reusable analytics components.
- AI-powered analysis — Integrate analysis capabilities through the Python microservice.

Features depend on the current implementation and availability of the connected services.

🧰 Tech Stack

Layer| Technology
Frontend| Flutter, Dart
Backend API| Node.js, Express.js
Database| MongoDB Atlas
AI microservice| Python, Flask

🏗️ Architecture

TubeLens uses a modular architecture that separates the client, backend API, database, and AI analysis service.

Flutter Frontend (Web / Mobile)
              |
              v
      Node.js + Express
         /         \
        v           v
 MongoDB Atlas   Python + Flask
                 AI Analysis

- Flutter: Renders the user interface and communicates with the backend.
- Node.js and Express: Handle API requests and application logic.
- MongoDB Atlas: Stores application data.
- Python and Flask: Provide a separate service for AI-related analysis.

🚀 Getting Started

Prerequisites

- "Flutter SDK" (https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code
- A running TubeLens backend for API-dependent features

1. Clone the repository

git clone https://github.com/BilalKhalifa/tube_lens_frontend.git
cd tube_lens_frontend

2. Install dependencies

flutter pub get

3. Configure the backend

Configure the backend API URL according to the project's existing configuration.

Ensure the backend is running and reachable from your target device. When testing on a physical phone, you may need to use your computer's local network IP address instead of "localhost".

4. Run the application

Check available devices:

flutter devices

Run on a connected device:

flutter run

Run on Chrome:

flutter run -d chrome

🧪 Useful Commands

Command| Description
"flutter pub get"| Install dependencies
"flutter analyze"| Analyze Dart code
"flutter test"| Run automated tests
"flutter devices"| List available devices
"flutter build apk"| Build an Android APK
"flutter build web"| Build the web application

📁 Project Scope

This repository focuses on the TubeLens Flutter client. Backend routes, database configuration, and AI service implementation are maintained separately.

🛣️ Roadmap

Potential areas for continued development include:

- Expand video analytics and comparison capabilities.
- Improve channel performance visualizations.
- Refine upload-time recommendations.
- Enhance AI-generated insights.
- Improve responsiveness and cross-platform usability.
- Strengthen testing, error handling, and API integration.

👨‍💻 Author

Bilal Khalifa

- GitHub: "@BilalKhalifa" (https://github.com/BilalKhalifa)
- Repository: "tube_lens_frontend" (https://github.com/BilalKhalifa/tube_lens_frontend)

---

Built with Flutter 💙