//
//  GameScene.swift
//  BallGame
//
//  Created by Binh Le on 8/3/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

import AVFoundation
import SpriteKit
import GameKit

struct PhysicsCategory {
    
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Block     : UInt32 = 0b1       // 1
    static let Screen    : UInt32 = 0b10      // 2
    static let Green     : UInt32 = 0b11      // 3
    static let Red       : UInt32 = 0b100     // 4
    static let Yellow    : UInt32 = 0b101     // 5
    static let Blue      : UInt32 = 0b110     // 6
    static let Black     : UInt32 = 0b111     // 7
    static let Brown     : UInt32 = 0b1000    // 8
    static let White     : UInt32 = 0b1001    // 9
}

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    weak var viewController: GameViewController!
    
    let block = SKSpriteNode(imageNamed: "woodbox.png")
    let bigbox = SKSpriteNode(imageNamed: "bigbox.png")
    let biggreen = SKSpriteNode(imageNamed: "biggreen.png")
    let play = SKSpriteNode(imageNamed: "playbutton.png")
    let leaderboard = SKSpriteNode(imageNamed: "leader.png")
    let title = SKLabelNode(fontNamed: "Chalkduster")
    let title2 = SKLabelNode(fontNamed: "Chalkduster")
    let startButton = SKLabelNode(fontNamed:"Chalkduster")
    let lead = SKLabelNode(fontNamed:"Chalkduster")
    
    let rules = SKLabelNode(fontNamed:"Chalkduster")
    let rule1 = SKLabelNode(fontNamed:"Chalkduster")
    let rule2 = SKLabelNode(fontNamed:"Chalkduster")
    let rule3 = SKLabelNode(fontNamed:"Chalkduster")
    let rule4 = SKLabelNode(fontNamed:"Chalkduster")
    let rule5 = SKLabelNode(fontNamed:"Chalkduster")
    let rule6 = SKLabelNode(fontNamed:"Chalkduster")
    let rule7 = SKLabelNode(fontNamed:"Chalkduster")
    let rule8 = SKLabelNode(fontNamed:"Chalkduster")
    let rule9 = SKLabelNode(fontNamed:"Chalkduster")
    
    let label_score = SKLabelNode(fontNamed:"MarkerFelt-Wide")
    let label = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    
    var sizing: CGFloat = 0.3
    var count: NSInteger = 0
    var start = false
    var xVelocity: CGFloat = 0
    var allGreen = false
    var allRed = false
    var rulesPage = false
    
    var moveNoise = AVAudioPlayer()
    var hitNoise = AVAudioPlayer()
    var backgroundMusic = AVAudioPlayer()
    var cashNoise = AVAudioPlayer()
    
    let ball1 = SKSpriteNode(imageNamed: "greenball")
    let ball2 = SKSpriteNode(imageNamed: "redball")
    let ball3 = SKSpriteNode(imageNamed: "blueball")
    let ball4 = SKSpriteNode(imageNamed: "brownball")
    let ball5 = SKSpriteNode(imageNamed: "yellowball")
    let ball6 = SKSpriteNode(imageNamed: "blackball")
    let ball7 = SKSpriteNode(imageNamed: "whiteball")
    
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

    override func didMoveToView(view: SKView) {
        
        let background : SKSpriteNode = SKSpriteNode (imageNamed: "junglevert.png")
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        background.size = self.frame.size
        self.addChild(background)
        
        let name: NSString = "TROPIC"
        title.text = name as String
        title.fontSize = 40;
        title.fontColor = SKColor.whiteColor()
        title.position = CGPointMake(size.width/2, size.height * 0.79)
        title.setScale(1.6)
        self.addChild(title)
        
        let name1: NSString = "RUSH"
        title2.text = name1 as String
        title2.fontSize = 40;
        title2.fontColor = SKColor.whiteColor()
        title2.position = CGPointMake(size.width/2, size.height * 0.67)
        title2.setScale(1.5)
        self.addChild(title2)
        
        let startmessage:NSString = "TOUCH TO PLAY";
        startButton.text = startmessage as String
        startButton.fontColor = SKColor.whiteColor()
        startButton.position = CGPointMake(size.width/2, size.height * 0.23)
        startButton.name = "start"
        startButton.setScale(0.85)
        self.addChild(startButton)
        
        //let leader:NSString = "TAP HERE FOR HIGH SCORES";
        //lead.text = leader as String
        //lead.fontColor = SKColor.whiteColor()
        //lead.position = CGPointMake(size.width/2, size.height * 0.15)
        //lead.name = "start"
        //lead.setScale(0.55)
        //self.addChild(lead)
        
        let rulesmessage:NSString = "TAP HERE FOR RULES";
        rules.text = rulesmessage as String
        rules.fontColor = SKColor.whiteColor()
        rules.position = CGPointMake(size.width/2, size.height * 0.025)
        rules.name = "start"
        rules.setScale(0.5)
        self.addChild(rules)
        
        backgroundMusic = self.setupAudioPlayerWithFile("electric", type:"mp3")
        backgroundMusic.numberOfLoops = -1
        self.setUpMusic()
        
        biggreen.position = CGPointMake(self.frame.size.width/2, size.height/2 - size.height * 0.01)
        biggreen.setScale(1.3)
        self.addChild(biggreen)
        
        bigbox.position = CGPointMake(self.frame.size.width/2, size.height/2 - size.height * 0.01)
        bigbox.setScale(1.0)
        self.addChild(bigbox)
        
        //play.position = CGPointMake(self.frame.size.width/2 - 65, size.height * 0.2 + 5)
        //play.setScale(0.12)
        //self.addChild(play)
        
        leaderboard.position = CGPointMake(self.frame.size.width/2 , size.height * 0.15)
        leaderboard.setScale(0.14)
        self.addChild(leaderboard)
        
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.dynamic = true
        block.physicsBody?.categoryBitMask = PhysicsCategory.Block
        block.physicsBody?.contactTestBitMask = PhysicsCategory.None
        block.physicsBody?.collisionBitMask = PhysicsCategory.Screen
        block.physicsBody!.angularVelocity = 0
        block.physicsBody!.allowsRotation = false
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: frame)
        borderBody.categoryBitMask = PhysicsCategory.Screen
        borderBody.contactTestBitMask  = PhysicsCategory.None
        borderBody.collisionBitMask = PhysicsCategory.Screen
        self.physicsBody = borderBody
        
        block.physicsBody?.usesPreciseCollisionDetection = true
        block.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)

        start = false
        
        authenticateLocalPlayer()
    }
    
    //Starts Game
    func setUpGame(){
        
        block.setScale(sizing)
        self.addChild(block)
        if (randRange(1,upper:2) == 1){
            xVelocity = -250
        }
        else{
            xVelocity = 250
        }
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        addBalls()
        
        label.position = CGPoint(x: CGRectGetMaxX(frame) - 52, y: CGRectGetMaxY(frame) - 45)
        label.text = String(count)
        label.fontColor = SKColor.whiteColor()
        label.zPosition = 50
        addChild(label)
    }
    
    //Sets Background Music
    func setUpMusic(){
        
        backgroundMusic.volume = 1.0
        backgroundMusic.play()
    }

    
    //Uses Touches On Button To Move Sprite Left And Right
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event!);
        let array = Array(touches)
        let touch = array[0] 
        let location = touch.locationInNode(self)
        
        if (location.x <= block.position.x && start == true){
            xVelocity = -225
            moveNoise = self.setupAudioPlayerWithFile("swoosh", type:"wav")
            moveNoise.volume = 1
            moveNoise.play()
        }
        
        if (location.x > block.position.x && start == true){
            xVelocity = 225
            moveNoise = self.setupAudioPlayerWithFile("swoosh", type:"wav")
            moveNoise.volume = 1
            moveNoise.play()
        }
        
        let node:SKNode = self.nodeAtPoint(location)
        if (start == false && (location.y > self.frame.size.height * 0.22 || rulesPage == true)) {
            start = true
            title.removeFromParent()
            title2.removeFromParent()
            startButton.removeFromParent()
            bigbox.removeFromParent()
            biggreen.removeFromParent()
            //play.removeFromParent()
            leaderboard.removeFromParent()
            
            rules.removeFromParent()
            ball1.removeFromParent()
            ball2.removeFromParent()
            ball3.removeFromParent()
            ball4.removeFromParent()
            ball5.removeFromParent()
            ball6.removeFromParent()
            ball7.removeFromParent()
            
            rule1.removeFromParent()
            rule2.removeFromParent()
            rule3.removeFromParent()
            rule4.removeFromParent()
            rule5.removeFromParent()
            rule6.removeFromParent()
            rule7.removeFromParent()
            rule8.removeFromParent()
            rule9.removeFromParent()
            
            setUpGame()
        }
        else if (start == false && ((location.y > self.frame.size.height * 0.085 && location.y < self.frame.size.height * 0.22) || (rulesPage == true))) {
            
            leaderboard(self.count)
        }
        else if (start == false && location.y < self.frame.size.height * 0.085){
            rulesPage = true
            
            title.removeFromParent()
            title2.removeFromParent()
            startButton.removeFromParent()
            bigbox.removeFromParent()
            biggreen.removeFromParent()
            rules.removeFromParent()
            //play.removeFromParent()
            leaderboard.removeFromParent()
            
            //let name: NSString = "Touch To Start!"
            //rules.text = name as String
            //rules.fontSize = 40;
            //rules.fontColor = SKColor.whiteColor()
            //rules.position = CGPointMake(size.width/2, size.height * 0.91)
            //rules.setScale(0.85)
            //self.addChild(rules)
            
            let startmessage:NSString = "TOUCH TO START!";
            startButton.text = startmessage as String
            startButton.fontColor = SKColor.whiteColor()
            startButton.position = CGPointMake(size.width/2, size.height * 0.025)
            startButton.name = "start"
            startButton.setScale(0.6)
            self.addChild(startButton)
            
            //let ball1 = SKSpriteNode(imageNamed: "greenball")
            ball1.position = CGPoint(x: size.width/12, y: size.height * 0.86)
            self.addChild(ball1)
            
            //let ball2 = SKSpriteNode(imageNamed: "redball")
            ball2.position = CGPoint(x: size.width/12, y: size.height * 0.76)
            self.addChild(ball2)
            
            //let ball3 = SKSpriteNode(imageNamed: "blueball")
            ball3.position = CGPoint(x: size.width/12, y: size.height * 0.66)
            self.addChild(ball3)
            
            //let ball4 = SKSpriteNode(imageNamed: "brownball")
            ball4.position = CGPoint(x: size.width/12, y: size.height * 0.56)
            self.addChild(ball4)
            
            //let ball5 = SKSpriteNode(imageNamed: "yellowball")
            ball5.position = CGPoint(x: size.width/12, y: size.height * 0.46)
            self.addChild(ball5)
            
            //let ball6 = SKSpriteNode(imageNamed: "blackball")
            ball6.position = CGPoint(x: size.width/12, y: size.height * 0.36)
            self.addChild(ball6)
            
            //let ball7 = SKSpriteNode(imageNamed: "whiteball")
            ball7.position = CGPoint(x: size.width/12, y: size.height * 0.26)
            self.addChild(ball7)
            
            rule1.text = "Green Increases Score"
            rule1.fontSize = 40;
            rule1.fontColor = SKColor.whiteColor()
            rule1.position = CGPointMake(size.width/2 + 5, size.height * 0.85)
            rule1.setScale(0.36)
            self.addChild(rule1)
            
            rule2.text = "Red Increases Size Of Box"
            rule2.fontSize = 40;
            rule2.fontColor = SKColor.whiteColor()
            rule2.position = CGPointMake(size.width/2 + 10, size.height * 0.75)
            rule2.setScale(0.34)
            self.addChild(rule2)
            
            rule3.text = "Blue Decreases Size Of Box"
            rule3.fontSize = 40;
            rule3.fontColor = SKColor.whiteColor()
            rule3.position = CGPointMake(size.width/2 + 10, size.height * 0.65)
            rule3.setScale(0.34)
            self.addChild(rule3)
            
            rule4.text = "Brown Causes Red To Fall For 3 Sec"
            rule4.fontSize = 40;
            rule4.fontColor = SKColor.whiteColor()
            rule4.position = CGPointMake(size.width/2 + 20, size.height * 0.55)
            rule4.setScale(0.28)
            self.addChild(rule4)
            
            rule5.text = "Yellow Causes Green To Fall For 3 Sec"
            rule5.fontSize = 40;
            rule5.fontColor = SKColor.whiteColor()
            rule5.position = CGPointMake(size.width/2 + 20, size.height * 0.45)
            rule5.setScale(0.28)
            self.addChild(rule5)
            
            rule6.text = "Black Results In Game Over"
            rule6.fontSize = 40;
            rule6.fontColor = SKColor.whiteColor()
            rule6.position = CGPointMake(size.width/2 + 10, size.height * 0.35)
            rule6.setScale(0.33)
            self.addChild(rule6)
            
            rule7.text = "White Returns Box To Its Initial Size"
            rule7.fontSize = 40;
            rule7.fontColor = SKColor.whiteColor()
            rule7.position = CGPointMake(size.width/2 + 18, size.height * 0.25)
            rule7.setScale(0.29)
            self.addChild(rule7)
            
            rule8.text = "Change Direction By Tapping Either Side Of Box"
            rule8.fontSize = 40;
            rule8.fontColor = SKColor.whiteColor()
            rule8.position = CGPointMake(size.width/2, size.height * 0.19)
            rule8.setScale(0.26)
            self.addChild(rule8)
            
            rule9.text = "LOSE WHEN THE BOX IS WIDER THAN THE SCREEN!"
            rule9.fontSize = 40;
            rule9.fontColor = SKColor.whiteColor()
            rule9.position = CGPointMake(size.width/2, size.height * 0.145)
            rule9.setScale(0.27)
            self.addChild(rule9)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        
        if (xVelocity>0){
            xVelocity = 250
        }
        else{
            xVelocity = -250
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        let rate: CGFloat = 0.5; //Controls rate of motion. 1.0 instantaneous, 0.0 none.
        
        let relativeVelocity: CGVector = CGVector(dx:xVelocity-block.physicsBody!.velocity.dx, dy:0);
        
        block.physicsBody!.velocity=CGVector(dx:block.physicsBody!.velocity.dx+relativeVelocity.dx*rate, dy:0);
    }
    
    //Spawns Ball
    func addBalls(){
        
        let ballPos = randRange(1,upper: 12)
        var count: CGFloat = 1.0
        
        while (count <= 12){
            let countInt: Int = Int(count)
            if (ballPos == countInt){
                let temp = randRange(1, upper: 100)
                if ((temp < 36 || allGreen == true) && allRed == false){
                    greenBall(count)
                }
                else if (((temp >= 36 && temp < 71) || allRed == true) && allGreen == false){
                    redBall(count)
                }
                else if (temp >= 71 && temp < 83){
                    brownBall(count)
                }
                else if (temp >= 83 && temp < 88){
                    yellowBall(count)
                }
                else if (temp >= 88 && temp < 95){
                    blueBall(count)
                }
                else if (temp >= 95 && temp < 100){
                    blackBall(count)
                }
                else if (temp >= 100){
                    whiteBall(count)
                }
            }
            count += 1
        }
        delay(0.25){
            self.addBalls()
        }
    }
    
    //Adds Green Ball
    func greenBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "greenball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Green // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))

    }
    
    //Adds Red Ball
    func redBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "redball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Red // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))
    }
    
    //Adds Blue Ball
    func blueBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "blueball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Blue // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))
    }
    
    //Adds Yellow Ball
    func yellowBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "yellowball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Yellow // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))
    }
    
    //Adds Black Ball
    func blackBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "blackball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Black // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))
    }
    
    //Adds Brown Ball
    func brownBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "brownball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Brown // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))
    }
    
    //Adds White Ball
    func whiteBall(count: CGFloat){
        
        let ball = SKSpriteNode(imageNamed: "whiteball")
        ball.position = CGPoint(x: size.width/12 * count - 13, y: size.height+100)
        self.addChild(ball)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2-8) // 1
        ball.physicsBody?.dynamic = true // 2
        ball.physicsBody?.categoryBitMask = PhysicsCategory.White // 3
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Block // 4
        ball.physicsBody?.collisionBitMask = PhysicsCategory.Block // 5
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let ballDestination = CGPoint(x: size.width/12 * count - 13, y: -100)
        let ballMove = SKAction.moveTo(ballDestination, duration: 3.0)
        let ballMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([ballMove, ballMoveDone]))
    }

    
    //Returns Random Number
    func randRange (lower: Int , upper: Int) -> Int {
        
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    //Program Waits For Duration
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //Deals With Collisions
    func blockHitsRed(){
        
        self.sizing += 0.03
        block.setScale(self.sizing)
        if (block.size.width >= self.frame.size.width)
        {
            backgroundMusic.stop()
            saveHighscore()
            //viewController.showLeader()
            let reveal = SKTransition.flipHorizontalWithDuration(1)
            let gameOverScene = GameOverScene(size: self.size, score: self.count)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        
        //Block Hits Green
        if (firstBody.categoryBitMask == 0b11 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b11){
                
                self.count += 1
                //saveHighscore()
                self.label.text = String(count)
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                }
                else{
                    secondBody.node?.removeFromParent()
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
        
        //Block Hits Red
        if (firstBody.categoryBitMask == 0b100 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b100){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    blockHitsRed()
                }
                else{
                    secondBody.node?.removeFromParent()
                    blockHitsRed()
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
        
        //Block Hits Yellow
        if (firstBody.categoryBitMask == 0b101 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b101){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    if (allRed == false){
                        allGreen = true
                    }
                    delay(3.0){
                        self.allGreen = false
                    }
                }
                else{
                    secondBody.node?.removeFromParent()
                    if (allRed == false){
                        allGreen = true
                    }
                    delay(3.0){
                        self.allGreen = false
                    }
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
        
        //Block Hits Blue
        if (firstBody.categoryBitMask == 0b110 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b110){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    if (self.sizing >= 0.35){
                        self.sizing -= 0.06
                    }
                    block.setScale(self.sizing)
                }
                else{
                    secondBody.node?.removeFromParent()
                    if (self.sizing >= 0.35){
                        self.sizing -= 0.06
                    }
                    else if (self.sizing >= 0.32){
                        self.sizing = 0.30
                    }
                    block.setScale(self.sizing)
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
        
        //Block Hits Black
        if (firstBody.categoryBitMask == 0b111 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b111){
                
                saveHighscore()
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    backgroundMusic.stop()
                    let reveal = SKTransition.flipHorizontalWithDuration(1)
                    let gameOverScene = GameOverScene(size: self.size, score: self.count)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                else{
                    secondBody.node?.removeFromParent()
                    backgroundMusic.stop()
                    let reveal = SKTransition.flipHorizontalWithDuration(1)
                    let gameOverScene = GameOverScene(size: self.size, score: self.count)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
        
        //Block Hits Brown
        if (firstBody.categoryBitMask == 0b1000 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b1000){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    if (allGreen == false){
                        allRed = true
                    }
                    delay(3.0){
                        self.allRed = false
                    }
                }
                else{
                    secondBody.node?.removeFromParent()
                    if (allGreen == false){
                        allRed = true
                    }
                    delay(3.0){
                        self.allRed = false
                    }
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
        
        //Block Hits White
        if (firstBody.categoryBitMask == 0b1001 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b1001){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    self.sizing = 0.3
                    block.setScale(self.sizing)
                }
                else{
                    secondBody.node?.removeFromParent()
                    self.sizing = 0.3
                    block.setScale(self.sizing)
                }
                hitNoise = self.setupAudioPlayerWithFile("gun1", type:"mp3")
                hitNoise.volume = 0.5
                hitNoise.play()
        }
    }
    
    func leaderboard(score: Int) {
        
        saveHighscore()
        showLeader()
    }
    
    //send high score to leaderboard
    func saveHighscore() {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "High_Scores1") //leaderboard id here
            
            scoreReporter.value = Int64(self.count) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
            
        }
        
    }
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.viewController.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    
}
