//
//  PuzzleProcessor.swift
//  puzzle-solver
//
//  Created by Nikita Agafonov on 02.06.25.
//

import UIKit

class QueensSolver {
    var board: [[Int]]?
    var positions: [Int]?
    
    init (){}
    
    func solve(image: UIImage) async -> UIImage {
        var solvedImage: UIImage? = nil
        do {
            solvedImage = try await APIClient.shared.uploadImage(
                image: image,
                to: "https://w0bc7tptfh.execute-api.eu-north-1.amazonaws.com/default/puzzle-queens-solver"
            )
            
            print("✅ Received decoded image successfully")
        } catch {
            print("❌ Upload or decode failed:", error)
        }
        
        
        return solvedImage!
    }
    
    func solve(puzzle: QueensPuzzleModel) -> Void {
        self.board = puzzle.board
        self.positions = [Int](repeating: -1, count: puzzle.board.count)
        solve(N: puzzle.board.count, row: 0)

        
        for (i, j) in self.positions!.enumerated() {
            puzzle.board[i][j] = -1
        }
        
        func solve(N: Int, row: Int) -> Bool {
            
            if (row == N) {
                return true
            }
            
            for curr in 0..<N {
                var flag: Bool = true
                for prevIndex in 0..<row {
                    if (curr == positions![prevIndex]) {
                        flag = false
                    }
                }
                
                if row != 0 &&
                   (abs(curr - positions![row - 1]) == 1 ||
                   isColorTakenTraversal(row: row, col: curr)) {
                    flag = false
                }
                
                if (flag) {
                    positions![row] = curr
                    if solve(N: N, row: row + 1) {
                        return true
                    }
                    positions![row] = -1
                }
            }
            
            func isColorTakenTraversal(row: Int, col: Int) -> Bool {
                let targetValue = self.board![row][col]
                let rows = self.board!.count
                let cols = self.board![0].count

                var visited = Set<[Int]>()
                var queue = [(Int, Int)]()
                
                queue.append((row, col))
                visited.insert([row, col])

                let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]  // Up, Down, Left, Right

                while !queue.isEmpty {
                    let (row, col) = queue.removeFirst()
                    
                    if (self.positions![row] == col) {
                        return true
                    }

                    for (dr, dc) in directions {
                        let newRow = row + dr
                        let newCol = col + dc

                        if newRow >= 0, newRow < rows,
                           newCol >= 0, newCol < cols,
                           !visited.contains([newRow, newCol]),
                           self.board![newRow][newCol] == targetValue {

                            queue.append((newRow, newCol))
                            visited.insert([newRow, newCol])
                        }
                    }
                }

                return false
            }
            
            return false
        }
    }
    
    
}
