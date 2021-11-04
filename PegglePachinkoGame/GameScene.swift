//
//  GameScene.swift
//  PegglePachinkoGame
//
//  Created by Nick Sagan on 03.11.2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var boxes = [SKSpriteNode]()
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var restartLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }

    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Restart"
        restartLabel.position = CGPoint(x: 80, y: 650)
        addChild(restartLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 256, y: 0))
        addBouncer(at: CGPoint(x: 512, y: 0))
        addBouncer(at: CGPoint(x: 768, y: 0))
        addBouncer(at: CGPoint(x: 1024, y: 0))
        
        //addHorizontalBox(at: CGPoint(x: 1024, y: 256), height: 32, width: 256)
        //addHorizontalBox(at: CGPoint(x: 0, y: 384), height: 32, width: 256)
        addRotatedBox(at: CGPoint(x: 128, y: 256), height: 16, width: 256)
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode = !editingMode
            //editLabel.toggle() - same as before
        } else if objects.contains(restartLabel) {
            for box in boxes {
                box.removeFromParent()
            }
            boxes.removeAll(keepingCapacity: true)
            for _ in 0...9 {
                let size = CGSize(width: Int.random(in: 32...256), height: 32)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1) ,size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                
                let x = Int.random(in: 30...850)
                let y = Int.random(in: 60...470)
                box.position = CGPoint(x: x, y: y)
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                boxes.append(box)
                addChild(box)
            }
        } else {
            if editingMode {
                //        let box = SKSpriteNode(color: .systemRed, size: CGSize(width: 64, height: 64))
                //        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
                //        box.position = location
                //        addChild(box)
                let size = CGSize(width: Int.random(in: 32...128), height: 32)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1) ,size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.zPosition = 10
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "box"
                boxes.append(box)
                addChild(box)
            } else if location.y > 500 {
                let ballColor = Int.random(in: 0...6)
                let ball: SKSpriteNode
                var ballColorName: String
                switch ballColor {
                case 0: ballColorName = "ballRed"
                case 1: ballColorName = "ballBlue"
                case 2: ballColorName = "ballCyan"
                case 3: ballColorName = "ballGreen"
                case 4: ballColorName = "ballYellow"
                case 5: ballColorName = "ballGrey"
                case 6: ballColorName = "ballPurple"
                default:
                    ballColorName = "ballRed"
                }
                

                    ball = SKSpriteNode(imageNamed: ballColorName)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                ball.physicsBody?.restitution = CGFloat.random(in: 0.1...0.9)
                
                // which collisions do we want to be noticed
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                
                ball.position = location
                ball.name = "ball"
                ball.zPosition = 100
                addChild(ball)
            }
        }
    }
    
    func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2.0)
        bouncer.physicsBody?.isDynamic = false
        bouncer.name = "bouncer"
        bouncer.zPosition = 4
        addChild(bouncer)
    }
    
    func addHorizontalBox(at position: CGPoint, height: Int, width: Int) {
        let size = CGSize(width: width, height: height)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1) ,size: size)
        //box.zRotation = CGFloat.random(in: 0...3)
        box.position = position
        box.zPosition = 10
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        boxes.append(box)
        addChild(box)
        
        if box.position.x > frame.width / 2 {
            let leftSlide = SKAction.move(by: CGVector(dx: -900, dy: 0), duration: 2)
            let rightSlide = SKAction.move(by: CGVector(dx: 900, dy: 0), duration: 2)
            let leftAndRightSlide = SKAction.sequence([leftSlide, rightSlide])
            let moveForever = SKAction.repeatForever(leftAndRightSlide)
            box.run(moveForever)
        } else {
            let rightSlide = SKAction.move(by: CGVector(dx: 900, dy: 0), duration: 2)
            let leftSlide = SKAction.move(by: CGVector(dx: -900, dy: 0), duration: 2)
            let leftAndRightSlide = SKAction.sequence([rightSlide, leftSlide])
            let moveForever = SKAction.repeatForever(leftAndRightSlide)
            box.run(moveForever)
        }
    }
    
    func addRotatedBox(at position: CGPoint, height: Int, width: Int) {
        let size = CGSize(width: width, height: height)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1) ,size: size)
        box.zRotation = 1
        box.position = position
        box.zPosition = 10
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        boxes.append(box)
        addChild(box)
        
        if box.position.x > frame.width / 2 {
            let leftSlide = SKAction.move(by: CGVector(dx: -600, dy: -32), duration: 2)
            let rightSlide = SKAction.move(by: CGVector(dx: 600, dy: 32), duration: 2)
            let leftAndRightSlide = SKAction.sequence([leftSlide, rightSlide])
            let moveForever = SKAction.repeatForever(leftAndRightSlide)
            box.run(moveForever)
        } else {
            let rightSlide = SKAction.move(by: CGVector(dx: 600, dy: -32), duration: 2)
            let leftSlide = SKAction.move(by: CGVector(dx: -600, dy: 32), duration: 2)
            let leftAndRightSlide = SKAction.sequence([rightSlide, leftSlide])
            let moveForever = SKAction.repeatForever(leftAndRightSlide)
            box.run(moveForever)
        }
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 1)
        let spinForever = SKAction.repeatForever(spin)
        box.run(spinForever)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position
        slotGlow.zPosition = 2
        slotBase.zPosition = 3
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            remove(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        let ballPosition = ball.position
        
        if let fireparticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireparticles.position = ballPosition
            addChild(fireparticles)
            let wait = SKAction.wait(forDuration: 5)
            let delete = SKAction.removeFromParent()
            let waitAndDelete = SKAction.sequence([wait, delete])
            fireparticles.run(waitAndDelete)
        }
        
        ball.removeFromParent()
    }
    
    func remove(ball: SKNode) {
        ball.physicsBody = nil
        ball.alpha = 0.5
        
        let moveToScore = SKAction.move(to: scoreLabel.position, duration: 0.5)
        let addScore = SKAction.run {
            self.score += 1
        }
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveToScore, addScore, remove])
        
        ball.run(moveAndRemove)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
}
