
//
//  File.swift
//  VirusFighter
//
//  Created by Fran González Ramos on 04/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import ARKit

class Syringe: SCNNode {
    var id: String = "Syringe1.usdz"
    
    init(withId id: String) {
        super.init()
        self.id = id
        let syringe = SCNScene(named: id) ?? SCNScene()
        let node = syringe.rootNode
        node.scale = SCNVector3(x: 0.0005, y: 0.0005, z: 0.0005)
        node.eulerAngles = SCNVector3Make(0, 0, .pi/2);
        self.addChildNode(node)
        
        // Añadimos físicas al virus
        let shape = SCNPhysicsShape(node: node, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
                
        // Rotate
        let action: SCNAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 3.0)
        let forever = SCNAction.repeatForever(action)
        node.runAction(forever)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
        let referenceNodeTransform = matrix_float4x4(referenceNode.transform)

        // Setup a translation matrix with the desired position
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = position.x
        translationMatrix.columns.3.y = position.y
        translationMatrix.columns.3.z = position.z

        // Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
        let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
        node.transform = SCNMatrix4(updatedTransform)
    }
}
