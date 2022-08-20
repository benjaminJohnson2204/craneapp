# Studying app

This is an app I created for studying. Users can answer pratice problems of different categories, and the app tracks their progress on each question and category.

## Tech Stack

I created this app using Flutter for the frontend, and MongoDB, Express, and Node for the backend.

## Running Instructions

To run the app, clone the repository and then run

```
flutter run
```

## Code Structure

All the app code is in the `lib` directory. Within that directory, the `constants` directory contains constants used across the whole app. `global_variables` contains variables like the server URL and the app's color theme. `util` contains commonly used functions.

The `models` directory contains classes to model data used by the app. There is a `Question` model to represent a question, and an `Option` model to reprsent an option (possible answer to the question).

The `screens` directory contains the different screens displayed to users. There are screens to login and register, a home screen displaying all categories of questions, a category screen displaying all questions within a category, and a question screen displaying a certain question.

The `services` directory contains functions to fetch data from the server. There are services to check if the user is authenticated (they must be authenticated before viewing and answering questions), to login the user, to register a new user, to fetch data about questions, and to answer questions and fetch data about the user's previous answers.

The `widgets` directory contains widgets (individual pieces of display and/or functionality, similar to components in React) that are commonly reused in the app. Currently, the only widget is the app bar, a top navigation bar with options to return to the home screen, logout, and return to the category (if viewing a question).

## Server

The app's server code, in the `server` folder, is on a separate repository, https://github.com/benjaminJohnson2204/studying-app-server. I chose to make the server a separate repoistory so that I could host that repository on Heroku and mak HTTP requests to the server APIs on the hosted server.
