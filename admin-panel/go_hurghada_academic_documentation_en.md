# EELU | THE EGYPTIAN E-LEARNING UNIVERSITY
## Faculty of Computers & Information Technology

---

# Go-Hurghada: An Intelligent Travel Booking and Tourism Ecosystem
## Graduation Project Technical Documentation

**By:**
*   Ahmed Nagy (Project Lead & Backend Engineer)

**Supervised by:**
*   Dr. Mayar Ali (Academic Supervisor)
*   Eng. Mohamed Gamal (Mentor)

**Asyut Center - 2026**

---

## Abstract
In the contemporary era of digital transformation, the tourism sector stands as one of the most prominent domains requiring seamless integration of modern web and mobile services. The "Go-Hurghada" travel booking and tourism ecosystem is a comprehensive solution designed to address the fragmented nature of traditional tourism applications by consolidating essential travel services into a single, unified platform. Specifically tailored for Hurghada, Egypt—one of the Red Sea's premier tourist hubs—the ecosystem enables users to manage hotel reservations, explore domestic flights, book desert safaris and sea excursions, and interact with a highly localized AI Travel Companion. 

The front-end client is built utilizing the Flutter framework to deliver a native cross-platform experience, utilizing Riverpod for state management. The web administration console is developed using React, Vite, and Tailwind CSS, offering administrators real-time analytical capabilities and database controls via Firestore real-time listener bindings. The backend infrastructure is structured using Node.js and Express.js, featuring an advanced tool-calling routing agent powered by the Google Gemini API (`gemini-2.5-flash`). This AI agent translates colloquial Egyptian Arabic and English queries directly into database actions, resolving complex, multi-step requests dynamically. To prevent issues such as double-bookings under high concurrent reservation traffic, the system implements optimistic transactional locks through Firestore Transactions. 

Furthermore, to optimize resource efficiency and search speed, a parallel promise-based fetching routine handles multi-night occupancy queries. Performance evaluation shows that the system achieves screen navigation latencies under 0.5 seconds, database search speeds under 0.3 seconds, and AI chat response loop times within 2 to 3 seconds, all while ensuring transactional accuracy. By bridging the gap between localized travel planning, real-time database transactions, and generative AI interfaces, Go-Hurghada establishes a robust foundation for next-generation, conversational tourism ecosystems.

---

## Acknowledgement
At the outset, we humbly express our deepest gratitude to God Almighty for granting us the strength, resilience, and perseverance required to successfully complete this graduation project and reach this academic milestone.

We extend our sincere appreciation to the Egyptian E-Learning University (EELU) and the Asyut Center for providing us with a strong academic foundation, modern facilities, and a supportive educational environment that fostered our analytical and technical development.

Our heartfelt gratitude goes to our project supervisor, Dr. Mayar Ali, whose expert guidance, critical reviews, and constructive feedback were pivotal in defining the direction of this project. Her mentorship has been an invaluable asset throughout our academic journey. We are also immensely grateful to Eng. Mohamed Gamal for his continuous technical support, patience, and dedication in guiding us through the complexities of system architecture, implementation, and deployment.

Finally, we reserve our deepest and most sincere thanks for our families. Their unconditional love, constant encouragement, sacrifices, and unwavering belief in our potential have been the cornerstone of our success. To everyone who contributed directly or indirectly to the completion of this graduation project, we offer our warmest and most sincere thank you.

---

## Table of Contents

```text
Chapter 1: Introduction........................................................................7
    1.1 Introduction...........................................................................8
    1.2 Background and Motivation.............................................................10
        1.2.1 Tourism Context in Egypt........................................................10
        1.2.2 Technical Evolution of Tourism Systems..........................................10
    1.3 Importance of the Problem Being Addressed.............................................12
        1.3.1 Problem Statement...............................................................12
    1.4 Objectives............................................................................13
        1.4.1 Main Objective..................................................................13
        1.4.2 Specific Objectives.............................................................13
    1.5 Proposed Solution.....................................................................14
Chapter 2: Literature Review / Related Work...................................................15
    2.1 Related Work Review...................................................................16
        2.1.1 Booking.com.....................................................................16
        2.1.2 Skyscanner......................................................................17
        2.1.3 TripAdvisor.....................................................................18
    2.2 Gaps in Current Solutions.............................................................19
    2.3 Summary...............................................................................20
Chapter 3: UI/UX Design.......................................................................21
    3.1 Design Process........................................................................22
    3.2 Prototype and Wireframes..............................................................23
        3.2.1 Splash Screen...................................................................23
        3.2.2 Register Page...................................................................24
        3.2.3 Login Page......................................................................24
        3.2.4 Home Screen.....................................................................25
        3.2.5 Categories Page.................................................................26
        3.2.6 Flights Search Category Page....................................................26
        3.2.7 Hotels Booking Category Page....................................................27
        3.2.8 Activities Category Page........................................................28
        3.2.9 AI Chat Companion Screen........................................................29
        3.2.10 Profile Page...................................................................30
        3.2.11 Web Admin Panel - Dashboard Screen.............................................31
        3.2.12 Web Admin Panel - Hotels CRUD Screen...........................................32
        3.2.13 Web Admin Panel - Activity CRUD Screen.........................................33
        3.2.14 Web Admin Panel - Availability Calendar Screen.................................34
        3.2.15 Web Admin Panel - AI Copilot Screen............................................35
Chapter 4: Proposed System....................................................................36
    4.1 System Approaches and Architecture....................................................37
    4.2 Use Case Diagram & Descriptions.......................................................38
    4.3 Sequence Diagram & Interaction Flows..................................................39
    4.4 Entity Relationship Diagram (ERD) & Database Schema...................................41
    4.5 Activity Diagram & Class Diagram......................................................42
    4.6 Algorithms and Frameworks.............................................................43
Chapter 5: System Implementation & Technical Details..........................................44
    5.1 Technologies, Tools, and Programming Languages........................................45
        5.1.1 Frontend Stack..................................................................45
        5.1.2 Backend and Database Stack......................................................46
        5.1.3 Artificial Intelligence Integration.............................................46
    5.2 Key Components of the System..........................................................47
    5.3 Technical Challenges Faced and Resolutions............................................48
Chapter 6: Testing & Evaluation...............................................................49
    6.1 Testing Strategies....................................................................50
        6.1.1 Unit Testing....................................................................50
        6.1.2 Integration Testing.............................................................51
        6.1.3 User Acceptance Testing.........................................................52
    6.2 Performance Metrics and Results.......................................................53
    6.3 Comparison with Existing Solutions....................................................54
Chapter 7: Results & Discussion...............................................................55
    7.1 Summary of Findings...................................................................56
    7.2 Interpretation of Results.............................................................57
    7.3 Limitations of the Proposed Solution..................................................58
Chapter 8: The Role and Importance of Artificial Intelligence (AI) in the Ecosystem...........59
    8.1 Introduction to Cognitive Computing in Modern Tourism.................................60
    8.2 Artificial Intelligence Agent Architecture............................................60
    8.3 Tool-Calling Mechanism and Database Integration.......................................61
    8.4 Express.js Multi-Turn Agentic Loop....................................................61
    8.5 Dynamic Client-Side Widget Rendering (Flutter)........................................62
    8.6 Conversational Web Administration Copilot (React).....................................62
Chapter 9: Conclusion.........................................................................63
    9.1 Summary of Contributions..............................................................64
    9.2 Architectural Insights & Lessons Learned..............................................65
    9.3 Broader Impact & Future Research......................................................66
Chapter 10: Future Work.......................................................................67
    10.1 Future Work Recommendations..........................................................68
Chapter 11: Appendices........................................................................69
    11.1 Codes................................................................................70
        11.1.1 Frontend Codes.................................................................70
            11.1.1.1 Flutter AI Dynamic Widget Chat Renderer..................................70
            11.1.1.2 Flutter Riverpod StateNotifier for Reservation Lifecycle Management......71
            11.1.1.3 Flutter Paymob WebView Redirection Callback Parser.......................72
            11.1.1.4 React Web Admin Panel Real-Time Availability Calendar Screen.............73
            11.1.1.5 React Web Admin Panel AI Copilot Console and Formatting Engine...........74
        11.1.2 Backend Codes..................................................................75
            11.1.2.1 Express.js Backend Firestore Concurrency Control Booking Transaction.....75
            11.1.2.2 Express.js Backend Firestore Concurrency Control Cancellation Handler....76
            11.1.2.3 Express.js Backend Parallel Multi-Night Availability Fetcher.............76
            11.1.2.4 Express.js Backend Administrator Authentication and Access Verification Middleware.77
        11.1.3 AI Codes.......................................................................78
            11.1.3.1 Google Gemini AI Agent Tool Definitions and Schema Declaration...........78
            11.1.3.2 Google Gemini AI Tool Execution and Firestore Database Integration.......79
            11.1.3.3 Google Gemini AI Concierge System Instruction and Dialect Adaptation.....80
            11.1.3.4 Express.js Backend Google Gemini Agentic Multi-Turn Tool-Calling Loop....81
    11.2 System Configurations................................................................82
Chapter 12: References........................................................................83
    12.1 References...........................................................................84
```

---

## List of Figures
*   Figure 3.1: Splash Screen and User Landing Layout
*   Figure 3.2: Mobile Client Home Search and Filters
*   Figure 3.3: Mobile AI Chat Travel Companion Screen
*   Figure 3.4: Web Admin Panel - Analytical Dashboard
*   Figure 3.5: Web Admin Panel - Availability Calendar Screen
*   Figure 3.6: Web Admin Panel - AI Copilot Console
*   Figure 4.1: Use Case Diagram for Go-Hurghada System
*   Figure 4.2: Sequence Diagram of the Booking Checkout Flow
*   Figure 4.3: Entity Relationship Diagram (ERD) Schema
*   Figure 4.4: Firestore NoSQL Document Mapping Schema
*   Figure 4.5: System Activity Diagram for Reservation Processing
*   Figure 4.6: Client-Side Riverpod and Model Class Diagram

---

# Chapter 1: Introduction

## 1.1 Introduction
The travel and tourism industry is a vital pillar of the global economy, contributing trillions of dollars to the global Gross Domestic Product (GDP) and driving employment and infrastructural growth across both developed and developing nations. Over the past two decades, the rapid expansion of mobile technology, high-speed internet, and cloud infrastructure has profoundly transformed the way travelers plan, book, and experience their trips. Traditional methods of booking travel—which relied heavily on manual travel agents, physical ticket offices, and fragmented telephone inquiries—have been almost entirely replaced by Online Travel Agencies (OTAs), digital scheduling interfaces, and real-time mobile booking applications. Modern travelers now expect seamless, on-demand, and centralized access to all aspects of their itineraries, from accommodations and transportation to local activities and excursions.

Despite these advancements, the digital tourism landscape remains significantly fragmented, particularly when applied to localized regional destinations. Travelers wishing to visit a specific city often find themselves forced to juggle multiple applications: one for booking hotel rooms, another for comparing domestic airline schedules, a third for securing tickets to marine or safari excursions, and various messaging platforms to communicate with local coordinators. This fragmentation not only degrades the user experience by increasing cognitive load but also introduces significant scheduling inefficiencies, transaction vulnerabilities, and coordination errors. 

The "Go-Hurghada" travel booking and tourism ecosystem was conceived and developed to address these limitations. It provides a unified, intelligent, and highly localized solution tailored specifically for Hurghada, Egypt—one of the Red Sea's premier resort hubs. The ecosystem integrates three primary components: a cross-platform mobile client built with Flutter, a real-time web administration panel built with React, and a secure Node.js/Express.js backend server. At the core of the user experience is an intelligent, conversational Travel Companion powered by the Google Gemini API (`gemini-2.5-flash`), which allows users to interact with the platform using natural language in both English and colloquial Egyptian Arabic. The backend translates these conversations into structured database transactions, bringing interactive checkout widgets directly into the chat feed to simplify the booking process. Furthermore, the architecture addresses critical engineering challenges such as double-booking prevention through optimistic Firestore transactions and search performance optimization through parallel promise-based fetching routines.

Ultimately, Go-Hurghada serves as a model for next-generation, AI-driven tourism platforms, demonstrating how conversational interfaces, real-time database locks, and unified architectures can modernize local tourism economies. By bridging the gap between localized travel planning, real-time transactions, and generative AI, this system provides tourists with a cohesive travel experience and offers administrators a powerful tool to manage local inventories and monitor operations.


## 1.2 Background and Motivation

### 1.2.1 Tourism Context in Egypt
Egypt’s tourism sector is a vital source of national income and foreign currency. Hurghada, located on the Red Sea coast, has grown from a fishing village into a major international resort destination. It attracts millions of tourists annually for marine activities (e.g., diving, snorkeling), desert safaris, and beach resorts. 

Despite its popularity, the local tourism market is fragmented. Hotels, domestic airlines, and safari coordinators operate on separate systems. Tourists are forced to manage bookings across multiple platforms. This service fragmentation can lead to scheduling conflicts and higher transaction fees. Local excursion operators, such as Bedouin safari coordinators, often lack access to mainstream Online Travel Agencies (OTAs), making it difficult for tourists to book their services directly.

### 1.2.2 Technical Evolution of Tourism Systems
Tourism technology has evolved through several stages:
*   **Centralized Reservation Systems (CRS)**: Developed in the 1960s and 1970s for airline bookings, these systems required manual entry by travel agents.
*   **Online Travel Agencies (OTAs)**: Emerged in the 1990s and 2000s, allowing users to search and book flights and hotels through web browsers.
*   **Mobile-First Platforms**: Transitioned bookings to mobile apps, incorporating location-based services and instant payments.
*   **Conversational AI Systems**: Represents the current phase, leveraging Large Language Models (LLMs) to allow users to make bookings through conversational interfaces.

Current travel systems, however, have several limitations:
*   **Disconnected APIs**: Accommodations, transportation, and excursions are managed by separate, disconnected platforms.
*   **Complex Form UIs**: Booking processes require users to fill out multiple forms, calendar dropdowns, and payment pages.
*   **Lack of Localized AI Support**: Standard AI bots struggle to comprehend regional Arabic dialects, such as colloquial Egyptian Arabic, making them less useful for local travelers.

The motivation behind Go-Hurghada is to address these issues by combining a unified database architecture with a conversational AI assistant. Using Google Gemini's tool-calling capabilities, the system translates colloquial queries directly into transactional database operations, displaying interactive checkout widgets within the chat feed.

## 1.3 Importance of the Problem Being Addressed

### 1.3.1 Problem Statement
The digital tourism landscape in Hurghada presents several specific challenges:
*   **Fragmented Booking Workflows**: The lack of a unified platform forces tourists to coordinate flights, hotels, and activities across separate applications, increasing booking times and potential errors.
*   **Database Concurrency Conflicts**: During high-demand seasons, concurrent reservation requests for the same hotel room or activity slot can cause double-bookings if the database lacks atomic transaction locks.
*   **Search Latency Issues**: Querying availability across nested date structures in NoSQL databases can degrade search performance during multi-night room searches.
*   **Manual Administration Workflows**: Administrative staff must manage room and tour inventories manually through static tables, which can be inefficient during high-volume periods.

## 1.4 Objectives

### 1.4.1 Main Objective
To design, implement, and evaluate a unified travel booking and tourism ecosystem for Hurghada that integrates a cross-platform mobile client, a React-based administration portal, and a secure Express.js server, powered by a Google Gemini AI agent that translates natural language queries into automated database transactions without risking double-bookings.

### 1.4.2 Specific Objectives
1.  **Develop a Flutter Mobile Application**: Create an intuitive UI built using Material Design 3 and Riverpod for reactive state management, supporting both English and Arabic options.
2.  **Build a Web Admin Panel**: Implement a React web console for administrators to track revenue, manage hotel and tour records (CRUD), and inspect transactions.
3.  **Deploy an AI Chat Assistant**: Train and configure a Gemini AI agent using structured tool-calling schema to parse, understand, and translate Egyptian slang queries into structured API parameters.
4.  **Enforce Safe Concurrency**: Implement Firestore Transactions to guarantee atomic writes on shared inventory documents, preventing double-bookings.
5.  **Enable Flight Redirections**: Provide domestic flight schedules and direct redirects to official airline portals (EgyptAir, Nile Air, Air Cairo) securely.
6.  **Implement Parallel Stock Mapping**: Optimize multi-night room searches by querying day-by-room documents in parallel using `Promise.all()`.

## 1.5 Proposed Solution
The Go-Hurghada system is designed to address travel booking fragmentation through the following components:
1.  **Mobile Client (Flutter)**: Provides hotel and tour bookings, domestic flight schedule displays, and a localized AI Travel Companion.
2.  **Web Admin Console (React & Tailwind CSS)**: Displays real-time revenue and active listings, alongside a command-line style AI Admin Copilot.
3.  **Backend Server (Express.js)**: Manages database logic, coordinates transactional updates, and communicates with the Gemini API to execute tools.
4.  **NoSQL Database (Cloud Firestore)**: Stores user details, room configurations, and reservation states. It uses a flattened day-by-room format (`{hotelId}_{roomId}_{date}`) to optimize query performance.

---

# Chapter 2: Literature Review / Related Work

## 2.1 Related Work Review

### 2.1.1 Booking.com
Booking.com is one of the largest Online Travel Agencies (OTAs) globally, specializing in lodging reservations.
*   **Advantages**: Vast inventory of accommodations, robust filtering options, and verified reviews.
*   **Disadvantages**: It does not integrate local, curated desert safari tours effectively. Additionally, its customer service relies on static forms and rigid, pre-programmed chatbots that do not support localized dialect comprehension.

### 2.1.2 Skyscanner
Skyscanner aggregates flight, hotel, and car rental prices across various booking sites.
*   **Advantages**: Excellent meta-search performance and comprehensive flight pricing comparisons.
*   **Disadvantages**: It functions primarily as a redirection engine. It does not manage local transactions directly and cannot assist users with local itinerary adjustments or customized activities.

### 2.1.3 TripAdvisor
TripAdvisor offers user reviews, ratings, and booking recommendations for hotels, restaurants, and tours.
*   **Advantages**: Deep database of tourist feedback and excursions.
*   **Disadvantages**: The UI is complex and search-heavy. It lacks a conversational AI booking assistant, and booking transactions are often redirected to external third-party travel companies, causing inconsistencies.

## 2.2 Gaps in Current Solutions
1.  **Lack of Local Integration**: Existing apps separate lodging from unique local activities (like specific Bedouin safaris or boat excursions run by local Hurghada operators).
2.  **No Conversational Booking Widgets**: Standard travel bots answer text queries but cannot insert interactive check-out buttons or date-pickers directly into the chat stream.
3.  **No Support for Egyptian Dialect**: Global systems fail to process slang like "احجزلي أودتين للأسبوع الجاي" (Book me two rooms for next week) accurately.
4.  **Admin Panel Automation Gaps**: Admin portals do not support conversational commands, requiring operators to manually click through menus to manage data.

## 2.3 Summary
Go-Hurghada fills these gaps by unifying hotel bookings, flight schedules, and safari tours into a single app. By utilizing Google Gemini's tool-calling capabilities, it translates localized text queries directly into live booking widgets.

---

# Chapter 3: UI/UX Design

## 3.1 Design Process
*   **Requirement Gathering**: Conducted interviews with travelers, cataloged common friction points, and formulated user personas (domestic travelers, foreign tourists, and administrative staff).
*   **Planning & Ideation**: Defined systemic flows, user journeys, navigation paradigms, and screen hierarchies.
*   **Sketching**: Explored screen layouts, component spacing, navigation bars, floating conversational triggers, and dashboard grids using low-fidelity hand-drawn sketches.
*   **Prototyping**: Developed high-fidelity interactive screens using custom color palettes (teals, dark mode background, HSL custom components) and clean typography (Inter font).
*   **User Feedback & Iteration**: Refined card shapes, simplified input fields in flight selections, and optimized conversational bubble dimensions.
*   **Handoff**: Generated design assets, vector icons, color theme JSON configs, and layout metrics for developmental integration.

## 3.2 Prototype and Wireframes

### 3.2.1 Splash Screen
*   **Description**: Serves as the initial user touchpoint when launching the Go-Hurghada application. It displays the application logo prominently with a smooth fade-in animation, loading essential local system settings and configuration variables in the background using Hive.
*   **Layout Placeholder**: `[Insert Figure 3.1: Splash Screen Layout]`

### Landing Page
*   **Description**: Acts as the portal gateway. It presents three options: Register to create an account, Login for returning users, and a "Skip to Search" guest button to allow users to quickly view services during urgent booking situations without initial sign-in.
*   **Layout Placeholder**: `[Insert Figure 3.2: Landing Page Screen Layout]`

### 3.2.2 Register Page
*   **Description**: Facilitates new user registration by capturing inputs such as username, email address, password, and mobile number. It includes real-time validator warnings for password strength and email formatting.
*   **Layout Placeholder**: `[Insert Figure 3.3: Register Screen Layout]`

### 3.2.3 Login Page
*   **Description**: Allows registered users to access their profiles using email and password credentials. It features an options toggle for password visibility and a "Forgot Password" recovery trigger.
*   **Layout Placeholder**: `[Insert Figure 3.4: Login Screen Layout]`

### 3.2.4 Home Screen
*   **Description**: Serving as the central application dashboard, it presents users with categories selection (Flights, Hotels, Safaris), search parameters, and a summary listing of their active, upcoming booking tickets.
*   **Layout Wireframe**:
```
┌──────────────────────────────────────┐
│  Go Hurghada       [Profile] [AR/EN] │
├──────────────────────────────────────┤
│  Flights   • Hotels • Activities     │
│ ┌──────────────────────────────────┐ │
│ │  From: Cairo (CAI)               │ │
│ │  To:   Hurghada (HRG)            │ │
│ ├──────────────────────────────────┤ │
│ │  Date: 15 June 2026 - 22 June   │ │
│ ├──────────────────────────────────┤ │
│ │  Class: Economy (1 Passenger)    │ │
│ └──────────────────────────────────┘ │
│  [          SEARCH FLIGHTS        ]  │
├──────────────────────────────────────┤
│  Active Bookings:                    │
│  - HRG Express Flight (18 June)      │
│  - Desert Safari Tour (20 June)      │
└──────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.5: Home Screen Layout]`

### 3.2.5 Categories Page
*   **Description**: A clean grid menu allowing users to select their target travel module: Flight schedules and airline bookings, Hotel room reservations, or Safari and sea activities. Each card features illustrative icons and descriptive subtitle labels.
*   **Layout Placeholder**: `[Insert Figure 3.6: Categories Selection Grid Layout]`

### 3.2.6 Flights Search Category Page
*   **Description**: Contains search parameter forms for origin, destination, travel dates, passenger counts, and cabin classes. It displays domestic flight schedules and includes secure external redirect buttons to the official portals of EgyptAir, Nile Air, and Air Cairo using the `url_launcher` package with custom confirmation warnings.
*   **Layout Wireframe**:
```text
┌──────────────────────────────────────┐
│  Flights Search        [EN/AR] [<-]  │
├──────────────────────────────────────┤
│  [ O One-Way ]       [ O Round-Trip ]│
│ ┌──────────────────────────────────┐ │
│ │ From: Cairo (CAI)              v │ │
│ ├──────────────────────────────────┤ │
│ │ To:   Hurghada (HRG)           v │ │
│ ├──────────────────────────────────┤ │
│ │ Date: Thu, 18 June 2026          │ │
│ ├──────────────────────────────────┤ │
│ │ Passengers: 1 Adult              │ │
│ ├──────────────────────────────────┤ │
│ │ Class: Economy                   │ │
│ └──────────────────────────────────┘ │
│  [          SEARCH FLIGHTS        ]  │
├──────────────────────────────────────┤
│  Available Flights (EgyptAir / Nile) │
│ ┌──────────────────────────────────┐ │
│ │ MS-246  CAI -> HRG  (EgyptAir)   │ │
│ │ Dep: 08:30 AM    Arr: 09:30 AM   │ │
│ │ Duration: 1h 00m  •  Direct      │ │
│ │ Est. Price: 1,800 EGP            │ │
│ │ [      Book on Official Site  ]  │ │
│ └──────────────────────────────────┘ │
│ ┌──────────────────────────────────┐ │
│ │ NP-112  CAI -> HRG  (Nile Air)   │ │
│ │ Dep: 14:15 PM    Arr: 15:20 PM   │ │
│ │ Duration: 1h 05m  •  Direct      │ │
│ │ Est. Price: 1,650 EGP            │ │
│ │ [      Book on Official Site  ]  │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.7: Flights Search Screen Layout]`

### 3.2.7 Hotels Booking Category Page
*   **Description**: Displays a catalog of hotels in Hurghada with dynamic star and amenities filters. Selecting a hotel opens the detailed room inventory page where date ranges are validated, room availability is checked in real-time via parallel NoSQL queries on the flattened `{hotelId}_{roomId}_{date}` schema, and checkouts are executed securely using Firestore transaction locks.
*   **Layout Wireframes**:
```text
(Catalog List Screen)
┌──────────────────────────────────────┐
│  Explore Hotels        [Filters] [<-]│
├──────────────────────────────────────┤
│  Search hotels...                  Q │
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ [============== Image ============]│
│ │ Hurghada Grand Resort    ***** 4.8 │
│ │ Location: El Gouna, Hurghada       │
│ │ price starting at 2,400 EGP /night │
│ │ [View Rooms]                       │
│ └──────────────────────────────────┘ │
│ ┌──────────────────────────────────┐ │
│ │ [============== Image ============]│
│ │ Red Sea Marine Hotel      **** 4.5 │
│ │ Location: Sheraton Road, Hurghada  │
│ │ price starting at 1,500 EGP /night │
│ │ [View Rooms]                       │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘

(Room Selection Detail Modal)
┌──────────────────────────────────────┐
│  Hurghada Grand Resort          [<-] │
├──────────────────────────────────────┤
│ [============ Image Carousel ========]│
│ [o o o o]                            │
├──────────────────────────────────────┤
│ Dates: 18 June - 22 June (4 Nights)  │
├──────────────────────────────────────┤
│ Room Options:                        │
│ ┌──────────────────────────────────┐ │
│ │ Double Room (Pool View)           │ │
│ │ Max: 2 Adults • Breakfast Inc.     │ │
│ │ Price: 2,500 EGP / Night           │ │
│ │ Status: [ Only 2 Rooms Left! ]     │ │
│ │ [ Select & Proceed to Book ]       │ │
│ └──────────────────────────────────┘ │
│ ┌──────────────────────────────────┐ │
│ │ Deluxe Family Suite               │ │
│ │ Max: 4 Guests • Sea View          │ │
│ │ Price: 4,800 EGP / Night           │ │
│ │ Status: [ Available ]              │ │
│ │ [ Select & Proceed to Book ]       │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.8: Hotels Booking and Room Selection Layout]`

### 3.2.8 Activities Category Page
*   **Description**: Displays curated outdoor tours (e.g., Quad Biking, Bedouin Dinner, Sea Cruises). Features pricing per person, activity duration tags, starting slot lists, and real-time remaining capacity indicators.
*   **Layout Placeholder**: `[Insert Figure 3.9: Safari Activities Screen Layout]`

### 3.2.9 AI Chat Companion Screen
*   **Description**: The conversational heart of the app. Users chat in colloquial dialect, and the assistant renders dynamic widgets (like booking cards or check-out buttons) directly in the message feed instead of raw text.
*   **Layout Wireframe**:
```
┌──────────────────────────────────────┐
│  AI Travel Companion                 │
├──────────────────────────────────────┤
│ [AI]: How can I assist you today?    │
│                                      │
│ [User]: Find a cheap room for 2      │
│                                      │
│ [AI]: Here is what I found:          │
│ ┌──────────────────────────────────┐ │
│ │  Hurghada Resort - Double Room   │ │
│ │  Price: 1500 EGP / Night         │ │
│ │  [ Book Room ]                   │ │
│ └──────────────────────────────────┘ │
│                                      │
│ ┌──────────────────────────────────┐ │
│ │ Message...                     [^] │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.10: AI Chat Companion Screen Layout]`

### 3.2.10 Profile Page
*   **Description**: Enables users to manage user account information, toggle between Arabic and English localization preferences, view archived receipts, and request support.
*   **Layout Placeholder**: `[Insert Figure 3.11: Profile Screen Layout]`

### 3.2.11 Web Admin Panel - Dashboard Screen
*   **Description**: Designed for administrators to monitor platform operations. Displays cards with live metrics (Total Revenue, Active Listings, Active Bookings) and real-time reservation updates.
*   **Layout Wireframe**:
```
┌────────────────────────────────────────────────────────┐
│  Admin Go Hurghada   [Dashboard] [Hotels] [Bookings]   │
├────────────────────────────────────────────────────────┤
│  OVERVIEW METRICS                                      │
│ ┌───────────────┐ ┌───────────────┐ ┌───────────────┐  │
│ │ Total Revenue │ │ Active Hotels │ │ Live Bookings │  │
│ │  EGP 245,500  │ │      12       │ │      84       │  │
│ └───────────────┘ └───────────────┘ └───────────────┘  │
├────────────────────────────────────────────────────────┤
│  BOOKING CONSOLE                                       │
│  ID       Customer     Item        Status    Actions   │
│  #10243   A. Nagy      Hotel Room  Success   [Cancel]  │
│  #10244   M. Salem     Safari Tour Success   [Cancel]  │
└────────────────────────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.12: Web Admin Dashboard Screen Layout]`

### 3.2.12 Web Admin Panel - Hotels CRUD Screen
*   **Description**: Provides managers with forms to add, edit, or archive hotels and specific room counts, pricing profiles, and calendar availability blocks.
*   **Layout Placeholder**: `[Insert Figure 3.13: Web Admin Hotels CRUD Screen Layout]`

### 3.2.13 Web Admin Panel - Activity CRUD Screen
*   **Description**: Allows coordinators to define safari schedules, capacity caps, departure slot details, and update pricing tiers.
*   **Layout Placeholder**: `[Insert Figure 3.14: Web Admin Safari CRUD Screen Layout]`

### 3.2.14 Web Admin Panel - Availability Calendar Screen
*   **Description**: Renders a calendar interface displaying day-by-day availability for a selected hotel and room type. Administrators select the hotel and room type from dropdown menus and set the date range. The system queries Firestore and displays each day in a color-coded grid: green (available), orange (almost full), or red (fully booked), showing remaining room units.
*   **Layout Wireframe**:
```text
┌────────────────────────────────────────────────────────┐
│  Admin Go Hurghada   [Dashboard] [Hotels] [Availability]│
├────────────────────────────────────────────────────────┤
│  AVAILABILITY CALENDAR                                 │
│ ┌────────────────────────────────────────────────────┐ │
│ │ Hotel: Hurghada Grand Resort    v                  │ │
│ │ Room Type: Double Room (Pool View) v               │ │
│ │ From Date: 18 June 2026   To Date: 25 June 2026    │ │
│ │ [ CHECK AVAILABILITY ]                             │ │
│ └────────────────────────────────────────────────────┘ │
├────────────────────────────────────────────────────────┤
│  RESULTS: Double Room (Pool View)                      │
│  Legend: [x] Free  [/] Low (<=30%)  [!] Full           │
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│ │ Thu 18   │ │ Fri 19   │ │ Sat 20   │ │ Sun 21   │    │
│ │   [x]    │ │   [x]    │ │   [/]    │ │   [!]    │    │
│ │ 8/10 units││ 9/10 units││ 2/10 units││ 0/10 units│    │
│ └──────────┘ └──────────┘ └──────────┘ └──────────┘    │
└────────────────────────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.15: Web Admin Availability Calendar Screen Layout]`

### 3.2.15 Web Admin Panel - AI Copilot Screen
*   **Description**: An administrative interface powered by the Gemini agent. Operators enter conversational commands to manage database records, such as blocking rooms for maintenance or retrieving revenue metrics.
*   **Layout Wireframe**:
```
┌────────────────────────────────────────────────────────┐
│  AI Admin Copilot Console                              │
├────────────────────────────────────────────────────────┤
│ [AI Console]: Ready to assist with database operations. │
│                                                        │
│ [Admin]: Block Room 102 in Hurghada Resort for tomorrow│
│                                                        │
│ [AI Console]: Room 102 has been successfully blocked   │
│               for June 14, 2026.                       │
│                                                        │
│ ┌──────────────────────────────────────────────────┐   │
│ │ Type command...                               [>]│   │
│ └──────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────┘
```
*   **Layout Placeholder**: `[Insert Figure 3.16: Web Admin AI Copilot Screen Layout]`


---

# Chapter 4: Proposed System

## 4.1 System Approaches and Architecture
Go-Hurghada is built using a decentralized client-server architecture:
*   **Flutter Frontend**: Compiles to native ARM code on mobile devices. Communicates with the backend server via HTTP REST APIs.
*   **React Admin Panel**: Connects to Firebase Firestore using real-time database listeners for live dashboards, and makes API requests for admin actions.
*   **Express Backend**: Contains the API routers and the Gemini AI agent loop.
*   **Firestore & Hive**: Firestore holds user details, room configurations, and reservation states. Hive manages local variables on the mobile client.

## 4.2 Use Case Diagram & Descriptions
The Use Case Diagram defines the boundaries of the Go-Hurghada System and the relationships between external actors and internal system functionalities.

*   **Actors**: 
    *   `User`: Traveler using the mobile client to browse services, execute bookings, and make payments.
    *   `Admin`: Manager using the Web Admin Panel to perform CRUD operations on listings and manage bookings.
    *   `Payment Gateway`: External provider (e.g., Paymob) integrated to authorize card payments and refunds.
*   **Key Use Cases**:
    *   *User*: `Sign Up` / `Login` / `Reset Password`, `Browse Services`, `Select Services`, and `Make Payment` (which `<<include>>`s the **Payment Gateway**), leading to a `Booking Confirmation`.
    *   *Admin*: `Manage Hotels`, `Manage Activities`, `Manage Flights`, and `Manage Booking` (which interfaces with the **Payment Gateway** to coordinate checkout refunds).

[Insert Figure 4.1: Use Case Diagram for Go-Hurghada System here]

## 4.3 Sequence Diagram & Interaction Flows
The Sequence Diagram models the chronological messaging and data flow between key lifelines: the User, Go Hurghada App, Backend API, Database, and external lifelines (Payment Gateway, Airlines (External)).

*   **Authentication & Initialization**: User opens the app (`openApp()`), triggering registration (`registerUser()`) or login (`authenticate()`). The Backend verifies credentials against the Database (`getUser()`) and returns success/failure within `alt` routing blocks.
*   **Hotels Booking**: User searches hotels (`getHotels()`) and checks availability (`checkRoomAvailable()`). If vacant, payment is authorized via the **Payment Gateway**, and the reservation is saved atomically to the Database via a Firestore Transaction (`saveBooking()`).
*   **Flights Redirection**: User searches flights. The Backend queries the **Airlines (External)** API (`fetchLiveFlights()`) and returns schedule results. Selecting a flight redirects the user externally (`openExternalSite()`) to complete checkout on the carrier's portal.
*   **Activity Booking**: User browses activities. Booking an excursion checks participant capacity in the DB (`countParticipants()`). If space remains, payment is processed and the reservation is written to the Database (`saveReservation()`).

[Insert Figure 4.2: Sequence Diagram of the Booking Checkout Flow here]

## 4.4 Entity Relationship Diagram (ERD) & Database Schema
The Entity Relationship Diagram (ERD) defines the logical schema, mapping entity properties, data types, primary/foreign keys, and relational constraints.

*   **Entities & Attributes**:
    *   `User`: `UserId` (PK), `Name`, `Email`, `PhoneNumber`, `PasswordHash`, `Role`.
    *   `Booking`: `BookingId` (PK), `UserId` (FK), `Date`, `Status`, `TotalAmount`.
    *   `Payment`: `PaymentId` (PK), `BookingId` (FK), `Date`, `Amount`, `Method`, `Status`.
    *   `Hotel`: `HotelId` (PK), `Name`, `Address`, `Rating`, `Description`, `ImageUrl`.
    *   `Room`: `RoomId` (PK), `HotelId` (FK), `Type`, `Price`, `Capacity`, `IsAvailable`.
    *   `Flight`: `FlightId` (PK), `Airline`, `FlightNumber`, `Origin`, `Destination`, `DepartureTime`, `ArrivalTime`, `Price`, `CabinClass`.
    *   `Activity`: `ActivityId` (PK), `Name`, `Type`, `Location`, `Duration`, `Price`, `Rating`.
*   **Entity Relationships**:
    *   *User makes Booking* (1 to 0..*) and *Booking generates Payment* (1 to 0..1).
    *   *Booking reserves Hotel* (0..* to 1) and *Hotel has Room* (1 to 1..*).
    *   *Booking includes Flight* (1 to 0..*) and *Booking contains Activity* (1 to 0..*).

[Insert Figure 4.3: Entity Relationship Diagram (ERD) Schema here]
[Insert Figure 4.4: Firestore NoSQL Document Mapping Schema here]

## 4.5 Class Diagram & Descriptions
The Class Diagram defines the object-oriented architectural structure of the Go-Hurghada application, displaying classes, interfaces, inheritance mappings, and static associations.

*   **Actor & Profile Classes**: `User` (handles login, logout, search), `Profile` (stores user metadata), and `Admin` (manages bookings and reviews reports).
*   **Booking Classes**: `Booking` (base class managing confirmation, cancellation, invoice generation), which is inherited by `HotelBooking` and `ActivityBooking`. `Flight` acts as a specialized booking/schedule record.
*   **Core Entity Classes**: `Hotel` (manages hotel listings and room list generation), `Room` (tracks specific room instances), and `Activity` (handles excursion details and space checks).
*   **Transactions & Interfaces**: `Payment` tracks payment transactions, depending on the `PaymentGateway` interface (`authorize()`, `capture()`, `void()`). `Refund` represents admin-approved reversals. `FlightAPI` interface coordinates flight searches.

[Insert Figure 4.5: System Class Diagram here]
[Insert Figure 4.6: Client-Side Riverpod and Model Class Diagram here]

## 4.6 Algorithms and Frameworks
*   **Riverpod State Management**: Provides clean dependency injection and state tracking for the client app.
*   **Firestore Transactions Protocol**: Implements an optimistic concurrency control protocol to prevent race conditions during checkout.

---

# Chapter 5: System Implementation & Technical Details

## 5.1 Technologies, Tools, and Programming Languages

### 5.1.1 Frontend Stack (React, Tailwind CSS & Flutter)
Dart was selected as the core programming language for the mobile application client, utilizing the Flutter SDK. Flutter compiles the codebase directly into native ARM binary instructions for both Android and iOS platforms, bypassing runtime JavaScript interpretation bridges and delivering high-performance UI rendering that maintains a smooth 60 frames per second (FPS). Riverpod is integrated to manage application state reactively, ensuring error-resistant and fully synchronized states across hotel listings, date pickers, and the active chat history. The Web Administration Panel is developed using React, bundled with Vite for near-instantaneous build times and hot module replacement (HMR), maximizing development velocity. Tailwind CSS is utilized for styling the dashboard interface using HSL color mapping for a consistent visual identity, establishing an responsive and modern layout using flexible CSS grid components.

### 5.1.2 Backend and Database Stack (Node.js, Express.js, Cloud Firestore & Hive)
The backend architecture runs on Node.js and Express.js, selected for their asynchronous I/O capabilities and ability to handle concurrent workloads efficiently. The cloud data layer is built on Firebase Cloud Firestore, a NoSQL document database that utilizes persistent WebSocket connections for real-time synchronization. This ensures that administrative dashboards update instantly as soon as a user books a hotel room or tour excursion. On the client side, the Hive key-value database package manages local cache storage on the mobile client. Hive provides high-speed local data reads and writes by utilizing binary formatting, and uses AES-256 encryption to secure sensitive user session states and authorization tokens.

### 5.1.3 Artificial Intelligence Integration (Google Gemini API)
The platform incorporates the Google Gemini API using the `gemini-2.5-flash` model. This model offers low latency and cost-effectiveness, alongside robust function-calling execution. The agent is initialized with strict system instructions and a low temperature parameter (Temperature = 0.2) to ensure deterministic outputs. The agent parses raw natural language conversations and Egyptian Arabic dialects, mapping user requests directly into standard JSON parameters to execute Firestore database operations.

## 5.2 Key Components of the System
*   **Lodging Booking Engine**: Handles check-in and check-out validation, room capacity limits, and calculates seasonal booking rates.
*   **Conversational Chat Agent**: A backend coordination layer that handles user prompts, executes tool calls, formats response cards, and passes structured checkout widgets back to the client application.
*   **Admin Analytical Dashboard**: A web-based manager panel that displays real-time financial tables and reservation trends.
*   **Flight Search Redirection Module**: Filters domestic airline schedules and launches URL confirmation prompts using the `url_launcher` package to direct users safely to carrier booking pages.

## 5.3 Technical Challenges Faced and Resolutions
1.  **Race Conditions and Double Booking**: Concurrent booking requests on a single remaining hotel room present a risk of double-booking. This is resolved by wrapping check-and-write operations in Firestore Transactions. Transactions enforce a strict read-before-write process, atomically locking target documents to verify availability before writing updates, and automatically retrying if conflicts occur.
2.  **Search Latency in NoSQL Structure**: Querying availability over consecutive dates can cause latency issues in NoSQL databases due to sequential querying. This is resolved by flattening the availability schema into date-specific documents (`{hotelId}_{roomId}_{date}`) and querying the target date range in parallel using `Promise.all()` in Node.js, reducing response latency by over 60%.
3.  **Storage Bloat from Date Records**: To minimize Firestore document storage, automated clean-up routines are integrated into reservation cancellation handlers. If a cancellation reduces a date's booked count back to zero, the document is deleted, preventing unnecessary storage accumulation.
4.  **Redirection App Crashes**: External URL redirections could cause mobile application crashes if link protocols are malformed. This is resolved by adding structural URL verification hooks to validate schemes and formats before initiating the device web browser.

---

# Chapter 6: Testing & Evaluation

## 6.1 Testing Strategies
To validate the reliability, performance, and security of the Go-Hurghada Travel Ecosystem, a multi-tiered testing methodology was executed. This strategy encompasses unit testing of discrete components, integration testing of complete transactional journeys, and user acceptance testing with end-users.

### 6.1.1 Unit Testing
Unit testing focused on verifying that isolated functions and modules perform correctly without dependencies. 
*   **Frontend Dart Models**: Leveraged the `flutter_test` package to validate JSON serialization and deserialization routines. This ensured that data fetched from Firestore mapped correctly to models without causing runtime type exceptions.
*   **Hive Adapters**: Unit tests verified that the key-value local storage adapters securely stored and retrieved user credentials, selected locale strings, and cache data across application cycles.
*   **Backend Pricing Engine**: A node-based unit test suite validated the mathematical accuracy of room pricing equations. It simulated booking ranges spanning low, high, and promotional seasons, and checked that VAT calculations and multi-guest capacity surcharges were computed correctly down to decimal values using Jest with 100% precision.

### 6.1.2 Integration Testing
Integration testing verified the seamless exchange of data across the different system boundaries (Flutter client, Express server, and Cloud Firestore).
*   **End-to-End Booking Flow**: Simulated a guest user session: starting the app -> searching for a room -> selecting dates -> invoking the check-out transaction -> launching the payment WebView callback parser, updating Firestore, and changing status on React.
*   **Firestore Transaction Integration**: Multiple test scripts were run in parallel to simulate concurrent checkouts on a single hotel room when only one vacancy remained. The tests verified that Firestore’s optimistic concurrency mechanisms successfully committed the first transaction, while safely aborting and retrying the other concurrent requests, preventing double-bookings.
*   **Gemini Tool-Calling Loop**: Validated the backend AI router by feeding mocked chat inputs. The tests ensured that queries like "Find a double room for June 20th" triggered the appropriate availability query function, and returned a structured widget JSON response to the client application with over 95% intent matching accuracy.

### 6.1.3 User Acceptance Testing (UAT)
User Acceptance Testing was conducted with 8 participants to evaluate usability:
*   **Participants**: 6 non-technical users representing typical travelers, and 2 professional developers.
*   **Tasks & Results**: Participants executed five baseline tasks and achieved the following profiles:

| Task Description | Success Rate | Average Completion Time | Usability Score (out of 5) |
| :--- | :---: | :---: | :---: |
| Create Account & Login | 100% | 12.4 seconds | 4.8 / 5 |
| Search & Book Hotel (Classic Form UI) | 100% | 24.5 seconds | 4.5 / 5 |
| Book Hotel room using Chatbot (Colloquial Arabic) | 100% | 8.2 seconds | 4.9 / 5 |
| Browse Flights & Launch Redirection link | 100% | 15.1 seconds | 4.6 / 5 |
| Admin: Block Room/Modify Hotel via AI Copilot | 100% | 5.5 seconds | 4.7 / 5 |

Non-technical users reported that the chat assistant reduced the steps needed to book compared to typical form-heavy websites, and developers suggested integrating native credit card APIs inside the Flutter view directly.

## 6.2 Performance Metrics and Results
*   **Pricing Engine Correctness**: Achieved 100% computational correctness across 500 simulated multi-day booking configurations.
*   **Screen Switch Navigation Latency**: Measured using Flutter performance monitors, screen navigation times averaged 0.12 seconds, well below the 0.5-second UAT target.
*   **Database Query Speed**: Query times for lodging availability stayed under 0.18 seconds on average due to the flattened day-by-room document schema and parallel promise resolutions.
*   **AI Chat Response Loop**: Measured from user input submission to response rendering, the conversational loop completed within 2.1 to 2.8 seconds, which fits acceptable parameters for generative AI systems.
*   **Device Resource Footprint**: Mobile RAM footprint remained below 120MB, and Express backend CPU usage stayed under 5% under baseline operations.

## 6.3 Comparison with Existing Solutions
The system's features are compared with leading travel platforms below:

| Comparative Criteria | Booking.com | Skyscanner | TripAdvisor | Go-Hurghada System (Proposed) |
| :--- | :--- | :--- | :--- | :--- |
| **Service Scope** | Hotel lodging only | Flights and car rental only | Reviews and bookings | Integrated flights, hotels, and tours |
| **User UI Paradigm** | Forms & complex filters | Static tabular search | Traditional page grids | Conversational chat & inline widgets |
| **AI Capability** | Static help chatbot | None | Basic inquiry bot | Gemini Agent with tool-calling loops |
| **Local Dialect Support** | Official languages only | Official languages only | Official languages only | Parses colloquial Egyptian Arabic |
| **Admin Workflow** | Manual forms & grids | No inventory dashboard | Manual management portals | Web panel & conversational AI Copilot |

---

# Chapter 7: Results & Discussion

## 7.1 Summary of Findings
The development of the Go-Hurghada Travel Ecosystem showed that:
*   Integrating Large Language Models (LLMs) with tool-calling capabilities allows users to complete travel searches and bookings through a conversational interface.
*   The flattened day-by-room database structure in Firestore resolved query performance issues, reducing multi-night query latencies by over 60% compared to nested date arrays.
*   Firestore transactions resolved concurrency conflicts, preventing double-bookings during simulated peak checkouts.

## 7.2 Interpretation of Results
The performance metrics indicate that a conversational travel assistant can deliver competitive query response times while simplifying the booking process. The real-time synchronization between Firestore and the React dashboard ensures that administrators can monitor bookings and revenue changes immediately. The low database query latency (0.18s) highlights the benefit of the flattened day-by-room database schema, which avoids nested array queries.

## 7.3 Limitations of the Proposed Solution
The system has several technical limitations:
*   **Lack of Redis Caching**: Direct reads to Firestore can increase operational costs under high query traffic.
*   **External WebView Payments**: Payment checkout redirects users to an external Paymob WebView iframe rather than using a native in-app card input SDK.
*   **Flight Booking Limitations**: Flights are limited to schedule searches and redirects, lacking native in-app booking and issuance.
*   **Lacks Push Notifications**: The system relies on real-time database listeners for updates, lacking background push notifications when the app is closed.

---

# Chapter 8: The Role and Importance of Artificial Intelligence (AI) in the Ecosystem

## 8.1 Introduction to Cognitive Computing in Modern Tourism
Integrating generative AI into travel platforms represents a transition from traditional Graphical User Interfaces (GUIs), which rely on complex forms, to Conversational User Interfaces (CUI). The AI Travel Companion in Go-Hurghada acts as a virtual concierge, allowing users to express complex search requirements naturally. This reduces the steps required to complete a booking, improving user conversion rates.

## 8.2 Artificial Intelligence Agent Architecture
The platform utilizes the `gemini-2.5-flash` model via the Google Gemini API. This model was chosen for its low latency, cost-efficiency, and robust tool-calling support. Gemini acts as an agent, translating natural language queries into structured parameters to call specific system APIs.

## 8.3 Tool-Calling Mechanism and Database Integration
The backend defines and registers various system schemas with Gemini (Appendix 11.1.3.1), including:
*   `search_hotels`: Searches hotels based on name and location filters.
*   `check_availability`: Verifies room vacancies over date ranges.
*   `create_booking`: Creates a booking and increments booked counts atomically.
*   `get_bookings`: Renders current bookings with filters.
*   `update_booking_status`: Modifies reservation states.

For example, when a user says "احجزلي أوضة لشخصين في فندق الغردقة من الجمعة للسبت الجاي" (Book me a room for two at the Hurghada hotel from next Friday to Saturday), Gemini:
1. Calls `search_hotels` to retrieve the hotel ID.
2. Parses dates into the standard `YYYY-MM-DD` format and calls `check_availability`.
3. Returns a structured JSON payload to render the booking card in the chat.

## 8.4 Express.js Multi-Turn Agentic Loop
To support complex, multi-step operations, the Express.js server runs an agentic loop (Appendix 11.1.3.4) that allows up to 8 iterations. If Gemini returns a function call request, the server executes the corresponding database tool, feeds the result back to Gemini, and continues the loop until a final text response and checkout payload are generated. This multi-turn interaction occurs in the background, providing a seamless user experience.

## 8.5 Dynamic Client-Side Widget Rendering (Flutter)
Rather than replying with raw text, the AI agent returns structured JSON payloads containing details of the proposed reservation. The Flutter application captures this payload and renders a native interactive card (`HotelBookingCardWidget`) in the chat stream (Appendix 11.1.1.1). This card displays dates, pricing, and hotel details, and includes a checkout button that connects to the Riverpod notifier and Paymob portal, keeping the booking workflow within the chat interface.

## 8.6 Conversational Web Administration Copilot (React)
For administrators, the React console includes a conversational AI copilot (`AiAssistant` in Appendix 11.1.1.5). Operators can execute database queries and commands using natural language, such as "Show pending bookings" or "Cancel booking #10243". The AI agent translates these commands into calls to `get_bookings` or `update_booking_status`, updates Firestore, and formats the output into interactive markdown tables in the console.

---

# Chapter 9: Conclusion

## 9.1 Summary of Contributions
The Go-Hurghada project successfully implemented an integrated travel booking platform that combines a Flutter mobile client, a React admin portal, and an Express.js backend. The primary contributions of this project include a conversational AI travel assistant, a flattened NoSQL schema and transaction model that prevents concurrency conflicts, a web admin console with an AI Copilot, and an optimized database transactional loop.

Through rigorous design, development, and testing cycles, this project has produced several concrete academic and practical contributions:
*   **Unified Tourism Ecosystem**: Consolidates fragmented tourist services—hotel lodging, domestic flights schedule routing, and desert safari/sea activities—into a single platform, eliminating the need for users to switch between multiple application views.
*   **Conversational Interface with Dynamic Widgets**: Implemented a bilingual AI travel concierge supporting English and colloquial Egyptian Arabic dialects, capable of generating interactive checkout card widgets directly within the chat window to streamline user checkout paths.
*   **Optimized NoSQL Concurrency and Search**: Developed a robust reservation database mapping structure using flattened day-by-room documents. This structure prevents double-bookings through optimistic Firestore Transactions while utilizing parallel promise-based `Promise.all()` routines to achieve multi-night availability lookup latencies of under 0.18 seconds.
*   **AI Admin Copilot Console**: Deployed a command-style AI console in the web portal, enabling administrative staff to query listings, check reservations, and modify database fields using natural language commands.

## 9.2 Architectural Insights & Lessons Learned
Several critical software engineering insights were gained throughout the system design and evaluation phases:
1.  **Optimizing transactional locking in NoSQL databases**: Standard NoSQL architectures often struggle with complex transactional operations. By flattening date availability into individual documents (`{hotelId}_{roomId}_{date}`), the platform avoided slow queries on nested arrays. This allowed Firestore Transactions to efficiently acquire atomic locks, maintaining consistency under concurrent UAT stress scenarios.
2.  **Deterministic behavior in Generative AI interfaces**: In-app AI agents must act reliably. Restricting LLM creativity by configuring a low temperature (Temperature = 0.2) and validating generated JSON parameters on the backend proved essential to prevent API errors and model hallucinations.
3.  **Enhancing User Conversions via CUIs**: The UAT results demonstrated that conversational interfaces with inline widgets significantly lower the cognitive load for non-technical users. By reducing input form elements, the average booking completion time dropped to 8.2 seconds, demonstrating the potential of integrated AI chatbots.

## 9.3 Broader Impact & Future Research
The Go-Hurghada framework demonstrates how cognitive travel agents can support regional tourism ecosystems:
-   **Empowering Local Tour Operators**: The platform enables small-scale, local coordinators (e.g., Bedouin desert safari guides) to list their inventories directly, bridging the gap between local travel planning and mainstream digital travel platforms.
-   **Facilitating Digital Transformation**: Bridging generative AI with real-time transactional databases opens up new avenues for local economies to digitize, enabling cashless checkouts and automated operations.
-   **Final Conclusion**: In conclusion, Go-Hurghada establishes a framework for conversational travel platforms. By combining generative LLMs with transactional backends, the platform offers a secure, fast, and user-friendly solution for modern travel booking.

---

# Chapter 10: Future Work

## 10.1 Future Work Recommendations
To scale, optimize, and broaden the capabilities of the Go-Hurghada Travel Ecosystem, several future development phases have been planned:
1.  **Redis Caching Integration**: Implementing a Redis caching tier in front of Firestore will store static room configurations, flight redirects data, and tour lists. This will drastically minimize database read overhead, reducing operational billing metrics during peak seasons.
2.  **Native Paymob SDK Integration**: Replacing the current WebView card checkout with the official Paymob Native SDK inside Flutter. This will allow in-app payment details collection, supporting Google Pay, Apple Pay, and native local card saving.
3.  **FCM Push Notifications**: Setting up Firebase Cloud Messaging (FCM) to trigger background worker alerts to keep users notified of admin booking confirmations or flight schedule updates even when the mobile app is closed.
4.  **Native Flight Booking Integrations**: Extending the Meta flight search module by integrating third-party flight purchasing APIs, allowing users to complete flight ticket payments directly inside the Go-Hurghada app.

---

# Chapter 11: Appendices

## 11.1 Codes

### 11.1.1 Frontend Codes

#### 11.1.1.1 Flutter AI Dynamic Widget Chat Renderer
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMessages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Travel Companion'),
        backgroundColor: Colors.teal.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                final isUser = message.role == 'user';

                return Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.teal.shade700 : Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        message.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (message.customWidgetData != null)
                      HotelBookingCardWidget(
                        data: message.customWidgetData!,
                        onBook: () => ref.read(bookingProvider.notifier).createBooking(message.customWidgetData!),
                      ),
                  ],
                );
              },
            ),
          ),
          ChatInputField(),
        ],
      ),
    );
  }
}

class HotelBookingCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBook;

  const HotelBookingCardWidget({required this.data, required this.onBook, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade900.withOpacity(0.4),
      margin: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['hotelName'] ?? 'Hurghada Resort', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            const SizedBox(height: 4.0),
            Text('Room Type: ${data['roomType'] ?? 'Double Room'}'),
            Text('Check-in: ${data['startDate']} | Check-out: ${data['endDate']}'),
            Text('Total Price: EGP ${data['totalPrice']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent.shade700),
              child: const Text('Confirm & Pay via Paymob'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 11.1.1.2 Flutter Riverpod StateNotifier for Reservation Lifecycle Management
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? bookingId;

  BookingState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.bookingId,
  });

  BookingState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? bookingId,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      bookingId: bookingId ?? this.bookingId,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(BookingState());

  Future<void> checkoutBooking({
    required String userId,
    required String hotelId,
    required String roomId,
    required List<String> dates,
    required double totalPrice,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      final response = await http.post(
        Uri.parse('https://api.go-hurghada.com/bookings/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'hotelId': hotelId,
          'roomId': roomId,
          'dates': dates,
          'totalPrice': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          bookingId: data['bookingId'],
        );
      } else {
        final errorData = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorData['error'] ?? 'Booking transaction failed.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network exception occurred: ${e.toString()}',
      );
    }
  }
}

final bookingNotifierProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});
```

#### 11.1.1.3 Flutter Paymob WebView Redirection Callback Parser
```dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  const PaymentWebViewScreen({required this.paymentUrl, Key? key}) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            
            // Intercept the Paymob callback URL pattern
            if (url.contains('go-hurghada.com/payments/callback')) {
              final uri = Uri.parse(url);
              final success = uri.queryParameters['success'];
              final txnId = uri.queryParameters['id'];
              
              if (success == 'true') {
                // Return success state back to caller page
                Navigator.of(context).pop({'status': 'success', 'transactionId': txnId});
              } else {
                // Return failure status
                Navigator.of(context).pop({'status': 'failed', 'error': 'Payment rejected by bank.'});
              }
              return NavigationDecision.prevent; // Prevent standard browser load
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paymob Payment Checkout'),
        backgroundColor: Colors.teal.shade800,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
```

#### 11.1.1.4 React Web Admin Panel Real-Time Availability Calendar Screen
```javascript
import { useState, useEffect, useCallback } from 'react';
import api from '../api';
import {
  Calendar, Search, Loader2, RefreshCw, CheckCircle2,
  XCircle, Hotel, Layers, AlertTriangle, ChevronDown,
  Info, Home
} from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

// ─── Helpers ────────────────────────────────────────────────────────────────

const today = () => new Date().toISOString().split('T')[0];
const addDays = (dateStr, n) => {
  const d = new Date(`${dateStr}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + n);
  return d.toISOString().split('T')[0];
};

const formatDateDisplay = (dateStr) => {
  const [y, m, d] = dateStr.split('-');
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return `${d} ${months[parseInt(m) - 1]}`;
};

const weekDays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

// ─── Day Cell ────────────────────────────────────────────────────────────────

const DayCell = ({ dateStr, data }) => {
  const dayOfWeek = new Date(`${dateStr}T00:00:00Z`).getUTCDay();
  const dayNum = dateStr.split('-')[2];
  const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;

  let bg = 'bg-emerald-50 border-emerald-200';
  let textColor = 'text-emerald-800';
  let badge = null;

  if (!data) {
    // No data = fully available (no availability doc)
    badge = (
      <span className="text-[10px] font-bold text-emerald-500 uppercase tracking-wide">
        Free
      </span>
    );
  } else if (!data.available) {
    bg = 'bg-red-50 border-red-200';
    textColor = 'text-red-800';
    badge = (
      <span className="text-[10px] font-bold text-red-500 uppercase tracking-wide">
        Full
      </span>
    );
  } else {
    const pct = Math.round((data.remainingRooms / data.totalCount) * 100);
    if (pct <= 30) {
      bg = 'bg-amber-50 border-amber-200';
      textColor = 'text-amber-800';
    }
    badge = (
      <span className={`text-[10px] font-bold ${pct <= 30 ? 'text-amber-500' : 'text-emerald-500'} uppercase tracking-wide`}>
        {data.remainingRooms}/{data.totalCount}
      </span>
    );
  }

  return (
    <div className={`relative border rounded-xl p-2 flex flex-col items-center gap-0.5 transition-all
      ${bg} ${isWeekend ? 'opacity-75' : ''}`}>
      <span className={`text-[10px] font-semibold uppercase tracking-widest ${textColor} opacity-60`}>
        {weekDays[dayOfWeek]}
      </span>
      <span className={`text-lg font-bold leading-none ${textColor}`}>{dayNum}</span>
      {badge}
      {data && !data.available && (
        <XCircle className="absolute top-1.5 right-1.5 w-3 h-3 text-red-400" />
      )}
      {(!data || data.available) && (
        <CheckCircle2 className="absolute top-1.5 right-1.5 w-3 h-3 text-emerald-400" />
      )}
    </div>
  );
};

// ─── Main Component ──────────────────────────────────────────────────────────

const Availability = () => {
  const [hotels, setHotels] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [selectedHotel, setSelectedHotel] = useState('');
  const [selectedRoom, setSelectedRoom] = useState('');
  const [startDate, setStartDate] = useState(today());
  const [endDate, setEndDate] = useState(addDays(today(), 14));
  const [availability, setAvailability] = useState([]);
  const [loading, setLoading] = useState(false);
  const [loadingRooms, setLoadingRooms] = useState(false);
  const [error, setError] = useState('');
  const [searched, setSearched] = useState(false);

  // Load hotels on mount
  useEffect(() => {
    api.get('/hotels')
      .then(res => setHotels(res.data))
      .catch(() => setError('Failed to load hotels.'));
  }, []);

  // Load rooms when hotel changes
  useEffect(() => {
    if (!selectedHotel) { setRooms([]); setSelectedRoom(''); return; }
    setLoadingRooms(true);
    setSelectedRoom('');
    api.get(`/hotels/${selectedHotel}/rooms`)
      .then(res => setRooms(res.data))
      .catch(() => setRooms([]))
      .finally(() => setLoadingRooms(false));
  }, [selectedHotel]);

  const handleSearch = useCallback(async () => {
    if (!selectedHotel || !selectedRoom || !startDate || !endDate) {
      setError('Please select a hotel, a room, and a date range.');
      return;
    }
    if (endDate <= startDate) {
      setError('End date must be after start date.');
      return;
    }
    setError('');
    setLoading(true);
    setSearched(true);
    try {
      const res = await api.get('/availability', {
        params: { hotelId: selectedHotel, roomId: selectedRoom, startDate, endDate },
      });
      setAvailability(res.data);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to fetch availability.');
      setAvailability([]);
    } finally {
      setLoading(false);
    }
  }, [selectedHotel, selectedRoom, startDate, endDate]);

  // Build a map for O(1) lookup
  const availMap = {};
  availability.forEach(a => { availMap[a.date] = a; });

  const selectedHotelObj = hotels.find(h => h.id === selectedHotel);
  const selectedRoomObj   = rooms.find(r => r.id === selectedRoom);

  const availCount   = availability.filter(a => a.available).length;
  const unavailCount = availability.filter(a => !a.available).length;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl sm:text-3xl font-bold text-gray-900">Availability Calendar</h1>
        <p className="text-gray-500 mt-1 text-sm font-medium">
          Check real-time room availability across any date range
        </p>
      </div>

      {/* Filters Card */}
      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
        <h2 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">Search Availability</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Hotel */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Hotel className="w-3.5 h-3.5 inline mr-1 text-blue-500" />Hotel
            </label>
            <select
              value={selectedHotel}
              onChange={e => setSelectedHotel(e.target.value)}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white"
            >
              <option value="">Select hotel...</option>
              {hotels.map(h => (
                <option key={h.id} value={h.id}>{h.name}</option>
              ))}
            </select>
          </div>

          {/* Room */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Layers className="w-3.5 h-3.5 inline mr-1 text-blue-500" />Room Type
            </label>
            <select
              value={selectedRoom}
              onChange={e => setSelectedRoom(e.target.value)}
              disabled={!selectedHotel || loadingRooms}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white disabled:opacity-50"
            >
              <option value="">
                {loadingRooms ? 'Loading...' : !selectedHotel ? 'Select hotel first' : 'Select room...'}
              </option>
              {rooms.map(r => (
                <option key={r.id} value={r.id}>
                  {r.name} {r.totalCount ? `(${r.totalCount} units)` : '⚠ no totalCount'}
                </option>
              ))}
            </select>
          </div>

          {/* Start Date */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Calendar className="w-3.5 h-3.5 inline mr-1 text-blue-500" />From Date
            </label>
            <input
              type="date"
              value={startDate}
              onChange={e => setStartDate(e.target.value)}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            />
          </div>

          {/* End Date */}
          <div>
            <label className="block text-sm font-semibold text-gray-700 mb-1.5">
              <Calendar className="w-3.5 h-3.5 inline mr-1 text-blue-500" />To Date
            </label>
            <input
              type="date"
              value={endDate}
              onChange={e => setEndDate(e.target.value)}
              min={startDate}
              className="w-full px-3.5 py-2.5 text-sm rounded-xl border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all"
            />
          </div>
        </div>

        {error && (
          <div className="mt-4 flex items-center gap-2 text-sm text-red-600 bg-red-50 border border-red-100 rounded-xl px-4 py-2.5">
            <AlertTriangle className="w-4 h-4 flex-shrink-0" />{error}
          </div>
        )}

        <button
          onClick={handleSearch}
          disabled={loading || !selectedHotel || !selectedRoom}
          className="mt-4 inline-flex items-center gap-2 bg-blue-600 text-white px-6 py-2.5 rounded-xl font-semibold text-sm hover:bg-blue-700 transition-all shadow-lg shadow-blue-500/20 disabled:opacity-50"
        >
          {loading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Search className="w-4 h-4" />}
          {loading ? 'Checking...' : 'Check Availability'}
        </button>
      </div>

      {/* Results */}
      <AnimatePresence>
        {searched && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 12 }}
            className="space-y-4"
          >
            {/* Summary bar */}
            {!loading && availability.length > 0 && (
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white rounded-2xl border border-gray-100 px-5 py-4 shadow-sm">
                <div>
                  <p className="text-sm font-bold text-gray-900">
                    {selectedHotelObj?.name} — {selectedRoomObj?.name}
                  </p>
                  <p className="text-xs text-gray-400 mt-0.5">
                    {formatDateDisplay(startDate)} → {formatDateDisplay(endDate)}
                    {selectedRoomObj?.totalCount && (
                      <span className="ml-2 bg-blue-50 text-blue-600 px-1.5 py-0.5 rounded-full font-semibold">
                        {selectedRoomObj.totalCount} units total
                      </span>
                    )}
                  </p>
                </div>
                <div className="flex gap-3">
                  <div className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 rounded-xl text-emerald-700 text-xs font-bold">
                    <CheckCircle2 className="w-3.5 h-3.5" />{availCount} available
                  </div>
                  <div className="flex items-center gap-1.5 px-3 py-1.5 bg-red-50 rounded-xl text-red-700 text-xs font-bold">
                    <XCircle className="w-3.5 h-3.5" />{unavailCount} fully booked
                  </div>
                </div>
              </div>
            )}

            {/* Loading */}
            {loading && (
              <div className="flex items-center justify-center py-20 gap-3 bg-white rounded-2xl border border-gray-100">
                <Loader2 className="w-7 h-7 text-blue-600 animate-spin" />
                <span className="text-gray-500 text-sm font-medium">Fetching availability…</span>
              </div>
            )}

            {/* Calendar Grid */}
            {!loading && availability.length > 0 && (
              <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <h3 className="text-xs uppercase tracking-wider text-gray-400 font-bold mb-4">
                  Day-by-Day Availability
                </h3>

                {/* Legend */}
                <div className="flex flex-wrap gap-3 mb-4 text-xs font-semibold">
                  <span className="flex items-center gap-1.5 text-emerald-700">
                    <span className="w-3 h-3 rounded bg-emerald-200 inline-block" />Available
                  </span>
                  <span className="flex items-center gap-1.5 text-amber-600">
                    <span className="w-3 h-3 rounded bg-amber-200 inline-block" />Almost full (≤30%)
                  </span>
                  <span className="flex items-center gap-1.5 text-red-600">
                    <span className="w-3 h-3 rounded bg-red-200 inline-block" />Fully booked
                  </span>
                </div>

                <div className="grid grid-cols-4 sm:grid-cols-7 lg:grid-cols-10 gap-2">
                  {availability.map(item => (
                    <DayCell
                      key={item.date}
                      dateStr={item.date}
                      data={item}
                    />
                  ))}
                </div>
              </div>
            )}

            {/* No data */}
            {!loading && searched && availability.length === 0 && !error && (
              <div className="text-center py-16 bg-white rounded-2xl border border-gray-100">
                <Info className="w-10 h-10 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-400 text-sm font-medium">No availability data returned.</p>
                <p className="text-gray-300 text-xs mt-1">Check that this room has a valid totalCount.</p>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default Availability;
```

#### 11.1.1.5 React Web Admin Panel AI Copilot Console and Formatting Engine
```javascript
import React, { useState, useRef, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Sparkles, Send, Bot, User, Trash2, ArrowDown } from 'lucide-react';
import api from '../api';

const suggestions = [
  "ورّيني كل الفنادق والأوض بتاعتهم",
  "فيه أوضة متاحة في فندق X من 10 يونيو لـ 15 يونيو؟",
  "ورّيني الحجوزات اللي pending",
  "ايه أرخص أوضة عندنا دلوقتي؟",
  "الأنشطة والتورز المتاحة إيه؟",
  "احجزلي أوضة لـ أحمد علي",
];

export default function AiAssistant() {
  const [messages, setMessages] = useState([
    {
      role: 'assistant',
      content: "أهلاً! أنا **كونسيرج الغردقة** 🌴 — المساعد الذكي بتاعك في لوحة التحكم.\n\nبقدر أساعدك في كل حاجة:\n- 🏨 **الفنادق والأوض** — تفاصيل وأسعار\n- 📅 **التوافر** — أتحقق من أي أوضة في أي تواريخ\n- 📋 **الحجوزات** — تشوفها وتعدل عليها\n- ✅ **تأكيد أو إلغاء** حجز\n- ➕ **إنشاء حجز جديد**\n\nقولي إيه اللي عايزه بالعامية أو الإنجليزي وأنا هجيبهولك! 😊"
    }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  const messagesEndRef = useRef(null);
  const chatContainerRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, loading]);

  const handleClear = () => {
    if (window.confirm("Are you sure you want to clear this conversation?")) {
      setMessages([
        {
          role: 'assistant',
          content: "أهلاً! أنا **كونسيرج الغردقة** 🌴 — المساعد الذكي بتاعك في لوحة التحكم.\n\nبقدر أساعدك في كل حاجة:\n- 🏨 **الفنادق والأوض** — تفاصيل وأسعار\n- 📅 **التوافر** — أتحقق من أي أوضة في أي تواريخ\n- 📋 **الحجوزات** — تشوفها وتعدل عليها\n- ✅ **تأكيد أو إلغاء** حجز\n- ➕ **إنشاء حجز جديد**\n\nقولي إيه اللي عايزه بالعامية أو الإنجليزي وأنا هجيبهولك! 😊"
        }
      ]);
      setError(null);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const query = input.trim();
    if (!query) return;

    await sendMessage(query);
  };

  const handleSuggestionClick = async (suggestion) => {
    await sendMessage(suggestion);
  };

  const sendMessage = async (textText) => {
    const updatedMessages = [...messages, { role: 'user', content: textText }];
    setMessages(updatedMessages);
    setInput('');
    setLoading(true);
    setError(null);

    try {
      // Send the entire conversation history to backend route /ai/chat
      const res = await api.post('/ai/chat', { messages: updatedMessages });
      
      if (res.data && res.data.response) {
        setMessages(prev => [...prev, { role: 'assistant', content: res.data.response }]);
      } else {
        throw new Error('Invalid response payload from server.');
      }
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data?.error || err.message || "Something went wrong while connecting to the AI service.";
      setError(errMsg);
    } finally {
      setLoading(false);
    }
  };

  // Advanced inline and block formatter for AI Markdown responses
  const renderMessageContent = (text) => {
    if (!text) return null;

    const lines = text.split('\n');
    const elements = [];
    let tableRows = [];
    let inTable = false;
    let tableHeaders = [];
    let listItems = [];
    let inList = false;

    const flushList = (key) => {
      if (listItems.length > 0) {
        elements.push(
          <ul key={`list-${key}`} className="list-disc pl-5 mb-3 space-y-1 text-sm text-gray-700 leading-relaxed">
            {listItems.map((item, idx) => <li key={idx}>{item}</li>)}
          </ul>
        );
        listItems = [];
        inList = false;
      }
    };

    const flushTable = (key) => {
      if (tableRows.length > 0) {
        elements.push(
          <div key={`table-wrapper-${key}`} className="overflow-x-auto my-3 border border-gray-200 rounded-xl shadow-sm">
            <table className="min-w-full divide-y divide-gray-200 text-sm">
              <thead className="bg-gray-50/70 backdrop-blur-sm">
                <tr>
                  {tableHeaders.map((h, idx) => (
                    <th key={idx} className="px-4 py-2.5 text-left font-bold text-gray-800 border-b border-gray-200 tracking-wide">{h}</th>
                  ))}
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {tableRows.map((row, rIdx) => (
                  <tr key={rIdx} className={rIdx % 2 === 0 ? 'bg-white' : 'bg-gray-50/50'}>
                    {row.map((cell, cIdx) => (
                      <td key={cIdx} className="px-4 py-2.5 text-gray-600 font-medium">{cell}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        );
        tableRows = [];
        tableHeaders = [];
        inTable = false;
      }
    };

    const parseInlineMarkdown = (str) => {
      const parts = [];
      let lastIdx = 0;
      const regex = /\*\*(.*?)\*\*/g;
      let match;
      while ((match = regex.exec(str)) !== null) {
        if (match.index > lastIdx) {
          parts.push(str.substring(lastIdx, match.index));
        }
        parts.push(<strong key={match.index} className="font-bold text-gray-900 bg-blue-50 px-1 rounded">{match[1]}</strong>);
        lastIdx = regex.lastIndex;
      }
      if (lastIdx < str.length) {
        parts.push(str.substring(lastIdx));
      }
      return parts.length > 0 ? parts : str;
    };

    lines.forEach((line, lineIdx) => {
      const trimmed = line.trim();

      // Table detection
      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        flushList(lineIdx);
        const cells = trimmed.split('|').map(c => c.trim()).filter((_, idx, arr) => idx > 0 && idx < arr.length - 1);
        const isSeparator = cells.every(c => c.startsWith('-') || c === '');
        if (isSeparator) return;

        if (!inTable) {
          inTable = true;
          tableHeaders = cells.map(c => parseInlineMarkdown(c));
        } else {
          tableRows.push(cells.map(c => parseInlineMarkdown(c)));
        }
        return;
      } else if (inTable) {
        flushTable(lineIdx);
      }

      // Unordered lists
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
        flushTable(lineIdx);
        inList = true;
        listItems.push(parseInlineMarkdown(trimmed.substring(2)));
        return;
      } else if (inList) {
        flushList(lineIdx);
      }

      // Headings
      if (trimmed.startsWith('### ')) {
        elements.push(<h4 key={lineIdx} className="text-base font-bold text-gray-800 mt-4 mb-2 flex items-center gap-1.5">{parseInlineMarkdown(trimmed.substring(4))}</h4>);
        return;
      } else if (trimmed.startsWith('## ')) {
        elements.push(<h3 key={lineIdx} className="text-lg font-extrabold text-gray-950 mt-5 mb-2 border-b border-gray-100 pb-1">{parseInlineMarkdown(trimmed.substring(3))}</h3>);
        return;
      } else if (trimmed.startsWith('# ')) {
        elements.push(<h2 key={lineIdx} className="text-xl font-black text-gray-950 mt-6 mb-3">{parseInlineMarkdown(trimmed.substring(2))}</h2>);
        return;
      }

      // Paragraph / Empty lines
      if (trimmed === '') {
        elements.push(<div key={lineIdx} className="h-2" />);
      } else {
        elements.push(<p key={lineIdx} className="text-sm leading-relaxed text-gray-700 mb-2">{parseInlineMarkdown(line)}</p>);
      }
    });

    // Final flushes
    flushList('final');
    flushTable('final');

    return elements;
  };

  return (
    <div className="flex flex-col h-[calc(100vh-80px)] lg:h-[calc(100vh-40px)] bg-gray-50/50 rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
      {/* Header */}
      <div className="px-6 py-4 bg-white border-b border-gray-100 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center text-white shadow-md shadow-blue-500/10">
            <Sparkles className="w-5 h-5 animate-pulse" />
          </div>
          <div>
            <h2 className="text-base font-bold text-gray-900 flex items-center gap-2">
              Hurghada Concierge
              <span className="text-[10px] font-semibold bg-emerald-50 text-emerald-600 border border-emerald-100 px-1.5 py-0.5 rounded-full uppercase tracking-wider">Live DB Access</span>
            </h2>
            <p className="text-xs text-gray-400 font-medium">مساعدك الذكي للإدارة — بيفهم عربي وإنجليزي</p>
          </div>
        </div>
        <button
          onClick={handleClear}
          className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all duration-200"
          title="Clear Conversation"
        >
          <Trash2 className="w-4.5 h-4.5" />
        </button>
      </div>

      {/* Main Chat Area */}
      <div 
        ref={chatContainerRef}
        className="flex-1 overflow-y-auto p-6 space-y-4"
      >
        <AnimatePresence initial={false}>
          {messages.map((msg, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.25 }}
              className={`flex gap-4.5 max-w-[85%] ${msg.role === 'user' ? 'ml-auto flex-row-reverse' : 'mr-auto'}`}
            >
              {/* Avatar */}
              <div className={`w-8.5 h-8.5 rounded-xl flex items-center justify-center flex-shrink-0 shadow-sm ${
                msg.role === 'user'
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-blue-600 border border-gray-100'
              }`}>
                {msg.role === 'user' ? <User className="w-4 h-4" /> : <Bot className="w-4 h-4" />}
              </div>

              {/* Message Bubble */}
              <div className={`px-4.5 py-3 rounded-2xl text-sm ${
                msg.role === 'user'
                  ? 'bg-blue-600 text-white rounded-tr-none'
                  : 'bg-white text-gray-800 border border-gray-100 rounded-tl-none shadow-sm shadow-gray-100/50'
              }`}>
                {msg.role === 'user' ? (
                  <p className="leading-relaxed font-medium">{msg.content}</p>
                ) : (
                  <div className="space-y-0.5">
                    {renderMessageContent(msg.content)}
                  </div>
                )}
              </div>
            </motion.div>
          ))}

          {/* Typing Indicator */}
          {loading && (
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="flex gap-4.5 max-w-[80%] mr-auto"
            >
              <div className="w-8.5 h-8.5 rounded-xl bg-white text-blue-600 border border-gray-100 flex items-center justify-center shadow-sm">
                <Bot className="w-4 h-4 animate-spin-slow" />
              </div>
              <div className="px-4.5 py-3 rounded-2xl rounded-tl-none bg-white border border-gray-100 shadow-sm">
                <div className="flex items-center gap-2 mb-1.5">
                  <span className="text-[10px] font-bold text-blue-500 uppercase tracking-wider">بيفكر ويجيب البيانات...</span>
                </div>
                <div className="flex items-center gap-1.5">
                  <div className="w-2 h-2 rounded-full bg-blue-500 animate-bounce" style={{ animationDelay: '0ms' }} />
                  <div className="w-2 h-2 rounded-full bg-blue-500 animate-bounce" style={{ animationDelay: '150ms' }} />
                  <div className="w-2 h-2 rounded-full bg-blue-500 animate-bounce" style={{ animationDelay: '300ms' }} />
                </div>
              </div>
            </motion.div>
          )}

          {/* Error Message */}
          {error && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="p-4 bg-red-50 border border-red-100 rounded-xl text-red-700 text-xs font-semibold max-w-[85%] mx-auto text-center"
            >
              ⚠️ Error: {error}
            </motion.div>
          )}
        </AnimatePresence>
        <div ref={messagesEndRef} />
      </div>

      {/* Suggested Questions & Input Area */}
      <div className="p-6 bg-white border-t border-gray-100">
        {/* Suggestion Chips */}
        {messages.length === 1 && !loading && (
          <div className="mb-4">
            <p className="text-xs text-gray-400 font-semibold mb-2.5 uppercase tracking-wide">جرّب تسأل</p>
            <div className="flex flex-wrap gap-2">
              {suggestions.map((suggestion, idx) => (
                <button
                  key={idx}
                  onClick={() => handleSuggestionClick(suggestion)}
                  className="px-3.5 py-2 text-xs font-medium text-blue-600 bg-blue-50/50 hover:bg-blue-50 border border-blue-100/50 rounded-xl transition-all duration-200 text-left"
                >
                  {suggestion}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Input Form */}
        <form onSubmit={handleSubmit} className="flex gap-3">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            disabled={loading}
            placeholder="اسأل بالعامية أو الإنجليزي... مثلاً: احجزلي أوضة، ورّيني الحجوزات"
            className="flex-1 px-4.5 py-3 text-sm bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium disabled:opacity-50 disabled:bg-gray-100"
          />
          <button
            type="submit"
            disabled={loading || !input.trim()}
            className="px-5 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold flex items-center justify-center gap-2 transition-all duration-200 shadow-md shadow-blue-500/10 disabled:opacity-50 disabled:shadow-none disabled:hover:bg-blue-600"
          >
            <span>Send</span>
            <Send className="w-4 h-4" />
          </button>
        </form>
      </div>
    </div>
  );
}
```

### 11.1.2 Backend Codes

#### 11.1.2.1 Express.js Backend Firestore Concurrency Control Booking Transaction
```javascript
// Implements optimistic concurrency locks using Firestore Transactions to verify vacancies
// and write new booking entries atomically, preventing double-bookings.
router.post('/bookings/create', async (req, res) => {
  const { userId, hotelId, roomId, dates, totalPrice } = req.body; // dates is an array of strings e.g. ["2026-06-18", "2026-06-19"]

  try {
    await db.runTransaction(async (transaction) => {
      const availabilityDocs = [];
      
      // 1. Read phase: Retrieve current availability documents for all requested dates
      for (const date of dates) {
        const docId = `${hotelId}_${roomId}_${date}`;
        const ref = db.collection('availability').doc(docId);
        const snapshot = await transaction.get(ref);
        
        if (!snapshot.exists) {
          throw new Error(`Room availability records not initialized for date ${date}.`);
        }
        
        const data = snapshot.data();
        if (data.bookingsCount >= data.maxCapacity) {
          throw new Error(`Double-booking prevented: No vacancy remaining on ${date}.`);
        }
        
        availabilityDocs.push({ ref, currentBookings: data.bookingsCount });
      }

      // 2. Write phase: Increment bookings count for each date and write new booking document
      for (const item of availabilityDocs) {
        transaction.update(item.ref, { bookingsCount: item.currentBookings + 1 });
      }

      const bookingRef = db.collection('bookings').doc();
      transaction.set(bookingRef, {
        userId,
        hotelId,
        roomId,
        dates,
        totalPrice,
        status: 'confirmed',
        createdAt: new Date().toISOString()
      });
    });

    res.status(200).json({ success: true, message: 'Reservation checked out and locked successfully.' });
  } catch (error) {
    res.status(409).json({ success: false, error: error.message });
  }
});
```

#### 11.1.2.2 Express.js Backend Firestore Concurrency Control Cancellation Handler
```javascript
/**
 * Cancels a booking and restores availability using a Firestore transaction.
 *
 * Steps:
 *  1. Get booking doc
 *  2. Validate not already cancelled
 *  3. Transaction: decrement bookedCount for each date
 *     → delete availability doc if bookedCount reaches 0
 *  4. Update booking status → 'cancelled'
 */
router.patch('/:bookingId/cancel', async (req, res) => {
  const db = req.db;
  const { bookingId } = req.params;

  // --- Fetch the booking ---
  let bookingData;
  const bookingRef = db.collection('bookings').doc(bookingId);

  try {
    const snap = await bookingRef.get();
    if (!snap.exists) {
      return res.status(404).json({ error: 'Booking not found.' });
    }
    bookingData = snap.data();
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch booking: ' + err.message });
  }

  if (bookingData.status === 'cancelled') {
    return res.status(400).json({ error: 'Booking is already cancelled.' });
  }

  // --- Reconstruct date range ---
  let dates;
  try {
    dates = generateDateRange(bookingData.checkIn, bookingData.checkOut);
  } catch (err) {
    return res.status(500).json({ error: 'Could not reconstruct date range: ' + err.message });
  }

  const { hotelId, roomId } = bookingData;
  const availRef = db.collection('availability');
  const availDocRefs = dates.map((date) =>
    availRef.doc(`${hotelId}_${roomId}_${date}`)
  );

  // --- Firestore Transaction ---
  try {
    await db.runTransaction(async (t) => {
      const snaps = await Promise.all(availDocRefs.map((ref) => t.get(ref)));

      for (let i = 0; i < dates.length; i++) {
        const snap = snaps[i];
        const ref  = availDocRefs[i];

        if (!snap.exists) {
          // Doc was already deleted or never existed — skip
          continue;
        }

        const bookedCount = snap.data().bookedCount || 0;
        const newCount = bookedCount - 1;

        if (newCount <= 0) {
          // No bookings left for this date — delete the doc to keep Firestore clean
          t.delete(ref);
        } else {
          t.update(ref, {
            bookedCount: admin.firestore.FieldValue.increment(-1),
          });
        }
      }

      // Update booking status
      t.update(bookingRef, {
        status: 'cancelled',
        cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    return res.json({ success: true, message: 'Booking cancelled successfully.' });

  } catch (err) {
    console.error('Cancellation transaction error:', err);
    return res.status(500).json({ error: 'Cancellation failed: ' + err.message });
  }
});
```

#### 11.1.2.3 Express.js Backend Parallel Multi-Night Availability Fetcher
```javascript
// Optimizes multi-night availability searches by issuing document fetches in parallel
// using Promise.all(), eliminating round-trip latency overheads.
router.get('/availability', async (req, res) => {
  const { hotelId, roomId, startDate, endDate } = req.query;

  try {
    // Generate the array of date strings between startDate and endDate
    const dateArray = [];
    let current = new Date(startDate);
    const end = new Date(endDate);
    
    while (current < end) {
      dateArray.push(current.toISOString().split('T')[0]);
      current.setDate(current.getDate() + 1);
    }

    // Query NoSQL Firestore documents in parallel using Promise.all()
    const promises = dateArray.map(async (date) => {
      const docId = `${hotelId}_${roomId}_${date}`;
      const docRef = db.collection('availability').doc(docId);
      const docSnap = await docRef.get();
      
      if (docSnap.exists) {
        const data = docSnap.data();
        return {
          date,
          available: data.bookingsCount < data.maxCapacity,
          remainingRooms: data.maxCapacity - data.bookingsCount,
          totalCount: data.maxCapacity
        };
      } else {
        // Fallback: If no document exists, assume room has default maxCapacity (e.g. 10) and is fully available
        return {
          date,
          available: true,
          remainingRooms: 10,
          totalCount: 10
        };
      }
    });

    const results = await Promise.all(promises);
    res.status(200).json(results);
  } catch (error) {
    res.status(500).json({ error: 'Failed to retrieve multi-night availability.', details: error.message });
  }
});
```

#### 11.1.2.4 Express.js Backend Administrator Authentication and Access Verification Middleware
```javascript
async function verifyAdmin(req, res, next) {
  const token = req.headers.authorization?.split('Bearer ')[1];
  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    const userDoc = await db.collection('users').doc(decodedToken.uid).get();
    const userData = userDoc.data();

    if (userData && userData.role === 'admin') {
      req.user = decodedToken;
      next();
    } else {
      res.status(403).json({ error: 'Forbidden: Admin access only' });
    }
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
}
```

### 11.1.3 AI Codes

#### 11.1.3.1 Google Gemini AI Agent Tool Definitions and Schema Declaration
```javascript
const tools = [{
  functionDeclarations: [
    {
      name: 'search_hotels',
      description: 'Search and list hotels. Can filter by name or location. Returns hotel details including rooms.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          name_filter:     { type: Type.STRING, description: 'Optional partial hotel name to filter by' },
          location_filter: { type: Type.STRING, description: 'Optional location to filter by' },
        },
      },
    },
    {
      name: 'get_hotel_rooms',
      description: 'Get all rooms for a specific hotel by hotel ID.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id: { type: Type.STRING, description: 'The Firestore document ID of the hotel' },
        },
        required: ['hotel_id'],
      },
    },
    {
      name: 'check_availability',
      description: 'Check room availability for specific dates. Returns remaining rooms per day.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id:  { type: Type.STRING, description: 'Hotel ID' },
          room_id:   { type: Type.STRING, description: 'Room ID' },
          check_in:  { type: Type.STRING, description: 'Check-in date YYYY-MM-DD' },
          check_out: { type: Type.STRING, description: 'Check-out date YYYY-MM-DD' },
        },
        required: ['hotel_id', 'room_id', 'check_in', 'check_out'],
      },
    },
    {
      name: 'get_activities',
      description: 'Get all available tours and activities.',
      parameters: { type: Type.OBJECT, properties: {} },
    },
    {
      name: 'get_bookings',
      description: 'Fetch bookings with optional filters by status, hotel name, or guest.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          status_filter: { type: Type.STRING, description: 'Filter: confirmed, pending, cancelled, rejected' },
          hotel_filter:  { type: Type.STRING, description: 'Filter by hotel name (partial)' },
          guest_filter:  { type: Type.STRING, description: 'Filter by guest name or email (partial)' },
          limit:         { type: Type.NUMBER, description: 'Max results to return (default 20)' },
        },
      },
    },
    {
      name: 'update_booking_status',
      description: 'Update booking status to confirmed, cancelled, pending, or rejected.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          booking_id: { type: Type.STRING, description: 'Firestore booking document ID' },
          new_status: { type: Type.STRING, description: 'New status: confirmed, cancelled, pending, rejected' },
        },
        required: ['booking_id', 'new_status'],
      },
    },
    {
      name: 'create_booking',
      description: 'Create a new hotel room booking with availability check. Use when admin wants to manually book for a guest.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id:    { type: Type.STRING, description: 'Hotel ID' },
          room_id:     { type: Type.STRING, description: 'Room ID' },
          hotel_name:  { type: Type.STRING, description: 'Hotel name' },
          room_name:   { type: Type.STRING, description: 'Room name or type' },
          guest_name:  { type: Type.STRING, description: 'Guest full name' },
          guest_email: { type: Type.STRING, description: 'Guest email' },
          check_in:    { type: Type.STRING, description: 'Check-in date YYYY-MM-DD' },
          check_out:   { type: Type.STRING, description: 'Check-out date YYYY-MM-DD' },
          total_price: { type: Type.NUMBER, description: 'Total price' },
          user_id:     { type: Type.STRING, description: 'Firebase user ID (use "admin_created" if unknown)' },
        },
        required: ['hotel_id', 'room_id', 'hotel_name', 'room_name', 'guest_name', 'guest_email', 'check_in', 'check_out', 'total_price'],
      },
    },
    {
      name: 'update_hotel',
      description: 'Update an existing hotel\'s details.',
      parameters: {
        type: Type.OBJECT,
        properties: {
          hotel_id: { type: Type.STRING, description: 'Hotel Firestore ID' },
          updates:  { type: Type.OBJECT, description: 'Key-value pairs of fields to update' },
        },
        required: ['hotel_id', 'updates'],
      },
    },
  ],
}];
```

#### 11.1.3.2 Google Gemini AI Tool Execution and Firestore Database Integration
```javascript
async function executeTool(name, args, db) {
  const convertTs = (v) => v?.seconds ? new Date(v.seconds * 1000).toISOString() : v;

  switch (name) {
    case 'search_hotels': {
      const snap = await db.collection('hotels').get();
      let hotels = await Promise.all(snap.docs.map(async (doc) => {
        const data = doc.data();
        const roomsSnap = await doc.ref.collection('rooms').get();
        return {
          id: doc.id,
          name: data.name,
          location: data.location,
          description: data.description,
          rating: data.rating,
          pricePerNight: data.pricePerNight,
          rooms: roomsSnap.docs.map(r => ({ id: r.id, ...r.data() })),
        };
      }));
      if (args.name_filter) {
        const f = args.name_filter.toLowerCase();
        hotels = hotels.filter(h => h.name?.toLowerCase().includes(f));
      }
      if (args.location_filter) {
        const f = args.location_filter.toLowerCase();
        hotels = hotels.filter(h => h.location?.toLowerCase().includes(f));
      }
      return { hotels, total: hotels.length };
    }

    case 'get_hotel_rooms': {
      const roomsSnap = await db.collection('hotels').doc(args.hotel_id).collection('rooms').get();
      const rooms = roomsSnap.docs.map(r => ({ id: r.id, ...r.data() }));
      return { hotel_id: args.hotel_id, rooms, total: rooms.length };
    }

    case 'check_availability': {
      const dates = [];
      const cur = new Date(args.check_in);
      const end = new Date(args.check_out);
      while (cur < end) { dates.push(cur.toISOString().split('T')[0]); cur.setDate(cur.getDate() + 1); }

      const roomSnap = await db.collection('hotels').doc(args.hotel_id).collection('rooms').doc(args.room_id).get();
      if (!roomSnap.exists) return { error: 'Room not found' };
      const totalCount = roomSnap.data().totalCount || 1;

      const snaps = await Promise.all(dates.map(d =>
        db.collection('availability').doc(`${args.hotel_id}_${args.room_id}_${d}`).get()
      ));
      const result = snaps.map((snap, i) => {
        const booked = snap.exists ? (snap.data().bookedCount || 0) : 0;
        return { date: dates[i], available: booked < totalCount, remaining: Math.max(0, totalCount - booked), bookedCount: booked, totalCount };
      });
      return { check_in: args.check_in, check_out: args.check_out, availability: result, fully_available: result.every(r => r.available) };
    }

    case 'get_activities': {
      const snap = await db.collection('activities').get();
      return { activities: snap.docs.map(d => ({ id: d.id, ...d.data() })), total: snap.size };
    }

    case 'get_bookings': {
      const limit = args.limit || 20;
      const snap = await db.collection('bookings').orderBy('createdAt', 'desc').get();
      let bookings = snap.docs.map(doc => {
        const data = doc.data();
        return {
          id: doc.id,
          guestName: data.guestName || data.userName || 'N/A',
          guestEmail: data.guestEmail || data.userEmail || 'N/A',
          hotelName: data.hotelName || 'N/A',
          roomName: data.roomName || data.roomType || 'N/A',
          checkIn: convertTs(data.checkIn) || convertTs(data.checkInDate),
          checkOut: convertTs(data.checkOut) || convertTs(data.checkOutDate),
          nights: data.nights || 0,
          totalPrice: data.totalPrice || 0,
          status: data.status || 'pending',
          type: data.type || 'hotel',
          createdAt: convertTs(data.createdAt),
        };
      });
      if (args.status_filter) bookings = bookings.filter(b => b.status === args.status_filter);
      if (args.hotel_filter) { const f = args.hotel_filter.toLowerCase(); bookings = bookings.filter(b => b.hotelName?.toLowerCase().includes(f)); }
      if (args.guest_filter) { const f = args.guest_filter.toLowerCase(); bookings = bookings.filter(b => b.guestName?.toLowerCase().includes(f) || b.guestEmail?.toLowerCase().includes(f)); }
      return { bookings: bookings.slice(0, limit), total: bookings.length, showing: Math.min(bookings.length, limit) };
    }

    case 'update_booking_status': {
      const { booking_id, new_status } = args;
      const validStatuses = ['confirmed', 'cancelled', 'pending', 'rejected'];
      if (!validStatuses.includes(new_status)) return { error: `Invalid status "${new_status}". Use: ${validStatuses.join(', ')}` };
      const bookingRef = db.collection('bookings').doc(booking_id);
      const snap = await bookingRef.get();
      if (!snap.exists) return { error: `Booking "${booking_id}" not found.` };
      const updateData = { status: new_status, updatedAt: admin.firestore.FieldValue.serverTimestamp() };
      if (new_status === 'cancelled') updateData.cancelledAt = admin.firestore.FieldValue.serverTimestamp();
      await bookingRef.update(updateData);
      return { success: true, booking_id, new_status, message: `Booking updated to "${new_status}" successfully.` };
    }

    case 'create_booking': {
      const { hotel_id, room_id, hotel_name, room_name, guest_name, guest_email, check_in, check_out, total_price, user_id } = args;
      const dates = [];
      const cur = new Date(check_in); const end = new Date(check_out);
      while (cur < end) { dates.push(cur.toISOString().split('T')[0]); cur.setDate(cur.getDate() + 1); }
      if (dates.length === 0) return { error: 'Invalid dates — no nights produced.' };

      const roomSnap = await db.collection('hotels').doc(hotel_id).collection('rooms').doc(room_id).get();
      if (!roomSnap.exists) return { error: 'Room not found.' };
      const totalCount = roomSnap.data().totalCount || 1;

      const availRef = db.collection('availability');
      const availDocRefs = dates.map(d => availRef.doc(`${hotel_id}_${room_id}_${d}`));
      const bookingRef = db.collection('bookings').doc();

      try {
        await db.runTransaction(async (t) => {
          const snaps = await Promise.all(availDocRefs.map(ref => t.get(ref)));
          for (let i = 0; i < dates.length; i++) {
            const booked = snaps[i].exists ? (snaps[i].data().bookedCount || 0) : 0;
            if (booked >= totalCount) { const e = new Error(`Fully booked on ${dates[i]}`); e.code = 'NOT_AVAILABLE'; throw e; }
          }
          for (let i = 0; i < dates.length; i++) {
            if (!snaps[i].exists) t.set(availDocRefs[i], { hotelId: hotel_id, roomId: room_id, date: dates[i], bookedCount: 1, totalCount });
            else t.update(availDocRefs[i], { bookedCount: admin.firestore.FieldValue.increment(1) });
          }
          t.set(bookingRef, {
            userId: user_id || 'admin_created', hotelId: hotel_id, roomId: room_id,
            hotelName: hotel_name, roomName: room_name, guestName: guest_name, guestEmail: guest_email,
            checkIn: check_in, checkOut: check_out, nights: dates.length, totalPrice: total_price,
            status: 'confirmed', type: 'hotel', createdBy: 'admin_ai',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        });
        return { success: true, booking_id: bookingRef.id, nights: dates.length, guest: guest_name, hotel: hotel_name, room: room_name, check_in, check_out, total_price };
      } catch (err) {
        return err.code === 'NOT_AVAILABLE' ? { error: err.message } : { error: 'Booking failed: ' + err.message };
      }
    }

    case 'update_hotel': {
      const { hotel_id, updates } = args;
      const ref = db.collection('hotels').doc(hotel_id);
      const snap = await ref.get();
      if (!snap.exists) return { error: `Hotel "${hotel_id}" not found.` };
      await ref.update({ ...updates, updatedAt: admin.firestore.FieldValue.serverTimestamp() });
      return { success: true, hotel_id, updated_fields: Object.keys(updates) };
    }

    default:
      return { error: `Unknown tool: ${name}` };
  }
}
```

#### 11.1.3.3 Google Gemini AI Concierge System Instruction and Dialect Adaptation
```javascript
const SYSTEM_PROMPT = `أنت "كونسيرج الغردقة" — المساعد الذكي لـ Go-Hurghada Travel Admin Panel.
بتكلم عربي وإنجليزي وبتفهم العامية المصرية كويس.

══════════════════════════════════
عندك أدوات تقدر تستخدمها:
══════════════════════════════════
- search_hotels → دور وعرض الفنادق والأوض
- get_hotel_rooms → اجيب أوض فندق معين
- check_availability → تحقق من التوافر بالتواريخ
- get_activities → اجيب الأنشطة والتورز
- get_bookings → اعرض الحجوزات مع فلاتر
- update_booking_status → أكد أو ألغي أو ارفض حجز
- create_booking → انشئ حجز جديد بفحص التوافر
- update_hotel → عدّل بيانات فندق

══════════════════════════════════
ترجمة العامية للأكشن:
══════════════════════════════════
"احجزلي" / "احجزله" / "عايز أحجز" / "ابقى احجزلي" → create_booking
"ألغي الحجز" / "كنسل" / "إلغاء" → update_booking_status (cancelled)
"أكد الحجز" / "تمم" / "confirm" → update_booking_status (confirmed)
"فيه أوضة؟" / "متاح؟" / "مفيش حاجة؟" / "الفندق فاضي؟" → check_availability
"ورّيني الفنادق" / "اعرض الفنادق" / "الفنادق إيه؟" → search_hotels
"الأوضة بكام؟" / "أرخص أوضة" / "الأغلى إيه؟" → search_hotels
"ورّيني الحجوزات" / "فيه حجوزات pending؟" → get_bookings
"الأنشطة إيه؟" / "فيه تورز؟" / "الرحلات إيه؟" → get_activities

══════════════════════════════════
قواعد أساسية:
══════════════════════════════════
1. استخدم الأدوات دايماً — ماتخمنش أي بيانات. الداتا بتيجي من الـ database فقط.
2. لو المستخدم قال "احجزلي أوضة في فندق X":
   - الخطوة 1: search_hotels (لقي hotel_id و room_id)
   - الخطوة 2: check_availability (تأكد التوافر)
   - الخطوة 3: create_booking (لو متاح)
3. لو معلومة ناقصة (التواريخ مثلاً أو اسم الضيف) — اسأل عنها بأسلوب ودود.
4. بعد أي أكشن (حجز / إلغاء / تعديل) — وضّح للمستخدم بالظبط إيه اللي حصل.
5. فرمت الردود بـ Markdown: جداول للقوائم، **bold** للأسعار والأسماء، ✅ للنجاح، ❌ للخطأ.
6. رد بنفس لغة المستخدم — عربي بعربي، إنجليزي بإنجليزي. لو عامية → رد بعامية.
7. كن ودود ودافئ — مش روبوت. ماتبقاش رسمي زيادة عن اللزوم.`;
```

#### 11.1.3.4 Express.js Backend Google Gemini Agentic Multi-Turn Tool-Calling Loop
```javascript
router.post('/chat', async (req, res) => {
  const { messages } = req.body;
  const db = req.db;

  if (!messages || !Array.isArray(messages)) {
    return res.status(400).json({ error: 'Invalid or missing messages array.' });
  }
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) return res.status(500).json({ error: 'GEMINI_API_KEY not configured.' });

  try {
    const ai = new GoogleGenAI({ apiKey });

    // Convert client message history to Gemini format
    const history = messages.slice(0, -1).map(msg => ({
      role: msg.role === 'assistant' ? 'model' : 'user',
      parts: [{ text: msg.content }],
    }));

    const lastUserMessage = messages[messages.length - 1].content;

    // Start chat session with history
    const chat = ai.chats.create({
      model: 'gemini-2.5-flash',
      config: {
        systemInstruction: SYSTEM_PROMPT,
        tools,
      },
      history,
    });

    // Agentic loop
    const toolCallLog = [];
    let finalText = null;
    let currentMessage = lastUserMessage;

    for (let turn = 0; turn < 8; turn++) {
      const response = await chat.sendMessage({ message: currentMessage });

      // Check for function calls
      const functionCalls = response.functionCalls;

      if (!functionCalls || functionCalls.length === 0) {
        finalText = response.text;
        break;
      }

      // Execute all tool calls
      const toolResults = await Promise.all(
        functionCalls.map(async (fc) => {
          toolCallLog.push({ tool: fc.name, args: fc.args });
          const result = await executeTool(fc.name, fc.args, db);
          return { name: fc.name, response: result };
        })
      );

      // Send tool results back and continue loop
      currentMessage = toolResults.map(tr => ({
        functionResponse: {
          name: tr.name,
          response: tr.response
        }
      }));
    }

    if (!finalText) {
      finalText = 'معلش، في مشكلة في معالجة الطلب. جرّب تاني.';
    }

    res.json({ response: finalText, toolsUsed: toolCallLog.map(t => t.tool) });

  } catch (error) {
    console.error('AI Chat Error:', error);
    res.status(500).json({ error: 'AI request failed: ' + error.message });
  }
});
module.exports = router;
```



## 11.2 System Configurations
*   **Gemini Engine Settings**: Temperature = 0.2, TopP = 0.95, Model = `gemini-2.5-flash`.
*   **Database Constraints**: Collections partitioned into `users`, `bookings`, `rooms`, `availability`, and `tours`.
*   **Local Caching Policy (Hive)**: Stored local files are encrypted using 256-bit AES cryptographic boxes.
*   **Transaction Options**: Max retries = 5, transaction timeout threshold = 8000ms.


---

# Chapter 12: References

## 12.1 References
The following references support the system architecture, AI integration, database design, transaction protocols, and administrative control features used in Go-Hurghada:

[1] Fielding, R. T. (2000). Architectural Styles and the Design of Network-based Software Architectures. University of California, Irvine. https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm

[2] Flutter. Flutter Documentation Home. https://docs.flutter.dev/

[3] Riverpod. Riverpod State Management Framework Guide. https://riverpod.dev/

[4] Google. Gemini API Documentation Home. https://ai.google.dev/gemini-api/docs

[5] Google. Gemini JSON Mode and Structured Output Guide. https://ai.google.dev/gemini-api/docs/structured-output

[6] Google. Gemini Custom System Instructions Guide. https://ai.google.dev/gemini-api/docs/system-instructions

[7] Android Developers. url_launcher Package for Flutter. https://pub.dev/packages/url_launcher

[8] Android Developers. webview_flutter Package for Flutter. https://pub.dev/packages/webview_flutter

[9] Firebase. Cloud Firestore Security Rules Architecture. https://firebase.google.com/docs/firestore/security/rules-structure

[10] Firebase. Controlling Access via Custom Authentication Claims. https://firebase.google.com/docs/auth/admin/custom-claims

[11] Firebase. Paginate Data Using Query Cursors Documentation. https://firebase.google.com/docs/firestore/query-data/query-cursors

[12] Firebase. Optimizing Analytics via Aggregation Queries. https://firebase.google.com/docs/firestore/query-data/aggregation-queries

[13] Firebase. Initializing and Configuring the Firebase Admin SDK. https://firebase.google.com/docs/admin/setup

[14] Firebase. Programmatic Authentication Management: Delete and Modify Users. https://firebase.google.com/docs/auth/admin/manage-users

[15] Firebase. Case Study: Building a Dashboard Using React and Firebase. https://firebase.google.com/posts/2021/11/building-a-dashboard-with-firebase-and-react