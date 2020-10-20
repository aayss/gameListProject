//
//  FavoriteController.swift
//  videoGameAppProject
//
//  Created by Ays  on 18.10.2020.
//  Copyright © 2020 AyseCengiz. All rights reserved.
//

import UIKit

class FavoriteController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var presenter:Presenter!
    var db:Model = Model()
    var games:[Games] = []
    var likeGames : [Games] = []
    var screenWidth:CGFloat = 0
    var indexNo: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        presenter = Presenter(view: self)
        presenter.setData()
        
        games = db.read()
        
         for i in 0 ..< self.games.count
         {
            if games[i].like.elementsEqual("true")
            {
                likeGames.append(games[i])
            }
        }
        
        
        
    }
    
    @IBAction func homeAction(_ sender: Any) {
        performSegue(withIdentifier: "favoriteToMainSegue", sender: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCELL", for: indexPath) as! FavoriteCell
        
      
            cell.name.text = String(likeGames[indexPath.row].name)
            cell.rating.text = "\(likeGames[indexPath.row].rating) - \(likeGames[indexPath.row].released)"
            cell.image.sd_setImage(with: URL(string: likeGames[indexPath.row].background_image))
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
       
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexNo = indexPath.row
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailController
        {
            let vc = segue.destination as? DetailController
            
            vc?.gameID = likeGames[indexNo].id
            vc?.gameLike = likeGames[indexNo].like
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.screenWidth - 20
        let height = CGFloat(90)
        
        return CGSize(width: width, height: height)
    }
}
extension FavoriteController: viewProtocol {
    func submit() -> [String] {
        
        return []
    }
}
