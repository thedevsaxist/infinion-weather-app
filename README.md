# WeatherApp

A simple weather application that allows users to search for weather information of any city using the **OpenWeather API**. The app is built with **MVVM architecture**, demonstrates dependency injection, follows **SOLID principles**, and includes unit tests.


## Features

* **Splash Screen**: A welcoming splash screen on app launch.
* **City Search**: Enter the name of a city to retrieve current weather information.
* **Weather Details Screen**: Displays the weather description and temperature of the selected city.
* **Favorite City**: Save your favorite city so that it’s prepopulated on the homepage.
* **Cross-Platform Implementation**:

  * **iOS**: Swift with Storyboards


## Architecture & Design

* **MVVM (Model-View-ViewModel)** pattern for separation of concerns.
* **Dependency Injection** used to manage services and repositories.
* **SOLID principles** are followed to ensure maintainable and scalable code.
* **Unit Tests** are included to verify core functionalities.
* Demonstrates **view lifecycle handling** with multiple screens.


## Setup & Configuration

1. Clone the repository:

```bash
git clone <YOUR_REPO_URL>
cd WeatherApp
```

2. **iOS Specific Setup**:

* Open the `WeatherApp.xcodeproj` in Xcode.
* The OpenWeather API key is stored in `Config/EnvConfig.xcconfig`. Make sure your key is added there:

```text
OPEN_WEATHER_API_KEY=your_api_key_here
```

* The app reads the API key from the config file securely, so it is **not hardcoded in the source code**.

3. **Android Specific Setup**:

* Configure your project to read the API key from a secure place (like `local.properties` or BuildConfig).


## Dependencies

* **iOS**: Swift standard libraries, URLSession for networking, XCTest for unit testing.


## Usage

1. Launch the app.
2. Enter a city name on the homepage.
3. View the weather information on the details screen.
4. Optionally, save the city as your favorite to prepopulate the city input field next time.


## Testing

Unit tests are provided for:

* Weather API service
* ViewModels
* Data persistence for favorite city

Run tests in Xcode via `Product > Test` or in Android Studio using the test runner.


## Screenshots
<img width="1179" height="2556" alt="Simulator Screenshot - iPhone 15 Pro - 2025-11-24 at 11 06 29" src="https://github.com/user-attachments/assets/b5f21c94-11d5-4337-8c0c-c5be9833f129" />

<img width="1179" height="2556" alt="Simulator Screenshot - iPhone 15 Pro - 2025-11-24 at 11 02 00" src="https://github.com/user-attachments/assets/8b37b294-497f-45ee-9391-68dba29da05a" />


## Notes

* Ensure your device/emulator has internet connectivity to fetch weather data.
* This app demonstrates best practices for iOS and Android development, including **dependency injection**, **MVVM**, and **SOLID** principles.


## License

MIT License © [Chidiebube Iroezindu]
