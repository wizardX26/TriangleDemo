//
//  Shaders.metal
//  TriangleDemo
//
//  Created by wizard.os25 on 13/4/26.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertex_main(const device float4* vertices [[buffer(0)]],
                          uint vertexID [[vertex_id]]
                          ) {
    return vertices[vertexID];
}

fragment float4 fragment_main() {
    return float4(0.0, // RED
                  1.0, // Green
                  0.0, // BLUE
                  0.8);// ALPHA
}
