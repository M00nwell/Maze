//
//  GameScene.swift
//  Maze
//
//  Created by Wenzhe on 25/3/16.
//  Copyright (c) 2016 Wenzhe. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct CATEGORY{
        static let player:UInt32 = 0x0001
        static let end:UInt32 = 0x00002
        static let laser:UInt32 = 0x0004
        static let shieldA:UInt32 = 0x1000
        static let shieldB:UInt32 = 0x2000
        static let laserA:UInt32 = 0x0100
        static let laserB:UInt32 = 0x0200
        static let wall:UInt32 = 0x8000 << 16
        static let playNormalMask:UInt32 = end | laser | shieldA | shieldB | laserA | laserB
    }
    
    let manager = CMMotionManager()
    var gameVC : GameViewController!
    var player = SKSpriteNode()
    var stage : Int?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        pauseGame()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0, 0.0)   
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
            (data,error) in
            
            self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 10, CGFloat((data?.acceleration.y)!) * 10)
        }
        
        player = childNodeWithName("player") as! SKSpriteNode
        player.physicsBody?.contactTestBitMask = CATEGORY.playNormalMask
        player.physicsBody?.collisionBitMask = CATEGORY.wall
        player.color = UIColor(hex: 0x0A00EC, alpha: 1)
        player.removeAllActions()
        player.physicsBody?.affectedByGravity = true
        
        resumeGame()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        switch(bodyA.categoryBitMask | bodyB.categoryBitMask){
        
        case CATEGORY.end | CATEGORY.player:
            manager.stopAccelerometerUpdates()
            pauseGame()
            gameVC!.gameEnd()
            break
            
        case CATEGORY.laser | CATEGORY.player:
            manager.stopAccelerometerUpdates()
            pauseGame()
            gameVC!.youDie()
            break
            
        case CATEGORY.laserA | CATEGORY.player:
            manager.stopAccelerometerUpdates()
            pauseGame()
            gameVC!.youDie()
            break
            
        case CATEGORY.laserB | CATEGORY.player:
            manager.stopAccelerometerUpdates()
            pauseGame()
            gameVC!.youDie()
            break
            
        case CATEGORY.shieldA | CATEGORY.player:
            player.color = UIColor(hex: 0x26840F, alpha: 1)
            player.physicsBody?.contactTestBitMask = CATEGORY.playNormalMask
            player.physicsBody?.contactTestBitMask &= (0xFFFFFFFF ^ CATEGORY.laserA)
            //TODO: change player image
            if bodyA.node?.name == "player"{
                bodyB.node?.removeFromParent()
            }else{
                bodyA.node?.removeFromParent()
            }
            break
        case CATEGORY.shieldB | CATEGORY.player:
            player.color = UIColor(hex: 0xC871FF, alpha: 1)
            player.physicsBody?.contactTestBitMask = CATEGORY.playNormalMask
            player.physicsBody?.contactTestBitMask &= (0xFFFFFFFF ^ CATEGORY.laserB)
            //TODO: change player image
            if bodyA.node?.name == "player"{
                bodyB.node?.removeFromParent()
            }else{
                bodyA.node?.removeFromParent()
            }
            break
        default:
            break
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func pauseGame(){
        if let view = self.view {
            view.scene?.paused = true
        }
    }
    func resumeGame(){
        if let view = self.view {
            view.scene?.paused = false
        }
    }
}
