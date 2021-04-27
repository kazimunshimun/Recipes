//
//  Recipe.swift
//  Recipes
//
//  Created by LizG on 2021-04-27.
//

import Foundation

class Recipe: Identifiable, Decodable {
    var id:UUID?
    var title: String
    var featured: Bool
    var image: String
    var description: String
    var prepTime: String
    var cookTime: String
    var totalTime: String
    var servings: Int
    var highlights: [String]
    var summary: [String:String]
    var category: String
    var ingredients: [Ingredient]
    var directions: [String]
}

class Ingredient: Identifiable, Decodable {

    var id:UUID?
    var name:String
    var num:Int?
    var denom:Int?
    var unit:String?
}

