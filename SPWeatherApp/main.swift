//
//  main.swift
//  SPWeatherApp
//
//  Created by David_Lam on 11/9/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit
import Foundation

class FakeAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window?.rootViewController = UIViewController()
        return true
    }
}

let isRunningTests = NSClassFromString("XCTestCase") != nil

if isRunningTests {
    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil,
                      NSStringFromClass(FakeAppDelegate.self))
} else {
    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil,
                      NSStringFromClass(AppDelegate.self))
}
