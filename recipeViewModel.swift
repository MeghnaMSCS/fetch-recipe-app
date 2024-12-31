//
//  recipeViewModel.swift
//  fetch-recipe-app
//
//  Created by Meghna Manjunatha on 12/31/24.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? = nil
    @Published var noDataMessage: String? = nil // Add a property for "no data" message
    
    func fetchRecipes() {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching recipes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch recipes. Please try again."
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from the server."
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                
                DispatchQueue.main.async {
                    if decodedResponse.recipes.isEmpty {
                        self.noDataMessage = "There are no recipes available."
                        self.recipes = []
                    } else {
                        self.recipes = decodedResponse.recipes
                        self.noDataMessage = nil
                        self.errorMessage = nil
                    }
                }
            } catch {
                print("Error decoding recipes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding data. Please try again."
                }
            }
        }.resume()
    }
}
