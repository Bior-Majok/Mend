# Mend — Campus Incident Reporting App

A mobile application developed for African Leadership University (ALU) to enable students and staff to report and track physical and infrastructural incidents on campus (such as water shortages, power outages, damaged facilities, safety hazards, and sanitation issues).

**Author:** Bior Majok Aguer Kuir  
**Email:** b.aguerkui@alustudent.com  
**Course:** Mobile Application Development — Formative Assignment 2  
**Institution:** African Leadership University (ALU), Kigali, Rwanda  

---

## Features

- **Institutional Authentication:** Enforces registration and login with verified `@alustudent.com` and `@alueducation.com` email addresses.
- **Incident Reporting:** Submit reports with category selection (Facilities, Water, Electricity, Safety, Sanitation), title, description, location, and optional photo attachment.
- **Real-Time Status Tracking:** Track incidents across three lifecycle stages (`Submitted` → `In Progress` → `Resolved`) with a visual status timeline stepper.
- **Search & Filtering:** Search incidents by keywords and filter by category or status chips.
- **Role-Based Access Control (RBAC):**
  - **Students:** Can create reports, view all campus incidents, and delete their own reports.
  - **Staff:** Authorized campus staff can update incident statuses and attach operational resolution notes.
- **State Management:** Built using the Provider pattern with clean separation of presentation, business logic, and services.

---

## Tech Stack

- **Framework:** Flutter (Dart SDK ^3.13)
- **State Management:** Provider (`provider: ^6.1.2`)
- **Backend & Database:** Firebase Authentication, Cloud Firestore
- **Storage:** Firebase Storage (image uploads)
- **Image Picker:** `image_picker: ^1.2.4`

---

## Getting Started

### Prerequisites
- Flutter SDK (3.13+ recommended)
- Android Studio / VS Code with Flutter extension
- An Android/iOS mobile device or emulator

### Installation & Run

1. Clone this repository:
   ```bash
   git clone https://github.com/Bior-Majok/Mend.git
   cd mend
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. Run analyzer and tests:
   ```bash
   flutter analyze
   flutter test
   ```
