//
//  GameScene.swift
//  Sandbitch
//
//  Created by 佐藤周平 on 2019/06/17.
//  Copyright © 2019 佐藤周平. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var belt : SKSpriteNode?
    private let belt_scroll : CGFloat = 186
    private var scroll : SKAction?
    
    private var hammer : SKSpriteNode?
    private var hammer_attack : SKShapeNode?
    private var crush : SKAction?
    private var crush_effect : SKEmitterNode?
    
    private var gal_a : SKSpriteNode?
    private var gal_b : SKSpriteNode?
    private var gal_c : SKSpriteNode?
    private var collapse : SKAction?

    private var score_label : SKLabelNode?
    
    private var gals : [SKSpriteNode] = []
    private var prev_gal_time : TimeInterval = 0
    private var hammer_attacking : Bool = false
    
    private var score = 0
    
    private var debug = false
    
    override func didMove(to view: SKView) {
        
        // 基本スクロールアニメ
        self.scroll = SKAction.moveBy(x: -self.belt_scroll, y: 0, duration: 0.5)
        // ベルトコンベア
        self.belt = self.childNode(withName: "//belt") as? SKSpriteNode
        if let n = self.belt {
            // 無限スクロールのため動いた後でx座標をリセットする
            let scroll = SKAction.sequence([self.scroll!,
                                            SKAction.customAction(withDuration: 0) {
                                                node, t in
                                                node.position.x = self.belt_scroll
                                            }])
            n.run(SKAction.repeatForever(scroll))
        }
        
        // ハンマー
        self.hammer = self.childNode(withName: "//hammer") as? SKSpriteNode
        self.hammer_attack = self.hammer?.childNode(withName: "attack") as? SKShapeNode
        self.hammer_attack!.alpha = 0
        //self.crush = SKAction(named: "Crush")
        // パンチするアニメーション、振り下したときに攻撃フラグを立てる
        self.crush = SKAction.sequence([SKAction.moveBy(x: 0, y: 100, duration: 1.0),
                                        SKAction.group([SKAction.moveBy(x: 0, y: -250, duration: 0.1),
                                                        SKAction.playSoundFileNamed("punch", waitForCompletion: false),
                                                        SKAction.customAction(withDuration: 0) {
                                                            n, t in
                                                            self.hammer_attacking = true
                                                        }]),
                                        SKAction.customAction(withDuration: 1) {
                                            n, t in
                                            self.hammer_attacking = false
                                        },
                                        SKAction.moveBy(x: 0, y: 150, duration: 2.0)])
        self.crush_effect = SKEmitterNode(fileNamed: "Crush")
        //　ギャル
        self.gal_a = self.childNode(withName: "//gal_a") as? SKSpriteNode
        self.gal_a?.childNode(withName: "damage")?.alpha = 0
        self.gal_a?.removeFromParent()
        self.gal_b = self.childNode(withName: "//gal_b") as? SKSpriteNode
        self.gal_b?.removeFromParent()
        self.gal_b?.childNode(withName: "damage")?.alpha = 0
        self.gal_c = self.childNode(withName: "//gal_c") as? SKSpriteNode
        self.gal_c?.removeFromParent()
        self.gal_c?.childNode(withName: "damage")?.alpha = 0

        self.collapse = SKAction(named: "Collapse")
        
        // スコア
        self.score_label = self.childNode(withName: "//score") as? SKLabelNode
        self.score_label!.text = "Score: \(self.score)"
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        // タッチでハンマーを動かす
        if let hammer = self.hammer {
            if !hammer.hasActions() {
                hammer.run(self.crush!)
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 戻るボタンが押されたらタイトルへ
        for t in touches {
            let loc = t.location(in: self)
            let node = self.atPoint(loc)
            if node.name == "return" {
                if let view = self.view {
                    if let scene = SKScene(fileNamed: "TitleScene") {
                        scene.scaleMode = .aspectFill
                        view.presentScene(scene)
                        return
                    }
                }
            }
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // 一定時間ごとにギャル生成
        if (currentTime - prev_gal_time) > TimeInterval.random(in: 3.0...5.0) {
            let type = Int.random(in: 0...2)
            let gal_base : SKSpriteNode?
            switch type {
            case 0: gal_base = self.gal_a
            case 1: gal_base = self.gal_b
            case 2: gal_base = self.gal_c
            default: gal_base = nil
            }
            let gal = gal_base!.copy() as! SKSpriteNode
            gal.alpha = 1
            gal.position.x = 500
            gal.physicsBody?.contactTestBitMask = 0xffffffff
            gal.run(SKAction.repeatForever(self.scroll!))
            
            gals.append(gal)
            self.addChild(gal)
            
            prev_gal_time = currentTime
        }
        
        // 画面から出て行ったギャルは消す
        for (i, gal) in gals.enumerated() {
            if gal.position.x < -500 {
                gal.removeFromParent()
                gals.remove(at: i)  // ここは怪しい。ループ中に要素消して大丈夫か？
            }
        }
        
        // 当たり判定
        if self.hammer_attacking {
            for gal in gals {
                // 点数が０なら既に処理済みなので何もしない
                var score = gal.userData?["score"] as! Int
                if (score != 0) && self.hammer_attack!.intersects(gal.childNode(withName: "damage")!) {
                    // 当たったら、スクロールを止めて潰れるアニメの後にスクロール再開する
                    gal.removeAllActions()
                    let eff = self.crush_effect!.copy() as! SKEmitterNode
                    eff.zPosition = 20
                    gal.addChild(eff)
                    gal.run(SKAction.group([self.collapse!,
                                            SKAction.playSoundFileNamed("gutya", waitForCompletion: false),
                                            SKAction.sequence([SKAction.wait(forDuration: 0.1),
                                                               SKAction.customAction(withDuration: 0.1) {
                                                                n, t in
                                                                eff.particleBirthRate = 0
                                                                eff.particleSpeed = 100
                                                }])])) {
                        gal.run(SKAction.repeatForever(self.scroll!))
                    }
                    //　拳の中心と近いほど点数が高い
                    if score > 0 {
                        let scale = 1 - abs((self.hammer!.position.x - gal.position.x)) / self.hammer!.size.width
                        score = Int(CGFloat(score) * scale)
                    }
                    self.score += score
                    self.score_label!.text = "Score: \(self.score)"
                    gal.userData?["score"] = 0  // 一度潰したらもう点は入らない
                    // スコアを表示
                    let flow_score = score_label!.copy() as! SKLabelNode
                    flow_score.text = "\(score)"
                    flow_score.position = gal.position
                    flow_score.zPosition = 15
                    flow_score.run(SKAction(named: "Flow")!) {
                        flow_score.removeFromParent()
                    }
                    self.addChild(flow_score)
                }
            }
        }
        
        if self.debug {
            if let hammer = self.hammer {
                if self.hammer_attacking {
                    hammer.childNode(withName: "attack")?.alpha = 1
                } else {
                    hammer.childNode(withName: "attack")?.alpha = 0
                }
            }
        }
        
    }
}
