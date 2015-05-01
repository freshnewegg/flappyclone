//
//  GameScene.swift
//  flappy
//
//  Created by Edgar Wang on 2015-04-30.
//  Copyright (c) 2015 Edgar Wang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode();
    
    var pipeTextureUp=SKTexture()
    var pipeTextureDown=SKTexture()
    var pipeMoveRemove=SKAction()
    
    let pipeGap=150.0
    
    override func didMoveToView(view: SKView) {
        
        //physics
        self.physicsWorld.gravity = CGVectorMake(0, -5.0);
        
        //bird
        var birdTexture=SKTexture(imageNamed: "bird");
        birdTexture.filteringMode = SKTextureFilteringMode.Nearest;
        
        bird = SKSpriteNode(texture: birdTexture);
        bird.setScale(0.5)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        
        //make sure bird can collide with things
        bird.physicsBody = SKPhysicsBody(circleOfRadius:bird.size.height/2.0)
        bird.physicsBody?.dynamic=true
        
        //dont let that bird rotate
        bird.physicsBody?.allowsRotation=false
        
        self.addChild(bird)
        
        
        //add a ground
        var groundTexture = SKTexture(imageNamed: "ground")
        
        var sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position=CGPointMake(self.size.width/2, sprite.size.height/2.0)
        
        self.addChild(sprite)
        
        //create physics around ground
        var ground = SKNode()
        ground.position=CGPointMake(0.0, groundTexture.size().height)
        ground.physicsBody=SKPhysicsBody(rectangleOfSize: (CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0)))
        
        ground.physicsBody?.dynamic=false
        
        self.addChild(ground)
        
        //movement of pipes
        
        pipeTextureUp=SKTexture(imageNamed: "tube")
        pipeTextureDown=SKTexture(imageNamed: "tube")
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0  * pipeTextureUp.size().width)
        
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        
        //add the remove pipes action in a sequence
        let removePipes=SKAction.removeFromParent()
        pipeMoveRemove=SKAction.sequence([movePipes,removePipes])
        
        //spawn pipes
        let spawn=SKAction.runBlock({() in self.spawnPipes()})
        let delay=SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay=SKAction.sequence([spawn,delay])
        let spawnThenDelayForever=SKAction.repeatActionForever(spawnThenDelay)
        
        self.runAction(spawnThenDelayForever)
        
        
        
    }
    
    func spawnPipes(){
        let pipePair=SKNode()
        pipePair.position=CGPointMake(self.frame.size.width+pipeTextureUp.size().width*2.0,0)
        //zposition makes an obect BEHIND another object
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height/4.0)
        let y=arc4random()%height + height //spawn from 0 to the height
        
        let pipeDown=SKSpriteNode(texture:pipeTextureDown)
        pipeDown.setScale(2.0)
        
        //I guess the y=0 starts from the top
        pipeDown.position=CGPointMake(0, CGFloat(y)+pipeDown.size.height + CGFloat(pipeGap))
        pipeDown.physicsBody=SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic=false
        
        pipePair.addChild(pipeDown)
        
        let pipeUp=SKSpriteNode(texture: pipeTextureDown)
        pipeUp.setScale(2.0)
        
        pipeUp.position=CGPointMake(0, CGFloat(y))
        
        pipeUp.physicsBody=SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic=false
        pipePair.addChild(pipeUp)
        
        pipePair.runAction(pipeMoveRemove)

        self.addChild(pipePair)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let location=touch.locationInNode(self)
            
            bird.physicsBody?.velocity=CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 25))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
