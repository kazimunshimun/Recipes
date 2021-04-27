//
//  RecipeView.swift
//  Recipes
//
//  
//

import SwiftUI

struct RecipeView: View {
    @StateObject var manager = RecipeManager()
    @Namespace private var viewSpace
    var body: some View {
        ZStack {
            // color change ..
            if manager.currentRecipeIndex % 2 == 0 {
                Color.lightBackground
                    .ignoresSafeArea()
                    .transition(.move(edge: .bottom))
            } else {
                Color.darkBackground
                    .ignoresSafeArea()
                    .transition(.move(edge: .bottom))
            }
            
            RecipeOverview(manager: manager, viewSpace: viewSpace)
                .padding(.horizontal)
            
            // recipe detail
            if manager.selectedRecipe != nil {
                RecipeDetailView(manager: manager, viewSpace: viewSpace)
            }
        }
    }
}

extension CGPoint {
    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        
        let x = center.x + radius * cos(angle)
        let y = center.x + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
}

// let's add some color for background
extension Color {
    static let lightBackground = Color.init(red: 243/255, green: 243/255, blue: 243/255)
    static let darkBackground = Color.init(red: 34/255, green: 51/255, blue: 68/255)
}

extension UIScreen {
    static let screenWidth  = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize   = UIScreen.main.bounds.size
}


struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}
