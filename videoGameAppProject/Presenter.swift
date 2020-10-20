//
//  Presenter.swift
//  videoGameAppProject
//
//  Created by Ays  on 18.10.2020.
//  Copyright © 2020 AyseCengiz. All rights reserved.
//

import UIKit


protocol viewProtocol: class {
    
    func submit() -> [String]
    
}

protocol presenterProtocol {
    
    init(view:viewProtocol)
    func getData() -> [String]
    
}

class Presenter: NSObject, presenterProtocol {
    
     var view:viewProtocol!
        private var model:Model!
        
        
        required init(view:viewProtocol) {
            self.view = view
        }
        
        func getData() -> [String] {
            
            return []
            
        }
        
        func setData() {
           
            let datas = view.submit()
            
            model = Model()
            
            if datas.count != 0
            {
                model.getGameDetail(ID: datas[0])
            }
            else
            {
                model.getGames()
            }
        }
        
    }
