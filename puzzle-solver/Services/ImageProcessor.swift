//
//  PuzzleProcessor.swift
//  puzzle-solver
//
//  Created by Nikita Agafonov on 02.06.25.
//

import Vision
import SwiftUI
import UIKit

class ImageProcessor {
    func toQueensPuzzle(image: UIImage) async -> QueensPuzzleModel {
        var cells : Array<RectangleObservation> = []
        var rectanglesRequest = DetectRectanglesRequest()
        rectanglesRequest.quadratureToleranceDegrees = 10
        rectanglesRequest.maximumObservations = 1
        rectanglesRequest.minimumConfidence = 0.95
        rectanglesRequest.minimumAspectRatio = 0.9
        rectanglesRequest.maximumAspectRatio = 1.0 // Prefer squares
        rectanglesRequest.minimumSize = 0.3
        
        do {
            cells = try await rectanglesRequest.perform(on: image.cgImage!, orientation: .up)
        } catch {
            print("An error occurred: \(error)")
        }
        
        let imageSize = CGSize(width: image.size.width, height: image.size.height)

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let renderedImage = renderer.image { ctx in
            // Draw the original image first
            image.draw(in: CGRect(origin: .zero, size: imageSize))
            
            // Set stroke color and line width
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.setLineWidth(2.0)
            
            for cell in cells {
                // VNRectangleObservation uses normalized coordinates (0–1),
                // we must convert to image coordinates
                let boundingBox = cell.boundingBox
                let convertedRect = CGRect(
                    x: boundingBox.origin.x * imageSize.width,
                    y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
                    width: boundingBox.width * imageSize.width,
                    height: boundingBox.height * imageSize.height
                )
                
                ctx.cgContext.stroke(convertedRect)
            }
        }
        
        
        Image(uiImage: renderedImage)
            .resizable()
            .scaledToFit()
        
        cells.forEach { cell in
            print(cell)
        }
        
        return QueensPuzzleModel(board: [[Int]]())
    }
    
    func fromQueensPuzzle(puzzle: QueensPuzzleModel) -> UIImage {
        // Placeholder: Replace with OCR/ML logic
        return UIImage()
    }
    
}
