//
//  ViewModelBasedProtocol.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/10/22.
//

import UIKit

protocol ViewModelBasedProtocol: AnyObject {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
}

extension ViewModelBasedProtocol where Self: UIViewController {
    
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
}
