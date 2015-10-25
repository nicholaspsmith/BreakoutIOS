//
//  GameScene.swift
//  demo
//
//  Created by Nick on 10/24/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var blockCount = 0
    var isTouchingPaddle = false
    var currentScore = 0
    
    let BallCategory: UInt32 = 0x1 << 0 //   00000000 00000000 00000000 00000001
    let PaddleCategory: UInt32 = 0x1 << 1 // 00000000 00000000 00000000 00000010
    let BlockCategory: UInt32 = 0x1 << 2 //  00000000 00000000 00000000 00000100
    let BottomCategory: UInt32 = 0x1 << 3 // 00000000 00000000 00000000 00001000
    
    override func didMoveToView(view: SKView) {

        /* Setup your scene here */
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        
        self.physicsBody = border
        
        let rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: rect)
        bottom.physicsBody!.categoryBitMask = BottomCategory
        addChild(bottom)
        
        
        // Set gravity to 0
        self.physicsWorld.gravity = CGVectorMake(0,0)
        self.physicsWorld.contactDelegate = self
        
        let ball = childNodeWithName("Ball") as! SKSpriteNode
        
        ball.physicsBody!.applyImpulse(CGVectorMake(30, -30))
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.angularDamping = 0
        
        ball.physicsBody!.categoryBitMask = BallCategory
        ball.physicsBody!.contactTestBitMask = BlockCategory | BottomCategory
        
        let numBlocks: CGFloat = 6
        for i in Range(0..<Int(numBlocks)) {
            let block = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(CGRectGetWidth(frame) / numBlocks - 40, 40))
            block.position = CGPointMake(20 + block.size.width / 2 + CGFloat(i) * (block.size.width + 40), CGRectGetHeight(frame) * 0.75)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody!.dynamic = false
            block.physicsBody!.allowsRotation = true
            block.physicsBody!.friction = 0
            block.physicsBody!.restitution = 1
            block.physicsBody!.linearDamping = 0
            block.physicsBody!.angularDamping = 0
            
            block.physicsBody!.categoryBitMask = BlockCategory
            
            addChild(block)
            blockCount++
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var first: SKPhysicsBody
        var second: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        } else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if first.categoryBitMask == BallCategory && second.categoryBitMask == BlockCategory {
            // Increment score
            let scoreLabel = childNodeWithName("Score") as! SKLabelNode
            currentScore += 100
            scoreLabel.text = "Score: " + String(currentScore)
            // Remove block
            contact.bodyB.node!.removeFromParent()
            
            if --blockCount == 0 {
                if let mainScene = view {
                    if let scene =  GameOverScene(fileNamed:"GameOverScene") {
                        scene.didWin = true
                        mainScene.presentScene(scene)
                    }
                }
            }
        } else if first.categoryBitMask == BallCategory && second.categoryBitMask == BottomCategory {

                if let scene =  GameOverScene(fileNamed:"GameOverScene") {
                    scene.didWin = false
                    view!.presentScene(scene)
                }
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        isTouchingPaddle = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isTouchingPaddle {
            let touch = touches.first as UITouch!
            let location = touch.locationInNode(self)
            let prevLocation = touch.previousLocationInNode(self)
            
            let paddle = childNodeWithName("Paddle") as! SKSpriteNode
            
            // Set position of paddle
            var xPos = paddle.position.x + (location.x - prevLocation.x)
            // Set left bound
            xPos = max(xPos, paddle.size.width / 2)
            // Set right bound
            xPos = min(xPos, size.width - paddle.size.width / 2)
            
            paddle.position = CGPointMake(xPos, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouchingPaddle = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
