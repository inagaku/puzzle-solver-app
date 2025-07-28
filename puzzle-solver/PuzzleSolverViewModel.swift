//
//  PuzzleSolverViewModel.swift
//  puzzle-solver
//
//  Created by Nikita Agafonov on 02.06.25.
//

import Foundation
import UIKit

class PuzzleSolverViewModel: ObservableObject {
    let solver = QueensSolver()

    func solvePuzzle(from image: UIImage, completion: @escaping (UIImage) -> Void) async {
        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                let solved = try await self.solver.solve(image: image)
                DispatchQueue.main.async {
                    completion(solved)
                }
            }
        }
    }
}
