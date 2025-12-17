# movietime

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

Capstone Project: Mobile Application Development 1
Project Documentation
Project Title: MovieTime
Student: Assan Sultan 230103325, Akhmetzhan Nursultan 230103229
Course: Mobile Application Development 1
Semester: Fall 2025
1. Project Overview
MovieTime is a mobile application developed using the Flutter framework.
The main purpose of the application is to provide users with convenient
access to movie information using an external movie database API
The application allows users to browse popular movies, search for films by
name, view detailed information about selected movies, and save favorite
movies for later viewing
User authentication is implemented using Firebase, which allows users to
securely sign up and sign in to the application
MovieTime is designed as a cross-platform application and works on both
Android and iOS devices
2. Goals and Learning Outcomes
The main goals of this project are:
●
●
●
●
●
●
To develop a cross-platform mobile application using Flutter
To implement user authentication using Firebase
To integrate a third-party REST API (TMDB)
To design a clean and intuitive user interface
To manage application state effectively
To improve practical skills in mobile app development
During this project, important skills in Flutter development, API integration,
and application architecture were improved
3. Scope and Features
User Authentication
●
●
●
User registration using email and password
User login and logout
Email verification using Firebase Authentication
Home Screen
●
●
●
Display of a list of movies fetched from TMDB API
Loading movie posters and titles
Smooth scrolling and responsive layout
Search System
●
●
●
Search movies by name
Real-time search results
Error handling for empty or incorrect queries
Movie Details
●
●
Detailed information about a selected movie
Movie poster, description, and rating
Favorites
●
●
●
Profile Screen
●
●
Ability to add movies to favorites
Favorites stored using Firebase Firestore
Separate screen for favorite movies
Display of user information
Logout functionality
4. Application Screens
The application includes the following screens:
●
●
●
●
●
●
●
●
●
●
●
Welcome Screen
Sign In Screen
Sign Up Screen
Email Verification Screen
Onboarding Screen
Home Screen
Search Screen
Movie Details Screen
Favorites Screen
Saved Genres Screen
Profile Screen
Each screen is designed to guide the user through the application in a clear
and logical way
5. Technical Specifications
Platform
●
●
Android
iOS
Framework
●
Flutter (Dart)
Backend Services
●
●
Firebase Authentication
Firebase Firestore
API Integration
●
TMDB (The Movie Database) API for movie data
State Management
●
●
Provider
Flutter Bloc
Networking
●
Dio package for HTTP requests
Local Storage
●
Shared Preferences
Additional Tools
●
●
Git for version control
Cached Network Image for optimized image loading
6. Application Architecture
The MovieTime application follows a layered architecture (Clean
Architecture DDD)
Presentation Layer
Responsible for UI components and screens
Business Logic Layer
Handles state management using Provider and Bloc
Data Layer
Communicates with Firebase services and TMDB API
This structure based on clean architecture helps keep the code clean,
modular, and easy to maintain

