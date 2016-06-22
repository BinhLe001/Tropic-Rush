//
//  GameViewController.swift
//  BallGame
//
//  Created by Binh Le on 8/3/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    var currentGame: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        currentGame = scene
        scene.viewController = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
