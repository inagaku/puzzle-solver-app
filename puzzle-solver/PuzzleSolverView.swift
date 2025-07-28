//
//  ContentView.swift
//  puzzle-solver
//
//  Created by Nikita Agafonov on 01.06.25.
//

import SwiftUI
import UIKit

struct PuzzleSolverView: View {
    @State private var sourceImage: UIImage?
    @State private var solutionImage: UIImage?
    @State private var showingImagePicker = false
    @ObservedObject var viewModel = PuzzleSolverViewModel()

    var body: some View {
       VStack(spacing: 20) {
           if let img = sourceImage {
               Image(uiImage: img)
                   .resizable()
                   .scaledToFit()
                   .frame(height: 250)
           } else {
               Text("No image selected")
           }

           Button("Upload Screenshot") {
               showingImagePicker = true
           }
        
           if let img = solutionImage {
               Image(uiImage: img)
                   .resizable()
                   .scaledToFit()
                   .frame(height: 250)
           } else {
               Text("No solution found")
           }
           
           Spacer()
       }
       .sheet(isPresented: $showingImagePicker) {
           ImagePicker(image: $sourceImage)
       }
       .onChange(of: sourceImage) {
           if var img = sourceImage {
               Task {
                   await viewModel.solvePuzzle(from: img) { result in
                       self.solutionImage = result
                   }
               }
           }
       }
       .padding()
    }
}

#Preview {
    PuzzleSolverView()
}
