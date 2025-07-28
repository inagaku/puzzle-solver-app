//
//  puzzle_solverTests.swift
//  puzzle-solverTests
//
//  Created by Nikita Agafonov on 01.06.25.
//

import Testing
import UIKit
import XCTest
@testable import puzzle_solver

struct puzzle_solverTests {

    @Test func solveQueensTest() async throws {
        let board = [[177, 177, 177, 177, 177, 177, 177, 211],
                     [177, 185, 185, 203, 203, 203, 177, 211],
                     [177, 185, 223, 223, 223, 203, 177, 211],
                     [177, 185, 159, 227, 223, 203, 177, 211],
                     [178, 185, 159, 227, 227, 203, 177, 211],
                     [178, 185, 159, 159, 159, 159, 177, 211],
                     [178, 185, 185, 185, 177, 177, 177, 211],
                     [178, 178, 211, 211, 211, 211, 211, 211]]

        
        let model = QueensPuzzleModel(board: board)
        let solver = QueensSolver()
        solver.solve(puzzle: model)
        
        for row in model.board {
            print(row)
        }
    }
    
    @Test func imageToPuzzleConversionTest() async throws {
        
        let image = UIImage(named: "queens_screenshot.jpg")!
        let imageProcessor = ImageProcessor()
        await imageProcessor.toQueensPuzzle(image: image)
    }
    
    @Test func apiClentSendsImageTest() async {
        var returnedImage: UIImage? = nil
        if let image = UIImage(named: "queens_screenshot.jpg") {
            do {
                returnedImage = try await APIClient.shared.uploadImage(
                    image: image,
                    to: "https://w0bc7tptfh.execute-api.eu-north-1.amazonaws.com/default/puzzle-queens-solver"
                )
                XCTAssertNotNil(returnedImage)
                print("✅ Received decoded image successfully")
            } catch {
                print("❌ Upload or decode failed:", error)
            }
        }
        
        print(returnedImage)
    }
}
