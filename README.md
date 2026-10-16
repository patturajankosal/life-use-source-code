# 📱 LifeUse — Intelligent Mobile & Financial Management Platform

A production-grade, enterprise-architected full-stack mobile application ecosystem built with **Flutter** (Cross-platform Mobile Frontend), **Java Spring Boot 3** (REST API Backend), and **PostgreSQL** (Relational Database).

---

## 🌟 Key Highlights

- **4-Tier Clean Architecture:** Strict separation across `Routes` $\rightarrow$ `Controller` $\rightarrow$ `IService` $\rightarrow$ `Service` $\rightarrow$ `IRepository` $\rightarrow$ `Repository` $\rightarrow$ `Constants (SQL Queries)` $\rightarrow$ `Entities / DTOs`.
- **JWT & Role-Based Security:** Stateless access tokens (15-min expiry) + persisted revocable refresh tokens (7-day sliding expiry) with BCrypt hashing.
- **Intelligent Money Manager:** 
  - Dynamic Daily Spending Limits based on variable cash flow, recurring bills, and savings commitments.
  - Automated Budget Pressure Warnings (Normal, Moderate, Critical).
  - Category-level budgets with carry-forward rules (Unspent Only, Total Budget, None).
  - Idempotent financial transaction tracking.
  - Recurring scheduled payments with automated occurrence pre-generation.
- **Unified API Response Standard:** Consistent `ApiResponse<T>` container with standardized error codes, correlation IDs, and global exception mapping (`@RestControllerAdvice`).
- **Zero Stack-Trace Leakage:** Layered exception boundaries translating low-level JDBC `DataAccessException` into contextual `DatabaseOperationException` and client-safe HTTP payloads.
- **Automated Database Migrations:** Production Flyway migration scripts version-controlled under `src/main/resources/db/migration`.

---

## 🏗️ Architecture & Project Structure

```
Mobile-Application-dev/
├── .env.example                     # Environment variables template
├── .gitignore                       # Multi-tier production Git ignore rules
├── pom.xml                          # Maven build dependencies (Java 21, Spring Boot 3.3.4)
├── mvnw / mvnw.cmd                  # Maven wrappers
├── sql/                             # PostgreSQL schema DDL and reference scripts
│   ├── all_tables.sql
│   └── tables/                      # Individual module DDLs
├── src/                             # Spring Boot Backend Source
│   ├── main/
│   │   ├── java/com/lifeuse/
│   │   │   ├── auth/                # Login, Register, Token, Password Reset, Verification
│   │   │   ├── common/              # ApiResponse, GlobalExceptionHandler, Exceptions, Utils
│   │   │   ├── money/               # Money Manager (Controllers, Services, Repositories, Entities, DTOs)
│   │   │   ├── notification/        # Email & SMS Service adapters
│   │   │   ├── security/            # JWT Filter, SecurityConfig, EntryPoints
│   │   │   └── user/                # User entity, UserService, UserRepository
│   │   └── resources/
│   │       ├── application.yml      # Externalized configuration
│   │       └── db/migration/        # Flyway versioned migrations (V1, V2, V3)
│   └── test/                        # Comprehensive JUnit 5 & Mockito test suites (105 tests)
└── lifeuse_mobile/                  # Flutter Mobile Application
    ├── lib/                         # Flutter Dart source code (Bloc/Provider/UI/Services)
    ├── assets/                      # Application icons, images, fonts
    ├── pubspec.yaml                 # Flutter dependencies
    └── android/ / ios/ / web/       # Native platform wrappers
```

---

## 🚀 Getting Started

### Prerequisites

- **Java JDK:** 21 LTS or newer
- **PostgreSQL:** 15+ or 16+
- **Flutter SDK:** 3.x+
- **Git:** 2.x+

---

### 1. Database Setup (PostgreSQL)

Create the database in PostgreSQL:
```sql
CREATE DATABASE "LifeUse";
```

*(Flyway will automatically execute migrations `V1__init_schema.sql`, `V2__add_username_and_unique_indexes.sql`, and `V3__create_money_manager_tables.sql` upon backend startup).*

---

### 2. Backend Setup & Run

1. Copy `.env.example` to your environment or configure your system variables:
   ```bash
   cp .env.example .env
   ```
2. Verify database credentials in `src/main/resources/application.yml` or set environment variables:
   ```bash
   export DB_URL="jdbc:postgresql://localhost:5432/LifeUse"
   export DB_USERNAME="postgres"
   export DB_PASSWORD="your_password"
   export JWT_SECRET="404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970"
   ```
3. Run automated tests:
   ```bash
   ./mvnw clean test        # Linux / macOS
   .\mvnw.cmd clean test    # Windows
   ```
4. Start the backend application:
   ```bash
   ./mvnw spring-boot:run   # Starts on port 8080 by default
   ```
5. **Swagger UI API Documentation:**
   Once running, access interactive OpenAPI documentation at:  
   `http://localhost:8080/swagger-ui.html`

---

### 3. Mobile Frontend Setup & Run (Flutter)

1. Navigate to the mobile directory:
   ```bash
   cd lifeuse_mobile
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## 🔒 Security Best Practices

- **Secrets Isolation:** Never commit `.env` or production credentials. Use `.env.example` as a template.
- **Token Security:** Short-lived access tokens with cryptographic HMAC-SHA256 signatures.
- **Data Protection:** Cross-user data isolation enforced at the SQL query parameter level (`WHERE user_id = :userId`).

---

## 📄 License

Proprietary enterprise application developed for the LifeUse ecosystem.
