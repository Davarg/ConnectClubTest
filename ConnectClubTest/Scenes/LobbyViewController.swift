//
//  LobbyViewController.swift
//  ConnectClubTest
//
//  Created by Aleksandr Makushkin on 29.07.2020.
//  Copyright © 2020 Aleksandr Makushkin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class LobbyViewController: UIViewController {
    weak var scene: SKScene?
    weak var selfView: SKView?
    weak var userNode: SKShapeNode?
    
    weak var userNode1: SKShapeNode?
    weak var userNode2: SKShapeNode?
    weak var userNode3: SKShapeNode?
    weak var userNode4: SKShapeNode?
    weak var userNode5: SKShapeNode?
    weak var userNode6: SKShapeNode?
    
    private let radius = CGFloat(30)
    private let mass = CGFloat(10)
    private var videoOutput = AVCaptureVideoDataOutput()
    private let captureSession = AVCaptureSession()
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            self.selfView = view
            
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(handleTap(_:)))
            view.addGestureRecognizer(tap)
            
            let scene = SKScene(size: view.frame.size)
            self.scene = scene
            scene.scaleMode = .aspectFill
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            view.presentScene(scene)
            
            let circle = SKShapeNode(circleOfRadius: self.radius)
            circle.strokeColor = .green
            circle.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
            circle.glowWidth = 1.0
            circle.fillColor = .white
            circle.physicsBody = self.getPhysicsBody()
            scene.addChild(circle)
            
            self.userNode = circle
            
            let circle1 = SKShapeNode(circleOfRadius: radius)
            circle1.strokeColor = .blue
            circle1.position = CGPoint(x: scene.frame.midX - (self.radius * 2), y: scene.frame.midY)
            circle1.glowWidth = 1.0
            circle1.fillColor = .white
            circle1.physicsBody = self.getPhysicsBody()
            scene.addChild(circle1)
            
            let circle2 = SKShapeNode(circleOfRadius: radius)
            circle2.strokeColor = .blue
            circle2.position = CGPoint(x: scene.frame.midX - (self.radius * 4), y: scene.frame.midY)
            circle2.glowWidth = 1.0
            circle2.fillColor = .white
            circle2.physicsBody = self.getPhysicsBody()
            scene.addChild(circle2)
            
            let circle3 = SKShapeNode(circleOfRadius: radius)
            circle3.strokeColor = .blue
            circle3.position = CGPoint(x: scene.frame.midX - (self.radius * 6), y: scene.frame.midY)
            circle3.glowWidth = 1.0
            circle3.fillColor = .white
            circle3.physicsBody = self.getPhysicsBody()
            scene.addChild(circle3)
            
            let circle4 = SKShapeNode(circleOfRadius: radius)
            circle4.strokeColor = .blue
            circle4.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - (self.radius * 2))
            circle4.glowWidth = 1.0
            circle4.fillColor = .white
            circle4.physicsBody = self.getPhysicsBody()
            scene.addChild(circle4)
            
            let circle5 = SKShapeNode(circleOfRadius: radius)
            circle5.strokeColor = .blue
            circle5.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - (self.radius * 4))
            circle5.glowWidth = 1.0
            circle5.fillColor = .white
            circle5.physicsBody = self.getPhysicsBody()
            scene.addChild(circle5)
            
            let circle6 = SKShapeNode(circleOfRadius: radius)
            circle6.strokeColor = .blue
            circle6.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - (self.radius * 6))
            circle6.glowWidth = 1.0
            circle6.fillColor = .white
            circle6.physicsBody = self.getPhysicsBody()
            scene.addChild(circle6)
            
            self.userNode1 = circle1
            self.userNode2 = circle2
            self.userNode3 = circle3
            self.userNode4 = circle4
            self.userNode5 = circle5
            self.userNode6 = circle6
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.connectCamera()
        
        self.appendCircle(atPosition: CGPoint(x: self.radius * 5, y: self.radius * 7))
    }
    
    //MARK: - Handlers
    @objc private func handleTap(_ tap: UIGestureRecognizer) {
        let location = tap.location(in: self.selfView)
        
        if let converted = self.selfView?.scene?.convertPoint(fromView: location) {
            let action = SKAction.move(to: converted, duration: 2)
            
            self.userNode?.run(action)
        }
    }
    
    //MARK: -
    private func appendCircle(atPosition pos: CGPoint) {
        let circle = SKShapeNode(circleOfRadius: self.radius)
        circle.strokeColor = .magenta
        circle.position = pos
        circle.glowWidth = 1.0
        circle.fillColor = .yellow
        circle.physicsBody = self.getPhysicsBody()
        circle.physicsBody?.mass *= 100
        
        self.scene?.addChild(circle)
    }
    
    private func getPhysicsBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(circleOfRadius: self.radius)
        body.isDynamic = true
        body.mass = self.mass
        body.affectedByGravity = false
        
        return body
    }
    
    private func connectCamera() {
        self.captureSession.sessionPreset = AVCaptureSession.Preset.medium
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .front)
        
        guard let videoCaptureDevice = discoverySession.devices.first else {
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if self.captureSession.canAddInput(videoInput) == true {
            self.captureSession.addInput(videoInput)
        } else {
            return
        }
        
        self.videoOutput.setSampleBufferDelegate(self,
                                                 queue: DispatchQueue.global())
        
        self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        if self.captureSession.canAddOutput(self.videoOutput) == true {
            self.captureSession.addOutput(self.videoOutput)
        }
        
        self.captureSession.startRunning()
    }
    
    private func image(fromSampleBuffer sb: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sb) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        guard let context = CGContext(data: baseAddress,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
                                        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
                                        
                                        return nil
        }
        
        guard let cgImage = context.makeImage() else {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            
            return nil
        }
        
        let img = UIImage(cgImage: cgImage)
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        
        return img
    }
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension LobbyViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = true
        
        if let img = self.image(fromSampleBuffer: sampleBuffer) {
            let texture = SKTexture(image: img)

            DispatchQueue.main.sync {
                self.userNode?.fillTexture = texture
                
                self.userNode1?.fillTexture = texture
                self.userNode2?.fillTexture = texture
                self.userNode3?.fillTexture = texture
                self.userNode4?.fillTexture = texture
                self.userNode5?.fillTexture = texture
                self.userNode6?.fillTexture = texture
            }
        }
    }
}
