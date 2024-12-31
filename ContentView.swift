//
//  ContentView.swift
//  fetch-recipe-app
//
//  Created by Meghna Manjunatha on 12/31/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    // Display error message
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Retry") {
                        viewModel.fetchRecipes()
                    }
                    .padding()
                } else if let noDataMessage = viewModel.noDataMessage {
                    // Display "no data" message
                    Text(noDataMessage)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // Display the list of recipes
                    List(viewModel.recipes) { recipe in
                        HStack {
                            if let photoURL = recipe.photoURLSmall, let url = URL(string: photoURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.headline)
                                Text(recipe.cuisine)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }
}
