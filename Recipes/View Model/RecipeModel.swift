//
//  RecipeModel.swift
//  Recipes
//
//  Created by LizG on 2021-04-27.
//

import Foundation

class RecipeModel: ObservableObject {
    
    @Published var recipes = [Recipe]() // empty array of Recipes
    
    init() {
        
        // Create an instance of data service and get the data
        self.recipes = DataService.getLocalData()
    }
}

