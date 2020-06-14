//
//  Collisions.swift
//  ARBillboad
//
//  Created by Fran González Ramos on 04/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import Foundation

struct Collisions: OptionSet {
    let rawValue: Int
    
    static let virus = Collisions(rawValue: 1 << 0)
    static let toiletPaper = Collisions(rawValue: 1 << 1)
}
