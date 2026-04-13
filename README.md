# Simple Grocery Store API - Automated Testing Framework

An API testing suite designed to validate the business logic, security, and state integrity of the **Simple Grocery Store API**. This framework leverages **Postman** and **Newman** to perform comprehensive end-to-end, functional, and negative testing.

## Project Overview

This project provides a robust automation layer for the Simple Grocery Store service. It is designed with a focus on **Data Integrity**, **State Handover**, and **Defensive Testing** (Boundary Analysis). Key features include:

* **Request Chaining:** Seamlessly passes state (e.g., `accessToken`, `cartId`, `orderId`) between requests to simulate real-world user flows.
* **Dynamic Data Generation:** Uses Postman dynamic variables (e.g., `{{$randomFullName}}`) and custom Pre-request scripts to ensure every test run is unique.
* **Inventory Logic Validation:** Specialized tests to ensure orders cannot exceed real-time stock levels and duplicate items are handled according to business rules.
* **State Rollback Verification:** Confirms that the system maintains a clean state after failed operations (e.g., verifying a cart remains empty after a failed "over-stock" addition).

---

## Tech Stack

* **Testing Tool:** Postman
* **Execution Engine:** Newman (CLI runner)
* **Reporting:** Newman-reporter-htmlextra (Professional HTML reporting)
* **Scripting Language:** JavaScript (Postman Sandbox)

---

## Repository Structure
* `Simple Grocery Store.postman_collection.json`: The core test suite.
* `Simple Grocery Env.postman_environment.json`: Environment variables and configuration.
* `run_api.sh`: A shell script to execute the full suite and generate reports.
* `simple-grocery-store-api.md`: Documentation for the API endpoints.

## Test Suite Structure

The collection is organized into logical folders mirroring the API's domain:

### 1. Happy Path Flows
* **AUTH:** Client registration and token management.
* **PRODUCTS:** Catalog browsing, random item selection, and category filtering.
* **CART:** Full lifecycle testing creating carts, adding/modifying/replacing/deleting items.
* **ORDERS:** Full lifecycle testing creating/modifying/deleting orders.

### 2. Negative & Boundary Testing
* **Oversell Protection:** Attempts to add more items than are currently in stock.
* **Idempotency Checks:** Validates system behavior when duplicate orders are placed with the same cart.
* **Input Validation:** Tests for invalid categories, out-of-range limits, and incorrect data types.
* **Security:** Validates unauthorized access attempts (Missing/Invalid tokens).

---

Getting Started & Setup

### 1. Prerequisites
* [Node.js](https://nodejs.org/) installed.
* Install Newman and the HTML reporter globally:
    ```bash
    npm install -g newman newman-reporter-htmlextra
    ```

### 2. Configuration (Security Setup)
To protect sensitive data, this project uses environment variables.
1.  Copy the `.env.example` file and rename it to `.env`.
2.  Open `.env` and enter your Postman details:
    ```bash
    POSTMAN_API_KEY=your_key_here
    POSTMAN_COLLECTION_ID=your_collection_uid
    POSTMAN_ENV_ID=your_environment_uid
    ```
*Note: The `.env` file is ignored by Git to keep your keys private.*

### 3. Execution
Run the full suite and generate a report using the automated bash script:
```bash
chmod +x run_api.sh
./run_api.sh




   
