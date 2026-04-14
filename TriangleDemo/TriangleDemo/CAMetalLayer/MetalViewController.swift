//
//  MetalViewController.swift
//  TriangleDemo
//
//  Created by wizard.os25 on 14/4/26.
//

import Metal
import UIKit

import QuartzCore

class MetalViewController: UIViewController {
    
    
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    
    let vertexData: [Float] = [
        0.0, 0.5, 0.0,
        -0.5, -0.7, 0.0,
        0.5, 0.3, 0.0
    ]
    
    var vertexBuffer: MTLBuffer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    
    var timer: CADisplayLink! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.metalLayer = CAMetalLayer()
        self.metalLayer.device = self.device
        self.metalLayer.pixelFormat = .bgra8Unorm
        self.metalLayer.framebufferOnly = true
        self.metalLayer.frame = view.layer.frame
        
        view.layer.addSublayer(self.metalLayer)
       
        let dataSize = self.vertexData.count * MemoryLayout.size(ofValue: self.vertexData[0])
        self.vertexBuffer = self.device.makeBuffer(bytes: self.vertexData,
                                                   length: dataSize,
                                                   options: [])
        
        let defaultLibrary = self.device.makeDefaultLibrary()
            let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
            let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try self.pipelineState = self.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error {
            print("Failed to create pipeline state, error \(error)")
        }
        
        self.timer = CADisplayLink(target: self, selector: #selector(self.gameLoop))
        self.timer.add(to: .main, forMode: .default)
        
    }
    
    func render() {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        
        guard let drawable = self.metalLayer.nextDrawable() else { return }
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 221.0/255.0, green: 160.0/255.0, blue: 137.0/255.0, alpha: 1.0)
        
        self.commandQueue = self.device.makeCommandQueue()
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(self.pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    @objc func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }
}
