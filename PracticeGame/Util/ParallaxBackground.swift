//
//  ParallaxBackground.swift
//  PracticeGame
//
//  Created by Jason Bhan on 6/11/25.
//

import SpriteKit
private struct ParallaxLayer {
    let node1: SKSpriteNode
    let node2: SKSpriteNode
    let speed: CGFloat
}

class ParallaxBackground {
    private var layers: [ParallaxLayer] = []
    private unowned let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        self.addLayer(imageName: "1", speed: 1, zPosition: -5)
        self.addLayer(imageName: "2", speed: 1.2, zPosition: -4)
        self.addLayer(imageName: "3", speed: 0, zPosition: -3)
        self.addLayer(imageName: "4", speed: 0, zPosition: -2)
        self.addLayer(imageName: "5", speed: 0, zPosition: -1)
    }
    
    func addLayer(imageName: String, speed: CGFloat, zPosition: CGFloat) {
        let texture = SKTexture(imageNamed: imageName)
        
        let node1 = SKSpriteNode(texture: texture)
        let node2 = SKSpriteNode(texture: texture)
        
        let scaleX = scene.size.width / texture.size().width
        let scaleY = scene.size.height / texture.size().height
        let scale = max(scaleX, scaleY) // maintain aspect ratio, or use scaleX/scaleY directly

        [node1, node2].forEach {
            $0.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            $0.setScale(scale)
            $0.zPosition = zPosition
            scene.addChild($0)
        }
        
        let centerY = scene.size.height / 2
        let centerX = scene.size.width / 2

        node1.position = CGPoint(x: centerX, y: centerY)
        node2.position = CGPoint(x: centerX + node1.size.width - 1, y: centerY)

        layers.append(ParallaxLayer(node1: node1, node2: node2, speed: speed))
    }
    
    func update() {
        for layer in layers {
            layer.node1.position.x -= layer.speed
            layer.node2.position.x -= layer.speed

            if layer.node1.position.x <= -layer.node1.size.width {
                layer.node1.position.x = layer.node2.position.x + layer.node2.size.width - 1
            }

            if layer.node2.position.x <= -layer.node2.size.width {
                layer.node2.position.x = layer.node1.position.x + layer.node1.size.width - 1
            }
        }
    }
}
