//
//  ViewController.swift
//  TriangleDemo
//
//  Created by wizard.os25 on 13/4/26.
//

import UIKit
import Metal
import MetalKit

class ViewController: UIViewController {

    @IBOutlet weak var mtkView: MTKView!
    private var renderer: Renderer!
    
    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.renderer = Renderer(mtkView: self.mtkView)
        self.mtkView.delegate = self.renderer
        
        self.mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
