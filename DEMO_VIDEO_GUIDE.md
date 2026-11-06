# 🎥 7-10 Minute Demonstration Video Script & Checklist
**Course:** Formative Assignment 2: Campus Incident Reporting App (Mend)  
**Deliverable Requirement:** 7–10 minute demonstration video of the functional mobile application.

---

## Video Recording Checklist & Rubric Mapping

| Time | Workflow / Screen | Action & Talking Points | Rubric Alignment |
| :--- | :--- | :--- | :--- |
| **0:00 - 1:00** | **App Introduction & Architecture Overview** | • Introduce yourself (Bior Majok Aguer Kuir, Student ID, Program).<br>• Introduce **Mend**, the Campus Incident Reporting mobile app.<br>• Explain the clean layered architecture (UI, Provider State Management, Firebase Service layer). | UI/UX & Architecture (8 pts) |
| **1:00 - 2:30** | **User Authentication & Institutional Verification** | • Show the Login Screen.<br>• Demonstrate validation rejecting a non-ALU email (e.g. `test@gmail.com`).<br>• Show registration with ALU email (`@alustudent.com`).<br>• Explain institutional email verification.<br>• Log in as student **Amina Hassan** (`amina.hassan@alustudent.com`). | Firebase Auth (6 pts) |
| **2:30 - 4:00** | **Home Dashboard & Metrics** | • Tour the Home Dashboard matching the sample UI mockup.<br>• Highlight greeting ("Hello, Amina 👋"), the gradient banner "+ Report an Issue", and the 4 metric summary cards.<br>• Explain how Provider updates summary counts dynamically (`My Reports: 12`, `In Progress: 5`, etc.). | UI/UX & State Mgmt (8 pts) |
| **4:00 - 5:30** | **Submitting a New Incident Report** | • Tap "+ Report an Issue" (or center floating button).<br>• Select category (e.g. **Water** or **Electricity**).<br>• Enter Title: *"Burst pipe on 2nd Floor"*, Description, and select Location (*"Student Residence - 2nd Floor"*).<br>• Tap *"Tap to add photos"* and attach a photo (demonstrating Firebase Storage upload).<br>• Tap **Submit Report** and show success feedback! | Feature Implementation & Firebase CRUD (13 pts) |
| **5:30 - 7:00** | **Browsing, Searching & Filtering Incidents** | • Navigate to the **Reports** tab.<br>• Demonstrate **Search** by keyword (e.g., typing *"projector"* or *"water"*).<br>• Demonstrate **Status Filters** (*All*, *Submitted*, *In Progress*, *Resolved*).<br>• Demonstrate **Category Filters** (*Facilities*, *Sanitation*, etc.).<br>• Tap into an incident to display the **Incident Details** screen and the interactive **Status Timeline** stepper. | Feature Implementation (7 pts) |
| **7:00 - 8:45** | **Staff Workflows & Role-Based Access Control** | • Explain that students cannot alter status or resolve issues.<br>• Go to **Profile** and use the **Demo Role Switcher** to switch to **Campus Staff** (`estate.admin@alueducation.com`).<br>• Open the newly submitted report.<br>• Show the **Authorized Staff Controls** panel.<br>• Change status from **Submitted** to **In Progress**, add notes (*"Plumber dispatched with spare valve"*), and tap **Update Status**.<br>• Show the live timeline update reflected immediately! | Role-Based Access & CRUD (12 pts) |
| **8:45 - 10:00** | **Firebase Console Showcase & Conclusion** | • (Optional / Recommended): Briefly show Firebase Console (Authentication users list and Firestore `incidents` collection) to prove live backend persistence.<br>• Conclude with lessons learned and testing results (`flutter test` passing, 0 analyzer errors). | Technical Explanation (7 pts) |

---

## Quick-Fill Credentials for Demonstration
* **Student Account:**
  * **Email:** `amina.hassan@alustudent.com`
  * **Password:** `password123`
  * **Role:** Student (Computer Science, Kigali)
* **Staff Account:**
  * **Email:** `estate.admin@alueducation.com`
  * **Password:** `password123`
  * **Role:** Staff (Facilities & Operations)
