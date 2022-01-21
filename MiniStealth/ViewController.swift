//
//  ViewController.swift
//  MiniStealth
//
//  Created by Maarten Engels on 21/01/2022.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: CGSize(width: 1280, height: 720))
        
        scene.scaleMode = .resizeFill
        
        // 16x16pt -> 80 columns -> 1280x720.
        
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}

