# Automated API Testing Framework
### Simple Grocery Store API

[![Postman](https://img.shields.io/badge/Postman-FF6C37?style=flat-square&logo=postman&logoColor=white)](https://www.postman.com/)
[![Newman](https://img.shields.io/badge/Newman-orange?style=flat-square&logo=postman&logoColor=white)](https://github.com/postmanlabs/newman)
[![Bash Scripting](https://img.shields.io/badge/Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![JavaScript](https://img.shields.io/badge/JavaScript-ES6-F7DF1E?style=flat-square&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![GitHub Actions CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=flat-square&logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

A robust, enterprise-grade automated testing framework designed to validate the business logic, performance, security, and state integrity of the **Simple Grocery Store API**. This framework leverages **Postman** for suite development, **Newman** for headless CLI execution, a **Bash script wrapper** for environment management and reporting orchestration, and **GitHub Actions** for continuous integration (CI/CD).

---

## 🚀 Key Automation Features

### 1. Dynamic State Handover (Request Chaining)
To mimic authentic user workflows, the framework dynamically extracts response payloads and headers, injecting them into successive requests.
* **Token Extraction:** Automatically registers an API client, parses the bearer token, and sets it to the Postman environment variables for authorization headers.
* **Lifecycle Flow:** Seamlessly propagates `cartId` and `orderId` throughout the cart modifications, ordering, and deletion lifecycle.

### 2. Advanced Test Assertions & Validations
The test suite utilizes the Postman Sandbox (ES6 JavaScript) to enforce strict validation rules:
* **Response Schema Verification:** Employs JSON Schema Validation to guarantee the structure of responses matches contract definitions.
* **Performance SLA Audits:** Asserts that API response latency is within acceptable thresholds (e.g., `< 200ms`).
* **Header & Type Audits:** Verifies content-types, status codes, and structural types (e.g., checking that returned product quantities are integers).

### 3. Edge-Case, Negative & Security Testing
* **Oversell Protection:** Validates that the inventory API correctly rejects requests that attempt to add items beyond the available stock limit.
* **State Rollback Verification:** Confirms that if an over-stock operation fails, the system rolls back to the previous stable state (e.g., verifying a cart remains empty after a failed addition).
* **Idempotency Audits:** Verifies that submitting duplicate orders results in appropriate error states or is handled gracefully by the backend.
* **Security & Auth Barriers:** Targets all protected routes with missing, invalid, or expired tokens to assert the API returns correct `401 Unauthorized` responses.

---

## 📂 Repository Structure

```text
Grocery_Store_API/
├── .github/
│   └── workflows/
│       └── api-tests.yml                       # GitHub Actions CI/CD Workflow configuration
├── .postman/                                   # Postman workspace configurations
├── reports/                                    # Test execution reports output (Git ignored)
│   ├── HTML_Report/                            # Interactive htmlextra dashboard reports
│   └── JUnit_Report/                           # XML test result logs for CI tools
├── .env.example                                # Configuration template for credentials
├── README.md                                   # Comprehensive documentation
├── Simple Grocery Env.postman_environment.json # Standard environment export
├── Simple Grocery Store.postman_collection.json# Full Postman Collection export
├── run_api.sh                                  # Automation Bash runner (CLI + Reporting)
└── simple-grocery-store-api.md                # Markdown API contract documentation
```

---

## 📊 Test Suite Coverage Map

| Category | Endpoint | Method | Key Validations |
| :--- | :--- | :---: | :--- |
| **Status** | `/status` | `GET` | Service availability checks, uptime validation, response format |
| **Products** | `/products` | `GET` | Catalog retrieval, category filters, limit/pagination parameters, availability audits |
| **Products** | `/products/:id` | `GET` | Product schema validation, status codes (200/404), data integrity |
| **Cart** | `/carts` | `POST` | Cart initialization, unique UUID generation, success flags |
| **Cart** | `/carts/:id/items`| `POST` | Product insertion, quantity constraints, oversell protection limits |
| **Cart** | `/carts/:id/items/:itemId`| `PATCH`/`PUT`/`DELETE` | Quantity modifications, item replacement, item removal validation |
| **Orders** | `/orders` | `POST` | Order placement, inventory reduction, order verification, token auth |
| **Orders** | `/orders/:id` | `GET`/`PATCH`/`DELETE` | Order retrieval, customer metadata modifications, cancellations |
| **Auth** | `/api-clients` | `POST` | Client registration, token emission, conflict (409) handling for duplicate emails |

---

## 🛠️ Local Setup & Execution

### 1. Prerequisites
Ensure you have the following installed on your machine:
* [Node.js](https://nodejs.org/) (v18+ recommended)
* [Newman](https://www.npmjs.com/package/newman) (Postman CLI runner)
* [Newman htmlextra reporter](https://www.npmjs.com/package/newman-reporter-htmlextra) (Visual reporting dashboard)

Install dependencies globally:
```bash
npm install -g newman newman-reporter-htmlextra
```

### 2. Configuration
The framework is designed to run against Postman's cloud-hosted collections/environments, ensuring you always test the latest version without maintaining stale local JSON exports.

1. Copy the `.env.example` file to create a `.env` file:
   ```bash
   cp .env.example .env
   ```
2. Retrieve your Postman credentials:
   * **`POSTMAN_API_KEY`:** Generate one in your [Postman Account Settings](https://web.postman.co/settings/me/api-keys).
   * **`POSTMAN_COLLECTION_ID` & `POSTMAN_ENV_ID`:** Find these Unique Identifiers (UIDs) under the info panels of your collection and environment in the Postman UI.
3. Open your `.env` file and populate the variables:
   ```env
   POSTMAN_API_KEY=PMAK-xxxx...
   POSTMAN_COLLECTION_ID=12345678-xxxx...
   POSTMAN_ENV_ID=12345678-xxxx...
   ```

### 3. Execution via Bash Wrapper
Run the full test suite and automatically generate reports by executing the provided orchestrator script:
```bash
chmod +x run_api.sh
./run_api.sh
```

**What the `run_api.sh` script does:**
1. **Environment Initialization:** Automatically detects and loads variables from `.env`. If running in a CI environment where variables are already injected, it bypasses `.env` check seamlessly.
2. **Directory Management:** Creates `reports/HTML_Report/` and `reports/JUnit_Report/` directories if they do not exist.
3. **Cloud Synchronization:** Fetches the most up-to-date collection and environment JSON profiles directly from the Postman API.
4. **Execution & Report Generation:** Runs Newman with multiple reporters enabled, generating:
   * **CLI Console output** for instant feedback.
   * **Dark-themed HTML dashboard reports** with visual breakdown of all assertions.
   * **JUnit XML files** for standard test suite reporting.

---

## 🔄 CI/CD Integration (GitHub Actions)

This project features a fully automated CI/CD pipeline integrated via GitHub Actions to validate the API on every code submission.

### Pipeline Workflow (`.github/workflows/api-tests.yml`)
* **Trigger Events:** Activates automatically on every `push` and `pull_request` to the `main` or `master` branches. Supports manual executions via the `workflow_dispatch` button.
* **Environment Setup:** Installs Node.js and imports Newman alongside both reporters.
* **Test Orchestration:** Executes `./run_api.sh` with environment variables dynamically injected from GitHub Repository Secrets.
* **Artifact Archiving:** Captures all JUnit XML and HTML dashboard files generated in the runner and uploads them as workflow build artifacts (retained for 7 days).

### Setup GitHub Secrets
To link your GitHub Repository with the Postman Cloud API safely:
1. Navigate to your GitHub Repository -> **Settings** -> **Secrets and variables** -> **Actions**.
2. Create three **Repository Secrets** matching your credentials:
   * `POSTMAN_API_KEY`
   * `POSTMAN_COLLECTION_ID`
   * `POSTMAN_ENV_ID`

---

## 📊 Test Reporting

This framework generates clean, comprehensive reports detailing test outcomes:
1. **Interactive HTML Dashboard (`htmlextra`):**
   * Located under `reports/HTML_Report/`.
   * High-level metrics showing total requests, assertions, pass rates, and response time curves.
   * Granular request-by-request breakdown showing exact request headers, bodies, response values, and failed tests.
2. **JUnit XML Report:**
   * Located under `reports/JUnit_Report/`.
   * Standard XML schema compatible with CI engines (e.g., Jenkins, GitLab CI, GitHub Actions test visualizers).
