# CoinApp

CoinApp is an iOS application that fetches and displays the top 100 cryptocurrencies from the CoinRanking API. The app features paginated lists of coins, a detailed view with performance charts, and a favorites screen. It is built using the MVVM pattern with RxSwift for reactive bindings and integrates SwiftUI components within UIKit view controllers.

## Minimum Requirements

- **iOS Version:** iOS 16 or later
- **Xcode:** Xcode 14 or later
- **Dependencies:**  
  - **RxSwift** (via Swift Package Manager)  
  - **SDWebImageSwiftUI** (via Swift Package Manager)  
  - **Swift Charts** (native to iOS 16+)

## Building and Running the Application

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/tejiriAdjos/EquityCoinApp.git
   cd CoinApp

2. Open the Project: Open the Xcode project (dependencies are managed via Swift Package Manager):
    ```bash
    open CoinApp.xcodeproj
    
3. Select a Simulator or Device: Ensure you select an iOS 16 (or later) simulator or device.
4. Build and Run:
    ```bash
    Press Cmd + R in Xcode to build and run the application.
5. Running Unit Tests: A bash script (build.sh) is provided for running unit tests from the command line. First, ensure the script is executable:
    ```bash 
    chmod +x build.sh
6.    Then, run the tests with:
    ```bash
    ./build.sh
7.    The script uses xcodebuild with a destination that matches an available iOS Simulator running iOS 16. Adjust the destination specifier if needed.
Assumptions and Design Decisions
* Architecture: The app follows the Model-View-ViewModel (MVVM) pattern to maintain a clear separation of concerns. Each view model is responsible for its own data fetching and state management using RxSwift.
* Reactive Programming: RxSwift is used exclusively for managing asynchronous operations and updating the UI reactively.
* Dependency Management: All dependencies are managed via Swift Package Manager (SPM), which simplifies integration and dependency resolution.
* API and Data Handling: The application fetches data from the CoinRanking API (https://api.coinranking.com/v2) and assumes the API provides all necessary data for display, including coin details and performance metrics.
* UI Components: UIKit is used for the primary view controllers (coin list, detail, and favorites screens), while SwiftUI is used for reusable components such as coin cells and performance charts. This hybrid approach demonstrates interoperability between UIKit and SwiftUI.
* Minimum iOS Version: The minimum iOS version is set to 16 to take advantage of Swift Charts for rendering performance graphs natively.
Challenges Encountered and Solutions

**Challenges:**
1. Asynchronous Data and Pagination: Managing asynchronous API calls and updating the UI with paginated data was challenging. I used RxSwift’s reactive bindings along with BehaviorRelays to maintain consistent state across view models.
2. Favorites Synchronization: Synchronizing favorites between the coin list and favorites screens required careful state management. I implemented a shared FavoritesViewModel (using RxSwift) that updates a BehaviorRelay for favorites, so any change propagates instantly across all relevant views.
3. Interoperability Between UIKit and SwiftUI: Embedding SwiftUI views (for coin cells and performance charts) within UIKit view controllers required careful management of UIHostingController instances and layout constraints. I addressed this by wrapping SwiftUI views in custom UITableViewCells and updating their root views as needed.
4. Unit Testing Asynchronous Code: Writing unit tests for asynchronous RxSwift code was nontrivial. I employed the RxBlocking library to convert asynchronous observables into synchronous operations during tests, simplifying assertions and enhancing test reliability.

