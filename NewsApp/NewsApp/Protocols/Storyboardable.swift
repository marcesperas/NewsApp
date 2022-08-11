//
//  Storyboardable.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import UIKit

protocol Storyboardable {
    static var storyboard: UIStoryboard { get }
    static var storyboardIdentifier: String { get }
}

extension Storyboardable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension Storyboardable where Self: UIViewController {

    static func instantiate() -> Self {

        let storyboard = Self.storyboard

        guard let viewController = storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as? Self else {
            fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(storyboardIdentifier)")
        }

        return viewController
    }

}

extension UIViewController: Storyboardable {
    public static var storyboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: nil)
    }
}
