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
///////VERSION WITH INCONTROLLABLE MOVEMENT DISTANCE
//
//class Gameplay: CCNode, CCPhysicsCollisionDelegate {
//    //Interface
//    weak var gameScore: CCLabelTTF!
//    var points: Int = 0
//    
//    //Gameplay & Physics
//    weak var gamePhysicsNode: CCPhysicsNode!
//    var scrollSpeed: CGFloat = 3
//    var ifPrevVisibleRand: UInt32!
//    var ifPrevNotVisibleRand: UInt32!
//    
//    var respawnChance: UInt32 = 85
//    var invisibilityChance: UInt32 = 85
//    
//    var lifeBar: CCNode!
//    var timeLeft: Float = 5 {
//        didSet {
//            timeLeft = max(min(timeLeft, 10), 0)
//            lifeBar.scaleX = timeLeft / Float (10)
//        }
//    }
//    
//    
//    // Grid
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
//    var defaultSpeed: CGFloat = 5
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
//        
//        //Player 2
//        player2 = CCBReader.load("Gameplay/Character2") as! Character!
//        player2positionX = screenSize.width * 0.10
//        gamePhysicsNode.addChild(player2)
//        player2.position = ccp(player2positionX, cellSize.height * (level1 + 1))// + positionCorrection)
//        player2.currentPositionY = player2.position.y
//        player2.initialPositionY = player2.position.y
//        
//        //        gamePhysicsNode.debugDraw = true
//        
//    }
//    
//    func isCheckedForVisibility() {//fish: Fish!, row: Int) {
//        ifPrevVisibleRand = arc4random_uniform(UInt32(100))
//        if isVisible == true {
//            if ifPrevVisibleRand < invisibilityChance {
//                isVisible = false
//            }
//        } else {
//            ifPrevNotVisibleRand = arc4random_uniform(UInt32(100))
//            if ifPrevNotVisibleRand < respawnChance {
//                isVisible = true
//            }
//        }
//    }
//    
//    //    func spawnWave(waveNumber: Int) {
//    //        var fishArray: [Fish!] = []
//    //        var intRows = Int(numberOfRows)
//    //        var fish: Fish!
//    //        for row in 1..<intRows {
//    //            if row != Int(level1) && row != Int(level2) {
//    //                if row == 1 || row == intRows - 1 {
//    //                    fish = CCBReader.load("Gameplay/BonusFish") as! Fish
//    //                    fish.points = 200
//    //                    fish.position = ccp(screenSize.width - fish.contentSize.width + CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row + 1))
//    //                    gamePhysicsNode.addChild(fish)
//    //                    fishArray.append(fish)
//    //                } else {
//    //                    isCheckedForVisibility()
//    //                    if isVisible {
//    //                        if row == Int(level1 - 1) || row == Int(level2 + 1) {
//    //                            fish = CCBReader.load("Gameplay/NormalFish") as! Fish
//    //                            fish.points = 0
//    //                        } else if row == intRows / 2 {
//    //                            fish = CCBReader.load("Gameplay/BadFish") as! Fish
//    //                            fish.points = -25
//    //                        } else {
//    //                            fish = CCBReader.load("Gameplay/NormalFish") as! Fish
//    //                            fish.points = 70
//    //                        }
//    //                        fish.position = ccp(screenSize.width - fish.contentSize.width + CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row + 1))
//    //                        gamePhysicsNode.addChild(fish)
//    //                        fishArray.append(fish)
//    //                    }
//    //                }
//    //            }
//    //        }
//    //        waveArray.append(fishArray)
//    //    }
//    
//    func spawnWave(waveNumber: Int) {
//        var fishArray: [Fish!] = []
//        var intRows = Int(numberOfRows)
//        var fish: Fish!
//        for row in 1..<intRows {
//            if row != Int(level1) {
//                if row == 1 {
//                    fish = CCBReader.load("Gameplay/BonusFish") as! Fish
//                    fish.points = 200
//                    fish.position = ccp(screenSize.width - fish.contentSize.width + CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row + 1))
//                    gamePhysicsNode.addChild(fish)
//                    fishArray.append(fish)
//                } else {
//                    isCheckedForVisibility()
//                    if isVisible {
//                        if row == Int(level1 - 1) {
//                            fish = CCBReader.load("Gameplay/NormalFish") as! Fish
//                            fish.points = 0
//                        } else if row == intRows / 2 {
//                            fish = CCBReader.load("Gameplay/BadFish") as! Fish
//                            fish.points = -25
//                        } else {
//                            fish = CCBReader.load("Gameplay/NormalFish") as! Fish
//                            fish.points = 70
//                        }
//                        fish.position = ccp(screenSize.width - fish.contentSize.width + CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row + 1))
//                        gamePhysicsNode.addChild(fish)
//                        fishArray.append(fish)
//                    }
//                }
//            }
//        }
//        waveArray.append(fishArray)
//    }
//    
//    
//    
//    override func update(delta: CCTime) {
//        gamePhysicsNode.position.x -= scrollSpeed
//        player1.position.x += scrollSpeed
//        player1.position.y += movementSpeed
//        
//        player2.position.x += scrollSpeed
//        
//        // Character controll mechanics
//        if player1.position.y >= player1.initialPositionY {
//            movementSpeed = 0
//            controllIsDisabled = false
//        }
//        
//        if !controllIsDisabled {
//            if acquiredNewPosition(player1) {
//                player1.currentPositionY = player1.position.y
//                movementSpeed = 0
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
//        //println(player1.gameScore.string)
//        
//    }
//    
//    func acquiredNewPosition(player: Character) -> Bool {
//        if player.position.y > player.currentPositionY - cellSize.height && player.position.y < player.currentPositionY + cellSize.height {
//            return false
//        } else {
//            controllIsDisabled = false
//            return true
//        }
//    }
//    
//    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
//        var a = cellSize.height * CGFloat(2)
//        
//        if !controllIsDisabled {
//            if touch.locationInWorld().x < screenSize.width / 2 {
//                if player1.position.y < player1.initialPositionY {
//                    movementSpeed = defaultSpeed
//                }
//            } else {
//                if player1.position.y > a {
//                    movementSpeed = -defaultSpeed
//                }
//            }
//        }
//    }
//    
//    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
//        
//    }
//    
//    
//    
//    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: Character!, fishLevel: Fish!) -> ObjCBool {
//        movementSpeed = defaultSpeed
//        controllIsDisabled = true
//        timeLeft += Float(fishLevel.points / 60)
//        points += Int(fishLevel.points)
//        gameScore.string = String(points)
//        fishLevel.visible = false
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
//    
//}