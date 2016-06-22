//
//  GameScene.swift
//  BallGame
//
//  Created by Binh Le on 8/3/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

import AVFoundation
import SpriteKit

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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    weak var viewController: GameViewController!
    let block = SKSpriteNode(imageNamed: "woodbox.png")
    let bigbox = SKSpriteNode(imageNamed: "greenball.png")
    let title = SKLabelNode(fontNamed: "Chalkduster")
    let title2 = SKLabelNode(fontNamed: "Chalkduster")
    let startButton = SKLabelNode(fontNamed:"Chalkduster")
    let label_score = SKLabelNode(fontNamed:"MarkerFelt-Wide")
    let label = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    var sizing: CGFloat = 0.24
    var count: NSInteger = 0
    var start = false
    var xVelocity: CGFloat = 0
    var allGreen = false
    var allRed = false
    
    var backgroundMusic = AVAudioPlayer()
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var error: NSError?
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        return audioPlayer!
    }

    override func didMoveToView(view: SKView) {
        
        let background : SKSpriteNode = SKSpriteNode (imageNamed: "junglevert.png")
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        background.size = self.frame.size
        self.addChild(background)
        
        let name: NSString = "JUNGLE"
        title.text = name as String
        title.fontSize = 40;
        title.fontColor = SKColor.whiteColor()
        title.position = CGPointMake(size.width/2, size.height * 0.8)
        title.setScale(1.5)
        self.addChild(title)
        
        let name1: NSString = "RUSH"
        title2.text = name1 as String
        title2.fontSize = 40;
        title2.fontColor = SKColor.whiteColor()
        title2.position = CGPointMake(size.width/2, size.height * 0.65)
        title2.setScale(1.5)
        self.addChild(title2)
        
        let startmessage:NSString = "TOUCH TO PLAY";
        startButton.text = startmessage as String
        startButton.fontColor = SKColor.whiteColor()
        startButton.position = CGPointMake(size.width/2, size.height * 0.2)
        startButton.name = "start"
        startButton.setScale(0.8)
        self.addChild(startButton)
        
        backgroundMusic = self.setupAudioPlayerWithFile("funky", type:"mp3")
        backgroundMusic.numberOfLoops = -1
        self.setUpMusic()
        
        bigbox.position = CGPointMake(self.frame.size.width/2, size.height/2)
        bigbox.setScale(1.5)
        self.addChild(bigbox)
        
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.dynamic = true
        block.physicsBody?.categoryBitMask = PhysicsCategory.Block
        block.physicsBody?.contactTestBitMask = PhysicsCategory.Green
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
    }
    
    //Starts Game
    func setUpGame(){
        
        block.setScale(sizing)
        self.addChild(block)
        if (randRange(1,upper:2) == 1){
            xVelocity = -175
        }
        else{
            xVelocity = 175
        }
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        addBalls()
        
        label.position = CGPoint(x: CGRectGetMaxX(frame) - 50, y: CGRectGetMaxY(frame) - 50)
        label.text = String(count)
        label.fontColor = SKColor.whiteColor()
        label.zPosition = 50
        addChild(label)
    }
    
    //Sets Background Music
    func setUpMusic(){
        
        backgroundMusic.volume = 0.5
        backgroundMusic.play()
    }

    
    //Uses Touches On Button To Move Sprite Left And Right
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event!);
        let array = Array(touches)
        let touch = array[0] as! UITouch
        let location = touch.locationInNode(self)
        
        if (location.x <= self.frame.size.width/2){
            xVelocity = -175
            //moveNoise = self.setupAudioPlayerWithFile("swoosh", type:"wav")
            //moveNoise.volume = 0.6
            //moveNoise.play()
        }
        
        if (location.x > self.frame.size.width/2){
            xVelocity = 175
            //moveNoise = self.setupAudioPlayerWithFile("swoosh", type:"wav")
            //moveNoise.volume = 0.6
            //moveNoise.play()
        }
        
        let node:SKNode = self.nodeAtPoint(location)
        if (start == false) {
            start = true
            title.removeFromParent()
            title2.removeFromParent()
            startButton.removeFromParent()
            bigbox.removeFromParent()
            setUpGame()
        }
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?)  {
        
        if (xVelocity>0){
            xVelocity = 175
        }
        else{
            xVelocity = -175
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
                if ((temp < 40 || allGreen == true) && allRed == false){
                    greenBall(count)
                }
                else if ((temp >= 40 && temp < 80 || allRed == true) && allGreen == false){
                    redBall(count)
                }
                else if (temp >= 80 && temp < 86){
                    brownBall(count)
                }
                else if (temp >= 86 && temp < 91){
                    yellowBall(count)
                }
                else if (temp >= 91 && temp < 97){
                    blueBall(count)
                }
                else if (temp >= 97 && temp < 100){
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
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
        if (sizing >= 0.90)
        {
            backgroundMusic.stop()
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
                self.label.text = String(count)
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                }
                else{
                    secondBody.node?.removeFromParent()
                }
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
        }
        
        //Block Hits Blue
        if (firstBody.categoryBitMask == 0b110 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b110){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    if (self.sizing >= 0.27){
                        self.sizing -= 0.03
                    }
                    block.setScale(self.sizing)
                }
                else{
                    secondBody.node?.removeFromParent()
                    if (self.sizing >= 0.27){
                        self.sizing -= 0.03
                    }
                    block.setScale(self.sizing)
                }
        }
        
        //Block Hits Black
        if (firstBody.categoryBitMask == 0b111 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b111){
                
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
        }
        
        //Block Hits White
        if (firstBody.categoryBitMask == 0b1001 && secondBody.categoryBitMask == 0b1
            || firstBody.categoryBitMask == 0b1 && secondBody.categoryBitMask == 0b1001){
                
                if (firstBody.categoryBitMask > secondBody.categoryBitMask){
                    firstBody.node?.removeFromParent()
                    self.sizing = 0.24
                    block.setScale(self.sizing)
                }
                else{
                    secondBody.node?.removeFromParent()
                    self.sizing = 0.24
                    block.setScale(self.sizing)
                }
        }

    }
}
