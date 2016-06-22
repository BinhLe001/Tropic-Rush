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
//import GoogleMobileAds
import GameKit

class GameViewController: UIViewController{
    
    var currentGame: GameScene!
    
    //@IBOutlet weak var adButton: UIButton!
    //@IBOutlet weak var bannerView: GADBannerView!
    //var interstitial: GADInterstitial!
    var done = false
    //@IBOutlet weak var lead: UIButton!
    
    //score variable--depends on game
    var score:Int = 0
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        
        //authenticateLocalPlayer()
        
        
        //self.interstitial = self.createAndLoadAd()
        
        //Banner Ad (problems right now)
        //self.bannerView.adUnitID = "ca-app-pub-2540314652045992/2297558667"
        //self.bannerView.rootViewController = self
        //let request: GADRequest = GADRequest()
        //self.bannerView.loadRequest(request)
        
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
    
    /*@IBAction func adButton(sender: AnyObject) {
        if(self.interstitial.isReady && done == false){
            done = true
            adButton.hidden = true
            self.interstitial.presentFromRootViewController(self)
            self.interstitial = self.createAndLoadAd()
        }
    }
    
    func createAndLoadAd() -> GADInterstitial{
        let ad = GADInterstitial(adUnitID: "ca-app-pub-2540314652045992/5772402260")
        let request: GADRequest = GADRequest()
        //request.testDevices = ["b08bf949370649bc0ecae23cba6f9c7c"]
        ad.loadRequest(request)
        return ad
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hidesBanner (banner: GADBannerView!) {
        bannerView.hidden = true
    }
    
    func showsBanner (banner: GADBannerView!) {
        bannerView.hidden = false
    }*/
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}