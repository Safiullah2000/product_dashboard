# Product Dashboard (Flutter Web)

A **Product Dashboard** web application built with **Flutter Web** and **BLoC/Cubit** for state management.  
This app allows viewing, adding, editing, and filtering products with responsive design and modern UI.

---

## 🛠️ Libraries & Packages Used

| Library | Purpose |
|---------|---------|
| `flutter_bloc` | State management using Cubit/BLoC |
| `go_router` | Routing and navigation |
| `equatable` | Value equality for models and states |
| `flutter/material.dart` | UI components and Material 3 support |

## Clone the repository
1. Open your terminal and run:

  git clone https://github.com/Safiullah2000/product_dashboard.git
  cd product_dashboard

2. Install Flutter dependencies
    flutter pub get

3. Run the app in web mode
    flutter run -d chrome

## 🗂️ Folder Structure
lib/
├── core/
│ ├── theme/
│ │ ├── app_theme.dart
│ │ ├── theme_cubit.dart
├── features/
│ └── product/
│ ├── data/ # Repository and mock API / JSON data
│ ├── domain/ # Business logic (entities, use cases)
│ ├── models/ # Product model
│ ├── presentation/
│ ├── blocs/ # ProductCubit / BLoC
│ ├── pages/ # ProductListPage, ProductDetailsPage
│ ├── widgets/ # Reusable widgets (DataTable, forms, etc.)
└── main.dart

**Reasoning:**  
- **Feature-based structure** improves scalability and modularity.  
- Each feature contains its own **data, domain, presentation, and models**.  
- Core folder is for **shared functionality**, like theme or utilities.
