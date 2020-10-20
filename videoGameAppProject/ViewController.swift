//
//  ViewController.swift
//  videoGameAppProject
//
//  Created by Ays  on 17.10.2020.
//  Copyright © 2020 AyseCengiz. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var pageBtn: UIButton!
    
       
    var presenter:Presenter!
    var db:Model = Model()
    var games:[Games] = []
    var gamesSearch:[Games] = []
    var screenWidth:CGFloat = 0
    var indexNo: Int = 0
    var watch : Int =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setupView()
        presenter = Presenter(view: self)
        presenter.setData()
        
        games = db.read()
        gamesSearch = games
        searchText.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)

        self.pageBtn.sd_setBackgroundImage(with: URL(string: games[0].background_image), for: .normal, completed: nil)//sd_setImage(with: URL(string: games[0].background_image), for: .normal)
    }
    
    
    func setupView() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        
        warningText.isHidden = true
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.addTarget(self, action: #selector(changePage(_:)), for: .allTouchEvents)
   
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
       
        let girilen_name : String = searchText.text!
        if(girilen_name.count >= 3)
        {
            for i in 0 ..< self.games.count
            {
                if(games[i].name.localizedLowercase.contains(girilen_name.localizedLowercase))
                {
                    watch += 1
                    gamesSearch[i].searched = true
                    self.pageControl.isHidden = true
                    self.pageBtn.isHidden = true
                }
               else
                {
                    gamesSearch[i].searched = false
                }
            }
                  games.removeAll()

            for i in 0 ..< self.gamesSearch.count
            {
                if gamesSearch[i].searched
                {
                    games.append(gamesSearch[i])
                }
            }
            
            
            if watch == 0
                   {
                    self.pageBtn.isHidden = true
                       self.pageControl.isHidden = true
                       self.collectionView.isHidden = true
                       self.warningText.isHidden = false
                   }
                   else
                   {
                    self.pageBtn.isHidden = false
                       self.pageControl.isHidden = false
                       self.collectionView.isHidden = false
                       self.warningText.isHidden = true
                   }
            
            self.collectionView.reloadData()

        }
        else
        {
            presenter.setData()
            
            games = db.read()
            
            self.pageControl.isHidden = false
            self.collectionView.isHidden = false
            self.warningText.isHidden = true
        }
        
       
          self.collectionView.reloadData()
    }
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        performSegue(withIdentifier: "mainToFavoriteSegue", sender: nil)
    }
    
    
    @IBAction func changePage(_ sender: UIPageControl) {
        
        
        switch sender.currentPage {
        case 0:
            indexNo = 0
            self.pageBtn.sd_setBackgroundImage(with: URL(string: games[0].background_image), for: .normal, completed: nil)
                case 1:
                    indexNo=1
                    self.pageBtn.sd_setBackgroundImage(with: URL(string: games[1].background_image), for: .normal, completed: nil)
             case 2:
                indexNo=2
             self.pageBtn.sd_setBackgroundImage(with: URL(string: games[2].background_image), for: .normal, completed: nil)
              default:
             self.pageBtn.sd_setBackgroundImage(with: URL(string: games[0].background_image), for: .normal, completed: nil)
                }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return games.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MainCELL", for: indexPath) as! MainCell
        
        if watch != 0
        {
            cell.name.text = String(games[indexPath.row].name)
            cell.rating.text = "\(games[indexPath.row].rating) - \(games[indexPath.row].released)"
            cell.image.sd_setImage(with: URL(string: games[indexPath.row].background_image))
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
        }
        
        if indexPath.row+3 < games.count
        {
             if games[indexPath.row+3].searched
                    {
                            cell.name.text = String(games[indexPath.row+3].name)
                            cell.rating.text = "\(games[indexPath.row+3].rating) - \(games[indexPath.row+3].released)"
                            cell.image.sd_setImage(with: URL(string: games[indexPath.row+3].background_image))
                            cell.layer.cornerRadius = 10
                            cell.clipsToBounds = true
                          
                    }
        }
        
       
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
                indexNo = indexPath.row+3
                performSegue(withIdentifier: "mainToDetailSegue", sender: nil)
    }
    
    @IBAction func pageAction(_ sender: Any) {
         performSegue(withIdentifier: "mainToDetailSegue", sender: nil)
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailController
        {
            let vc = segue.destination as? DetailController
            
            vc?.gameID = indexNo//games[indexNo].id
            vc?.gonderID = games[indexNo].id
            vc?.gameLike = games[indexNo].like
            
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.screenWidth - 20
        let height = CGFloat(90)
        
        return CGSize(width: width, height: height)
    }
}

extension ViewController: viewProtocol {
    func submit() -> [String] {
        
        return []
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
