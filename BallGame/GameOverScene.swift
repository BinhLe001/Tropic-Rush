//
//  GameOverScene.swift
//  BallGame
//
//  Created by Binh Le on 8/6/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

import AVFoundation
import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    var backgroundMusic = AVAudioPlayer()
    var currentHigh = 0
    weak var viewController: GameViewController!
    var currentGame: GameScene!
    let play = SKSpriteNode(imageNamed: "playbutton.png")
    let leaderboard = SKSpriteNode(imageNamed: "leaderboard.png")
    
    init(size: CGSize, score: NSInteger) {
        
        super.init(size: size)
        
        let background : SKSpriteNode = SKSpriteNode (imageNamed: "junglevert.png")
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        background.size = self.frame.size
        self.addChild(background)
        
        backgroundMusic = self.setupAudioPlayerWithFile("endgame", type:"mp3")
        backgroundMusic.numberOfLoops = -1
        self.setUpMusic()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let highscore = defaults.integerForKey("highscore")
        if (NSUserDefaults.standardUserDefaults().objectForKey("highscore") == nil){
            defaults.setInteger(score, forKey: "highscore")
        }
        if score > highscore {
            defaults.setInteger(score, forKey: "highscore")
            defaults.synchronize()
        }
        let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("highscore") as! Int
        
        let highScore = SKLabelNode (fontNamed: "Chalkduster")
        let high: NSString = "High Score: " + String(savedScore)
        highScore.text = high as String
        highScore.fontColor = SKColor.whiteColor()
        highScore.position = CGPointMake(size.width/2, size.height * 0.6)
        highScore.name = "High Score:  "
        highScore.setScale(0.7)
        self.addChild(highScore)
        
        let message: NSString = "GAME OVER"
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message as String
        label.fontSize = 40;
        label.fontColor = SKColor.whiteColor()
        label.position = CGPointMake(size.width/2, size.height * 0.82)
        self.addChild(label)
        
        let retrymessage:NSString = "TOUCH FOR START MENU";
        let retryButton = SKLabelNode(fontNamed:"Chalkduster")
        retryButton.text = retrymessage as String
        retryButton.fontColor = SKColor.whiteColor()
        retryButton.position = CGPointMake(size.width/2, size.height/2 - size.height * 0.02)
        retryButton.name = "retry"
        retryButton.setScale(0.65)
        self.addChild(retryButton)
        
        //let leader:NSString = "TAP HERE FOR HIGH SCORES";
        //let lead = SKLabelNode(fontNamed:"Chalkduster")
        //lead.text = leader as String
        //lead.fontColor = SKColor.whiteColor()
        //lead.position = CGPointMake(size.width/2, size.height * 0.025)
        //lead.name = "start"
        //lead.setScale(0.55)
        //self.addChild(lead)
        
        //play.position = CGPointMake(self.frame.size.width/2 - 65, size.height * 0.53)
        //play.setScale(0.12)
        //self.addChild(play)
        
        //leaderboard.position = CGPointMake(self.frame.size.width/2 + 65, size.height * 0.53)
        //leaderboard.setScale(0.27)
        //self.addChild(leaderboard)
        
        let playerscoremsg:NSString = "Player Score: " + String(score)
        let playerscore = SKLabelNode(fontNamed: "Chalkduster")
        playerscore.text = playerscoremsg as String;
        playerscore.fontColor = SKColor.whiteColor()
        playerscore.position = CGPointMake(size.width/2, size.height * 0.7);
        playerscore.name = "Player Score"
        playerscore.setScale(0.7)
        self.addChild(playerscore)
        
        let bigred = SKSpriteNode(imageNamed: "bigred.png")
        let bigbox = SKSpriteNode(imageNamed: "woodstack.png")

        bigred.position = CGPointMake(self.frame.size.width/2, size.height * 0.3)
        bigred.setScale(1.3)
        self.addChild(bigred)
        
        bigbox.position = CGPointMake(self.frame.size.width/2, size.height * 0.3)
        bigbox.setScale(1.0)
        self.addChild(bigbox)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //Detects Pressing Of Retry Button
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event!);
        let array = Array(touches)
        let touch = array[0] 
        let location = touch.locationInNode(self)
        let node:SKNode = self.nodeAtPoint(location)
        
        //if (location.y > self.size.height * 0.1){
            backgroundMusic.stop()
            let reveal = SKTransition.flipHorizontalWithDuration(1.0)
            let scene = GameScene(size: size)
            self.view?.presentScene(scene, transition: reveal)
        //}
        //else{
        //    currentGame.leaderboard(0)
        //}
    }

    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        var audioPlayer:AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        return audioPlayer!
    }
    
    //Sets Background Music
    func setUpMusic(){
        
        backgroundMusic.volume = 0.2
        backgroundMusic.play()
    }
    
    
}