
//
//  File.swift
//  ARBillboad
//
//  Created by Oscar Izquierdo on 04/06/2020.
//  Copyright © 2020 Oscar Izquierdo. All rights reserved.
//

import ARKit

class ToiletPaper: SCNNode {
    fileprivate let velocity: Float = 9
    
    init(_ camera: ARCamera) {
        super.init()
        
        
        let toiletPaper = SCNScene(named: "Simple_Toilet_Paper.usdz") ?? SCNScene()
        let node = toiletPaper.rootNode
        node.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node.eulerAngles = SCNVector3Make(0, .pi/2, .pi);
        self.addChildNode(node)
        
        // Añadimos las físicas
        let shape = SCNPhysicsShape(node: node, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = Collisions.toiletPaper.rawValue
        
        self.physicsBody?.contactTestBitMask = Collisions.virus.rawValue
        
        // Aplicamos un impulso a la bala
        let matrix = SCNMatrix4(camera.transform)
        // Vector de dirección (También lleva incluida la velicidad)
        let v = -self.velocity
        let dir = SCNVector3(v * matrix.m31, v * matrix.m32, v * matrix.m33)
        // Necesitamos un punto de origen
        let pos = SCNVector3(matrix.m41, matrix.m42, matrix.m43)
        
        self.physicsBody?.applyForce(dir, asImpulse: true)
        self.position = pos
        
        // Rotate
        let action: SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(1, 1, 1), duration: 0.3)
        let forever = SCNAction.repeatForever(action)
        node.runAction(forever)
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
}
