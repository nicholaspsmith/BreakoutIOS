//
//  GameOverScene.swift
//  demo
//
//  Created by Nick on 10/24/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    var didWin: Bool = false {
        didSet {
            let label = childNodeWithName("Result") as! SKLabelNode
            label.text = didWin ? "You win" : "You lose"
        }
    }

}
