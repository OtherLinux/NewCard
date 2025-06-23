//
//  BarcodeUI.swift
//  NewCard
//
//  Created by Marek Polame on 08.06.2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

func generateBarCode(data:String) -> Image {
    let context = CIContext()
    let generator = CIFilter.code128BarcodeGenerator()
    generator.message = Data(data.utf8)
    
    if (data == "") {
        generator.message = Data("No card data".utf8)
    }
    
    if let outputImage = generator.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10)),
       
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            
            let uiImage = UIImage(cgImage: cgImage)
            
            return Image(uiImage: uiImage)
        }
        
        return Image(systemName: "")
    
}

func generateQrCode(data:String) -> Image {
    let context = CIContext()
    let generator = CIFilter.qrCodeGenerator()
    generator.message = Data(data.utf8)
    
    if (data == "") {
        generator.message = Data("No card data".utf8)
    }
    
    if let outputImage = generator.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10)),
       
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            
            let uiImage = UIImage(cgImage: cgImage)
            
            return Image(uiImage: uiImage)
        }
        
        return Image(systemName: "")
}

