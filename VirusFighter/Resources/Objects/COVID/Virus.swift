//
//  Virus.swift
//  VirusFighter
//
//  Created by Fran González Ramos on 04/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import ARKit

class Virus: SCNNode {
    
    var id: Int = 0
    var type: String = ""
    
    init(withId id: Int, type: String) {
        super.init()
        self.id = id
        self.type = type
        var virus = SCNScene()
        if type == "normal" {
            print("CARGO VIRUS NORMAL")
            virus = SCNScene(named: "Coronavirus_SARS-CoV-2.usdz") ?? SCNScene()
        } else {
            print("CARGO VIRUS NOVEL")
            virus = SCNScene(named: "Novel_Coronavirus__2019-nCoV.usdz") ?? SCNScene()
        }
        let node = virus.rootNode
        node.scale = SCNVector3(x: 0.005, y: 0.005, z: 0.005)
        self.addChildNode(node)
        
        // Añadimos físicas al virus
        let shape = SCNPhysicsShape(node: node, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        // Identificador de nuestro objeto para las colisiones
        self.physicsBody?.categoryBitMask = Collisions.virus.rawValue
        
        // Especeficamos los objetos contra los que puede colisionar
        self.physicsBody?.contactTestBitMask = Collisions.toiletPaper.rawValue
        
        // Animar el virus un poquito
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.4, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.4, z: 0, duration: 2.5)
        let hoverLeft = SCNAction.moveBy(x: -0.4, y: 0, z: 0, duration: 2.5)
        let hoverRight = SCNAction.moveBy(x: 0.4, y: 0, z: 0, duration: 2.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverLeft, hoverDown, hoverRight])
        let hoverForever = SCNAction.repeatForever(hoverSequence)
        self.runAction(hoverForever)
        
        // Rotate
        let action: SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(1, 1, 1), duration: 3.0)
        let forever = SCNAction.repeatForever(action)
        node.runAction(forever)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func face(to objectOrientation: simd_float4x4) {
        var transform = objectOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
    }
}
