//
//  SkillButtonNode.swift
//  Sandbitch
//
//  Created by 佐藤周平 on 2019/06/29.
//  Copyright © 2019 佐藤周平. All rights reserved.
//

import SpriteKit
import GameplayKit

class SkillButtonNode : SKNode {
    
    var buttonSprite : SKSpriteNode!
    var frameShape : SKShapeNode!
    var frameGauge : ProgressPassShapeNode!
    var frameGaugeBase : SKShapeNode!
    var frameMask : SKShapeNode!
    var frameCrop : SKCropNode!
    
    var interval = 1.0  // スキル再使用時間
    private var prevTrigger = 0.0 // 前回スキル使用時間
    private var isTouched = false
    var canTriggered = true
    
    var onTriggered : (() -> Void)?
    
    init?(texture: SKTexture?, size: CGSize) {
        super.init()
        // ボタン スプライト
        self.buttonSprite = SKSpriteNode(texture: texture, size: size)
        self.buttonSprite.isUserInteractionEnabled = false
        // ボタン背景
        let radius = (size.width + size.height) / 4
        self.frameShape = SKShapeNode(circleOfRadius: radius)
        self.frameShape.isUserInteractionEnabled = false
        self.frameShape.fillColor = UIColor.white
        // 待ち時間ゲージ
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero, radius: radius, startAngle: CGFloat.pi / 2, endAngle: -CGFloat.pi * 3 / 2, clockwise: true)
        self.frameGauge = ProgressPassShapeNode(path: path)
        self.frameGauge.progress = 1.0
        self.frameGauge.isUserInteractionEnabled = false
        self.frameGauge.strokeColor = UIColor.white
        self.frameGauge.lineWidth = 3
        self.frameGauge.glowWidth = 3
        // 待ち時間ゲージ背景
        self.frameGaugeBase = SKShapeNode(circleOfRadius: radius)
        self.frameGaugeBase.isUserInteractionEnabled = false
        self.frameGaugeBase.strokeColor = UIColor.gray
        self.frameGaugeBase.lineWidth = 3
        self.frameGaugeBase.glowWidth = 3
        // ボタンスプライトがボタン背景からはみ出ないようにするマスク
        self.frameMask = SKShapeNode(circleOfRadius: radius - 3)
        self.frameMask.fillColor = UIColor.white
        self.frameCrop = SKCropNode()
        self.frameCrop.isUserInteractionEnabled = false
        self.frameCrop.maskNode = self.frameMask
        // 順番に追加
        self.frameCrop.addChild(self.buttonSprite)
        self.addChild(self.frameShape)
        self.frameShape.addChild(self.frameCrop)
        self.frameShape.addChild(self.frameGaugeBase)
        self.frameGaugeBase.addChild(frameGauge)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval) {
        // タッチされてたら＆実行可能な状態ならスキル実行
        let elapsed = currentTime - self.prevTrigger
        if self.canTriggered {
            if self.isTouched {
                self.onTriggered?()
                self.canTriggered = false
                self.frameGauge.progress = 0.0
                self.prevTrigger = currentTime
            }
        } else if elapsed > self.interval {
            self.frameGauge.progress = 1.0
            self.canTriggered = true
        } else {
            self.canTriggered = false
            self.frameGauge.progress = elapsed / self.interval
        }
        
        self.isTouched = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            self.isTouched = true
        }
    }
}
