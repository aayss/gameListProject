//
//  Model.swift
//  videoGameAppProject
//
//  Created by Ays  on 18.10.2020.
//  Copyright © 2020 AyseCengiz. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class Model
{
    init()
    {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    var games:[Games] = []
               
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS games(id INTEGER PRIMARY KEY,name TEXT,released TEXT,background_image TEXT,rating DOUBLE, like TEXT, metacritic INTEGER, description TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("games table created.")
            } else {
                print("games table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, released:String, background_image:String, rating:Double, like:String, metacritic:Int, description:String)
    {
        let games = read()
        for g in games
        {
            if g.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO games(id, name, released, background_image, rating, like, metacritic, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (released as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (background_image as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 5, rating)
            sqlite3_bind_text(insertStatement, 6, (like as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, Int32(metacritic))
            sqlite3_bind_text(insertStatement, 8, (description as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Games] {
        let queryStatementString = "SELECT * FROM games;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Games] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
        {
            while sqlite3_step(queryStatement) == SQLITE_ROW
            {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let released = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let background_image = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let rating = sqlite3_column_double(queryStatement, 4)
                let like = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let metacritic = sqlite3_column_int(queryStatement, 6)
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                psns.append(Games(id: Int(id), name: name, released: released, background_image: background_image, rating:rating, like:like, metacritic: Int(metacritic), gameDescription: description, searched: true))
                games.append(contentsOf: psns)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func update(like:String, id:Int) {
        let queryStatementString = "UPDATE games SET like='?' WHERE id=?;"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement is not prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    
    func updateDetail(metacritic:Int, gameDescription:String, id:Int) {
        let queryStatementString = "UPDATE games SET metacritic='?', description='?' WHERE id=?;"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement is not prepared")
        }
        sqlite3_finalize(queryStatement)
        
        
    }
    
      func getGames()
      {
          
          let baseUrl = "https://rapidapi.p.rapidapi.com/games"
          
          let headers : HTTPHeaders = [
              "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com",
              "x-rapidapi-key": "4e77b4a5e0msh933d641e14efe0ap108d1cjsnf5d0652cca63"
          ]
          
        
        AF.request(baseUrl, headers: headers).responseJSON
            { response in
                var urlData: Data?
                urlData = response.data
                
                if ( urlData != nil )
                {
                    let jsonData:NSDictionary? = try?JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                    let gelenler : NSArray =  jsonData!.value(forKey: "results") as! NSArray
                    
                    for i in 0  ..< gelenler.count
                    {
                        
                        let id: Int? = (gelenler[i] as AnyObject).value(forKey:"id") as? Int
                        let name: String? = ((gelenler[i] as AnyObject).value(forKey:"name") as? String)!
                        let released: String? = (gelenler[i] as AnyObject).value(forKey: "released") as? String ?? ""
                        let background_image: String? = ((gelenler[i] as AnyObject).value(forKey:"background_image") as? String)!
                        let rating: Double? = (gelenler[i] as AnyObject).value(forKey:"rating") as? Double
                        
                        //insert sqllite database
                        self.insert(id: id!, name: name!, released: released!, background_image: background_image!, rating:rating!, like:"false", metacritic: 0, description:"")
                        
                        
                    }
                }
        }
    }
    
  
        func getGameDetail(ID:String)
         {
           
             let baseUrl = "https://rapidapi.p.rapidapi.com/games/\(ID)"
             
             let headers : HTTPHeaders = [
                 "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com",
                 "x-rapidapi-key": "4e77b4a5e0msh933d641e14efe0ap108d1cjsnf5d0652cca63"
             ]
             
        AF.request(baseUrl, headers: headers).responseJSON
            { response in
                var urlData: Data?
                urlData = response.data
                
                if ( urlData != nil )
                {
                    let jsonData:NSDictionary? = try?JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                    
                   let metacritic: Int? = (jsonData as AnyObject).value(forKey:"metacritic") as? Int ?? 0
                   let description: String? = ((jsonData as AnyObject).value(forKey:"description") as? String)!
                   
                    //update sqllite database
//                   OperationQueue.main.addOperation({
//
                     //       self.updateDetail(metacritic: metacritic!, gameDescription: description!, id: ID)
//                    })
                    
                    let id:Int = Int(ID)!
                     self.updateDetail(metacritic: metacritic!, gameDescription: description!, id: id)
                    
                }
        }
    }
}
