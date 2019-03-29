//
//  NavController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class NavController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        
        var bounds = navigationBar.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        
     //   gradient.colors = [UIColor.greenBrazil.cgColor, UIColor.yellowBrazil.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        
        if let image = UIImage.imageFromLayer(gradientLayer: gradient) {
            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }
}
