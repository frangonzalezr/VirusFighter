//
//  VirusFighterViperWireframe.swift
//  VIrusFighter
//
//  Created Fran González on 14/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import UIKit

protocol VirusFighterViperWireframeProtocol {
    static func makeViewController(delegate: VirusFighterViperDelegateProtocol?) throws -> VirusFighterViperViewController
}

struct VirusFighterViperWireframe: VirusFighterViperWireframeProtocol {
    static func makeViewController(delegate: VirusFighterViperDelegateProtocol?) throws -> VirusFighterViperViewController {
        guard let viewController = UIStoryboard(name: "VirusFighterViper", bundle: nil).instantiateInitialViewController() as? VirusFighterViperViewController else {
            throw VirusFighterViperWireframeError.couldNotInstantiateVirusFighterViperViewController
        }

        let routerDependencies = VirusFighterViperRouterDependencies()
        let router = VirusFighterViperRouter(dependencies: routerDependencies, viewController: viewController)

        let interactorDependencies = VirusFighterViperInteractorDependencies()
        let presenterDependencies = VirusFighterViperPresenterDependencies()

        let interactor = VirusFighterViperInteractor(dependencies: interactorDependencies)
        let presenter = VirusFighterViperPresenter(dependencies: presenterDependencies, view: viewController, interactor: interactor, router: router, delegate: delegate)
        viewController.setPresenter(presenter)
        
        return viewController
    }
}
