//
//  GameScene.swift
//  PegglePachinkoGame
//
//  Created by Nick Sagan on 03.11.2021.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 256, y: 0))
        addBouncer(at: CGPoint(x: 512, y: 0))
        addBouncer(at: CGPoint(x: 768, y: 0))
        addBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
//        let box = SKSpriteNode(color: .systemRed, size: CGSize(width: 64, height: 64))
//        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
//        box.position = location
//        addChild(box)
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        addChild(ball)
    }
    
    func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        slotBase = isGood ? SKSpriteNode(imageNamed: "slotBaseGood") : SKSpriteNode(imageNamed: "slotBaseBad")
        slotBase.position = position
        addChild(slotBase)
        
    }
    
    
}
