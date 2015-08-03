//
//  Gameplay.swift
//  Blocks101
//
//  Created by Yeldos Balgabekov on 7/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import Social
import Firebase

class Tutorial: CCNode, CCPhysicsCollisionDelegate {
    //Interface
    weak var gameScore: CCLabelTTF!
    var points: Int = 0
    var controlBoard: CCSprite!
    var control: CCSprite!
    var initialControlPositionY: CGFloat!
    var currentControlPositionY: CGFloat!
    
    weak var upLabel: CCLabelTTF!
    weak var downLabel: CCLabelTTF!
    weak var gameOverLabel: CCLabelTTF!
    
    weak var restartButton1: CCButton!
    weak var restartButton2: CCButton!
    weak var shareButton: CCButton!
    
    //    var gameStatistics: GameStatistics!
    weak var bestScore: CCLabelTTF!
    weak var recordScore: CCLabelTTF!
    
    //Gameplay & Physics
    weak var gamePhysicsNode: CCPhysicsNode!
    var scrollSpeed: CGFloat = 3.5//1.5
    var ifPrevVisibleRand: UInt32!
    var ifPrevNotVisibleRand: UInt32!
    
    var invisibilityChance: UInt32 = 85
    var respawnChance: UInt32 = 40
    
    var lifeBar: CCNode!
    var timeLeft: Float = 10 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float (10)
        }
    }
    
    
    // Grid
    var screenSize: CGRect!
    var cellSize: (width: CGFloat, height: CGFloat)!
    var distanceBetweenFishesX: CGFloat!
    var distanceBetweenFishesY: CGFloat!
    var numberOfColumns: CGFloat!
    var numberOfRows: CGFloat!
    var level1: CGFloat!
    var level2: CGFloat!
    
    //Player
    weak var player1: Character!
    var player1positionX: CGFloat!
    
    //    weak var player2: Character!
    //    var player2positionX: CGFloat!
    
    var positionCorrection: CGFloat!
    var movementSpeed: CGFloat = 0
    var defaultSpeed: CGFloat = 5.5
    
    var controllIsDisabled = false
    
    
    ///MULTIPLAYER: ENUM CONTROLLING PLAYER
    
    //Fish
    weak var fish: Fish!
    var waveArray: [[Fish!]] = []
    var waveNumber = 1
    var maxWaves = 2
    var visibilitiy = [Int: Bool]()
    var isVisible =  true
    var firstFishPoints: CGFloat = 7
    var bonusFishPoints: CGFloat = 100
    var penaltyFishPoints: CGFloat = -25
    
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        screenSize = UIScreen.mainScreen().bounds // (0.0, 0.0, 568.0, 320.0)
        
        
        //Grid
        fish = CCBReader.load("Gameplay/Fishes/littleFish2") as! Fish!
        distanceBetweenFishesX = fish.contentSize.width * 1
        distanceBetweenFishesY = fish.contentSize.width * 0.1
        
        cellSize = (width: fish.contentSize.width + distanceBetweenFishesX, height: fish.contentSize.height + distanceBetweenFishesY )
        
        numberOfRows = round(screenSize.height * 0.8 / cellSize.height)
        numberOfColumns = round(screenSize.width/cellSize.width )
        
        level1 = numberOfRows + 1
        
        while waveNumber <= Int(numberOfColumns + 5) {
            spawnWave(waveNumber)
            maxWaves = waveNumber
            waveNumber++
        }
        
        //Player 1
        player1 = CCBReader.load("Gameplay/Character1") as! Character!
        player1positionX = screenSize.width * 0.05
        gamePhysicsNode.addChild(player1)
        player1.position = ccp(player1positionX, cellSize.height * (level1))// + positionCorrection)
        player1.currentPositionY = player1.position.y
        player1.initialPositionY = player1.position.y
        player1.minPositionY = cellSize.height * CGFloat(2)
        
    }
    
    func next() {
        
    }
    
    func isCheckedForVisibility() {//fish: Fish!, row: Int) {
        ifPrevVisibleRand = arc4random_uniform(UInt32(100))
        if isVisible == true {
            if ifPrevVisibleRand < invisibilityChance { // 85 perc
                isVisible = false
            }
        } else {
            ifPrevNotVisibleRand = arc4random_uniform(UInt32(100))
            if ifPrevNotVisibleRand < respawnChance { // 85 perc
                isVisible = true
            }
        }
    }
    
    // TODO:
    //        - Rotation of Fishes - Animation for fishes
    //        - Save of record on phone
    //        - Add levels or Balance it through math equations
    //        - Animation of hooked fishes
    //        - Add music
    
    func spawnWave(waveNumber: Int) {
        var fishArray: [Fish!] = []
        var intRows = Int(numberOfRows)
        var fish: Fish!
        for row in 2...intRows {
            if row != Int(numberOfRows + 1) {
                if row == 2 {
                    fish = CCBReader.load("Gameplay/Fishes/littleFish3") as! Fish // BONUS
                    
                    fish.points = bonusFishPoints
                    
                    fish.position = ccp(CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row))
                    gamePhysicsNode.addChild(fish)
                    fishArray.append(fish)
                } else if row == Int(numberOfRows) {
                    fish = CCBReader.load("Gameplay/Fishes/littleFish1") as! Fish // ONE POINT
                    fish.points = 1
                    
                    
                    fish.position = ccp(CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row))
                    gamePhysicsNode.addChild(fish)
                } else {
                    isCheckedForVisibility()
                    if isVisible {
                        var randBonus = arc4random_uniform(100)
                        if randBonus < 5 {
                            fish = CCBReader.load("Gameplay/Fishes/littleFish3") as! Fish // Bonus FISH
                            fish.points = bonusFishPoints
                        } else if randBonus > 90 {
                            fish = CCBReader.load("Gameplay/Fishes/littleBadFish") as! Fish // Bad FISH
                            fish.points = penaltyFishPoints
                        } else {
                            fish = CCBReader.load("Gameplay/Fishes/littleFish2") as! Fish // NO FISH
                            fish.points = firstFishPoints
                        }
                        
                        
                        
                        fish.position = ccp(CGFloat(waveNumber) * cellSize.width, cellSize.height * CGFloat(row))
                        gamePhysicsNode.addChild(fish)
                        fishArray.append(fish)
                    }
                }
            }
        }
        waveArray.append(fishArray)
    }
    
    override func update(delta: CCTime) {
        gamePhysicsNode.position.x -= scrollSpeed
        player1.position.x += scrollSpeed
        //        player2.position.x += scrollSpeed
        
        // World scrolling
        var wave = waveArray[0]
        var fish = wave[0]
        
        let fishWorldPosition = gamePhysicsNode.convertToWorldSpace(fish.position)
        let fishScreenPosition = convertToNodeSpace(fishWorldPosition)
        if fishScreenPosition.x < -fish.contentSize.width {
            var wave = waveArray[0]
            for fish in wave {
                fish.removeFromParent()
            }
            waveArray.removeAtIndex(0)
            spawnWave(waveNumber)
            waveNumber++
        }
        
        
        
        // Difficulty
        
        if waveNumber <= 20 {
            scrollSpeed = 3
        } else if waveNumber < 30 {
            scrollSpeed = 3.25
        } else {
            scrollSpeed = 3.5
        }
        
        // Controller mechanics
        if !controllIsDisabled {
            if player1.position.y > player1.initialPositionY {
                player1.position.y = player1.initialPositionY
            } else if player1.position.y < player1.minPositionY {
                player1.position.y = player1.minPositionY
            } else {
                player1.position.y += movementSpeed
            }
        } else {
            player1.position.y += defaultSpeed * CGFloat(1.5)
        }
        
        if player1.position.y >= player1.initialPositionY {
            controllIsDisabled = false
        }
        
        // Time mechanics
        
        timeLeft -= Float(delta)
        gameOver()
        
        
        // Best score of the session
        if GameStatistics.bestPoints <= points {
            GameStatistics.bestPoints = points
        }
        
        bestScore.string = String(GameStatistics.bestPoints)
        
        
        // Recording best scores to device
        let defaults = NSUserDefaults.standardUserDefaults()
        var currentRecordScore = defaults.integerForKey("recordScore")
        recordScore.string = "\(currentRecordScore)"
        
    }
    
    func gameOver() {
        if timeLeft <= 0 {
            gameOverLabel.visible = true
            paused = true
            restartButton1.visible = false
            restartButton2.visible = true
            updateBestScore()
            //            OALSimpleAudio.sharedInstance().playEffect("Cave.mp3")
            //            OALSimpleAudio.sharedInstance().effectsVolume = 0.5
            // Recording best scores to device
            let defaults = NSUserDefaults.standardUserDefaults()
            var bestScore = defaults.integerForKey("recordScore")
            if self.points > bestScore {
                defaults.setInteger(Int(self.points), forKey: "recordScore")
                
            }
        }
    }
    
    func updateBestScore() {
        var newBestScore = NSUserDefaults.standardUserDefaults().integerForKey("bestScore")
        bestScore.string = "\(newBestScore)"
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if touch.locationInWorld().x < screenSize.width / 2 {
            movementSpeed = +defaultSpeed
            upLabel.visible = true
        } else {
            movementSpeed = -defaultSpeed
            downLabel.visible = true
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        movementSpeed = 0
        upLabel.visible = false
        downLabel.visible = false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: Character!, fishLevel: Fish!) -> ObjCBool {
        if fishLevel != nil {
            controllIsDisabled = true
            timeLeft += Float(fishLevel.points / 60)
            points += Int(fishLevel.points)
            
            fishLevel.removeFromParent()
            
            gameScore.string = String(points)
        }
        return true
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("Gameplay/Gameplay")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func shareButtonTapped() {
        var scene = CCDirector.sharedDirector().runningScene
        var n: AnyObject = scene.children[0]
        var image = screenShotWithStartNode(n as! CCNode)
        
        let sharedText = "My score is \(points) points. Can anyone beat me? :))"
        let itemsToShare = [image, sharedText]
        
        var excludedActivities = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop]
        
        var controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivities
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func screenShotWithStartNode(node: CCNode) -> UIImage {
        CCDirector.sharedDirector().nextDeltaTimeZero = true
        var viewSize = CCDirector.sharedDirector().viewSize()
        var rtx = CCRenderTexture(width: Int32(viewSize.width), height: Int32(viewSize.height))
        rtx.begin()
        node.visit()
        rtx.end()
        return rtx.getUIImage()
    }
    

    
    
    
}


