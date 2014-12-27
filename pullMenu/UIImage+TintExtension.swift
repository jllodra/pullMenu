//
//  UIImage+TintExtension.swift
//  pullMenu
//
//  Created by Ruben on 12/27/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import Foundation

extension UIImage {
    
    func rasterizedWithColor(color: UIColor) -> UIImage? {
        var rasterizedImage: UIImage?
        
        if self.renderingMode != UIImageRenderingMode.AlwaysTemplate
        {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let imageBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        color.setFill()
        
        drawInRect(imageBounds)
        
        rasterizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return rasterizedImage
    }
}
