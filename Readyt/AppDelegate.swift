//
//  AppDelegate.swift
//  Readyt
//
//  Created by Raul Martinez Padilla on 30/08/2018.
//  Copyright © 2018 Raul Martinez Padilla. All rights reserved.
//

import UIKit

import ReSwift

public extension FileManager {
  static var documentDirectoryURL: URL {
    return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

var store = Store<AppState>(reducer: appReducer, state: nil, middleware: [logginMiddleware])

let appStateURL = URL(
  fileURLWithPath: "AppState",
  relativeTo: FileManager.documentDirectoryURL.appendingPathComponent("AppState")
)

enum PersistenceError: Error {
  case cantGetData
  case cantDecode
  case cantEncode
  case cantSave
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appRouter: AppRouter?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions
                   launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    do {
      try store.state = getState()
    } catch {
      //TODO: Error management
      print(error)
    }

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window

    self.window!.makeKeyAndVisible()

    appRouter = AppRouter(window: self.window!)

    return true
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    store.state = try! getState()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    try! setState(appState: store.state)
  }

  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    try! setState(appState: store.state)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    try! setState(appState: store.state)
  }

  func getState() throws -> AppState {
    let plistAppStateURL = appStateURL.appendingPathExtension("plist")
    let plistDecoder = PropertyListDecoder()
    let savedPlistData: Data!

    do {
      savedPlistData = try Data(contentsOf: plistAppStateURL)
    } catch {
      throw PersistenceError.cantGetData
    }

    let plistAppState: AppState
    do {
      plistAppState = try plistDecoder.decode(AppState.self, from: savedPlistData)
    } catch {
     throw PersistenceError.cantDecode
    }

    return plistAppState
  }

  func setState(appState: AppState) throws {
    let plistAppStateURL = appStateURL.appendingPathExtension("plist")
    let plistEncoder = PropertyListEncoder()
    plistEncoder.outputFormat = .binary

    let plistData: Data

    do {
     plistData = try plistEncoder.encode(appState)

    } catch {
      throw PersistenceError.cantEncode
    }

    do {
      try plistData.write(to: plistAppStateURL)
    } catch {
      throw PersistenceError.cantSave
    }
  }
}
