//
//  ViewControllerFactory.swift
//  SPWeatherApp
//
//  Created by David_Lam on 14/5/19.
//  Copyright © 2019 David_Lam. All rights reserved.
//

import UIKit

extension UIViewController {

    public static func make<T>(viewController: T.Type) -> T {
        let viewControllerName = String(describing: viewController)

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Unable to create ViewController: \(viewControllerName) from storyboard: \(storyboard)")
        }
        return viewController
    }
}
