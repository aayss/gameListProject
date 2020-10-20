//
//  Games.swift
//  videoGameAppProject
//
//  Created by Ays  on 18.10.2020.
//  Copyright © 2020 AyseCengiz. All rights reserved.
//

import UIKit

class Games
{
    var id: Int = 0
    var name: String = ""
    var released: String = ""
    var background_image: String = ""
    var rating: Double
    var like: String
    var metacritic : Int
    var gameDescription : String
    var searched : Bool
    
    init(id:Int, name:String, released:String, background_image:String, rating:Double, like:String, metacritic:Int, gameDescription:String, searched: Bool)
    {
        self.id = id
        self.name = name
        self.released = released
        self.background_image = background_image
        self.rating = rating
        self.like = like
        self.metacritic = metacritic
        self.gameDescription = gameDescription
        self.searched = searched
    }
}



