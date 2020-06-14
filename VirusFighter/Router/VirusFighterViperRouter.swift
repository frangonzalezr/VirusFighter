//
//  VirusFighterViperRouter.swift
//  VIrusFighter
//
//  Created Fran González on 14/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import UIKit

protocol VirusFighterViperRouterProtocol {
    func navigate(toRoute route: VirusFighterViperRoute)
    func dismiss(animated: Bool)
}

final class VirusFighterViperRouter {
    private let dependencies: VirusFighterViperRouterDependenciesProtocol
    private weak var viewController: UIViewController?

    init(dependencies: VirusFighterViperRouterDependenciesProtocol,
    	 viewController: UIViewController?) {
        self.dependencies = dependencies
        self.viewController = viewController
    }
}

extension VirusFighterViperRouter: VirusFighterViperRouterProtocol {
	func navigate(toRoute route: VirusFighterViperRoute) {
        switch route {
            default: ()
        }
    }

    func dismiss(animated: Bool) {
		viewController?.dismiss(animated: animated, completion: nil)
	}
}
