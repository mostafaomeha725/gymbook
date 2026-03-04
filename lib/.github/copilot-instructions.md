# Flutter Architecture Guidelines

All generated code in this repository MUST follow these rules.

---

# Architecture

Use Clean Architecture with a feature-first structure.

Layers:

* presentation
* domain
* data

Dependency direction:
presentation → domain → data

Rules:

* UI must never access the data layer directly.
* Business logic must exist only in the domain layer.
* Each layer must be independent.

---

# State Management

Use Cubit from flutter_bloc.

Each feature must contain:

* cubit
* state

Rules:

* Cubits must only call UseCases.
* Cubits must not access repositories directly.
* Cubits must not contain business logic.

---

# Dependency Injection

Use **Service Locator** for dependency injection.

Rules:

* All dependencies must be registered in the Service Locator.
* Use existing Service Locator setup from the project.
* Do NOT create new dependency systems.

Example:
Use the existing `service_locator.dart` file in `core/`.

---

# Code Reuse (VERY IMPORTANT)

Before creating new code ALWAYS check existing code and reuse it.

Rules:

* Reuse existing **custom widgets** if they already exist.
* Reuse utilities from the **core** folder.
* Reuse existing **error handling**, **network clients**, and **helpers**.
* Do NOT duplicate components that already exist.

Priority:

1. Use existing widgets
2. Use existing helpers/utilities
3. Use existing services
4. Only create new code if nothing suitable exists

---

# Folder Structure

lib/
core/
errors/
usecases/
utils/
widgets/
services/
di/
cache/
constants/
enums/
extensions/
theme/
network/
routes/

features/
feature_name/
data/
models/
datasources/
repositories/
domain/
entities/
repositories/
usecases/
presentation/
cubit/
screens/
widgets/

---

# Domain Layer

Contains:

* Entities
* Repository interfaces
* UseCases

Rules:

* Must NOT depend on Flutter.
* Must NOT depend on external frameworks.
* Must contain pure business logic.

---

# Data Layer

Contains:

* Models
* Data Sources
* Repository Implementations

Rules:

* Models map to domain entities.
* Data sources handle API / local storage.

---

# Presentation Layer

Contains:

* Cubits
* Screens
* Widgets

Rules:

* Presentation depends only on the domain layer.
* UI must stay clean and simple.
* No business logic inside UI.

---

# Code Rules

Follow these principles:

* SOLID principles
* Clean and readable code
* Small reusable classes
* Single responsibility per class
* Proper naming conventions
* Avoid duplicate code
* Reuse existing project components whenever possible

---

# Feature Generation

When creating a new feature generate the full structure:

feature_name/
data/
models/
datasources/
repositories/
domain/
entities/
repositories/
usecases/
presentation/
cubit/
screens/
widgets/

Also:

* Register dependencies in Service Locator
* Reuse existing widgets and utilities
* Follow all architecture rules
