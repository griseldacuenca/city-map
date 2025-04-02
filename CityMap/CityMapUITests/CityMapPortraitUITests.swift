//
//  CityMapUITests.swift
//  CityMapPortraitUITests
//
//  Created by Griselda Cuenca on 28/03/2025.
//

import XCTest

final class CityMapPortraitUITests: XCTestCase {
  
  private var app: XCUIApplication!
  
  override func setUp() {
    app = XCUIApplication()
    app.launchArguments = ["NoAnimations", "UITests"]
    app.launch()
    continueAfterFailure = false
    XCUIDevice.shared.orientation = .portrait
  }
  
  override func tearDown() {
    app = nil
  }
  
  func testLoadingApp() {
    setUp()
    
    // Wait for the app to load
    let progressIndicator = app.activityIndicators["Initializing the app..."]
    if progressIndicator.exists {
      XCTAssertTrue(progressIndicator.waitForExistence(timeout: 5), "App initialization took too long")
    }
    tearDown()
  }
  
  func testFindCityList() {
    setUp()
    
    // Verify that the city list appears
    let cityList = app.scrollViews.firstMatch
    XCTAssertTrue(cityList.waitForExistence(timeout: 15), "City list did not appear")
    tearDown()
  }
  
  func testFindCityCellsAvailable() {
    setUp()
    // Ensure there are city cells available
    let firstCity = app.staticTexts.firstMatch
    XCTAssertTrue(firstCity.exists, "No cities found in the list")
    tearDown()
  }
  
  func findSearchComponent() {
    setUp()
    // Find the text field with placeholder "Filter"
    let searchField = app.textFields["Filter"]
    
    // Verify that it exists
    XCTAssertTrue(searchField.waitForExistence(timeout: 10), "Filter text field not found")
    tearDown()
  }
  
  func testCitySearch() {
    setUp()
    
    let searchField = app.textFields["Filter"]
    XCTAssertTrue(searchField.waitForExistence(timeout: 10), "Search field not found")
    
    searchField.tap()
    searchField.typeText("Paris\n")
    // Verify search updated the list
    let parisCell = app.staticTexts.matching(identifier: "Paris, FR").firstMatch
    XCTAssertTrue(parisCell.waitForExistence(timeout: 2), "Paris, FR was not found in the list")
    parisCell.tap()
    
    // Verify the new map view appears
    let parisInMapView = app.staticTexts.matching(identifier: "Paris, FR").firstMatch
    XCTAssertTrue(parisInMapView.waitForExistence(timeout: 2), "Map did not appear after selecting Paris, FR")
    tearDown()
  }
  
  func testDisplayMap() {
    setUp()
    let searchField = app.textFields["Filter"]
    XCTAssertTrue(searchField.waitForExistence(timeout: 10), "Search field not found")
    
    searchField.tap()
    searchField.typeText("Paris\n")
    
    let parisCell = app.staticTexts.matching(identifier: "Paris, FR").firstMatch
    parisCell.tap()
    
    // Verify the new map view appears
    let parisInMapView = app.staticTexts.matching(identifier: "Paris, FR").firstMatch
    XCTAssertTrue(parisInMapView.waitForExistence(timeout: 2), "Map did not appear after selecting Paris, FR")
    tearDown()
  }
  
  func testFindToggleSearchFavoritesOnly() {
    setUp()
    
    // Ensure the city list is visible
    let cityList = app.scrollViews.firstMatch
    XCTAssertTrue(cityList.waitForExistence(timeout: 5), "City list did not appear")
    
    // Locate the "Search Favorites Only" toggle
    let favoritesToggle = app.switches["Search Favorites Only"]
    XCTAssertTrue(favoritesToggle.exists, "Favorites toggle not found")
    
    if favoritesToggle.value as? String == "0" {
      favoritesToggle.switches.firstMatch.tap()
    }
    
    // Verify it's turned ON
    XCTAssertEqual(favoritesToggle.value as? String, "1", "Favorites toggle did not turn ON")
    
    if favoritesToggle.value as? String == "1" {
      favoritesToggle.switches.firstMatch.tap()
    }
    
    tearDown()
  }
  
  func testMarkCityAsFavorite() {
    setUp()
    
    // Ensure the city list is visible
    let cityList = app.scrollViews.firstMatch
    XCTAssertTrue(cityList.waitForExistence(timeout: 5), "City list did not appear")
    
    let searchField = app.textFields["Filter"]
    searchField.tap()
    searchField.typeText("Jakarta\n")
    
    // Verify search updated the list
    let cityCell = app.staticTexts.matching(identifier: "Jakarta, ID").firstMatch
    XCTAssertTrue(cityCell.waitForExistence(timeout: 2), "Jakarta, FR was not found in the list")
    
    let favoriteButton = app.buttons.matching(identifier: "star").firstMatch
    XCTAssertTrue(favoriteButton.exists, "Favorite button not found for city 'Jakarta, ID'")
    
    // Tap the favorite button
    favoriteButton.tap()
    
    // Verify the button changed to "star.fill" (marked as favorite)
    let filledStar = app.buttons.matching(identifier: "star.fill").firstMatch
    XCTAssertTrue(filledStar.exists, "City 'Jakarta, ID' was not marked as favorite")
    
    // Enable "Search Favorites Only"
    let favoritesToggle = app.switches["Search Favorites Only"]
    XCTAssertTrue(favoritesToggle.exists, "Favorites toggle not found")
    favoritesToggle.switches.firstMatch.tap()
    
    // Verify "Jakarta, ID" appears in the favorites list
    XCTAssertTrue(cityCell.waitForExistence(timeout: 2), "City 'Jakarta, ID' did not appear in favorites list")
    
    // Tap again to unfavorite
    filledStar.tap()
    
    // Verify "Paris, FR" disappears when filtering favorites
    XCTAssertFalse(cityCell.waitForExistence(timeout: 2), "City 'Jakarta, ID' should not be in favorites list after unfavoriting")
    
    tearDown()
  }
}
