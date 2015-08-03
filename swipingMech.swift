////
////  Gameplay.swift
////  Blocks101
////
////  Created by Yeldos Balgabekov on 7/24/15.
////  Copyright (c) 2015 Apportable. All rights reserved.
////
//
//import Foundation
//import Social
//import Firebase
//
//class Gameplay: CCNode, CCPhysicsCollisionDelegate {
//    //Interface
//    weak var gameScore: CCLabelTTF!
//    var points: Int = 0
//    var controlBoard: CCSprite!
//    var control: CCSprite!
//    var initialControlPositionY: CGFloat!
//    var currentControlPositionY: CGFloat!
//    
//    //Gameplay & Physics
//    weak var gamePhysicsNode: CCPhysicsNode!
//    var scrollSpeed: CGFloat = 1.5
//    var ifPrevVisibleRand: UInt32!
//    var ifPrevNotVisibleRand: UInt32!
//    
//    var respawnChance: UInt32 = 85
//    var invisibilityChance: UInt32 = 85
//    
//    var lifeBar: CCNode!
//    var timeLeft: Float = 10 {
//        didSet {
//            timeLeft = max(min(timeLeft, 10), 0)
//            lifeBar.scaleX = timeLeft / Float (10)
//        }
//    }
//    
//    
//        // Grid
//    var screenSize: CGRect!
//    var cellSize: (width: CGFloat, height: CGFloat)!
//    var distanceBetweenFishesX: CGFloat!
//    var distanceBetweenFishesY: CGFloat!
//    var numberOfColumns: CGFloat!
//    var numberOfRows: CGFloat!
//    var level1: CGFloat!
//    var level2: CGFloat!
//    
//    //Player
//    weak var player1: Character!
//    var player1positionX: CGFloat!
//    
//    weak var player2: Character!
//    var player2positionX: CGFloat!
//    
//    var positionCorrection: CGFloat!
//    var movementSpeed: CGFloat = 0
//    var defaultSpeed: CGFloat = 3.5
//    
//    var controllIsDisabled = false
//    
//
//    ///ENUM CONTROLLING PLAYER
//    
//    //Fish
//    weak var fish: Fish!
//    var waveArray: [[Fish!]] = []
//    var waveNumber = 1
//    var maxWaves = 2
//    var visibilitiy = [Int: Bool]()
//    var isVisible =  true
//    
//    func didLoadFromCCB() {
//        userInteractionEnabled = true
//        gamePhysicsNode.collisionDelegate = self
//        screenSize = UIScreen.mainScreen().bounds // (0.0, 0.0, 568.0, 320.0)
//        
//        
//        //Grid
//        fish = CCBReader.load("Gameplay/NormalFish") as! Fish!
//        distanceBetweenFishesX = fish.contentSize.width * 1
//        distanceBetweenFishesY = fish.contentSize.width * 0.1
//        
//        cellSize = (width: fish.contentSize.width + distanceBetweenFishesX, height: fish.contentSize.height + distanceBetweenFishesY )
//        
//        numberOfRows = round(screenSize.height * 0.8 / cellSize.height)
//        numberOfColumns = round(screenSize.width/cellSize.width )
//
//        level1 = numberOfRows - 1
//        
//        while waveNumber <= Int(numberOfColumns) {
//            spawnWave(waveNumber)
//            maxWaves = waveNumber
//            waveNumber++
//        }
//        
//        //Player 1
//        player1 = CCBReader.load("Gameplay/Character1") as! Character!
//        player1positionX = screenSize.width * 0.05
//        gamePhysicsNode.addChild(player1)
//        player1.position = ccp(player1positionX, cellSize.height * (level1 + 1))// + positionCorrection)
//        player1.currentPositionY = player1.position.y
//        player1.initialPositionY = player1.position.y
//        player1.minPositionY = cellSize.height * CGFloat(1)
//        
//        //Player 2
//        player2 = CCBReader.load("Gameplay/Character2") as! Character!
//        player2positionX = screenSize.width * 0.10
//        gamePhysicsNode.addChild(player2)
//        player2.position = ccp(player2positionX, cellSize.height * (level1 + 1))// + positionCorrection)
//        player2.currentPositionY = player2.position.y
//        player2.initialPositionY = player2.position.y
//        player2.visible = false
//        
////        gamePhysicsNode.debugDraw = true
//        
//    }
//    
//    func isCheckedForVisibility() {//fish: Fish!, row: Int) {
//        ifPrevVisibleRand = arc4random_uniform(UInt32(100))
//        if isVisible == true {
//            if ifPrevVisibleRand < invisibilityChance { // 85 perc
//                 isVisible = false
//            }
//        } else {
//            ifPrevNotVisibleRand = arc4random_uniform(UInt32(100))
//            if ifPrevNotVisibleRand < respawnChance { // 85 perc
//                isVisible = true
//            }
//        }
//    }
//
//    func spawnWave(waveNumber: Int) {
//        var fishArray: [Fish!] = []
//        var intRows = Int(numberOfRows)
//        var fish: Fish!
//        for row in 0..<intRows {
//            if row != Int(level1) {
//                if row == 0 {
//                    fish = CCBReader.load("Gameplay/BonusFish") as! Fish
//                    fish.points = 200
//                    fish.position = ccp(CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(1))
////                    fish.position = ccp(screenSize.width - fish.contentSize.width + CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(1))
//                    gamePhysicsNode.addChild(fish)
//                    fishArray.append(fish)
//                } else {
//                    isCheckedForVisibility()
//                    if isVisible {
//                        if row == Int(level1 - 1) {
//                            fish = CCBReader.load("Gameplay/NormalFish") as! Fish
//                            fish.points = 1
//                        } else if row == intRows / 2 {
//                            fish = CCBReader.load("Gameplay/BadFish") as! Fish
//                            fish.points = -25
//                        } else {
//                            fish = CCBReader.load("Gameplay/NormalFish") as! Fish
//                            fish.points = 25
//                        }
//                        
//                        fish.position = ccp(CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row + 1))
////                        fish.position = ccp(screenSize.width - fish.contentSize.width + CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row + 1))
//                        gamePhysicsNode.addChild(fish)
//                        fishArray.append(fish)
//                    }
//                }
//            }
//        }
//        waveArray.append(fishArray)
//    }
//    
//    override func update(delta: CCTime) {
//        gamePhysicsNode.position.x -= scrollSpeed
//        player1.position.x += scrollSpeed
//        
//        player2.position.x += scrollSpeed
//        
//        // Controller mechanics
//        if !controllIsDisabled {
//            if initialControlPositionY != nil && control != nil && currentControlPositionY != nil {
//                let controllerClampf = clampf(Float(control.position.y), Float(initialControlPositionY - 45), Float(initialControlPositionY + 45))
//                control.position.y = CGFloat(controllerClampf)
//                
//                if currentControlPositionY > initialControlPositionY {
//                    if player1.position.y <= player1.initialPositionY {
//                        player1.position.y += defaultSpeed
//                    } else {
//                        player1.position.y = player1.initialPositionY
//                    }
//                } else if currentControlPositionY < initialControlPositionY {
//                    if player1.position.y > player1.minPositionY {
//                        player1.position.y -= defaultSpeed
//                    } else {
//                        player1.position.y = player1.minPositionY
//                    }
//                } else {
//                    movementSpeed = 0
//                }
//            }
//        } else {
//            if player1.position.y < player1.initialPositionY {
//                player1.position.y += defaultSpeed
//            } else if player1.position.y == player1.initialPositionY {
//                controllIsDisabled = false
//            } else if player1.position.y > player1.initialPositionY {
//                player1.position.y = player1.initialPositionY
//                controllIsDisabled = false
//            }
//        }
//        
//        // World scrolling
//        var wave = waveArray[0]
//        var fish = wave[0]
//        
//        let fishWorldPosition = gamePhysicsNode.convertToWorldSpace(fish.position)
//        let fishScreenPosition = convertToNodeSpace(fishWorldPosition)
//        if fishScreenPosition.x < -fish.contentSize.width {
//            var wave = waveArray[0]
//            for fish in wave {
//                fish.removeFromParent()
//            }
//            waveArray.removeAtIndex(0)
//            spawnWave(waveNumber)
//            waveNumber++
//        }
//        
//        timeLeft -= Float(delta)
//        if gameOver() {
//            restart()
//        }
//        
//        // difficulty
//        
//        if waveNumber <= 20 {
//            scrollSpeed = 1.5
//        } else if waveNumber > 20 {
//            scrollSpeed = 1.75
//        } else if waveNumber > 35 {
//            scrollSpeed = 2
//        } else if waveNumber > 50 {
//            scrollSpeed = 2.25
//        } else if waveNumber > 65 {
//            scrollSpeed = 2.5
//        } else if waveNumber > 80 {
//            scrollSpeed = 3
//        }
//        
//        
//    }
//    
//    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
//        controlBoard = CCBReader.load("Interface/ControlBoard") as! CCSprite
//        controlBoard.position = touch.locationInWorld()
//        
//        control = CCBReader.load("Interface/Control") as! CCSprite
//        control.position = touch.locationInWorld()
//        
//        initialControlPositionY = touch.locationInWorld().y
//        
//        self.addChild(controlBoard)
//        self.addChild(control)
//    }
//    
//    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
//        currentControlPositionY = touch.locationInWorld().y
//        control.position.y = currentControlPositionY
//    }
//    
//    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
//        controlBoard.removeFromParent()
//        control.removeFromParent()
//        
//        initialControlPositionY = nil
//        controlBoard = nil
//        control = nil
//        currentControlPositionY = nil
//        
////        movementSpeed = 0
//        
//    }
//    
//    
//
//    
//    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: Character!, fishLevel: Fish!) -> ObjCBool {
//        controllIsDisabled = true
////        movementSpeed = defaultSpeed
//        
//        timeLeft += Float(fishLevel.points / 60)
//        points += Int(fishLevel.points)
//        
////        fishLevel.visible = false
//        fishLevel.removeFromParent()
//        
//        gameScore.string = String(points)
//        
//        return true
//    }
//    
//    func restart() {
//        let scene = CCBReader.loadAsScene("Gameplay/Gameplay")
//        CCDirector.sharedDirector().presentScene(scene)
//    }
//    
//    func gameOver() -> Bool {
//        if timeLeft <= 0 {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func shareButtonTapped() {
//        var scene = CCDirector.sharedDirector().runningScene
//        var n: AnyObject = scene.children[0]
//        var image = screenShotWithStartNode(n as! CCNode)
//        
//        let sharedText = "My score is \(points) points. Can anyone beat me? :))"
//        let itemsToShare = [image, sharedText]
//        
//        var excludedActivities = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
//            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
//            UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop]
//        
//        var controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//        controller.excludedActivityTypes = excludedActivities
//        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
//        
//    }
//    
//    func screenShotWithStartNode(node: CCNode) -> UIImage {
//        CCDirector.sharedDirector().nextDeltaTimeZero = true
//        var viewSize = CCDirector.sharedDirector().viewSize()
//        var rtx = CCRenderTexture(width: Int32(viewSize.width), height: Int32(viewSize.height))
//        rtx.begin()
//        node.visit()
//        rtx.end()
//        return rtx.getUIImage()
//    }
//}
