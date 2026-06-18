# Go-Hurghada: An Intelligent Travel Booking & Tourism Ecosystem 🌴✈️

Go-Hurghada is a comprehensive, next-generation travel booking and tourism ecosystem designed specifically for the Red Sea resort hub of Hurghada, Egypt. The platform integrates a cross-platform mobile client, a web administration dashboard, and a secure backend server powered by generative AI.

---

## 🏛️ System Architecture

The project is structured as a monorepo containing:

1. **`go_hurghada-app/`**: Cross-platform mobile client built with **Flutter**.
2. **`admin-panel/`**: Central administrative dashboard built with **React & Node.js/Express.js**.
   * `admin-panel/client/`: React Web frontend interface.
   * `admin-panel/server/`: Node.js/Express.js backend server handling database operations and the AI agent loop.

---

## 🛠️ Technology Stack

| Component | Technologies Used |
| :--- | :--- |
| **Mobile App (Frontend)** | Flutter, Dart, Riverpod (State Management), Hive (Local Caching) |
| **Admin Panel (Frontend)** | React, Vite, Tailwind CSS, Axios, Lucide Icons |
| **Backend API Server** | Node.js, Express.js, Firebase Admin SDK |
| **Database & Auth** | Google Cloud Firestore (NoSQL), Firebase Authentication |
| **Artificial Intelligence** | Google Gemini API (`gemini-2.5-flash`), Structured Tool-Calling |
| **Payment Gateway** | PayMob Integration (with WebView redirection) |

---

## ✨ Key Features

### 1. Intelligent AI Travel Companion (Mobile)
* Powered by Google Gemini to translate natural language queries into automated database actions.
* Supports **colloquial Egyptian Arabic** and English seamlessly.
* Dynamically renders **interactive booking widgets** directly inside the chat feed for frictionless checkouts.

### 2. Real-Time Hotel & Room Reservation
* Concurrency protection via **Firestore Transactions** (optimistic locks) to prevent double-bookings during high traffic.
* Optimized multi-night searches using **parallel promise-based fetching routines** (`Promise.all()`) to minimize query latencies.

### 3. Flight Lookup & Excursion Bookings
* Direct search interface for domestic flights with secure redirection to official airlines (EgyptAir, Nile Air, Air Cairo).
* Curated catalog of localized Hurghada outdoor tours (Safaris, Sea Cruises) with real-time remaining capacity indicators.

### 4. Admin Dashboard & Availability Calendar
* Renders a real-time color-coded availability matrix: **Green** (Available), **Orange** (Almost Full ≤ 30%), **Red** (Fully Booked).
* Integrates a conversational **AI Admin Copilot Console** allowing operators to perform database operations (like blocking rooms for maintenance) using text commands.

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (for mobile app)
* [Node.js](https://nodejs.org/) (v16+ recommended, for backend & admin dashboard)
* Firebase Account with Firestore database initialized

---

### 📡 1. Running the Backend Server

1. Navigate to the server folder:
   ```bash
   cd admin-panel/server
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up your `.env` file containing:
   ```env
   PORT=5000
   FIREBASE_PROJECT_ID=your-project-id
   GEMINI_API_KEY=your-gemini-key
   ```
4. Place your Firebase `serviceAccountKey.json` inside `admin-panel/server/` directory.
5. Start the development server:
   ```bash
   npm run dev
   ```

---

### 💻 2. Running the Admin Dashboard (React Client)

1. Navigate to the client folder:
   ```bash
   cd admin-panel/client
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the Vite development server:
   ```bash
   npm run dev
   ```
4. Open your browser at [http://localhost:5173/](http://localhost:5173/)

---

### 📱 3. Running the Mobile App (Flutter Client)

1. Navigate to the mobile app folder:
   ```bash
   cd go_hurghada-app
   ```
2. Configure `.env` file containing:
   ```env
   BACKEND_URL=http://<your-local-ip>:5000
   GEMINI_API_KEY=your-gemini-key
   AMADEUS_API_KEY=your-amadeus-key
   AMADEUS_API_SECRET=your-amadeus-secret
   PAYMOB_API_KEY=your-paymob-key
   PAYMOB_INTEGRATION_ID=your-integration-id
   PAYMOB_IFRAME_ID=your-iframe-id
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
.
├── admin-panel/
│   ├── client/                  # React dashboard frontend
│   │   ├── src/
│   │   │   ├── components/      # Reusable UI widgets
│   │   │   └── pages/           # Dashboard, Bookings, Availability Calendar
│   │   └── package.json
│   └── server/                  # Node.js Express server
│       ├── routes/              # Booking, Availability, & AI assistant endpoints
│       ├── utils/               # Timezone-safe date helper functions
│       ├── index.js             # Main server entrypoint
│       └── package.json
│
├── go_hurghada-app/             # Flutter Mobile Client
│   ├── lib/
│   │   ├── core/                # Global services (API, Payment, Currency)
│   │   ├── config/              # App routing & theme definitions
│   │   └── features/            # Hotel, Flight, Activity, & AI chatbot features
│   └── pubspec.yaml
│
└── README.md                    # Project overview & guide
```
