//
//  GameScene.swift
//  demo
//
//  Created by Nick on 10/24/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isTouchingPaddle = false
    
    let BallCategory: UInt32 = 0x1 << 0 //   00000000 00000000 00000000 00000001
    let PaddleCategory: UInt32 = 0x1 << 1 // 000000000 00000000 0000000 00000010
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        
        self.physicsBody = border
        
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
        
        let paddle = childNodeWithName("Paddle") as! SKSpriteNode
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        
        ball.physicsBody!.contactTestBitMask = PaddleCategory
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == BallCategory && contact.bodyB.categoryBitMask == PaddleCategory {
            print("The ball hit the paddle")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch = touches.first as UITouch!;
        let location = touch.locationInNode(self);
        _ = touch.previousLocationInNode(self);
        
        if let body = self.physicsWorld.bodyAtPoint(location) {
            if body.node!.name == "Paddle" {
                isTouchingPaddle = true
            }
        }
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
