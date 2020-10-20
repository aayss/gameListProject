//
//  DetailController.swift
//  videoGameAppProject
//
//  Created by Ays  on 18.10.2020.
//  Copyright © 2020 AyseCengiz. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Alamofire

class DetailController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var metacriticRate: UILabel!
    @IBOutlet weak var gameDecription: UITextView!
    
    var presenter:Presenter!
    var db:Model = Model()
    
    
    var games:[Games] = []
    var gameID: Int = 0
    var gonderID : Int = 0
    var gameLike: String = ""
    var liked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = Presenter(view: self)
        presenter.setData()
        
        setupView()
         getGameDetail(ID: gonderID)
        Analytics.logEvent("showCount", parameters: [:])
    }
    
    func setupView()
    {
        
        backButton.layer.cornerRadius = 10
        backButton.clipsToBounds = true
       
        games = db.read()
        
        if games[gameID].like.elementsEqual("true")
                          {
                              likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                          }
                          else
                          {
                              likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
                          }

                   gameImage.sd_setImage(with: URL(string:
                       games[gameID].background_image))
                   gameName.text = games[gameID].name
                   releasedDate.text = games[gameID].released
                   

    }
    
     func getGameDetail(ID:Int)
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
                    
                        
                       let metacritic: Int? = ((jsonData as AnyObject).value(forKey:"metacritic") as? Int)!
                       let description: String? = ((jsonData as AnyObject).value(forKey:"description") as? String)!
                       
                        //update sqllite database
    //                   OperationQueue.main.addOperation({
    //
                         //       self.updateDetail(metacritic: metacritic!, gameDescription: description!, id: ID)
    //                    })
                        
                        self.metacriticRate.text = "\(metacritic)"
                        self.gameDecription.text = description
                        
                    }
            }
        }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        if liked
        {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }
        else
        {
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            
        }
       
        Analytics.logEvent("liked", parameters: [:])
        
        db.update(like: "\(liked)", id: gameID)
        
    }
}
extension DetailController: viewProtocol {
    func submit() -> [String] {
        return ["\(gonderID)"]
    }
}
