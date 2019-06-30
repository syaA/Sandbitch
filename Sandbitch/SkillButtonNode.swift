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
    var frameGauge : ProgressPassShapeNode!
    var frameGaugeBase : SKShapeNode!
    var frameMask : SKShapeNode!
    var frameCrop : SKCropNode!
    
    init?(name: String, texture: SKTexture?, size: CGSize) {
        super.init()
        super.name = name
        self.buttonSprite = SKSpriteNode(texture: texture, size: size)
        self.buttonSprite.name = name
        let radius = (size.width + size.height) / 4
        self.frameShape = SKShapeNode(circleOfRadius: radius)
        self.frameShape.name = name
        self.frameShape.fillColor = UIColor.white
        //self.frameGauge = SKShapeNode(circleOfRadius: (size.width + size.height) / 4)
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, radius: radius, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi * 3 / 2, clockwise: true)
        self.frameGauge = ProgressPassShapeNode(path: path)
        self.frameGauge.progress = 0.4
        self.frameGauge.name = name
        self.frameGauge.strokeColor = UIColor.white
        self.frameGauge.lineWidth = 3
        self.frameGauge.glowWidth = 3
        self.frameGaugeBase = SKShapeNode(circleOfRadius: radius)
        self.frameGaugeBase.name = name
        self.frameGaugeBase.strokeColor = UIColor.black
        self.frameGaugeBase.lineWidth = 3
        self.frameGaugeBase.glowWidth = 3
        self.frameMask = SKShapeNode(circleOfRadius: radius - 3)
        self.frameMask.fillColor = UIColor.white
        self.frameCrop = SKCropNode()
        self.frameCrop.name = name
        self.frameCrop.maskNode = self.frameMask
        self.frameCrop.addChild(self.buttonSprite)
        self.addChild(self.frameShape)
        self.frameShape.addChild(self.frameCrop)
        self.frameShape.addChild(self.frameGaugeBase)
        self.frameGaugeBase.addChild(frameGauge)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
