//
//  ViewController.swift
//  MiniStealth
//
//  Created by Maarten Engels on 03/02/2022.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            let scene = GameScene(size: CGSize(width: 1280, height: 720))
            scene.scaleMode = .aspectFit
                
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

