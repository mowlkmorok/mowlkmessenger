# Real-Time Chat Application  
### Flutter • Java Spring Boot • WebSocket • Redis

## Project Summary

This project is a real-time chat application built to explore WebSocket-based communication, distributed state management, and full-stack integration.

It demonstrates how to handle persistent real-time messaging, user session lifecycle, and scalable state storage using Redis — similar patterns used in multiplayer systems, financial platforms, and collaborative applications.

---

## Key Highlights

- Real-time bidirectional communication using WebSocket
- Persistent chat history stored in Redis
- Automatic room lifecycle management (cleanup when empty)
- System join/leave events handled in real time
- Flutter frontend with responsive chat interface
- Backend session tracking and message broadcasting
- Clear separation between system messages and user messages

---

## Tech Stack

### Backend
- Java 17+
- Spring Boot WebSocket
- Redis (Jedis client)
- JSON messaging protocol

### Frontend
- Flutter (Dart)
- WebSocket client
- Real-time UI updates

---

## Architecture Overview

The backend maintains chat room state using Redis:

- User sessions tracked per room
- Message history persisted with automatic trimming
- Room cleanup triggered when all users disconnect
- WebSocket lifecycle properly handled to avoid stale sessions

This architecture mirrors patterns used in:

- Multiplayer games
- Trading/chat platforms
- Collaborative apps
- Real-time dashboards

---

## Current Scope

This project intentionally focuses on real-time communication concepts:

- Authentication not implemented yet
- Security hardening planned for future versions
- Designed primarily as a learning and architecture exploration project

---

## Future Improvements

- Authentication layer (JWT/session)
- Docker deployment
- Security enhancements
- Improved UI/UX
- Expansion toward multiplayer game prototype (poker)

---

## What This Project Demonstrates

- Real-time system design fundamentals
- Backend/frontend integration skills
- State management using Redis
- WebSocket lifecycle handling
- Clean separation of responsibilities
- Practical full-stack development experience

---

## Running the Project

### Backend
Requirements:

- Java 17+
- Redis instance running

```bash
./mvnw spring-boot:run
```
### WebSocket endpoint example:

```bash
ws://localhost:8080/table/{tableId}
```


# FRONTEND
---
## Create your Flutter project and copy files from the *lib* in frontend directory.

<br>

```bash
flutter pub get
flutter run
```
