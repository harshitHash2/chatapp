# chatapp

# Flutter Chat App

A fully-featured chat application built using Flutter and Firebase. This app supports real-time messaging, user authentication and more.

## Features

- **User Authentication:**
  - Sign up and login using email and password.
  - Profile management with profile picture updates

- **Real-time Messaging:**
  - One-to-one and group chat functionalities
  - Support for sending images, videos, audio, and documents
  - Read receipts and typing indicators
  - Real-time message updates

- **User Interface:**
  - Chat list displaying recent conversations
  - Chat screen for viewing and sending messages
  - User search functionality
  - Notifications for new messages

## Technical Stack

- **Frontend:**
  - Flutter for building the cross-platform user interface
  - Firebase for real-time database, authentication, and storage

- **Backend:**
  - Firebase Cloud Firestore for storing chat messages and user data
  - Firebase Authentication for secure user sign-up and login
  - Firebase Cloud Functions for server-side logic and notifications

## Architecture

- **Model-View-ViewModel (MVVM):**
  - Models for data structures (users, messages, etc.)
  - ViewModels for handling business logic and data preparation
  - Views for displaying the user interface

- **State Management:**
  - Provider, Riverpod, or Bloc for managing the app’s state efficiently

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase project: [Set up Firebase](https://firebase.google.com/docs/flutter/setup)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/harshitHash2/chatapp
   cd chatapp
