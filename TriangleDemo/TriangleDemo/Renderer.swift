//
//  Renderer.swift
//  TriangleDemo
//
//  Created by wizard.os25 on 13/4/26.
//

import Metal
import MetalKit

class Renderer: NSObject {
    
    var device: MTLDevice!
    var vertexBuffer: MTLBuffer!
    var commandQueue: MTLCommandQueue!
    
    var library: MTLLibrary!
    var descriptor: MTLRenderPipelineDescriptor!
    
    var pipelineState: MTLRenderPipelineState!

    
    init(mtkView: MTKView) {
        super.init()
        
        self.device = MTLCreateSystemDefaultDevice()
        self.descriptor = MTLRenderPipelineDescriptor()
        
        self.commandQueue = self.device.makeCommandQueue()
        self.library = self.device.makeDefaultLibrary()
        
        mtkView.device = self.device
        
        self.setupLibrary(mtkView: mtkView)
        self.setupVertex(viewSize: mtkView.bounds.size)
        
    }
    
    func setupLibrary(mtkView: MTKView) {
        let VertexFunction = library.makeFunction(name: "vertex_main")
        let FragmentFunction = library.makeFunction(name: "fragment_main")
        
        self.descriptor.vertexFunction = VertexFunction
        self.descriptor.fragmentFunction = FragmentFunction
        self.descriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        
        self.pipelineState = try! self.device.makeRenderPipelineState(descriptor: self.descriptor)
    }
    
    func setupVertex(viewSize: CGSize) {
        let triangle = Triangle(vertex: [
            Vertex(position: SIMD2(200, 688)),  // Top
            Vertex(position: SIMD2(100, 300)),  // Left
            Vertex(position: SIMD2(368, 456))   // Right
        ])
        
        let data = Vertex.buildVertexBuffer(triangle: triangle, viewSize: viewSize)
        
        self.vertexBuffer = self.device.makeBuffer(bytes: data,
                                                   length: data.count * MemoryLayout<Float>.size,
                                              options: [])
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.setupVertex(viewSize: view.bounds.size)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor
        else { return }
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()
        let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        encoder?.setRenderPipelineState(self.pipelineState)
        encoder?.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        encoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
}
