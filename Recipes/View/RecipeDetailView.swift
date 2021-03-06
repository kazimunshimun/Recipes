//
//  RecipeDetailView.swift
//  Recipes
//
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var manager: RecipeManager
    @State var isIngredient = true
    public var viewSpace: Namespace.ID
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
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    // recipe image view
                    RecipeInteractionView(recipe: manager.selectedRecipe ?? manager.data[0], index: manager.currentRecipeIndex, count: manager.data.count, manager: manager, viewSpace: viewSpace)
                        .rotationEffect(.degrees(90))
                        .offset(y: -80)
                    Group {
                        // title
                        Text(manager.selectedRecipe?.title ?? "?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
                        // info view
                        HStack(spacing: 32) {
                            HStack(spacing: 12) {
                                Image(systemName: RecipeData.summaryImageName["cooking"] ?? "?")
                                    .foregroundColor(.green)
                                Text(manager.selectedRecipe?.summary["cooking"] ?? "?")
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: RecipeData.summaryImageName["serves"] ?? "?")
                                    .foregroundColor(.green)
                                Text(manager.selectedRecipe?.summary["serves"] ?? "?")
                            }
                        }
                        .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                    
                    // ingredient/step toggle view
                    Toggle(isOn: $isIngredient, label: {})
                        .toggleStyle(IngredientMethodToggleStyle())
                        .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
                    
                    if isIngredient {
                        // ingredient list
                        IngredientListView(manager: manager)
                        
                    } else {
                        // steps list
                        MethodListView(methods: manager.selectedRecipe?.directions ?? ["?"])
                            .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
                    }
                }
            }
            
            BackButtonView(manager: manager)
                .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
        }
    }
}

// back button to go back to Main Screen
struct BackButtonView: View {
    @ObservedObject var manager: RecipeManager
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    manager.selectedRecipe = nil
                }
            }, label: {
                HStack {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .padding(24)
                    
                    Spacer()
                }
            })
            
            Spacer()
        }
    }
}

struct IngredientMethodToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return
            VStack(alignment: .leading) {
                HStack {
                    Text("INGREDIENTS")
                        .font(.system(size: 16, weight: configuration.isOn ? .bold : .regular))
                        .frame(width: 110)
                        .fixedSize()
                        .animation(nil)
                        .padding(4)
                        .padding(.leading, 12)
                        .onTapGesture {
                            withAnimation {
                                configuration.isOn = true
                            }
                        }
                    
                    Text("METHOD")
                        .font(.system(size: 16, weight: configuration.isOn ? .regular : .bold))
                        .animation(nil)
                        .padding(4)
                        .onTapGesture {
                            withAnimation {
                                configuration.isOn = false
                            }
                        }
                }
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 3)
                    
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: configuration.isOn ? 110 : 70, height: 3)//110 : 70
                        .offset(x: configuration.isOn ? 16 : 140)//0 : 115
                }
            }
    }
}

struct IngredientListView: View {
    @ObservedObject var manager: RecipeManager
    var body: some View {
        ForEach(0..<manager.data[manager.currentRecipeIndex].ingredients.count) { i in
            Toggle(isOn: Binding<Bool>(
                get: {
                    manager.data[manager.currentRecipeIndex].ingredients[i].available ?? false
                },
                set: {
                    manager.data[manager.currentRecipeIndex].ingredients[i].available = $0
                    manager.objectWillChange.send()
                }
            ),
                   label: {
                    Text(manager.data[manager.currentRecipeIndex].ingredients[i].name)
                        .foregroundColor(manager.currentRecipeIndex%2 == 0 ? .black : .white)
            })
            .toggleStyle(CircularToggleStyle())
            .padding(.vertical, 8)
        }
    }
}

struct CircularToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .stroke(configuration.isOn ? Color.green : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if configuration.isOn {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.horizontal)
                
                configuration.label
            }.onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
            
    }
}

struct MethodListView: View {
    let methods: [String]
    var body: some View {
        ForEach(methods, id: \.self) { value in
            Text(value)
                .padding(.horizontal)
                .padding(.vertical, 4)
        }
    }
}
