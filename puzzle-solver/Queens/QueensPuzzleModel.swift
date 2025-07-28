import UIKit

class QueensPuzzleModel {
    var board: [[Int]]
//    var imageProcessor = ImageProcessor()
    
    init (image: UIImage) {
        self.board = []
//        self.board = imageProcessor.toMatrix(image: image)
    }
    
    init (board: [[Int]]) {
        self.board = board
    }
}
