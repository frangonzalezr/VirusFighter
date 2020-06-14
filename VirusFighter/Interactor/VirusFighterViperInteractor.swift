//
//  VirusFighterViperInteractor.swift
//  VIrusFighter
//
//  Created Fran González on 14/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import Foundation

protocol VirusFighterViperInteractorProtocol {

}

final class VirusFighterViperInteractor {
    private let dependencies: VirusFighterViperInteractorDependenciesProtocol
    
    init(dependencies: VirusFighterViperInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension VirusFighterViperInteractor: VirusFighterViperInteractorProtocol {
	
}
