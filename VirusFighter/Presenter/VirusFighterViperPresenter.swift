//
//  VirusFighterViperPresenter.swift
//  VIrusFighter
//
//  Created Fran González on 14/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import UIKit

protocol VirusFighterViperPresenterProtocol: class {
    func didReceiveEvent(_ event: VirusFighterViperEvent)
    func didTriggerAction(_ action: VirusFighterViperAction)
}

final class VirusFighterViperPresenter {
    private let dependencies: VirusFighterViperPresenterDependenciesProtocol
    private weak var view: (VirusFighterViperViewProtocol & UIViewController)?
    private let interactor: VirusFighterViperInteractorProtocol
    private let router: VirusFighterViperRouterProtocol
    private weak var delegate: VirusFighterViperDelegateProtocol?
    
    init(dependencies: VirusFighterViperPresenterDependenciesProtocol, 
         view: (VirusFighterViperViewProtocol & UIViewController),
         interactor: VirusFighterViperInteractorProtocol, 
         router: VirusFighterViperRouterProtocol, 
         delegate: VirusFighterViperDelegateProtocol?) {
        self.dependencies = dependencies
        self.view = view
        self.interactor = interactor
        self.router = router
        self.delegate = delegate
    }
}

extension VirusFighterViperPresenter: VirusFighterViperPresenterProtocol {
    func didReceiveEvent(_ event: VirusFighterViperEvent) {
        switch event {
            case .viewDidLoad:
                debugPrint("viewDidLoad")
        }
    }

    func didTriggerAction(_ action: VirusFighterViperAction) {
        switch action {
            default: ()
        }
    }
}
