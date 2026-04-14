//
//  Model.swift
//  TriangleDemo
//
//  Created by wizard.os25 on 13/4/26.
//

/*
 Coordinate in:
    - UIKit: (0,0) top-left
    - GPU: (0,0) center
 
 x_ndc = (x / width) * 2 - 1
 y_ndc = 1 - (y / height) * 2
 
 with ndc - Normalized Device Coordinates
 */

import Foundation
import simd

struct Triangle {
    var vertex: [Vertex]
}


struct Vertex {
    var position: SIMD2<Float>
    
    static func normalizeDeviceCoor(vertex: Vertex, viewSize: CGSize) -> SIMD2<Float> {
        let width = Float(viewSize.width)
        let height = Float(viewSize.height)
        
        let xNDC = (vertex.position.x / width) * 2 - 1
        let yNDC = 1 - (vertex.position.y / height) * 2
        
        return SIMD2<Float>(xNDC, yNDC)
    }
    
    static func buildVertexBuffer(triangle: Triangle, viewSize: CGSize) -> [Float] {
        var result: [Float] = []
        
        for v in triangle.vertex {
            let ndc = self.normalizeDeviceCoor(vertex: v, viewSize: viewSize)
            
            result.append(contentsOf: [
                ndc.x,
                ndc.y,
                0.0,
                1.0
            ])
        }
        
        return result
    }
}


