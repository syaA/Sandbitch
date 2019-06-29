//
//  SkillButtonNode.swift
//  Sandbitch
//
//  Created by 佐藤周平 on 2019/06/29.
//  Copyright © 2019 佐藤周平. All rights reserved.
//

import SpriteKit
import GameplayKit

class SkillButtonNode: SKNode {
    
    var buttonSprite : SKSpriteNode!
    var frameShape : SKShapeNode!
    var frameMask : SKShapeNode!
    var frameCrop : SKCropNode!
    
    init?(name: String, texture: SKTexture?, size: CGSize) {
        super.init()
        super.name = name
        self.buttonSprite = SKSpriteNode(texture: texture, size: size)
        self.buttonSprite.name = name
        self.frameShape = SKShapeNode(circleOfRadius: (size.width + size.height) / 4)
        self.frameShape.name = name
        self.frameShape.fillColor = UIColor.white
        self.frameShape.strokeColor = UIColor.gray
        self.frameShape.glowWidth = 3
        self.frameMask = SKShapeNode(circleOfRadius: (size.width + size.height) / 4 - 3)
        self.frameMask.fillColor = UIColor.white
        self.frameCrop = SKCropNode()
        self.frameCrop.name = name
        self.frameCrop.maskNode = self.frameMask
        self.frameCrop.addChild(self.buttonSprite)
        self.addChild(self.frameShape)
        self.frameShape.addChild(self.frameCrop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
