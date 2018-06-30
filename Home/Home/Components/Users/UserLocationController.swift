//
//  UserLocationController.swift
//  Home
//
//  Created by Sebastien Villar on 5/31/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class UserLocationController: NSObject, CLLocationManagerDelegate {

  private struct Constants {
    static let regionIdentifier = "home"
  }

  // MARK: - Public

  init(dataSource: DataSource) {
    self.dataSource = dataSource

    super.init()

    // Register changes
    dataSource.subscribeToChanges(for: [.users, .user], block: DataSource.ChangeBlock(block: { [weak self] in
      self?.handleUserModelChange(model: dataSource.userModel)
    }))

    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.delegate = self
  }

  // MARK: - Private

  private lazy var locationManager = CLLocationManager()
  private let dataSource: DataSource
  private var setupTrackingCompletion: ((Bool) -> Void)?
  private var shouldHandleLocationUpdate = false
  private lazy var region: CLCircularRegion = {
    let center = CLLocationCoordinate2D(
      latitude: Config.shared.homeLatitude,
      longitude: Config.shared.homeLongitude
    )

    return CLCircularRegion(
      center: center,
      radius: min(CLLocationDistance(Config.shared.homeRadius), locationManager.maximumRegionMonitoringDistance),
      identifier: Constants.regionIdentifier
    )
  }()

  // MARK: Handlers

  private func handleUserModelChange(model: UserModel?) {
    guard let model = model else {
      return
    }

    switch model.awayMethod {
    case .auto:
      startTracking()
    case .manual:
      stopTracking()
    }
  }

  // MARK: Helpers

  func startTracking() {
    guard locationManager.monitoredRegions.isEmpty else {
      return
    }

    print("Start tracking region")
    setupTracking { success in
      guard success else {
        return
      }

      // Get current location just for the first time
      self.shouldHandleLocationUpdate = true
      self.locationManager.startUpdatingLocation()
      self.locationManager.startMonitoring(for: self.region)
    }
  }

  func stopTracking() {
    guard !locationManager.monitoredRegions.isEmpty else {
      return
    }

    print("Stop tracking region")
    locationManager.stopMonitoring(for: region)
  }

  private func setupTracking(completion: @escaping (Bool) -> Void) {
    guard UIApplication.shared.backgroundRefreshStatus == .available else {
      AlertController.shared.show(title: "Background refresh is disabled", message: "Enable background refresh for location tracking to work")
      completion(false)
      return
    }

    guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
      AlertController.shared.show(title: "Region monitoring is disabled", message: "Device might not support region monitoring")
      completion(false)
      return
    }

    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined:
      setupTrackingCompletion = completion
      locationManager.requestAlwaysAuthorization()
    case .authorizedAlways:
      completion(true)
    case .authorizedWhenInUse, .denied, .restricted:
      AlertController.shared.show(title: "Location disabled", message: "Location must be always in order to track region")
      completion(false)
    }
  }

  private func updateAwayValue(to value: UserModel.AwayValue) {
    let identifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
    UsersManager.setUserAwayValue(value, dataSource: dataSource) {
      UIApplication.shared.endBackgroundTask(identifier)
    }
  }

  // MARK: Location delegate

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedAlways:
      setupTrackingCompletion?(true)
      setupTrackingCompletion = nil
    case .authorizedWhenInUse, .denied, .restricted:
      setupTrackingCompletion?(false)
      setupTrackingCompletion = nil
    case .notDetermined:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("Did enter home on region change")
    updateAwayValue(to: .home)
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    print("Did leave home on region change")
    updateAwayValue(to: .away)
  }

  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Monitoring did fail: \(error)")
    AlertController.shared.show(title: "Couldn't monitor region")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    defer {
      locationManager.stopUpdatingLocation()
      shouldHandleLocationUpdate = false
    }

    guard let location = locations.last, let userModel = dataSource.userModel, userModel.awayMethod == .auto, shouldHandleLocationUpdate else {
      return
    }

    let homeLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
    if homeLocation.distance(from: location) <= Config.shared.homeRadius {
      print("Did enter home on explicit location request")
      updateAwayValue(to: .home)
    }
    else {
      print("Did leave home on explicit location request")
      updateAwayValue(to: .away)
    }
  }
}
