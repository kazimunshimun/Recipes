//
//  RecipeManager.swift
//  Recipes
//
//

import SwiftUI

class RecipeManager: ObservableObject {
    @Published var data = RecipeData.recipes
    @Published var selectedRecipe: RecipeItem? = nil
    //@Published var selectedRecipe: RecipeItem? = Data.recipes[0]
    @Published var swipeHeight:CGFloat = 0.0
    
    var currentRecipeIndex = 0
    
    func changeSwipeValue(value: CGFloat) {
        swipeHeight = value/3
    }
    
    func swipeEnded(value: CGFloat) {
        if value/3 > 20 || value/3 < -20 {
            var isChanged = false
            if swipeHeight > 0 {
                if currentRecipeIndex > 0 {
                    currentRecipeIndex -= 1
                    swipeHeight = 360.0
                    isChanged = true
                }
            } else if swipeHeight < 0 {
                if currentRecipeIndex < data.count - 1 {
                    currentRecipeIndex += 1
                    swipeHeight = -360.0
                    isChanged = true
                }
            }
            if isChanged  {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.swipeHeight = 0.0
                }
            } else {
                swipeHeight = 0.0
            }
        } else {
            swipeHeight = 0.0
        }
    }
}
