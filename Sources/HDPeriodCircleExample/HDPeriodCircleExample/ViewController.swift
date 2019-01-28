//
//  ViewController.swift
//  HDPeriodCircleExample
//
//  Created by GRU on 1/28/19.
//  Copyright © 2019 GRU. All rights reserved.
//

import UIKit
import HDPeriodCircleView

class ViewController: UIViewController {
    
    @IBOutlet var periodCircleView: HDPeriodCircleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Background gradient
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.drawsAsynchronously = true
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.colors = [
            UIColor(red: 255.0/255.0, green: 105.0/255.0, blue: 150.0/255.0, alpha: 1.0).cgColor,
            UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 136.0/255.0, alpha: 1.0).cgColor
        ]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Configure period view
        
        
        /// Redraw
        self.periodCircleView.reDrawCycleView()
    }
}

