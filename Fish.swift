//
//  Fish.swift
//  Blocks101
//
//  Created by Yeldos Balgabekov on 7/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


class Fish: CCSprite {
    
    var points: CGFloat! //{
//        didSet {
//            pointsString.string = String(NSInteger(points))
//        }
//    }
//    
//    weak var pointsString: CCLabelTTF!
    
    func didLoadFromCCB() {
        self.physicsBody.sensor = true
        
    }
    
}