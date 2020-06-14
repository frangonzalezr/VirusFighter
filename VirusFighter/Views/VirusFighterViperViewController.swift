//
//  VirusFighterViperViewController.swift
//  VIrusFighter
//
//  Created Fran González on 14/06/2020.
//  Copyright © 2020 Fran González Ramos. All rights reserved.
//

import ARKit

protocol VirusFighterViperViewProtocol: VirusFighterViperProtocol {
    func setPresenter(_ presenter: VirusFighterViperPresenterProtocol)
}

final class VirusFighterViperViewController: UIViewController {
    private var presenter: VirusFighterViperPresenterProtocol?
    
    // HAY QUE SACAR TODO ESTO DE AQUI
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var viruses: [Virus] = []
    var syringes: [Syringe] = []
    var idVirus = 0
    var counter = 10
    var score = 0
    var scoreText = SCNText(string: "Kill Virus", extrusionDepth: 1.0)
    var highScoreText = SCNText(string: "High Score: \(UserDefaults.standard.integer(forKey: "HighScore"))", extrusionDepth: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        playBackgroundMusic()
        addScoreLabels()
        presenter?.didReceiveEvent(.viewDidLoad)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        sceneView.session.pause()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addNewVirus(quantity: 3, type: "normal")
    }
    
    fileprivate func setupComponents() {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
            sceneView.session.delegate = self
            addSyringe(id: "Syringe1.usdz", xPos: -0.22 )
            addSyringe(id: "Syringe2.usdz", xPos: 0.22 )
            // tenemos que indicar que se nos avise cuando haya un contacto
            sceneView.scene.physicsWorld.contactDelegate = self
            
        }
        
        fileprivate func addSyringe(id: String, xPos: Float) {
            guard let pointOfView = self.sceneView.pointOfView else { return }
            let syringe = Syringe(withId: id)
            let syringePosition = SCNVector3(x: xPos, y: -0.05, z: -0.5)
            self.syringes.append(syringe)
            syringe.updatePositionAndOrientationOf(syringe, withPosition: syringePosition, relativeTo: pointOfView)
            self.sceneView.prepare([syringe]) { _ in
                self.sceneView.pointOfView?.addChildNode(syringe)
            }
        }
        
        fileprivate func addScoreLabels(){
            highScoreText.font = UIFont (name: "Arial", size: 8)
            scoreText.font = UIFont (name: "Arial", size: 8)
            highScoreText.flatness = 0
            scoreText.flatness = 0
            highScoreText.firstMaterial!.diffuse.contents = UIColor.red
            scoreText.firstMaterial!.diffuse.contents = UIColor.green
            let highScoreNode = SCNNode(geometry: highScoreText)
            let scoreNode = SCNNode(geometry: scoreText)
            highScoreNode.position = SCNVector3(-0.7, 0.25, -1.5)
            scoreNode.position = SCNVector3(0.5, 0.25, -1.5)
            highScoreNode.scale = SCNVector3(0.01, 0.01 , 0.01)
            scoreNode.scale = SCNVector3(0.01, 0.01 , 0.01)
            self.sceneView.pointOfView?.addChildNode(highScoreNode)
            self.sceneView.pointOfView?.addChildNode(scoreNode)
        }
        
        private func addNewVirus(quantity: Int, type: String) {
    //        if contador == 0 {
    //            type = "novel"
    //            self.syringes[1].scale = SCNVector3(x: self.syringes[1].scale.x * 10, y: self.syringes[1].scale.y * 10, z: self.syringes[1].scale.z * 10)
    //        } else {
    //            type = "normal"
    //        }
            
            for _ in 1...quantity {
                idVirus += 1
                let virus = Virus(withId: 0, type: type)
                virus.id = idVirus
                
                let x = CGFloat.random(in: -1...1)
                let y = CGFloat.random(in: -2...1)
                let z = CGFloat.random(in: -6 ... -2)
                
                virus.position = SCNVector3(x, y, z)
                self.viruses.append(virus)
                
                self.sceneView.prepare([virus]) { _ in
                    self.sceneView.scene.rootNode.addChildNode(virus)
                }
            }

        }
    @IBAction func tapScreen(_ sender: Any) {
        guard let camera = self.sceneView.session.currentFrame?.camera else { return }
        let toiletPaper = ToiletPaper(camera)
        self.sceneView.prepare([toiletPaper]) { _ in
            self.sceneView.scene.rootNode.addChildNode(toiletPaper)
        }
    }
    
        // MARK: - SOUNDS - Moverlos fuera de aquí

        
        var player: AVAudioPlayer?
        
        // Audio player method for bullet and explosion
        func playSound(sound : String, format: String) {
            guard let url = Bundle.main.url(forResource: sound, withExtension: format) else { return }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                guard let player = player else { return }
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        // Background music method
        func playBackgroundMusic(){
            let audioNode = SCNNode()
            let audioSource = SCNAudioSource(fileNamed: "expartigh.aiff")!
            let audioPlayer = SCNAudioPlayer(source: audioSource)
            
            audioNode.addAudioPlayer(audioPlayer)
            
            let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
            audioNode.runAction(play)
            sceneView.scene.rootNode.addChildNode(audioNode)
        }
}

extension VirusFighterViperViewController: VirusFighterViperViewProtocol {
    func setPresenter(_ presenter: VirusFighterViperPresenterProtocol) {
        self.presenter = presenter
    }
}

extension VirusFighterViperViewController: VirusFighterViperProtocol {
  
}

//MARK: - Contact delegate
extension VirusFighterViperViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Si algo choca con el virus
        if contact.nodeA.physicsBody?.categoryBitMask == Collisions.virus.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == Collisions.virus.rawValue {
            
            var node: SCNNode!
            if contact.nodeA is Virus { node = contact.nodeA }
            if contact.nodeB is Virus { node = contact.nodeB }
            
            var bulletNode: SCNNode!
            if contact.nodeA is ToiletPaper { bulletNode = contact.nodeA }
            if contact.nodeB is ToiletPaper { bulletNode = contact.nodeB }
            
            let virus = node as! Virus
            
            guard let virusIndex = self.viruses.firstIndex(where: {$0.id == virus.id}) else { return }
            self.viruses.remove(at: virusIndex)

            // Explossion
            
            Explossion.show(with: node, in: sceneView.scene)
            playSound(sound: "explosion", format: "mp3")
            
            counter -= 1
            print("CONTADOR: \(counter)")
            
            if counter == 0 {
                print("GAME OVER")
            }
            score += 1
            
            var currentHighScore = UserDefaults.standard.integer(forKey: "HighScore")
            if score >= currentHighScore {
                currentHighScore = score
                UserDefaults.standard.set(score, forKey: "HighScore")
            }
            highScoreText.string = "HighScore: \(currentHighScore)"
            scoreText.string = "Killed: \(score)"
            DispatchQueue.main.async {
                node.removeFromParentNode()
                self.syringes[1].scale = SCNVector3(x: self.syringes[1].scale.x * 0.9, y: self.syringes[1].scale.y * 0.9, z: self.syringes[1].scale.z * 0.9)
                if bulletNode != nil {
                    bulletNode.removeFromParentNode()
                }
            }
            
            // Cargamos un nuevo virus
            if counter == 0 {
                self.addNewVirus(quantity: 1, type: "novel")
            } else {
                self.addNewVirus(quantity: 1, type: "normal")
            }
            // Recargamos el arma
            playSound(sound: "mossbergShotgun", format: "wav")
        }
    }
}

//MARK: - ARSessionDelegate
extension VirusFighterViperViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let cameraOrientation = session.currentFrame?.camera.transform {
            self.viruses.forEach { $0.face(to: cameraOrientation) }
        }
    }
}
