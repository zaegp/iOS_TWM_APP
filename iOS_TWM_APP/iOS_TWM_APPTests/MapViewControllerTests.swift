//
//  MapViewControllerTests.swift
//  iOS_TWM_APPTests
//
//  Created by Rowan Su on 2024/8/28.
//

import XCTest
@testable import iOS_TWM_APP
import CoreLocation

class MapViewControllerTests: XCTestCase {

    var mapViewController: MapViewController!

    override func setUp() {
        super.setUp()
        mapViewController = MapViewController()
        mapViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        mapViewController = nil
        super.tearDown()
    }

    func testInitialSetup() {
        XCTAssertNotNil(mapViewController.mapView, "MapView 應該被初始化。")
        XCTAssertNotNil(mapViewController.loadingIndicator, "Loading indicator 應該被初始化。")
        XCTAssertTrue(mapViewController.mapView.delegate is MapViewController, "MapView 的 delegate 應該是 MapViewController。")
    }

    func testLocationManagerDidUpdateLocations() {
        let mockLocationManager = CLLocationManager()
        mapViewController.locationManager = mockLocationManager
        mapViewController.locationManagerDidChangeAuthorization(mockLocationManager)
        
        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        mapViewController.locationManager(mockLocationManager, didUpdateLocations: [mockLocation])
        
        XCTAssertEqual(mapViewController.mapView.centerCoordinate.latitude, mockLocation.coordinate.latitude, accuracy: 0.0001)
            XCTAssertEqual(mapViewController.mapView.centerCoordinate.longitude, mockLocation.coordinate.longitude, accuracy: 0.0001)
    }
    
    func testHandleLocateButtonTappedNotification() {
        let notification = Notification(name: NSNotification.Name("LocateButtonTappedNotification"))
        mapViewController.handleLocateButtonTappedNotification(notification)
        
        XCTAssertTrue(mapViewController.loadingIndicator.isAnimating)
    }

}

