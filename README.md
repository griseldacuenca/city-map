# city-map

##   City Search Feature Implementation

This document describes the design and implementation of the search feature, which efficiently filters and displays city results based on user input. The implementation prioritizes a smooth user experience by employing an asynchronous approach.

###   Initial Data Loading

When the view appears, the app fetches the list of cities using the `handleOnAppear` method. The fetched city data is then stored in a view model to facilitate efficient filtering and access.

###   City Data Loading Mechanism

To optimize performance and reduce network load, the `GetCitiesUseCase` class implements a caching mechanism to efficiently manage city data:

####   1. Local Caching with Compression

*     The city list is stored locally in a compressed JSON file (`cities.json.gz`) within the app's documents directory.
*     LZFSE compression is used, providing a balance of fast compression/decompression and reduced file size.

####   2. Cache Expiration Strategy

*     A timestamp (`lastUpdateKey`) is stored in UserDefaults to track the last successful data fetch.
*     To minimize network requests, the app loads city data from disk if the cached file exists and its timestamp is within the allowed freshness window (`updateInterval`).

####   3. Fresh Data Fetching

*     If the cache is expired or missing, the app asynchronously fetches city data from the API.
*     The fetched data is compressed and saved to disk, and the timestamp is updated.

####   4. Compression and Decompression

*     **Saving City Data:**
    *     JSON data is encoded using `JSONEncoder`.
    *     The encoded data is compressed using LZFSE before being written to disk.
*     **Loading City Data:**
    *     The compressed file is read from disk.
    *     The data is decompressed and then decoded using `JSONDecoder`.

This caching approach optimizes data storage and retrieval, balancing performance and data freshness. The refresh frequency is controlled by a configurable parameter.

###   Search Logic Implementation

*     **Input Handling:** User-entered prefixes are processed asynchronously in `onSearch()` to prevent UI lag.
*     **Efficient Lookups:** A PrefixTrie is used to optimize search, enabling O(m) time complexity (where m is the prefix length).
*     **Dynamic Results:**
    *     If no prefix is entered, the app displays all cities or only favorites (if filtering is enabled), sorted alphabetically.
    *     Non-empty prefixes are processed by `filterCitiesData(with: prefix, favoritesOnly: searchFavoritesOnly)` for fast and responsive searches.
*     **Flexible UI:** A custom search component allows easy UI adjustments, such as placing a toggle between the search input and results list.

###   Performance Optimizations

*     Search tasks are canceled to avoid unnecessary computations when users type quickly.
*     `LazyVStack` is used to optimize rendering of search results, improving performance for long lists.

###   Key Design Decisions and Assumptions

####   1. Asynchronous Search

*     An asynchronous approach (using `Task`) was chosen to prevent UI blocking during search operations.
*     Previous search tasks are canceled when a new search term is entered.

####   2. Handling "No Matches"

*     The `noMatchesFound` flag is set to `true` to display a user-friendly message when no search results are found, providing clear feedback.

####   3. Favorite Cities Feature

*     A toggle (`Search Favorites Only`) allows users to filter and display only their favorite cities.
*     Favorite city data is persisted between app launches using:
    *     `@AppStorage` for saving favorites to UserDefaults.
    *     An in-memory `Set<Int>` for efficient O(1) lookup performance.
    *     Storage of only city IDs to minimize storage overhead.

####   4. Navigation and UI Behavior

*     In portrait mode, tapping a city navigates to a detail view (`CityMapView`).
*     In landscape mode, tapping a city selects it, optimizing the UI for split-screen use.

###   Future Improvements

*     Implement view and event tracking for app usage analysis.
*     Add a user-friendly snack bar to display city loading errors.









