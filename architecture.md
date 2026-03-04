# Flutter Project Architecture

This project follows **Clean Architecture** with a **feature-first structure**.

The goal is to keep the code:

* scalable
* maintainable
* testable

---

# Architecture Layers

The project is divided into three main layers:

1. Presentation
2. Domain
3. Data

Dependency direction:

presentation → domain → data

Rules:

* UI must never communicate directly with the data layer.
* Business logic exists only in the domain layer.
* Each layer must have a single responsibility.

---

# State Management

State management uses **Cubit** from `flutter_bloc`.

Each feature contains:

* Cubit
* State

Rules:

* Cubits call **UseCases only**
* Cubits must not call repositories directly
* Business logic must not be inside UI

---

# Dependency Injection

The project uses a **Service Locator** pattern.

All dependencies are registered in:

lib/core/di/service_locator.dart

Responsibilities:

* register repositories
* register use cases
* register cubits
* manage dependency lifecycle

---

# Folder Structure

lib/

core/
errors/
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

* No Flutter imports
* No framework dependencies
* Pure business logic only

---

# Data Layer

Contains:

* Models
* DataSources
* Repository implementations

Responsibilities:

* API calls
* Local storage
* Data mapping

Models map to domain entities.

---

# Presentation Layer

Contains:

* Cubits
* Screens
* Widgets

Responsibilities:

* UI rendering
* State management
* Calling use cases

UI must remain simple and free of business logic.

---

# Code Reuse

Always reuse existing components before creating new ones.

Check first:

* core/widgets
* core/utils
* shared services
* existing helpers

Avoid code duplication.

---

# Principles

This project follows:

* Clean Architecture
* SOLID principles
* Separation of concerns
* Reusable components
* Scalable feature modules
