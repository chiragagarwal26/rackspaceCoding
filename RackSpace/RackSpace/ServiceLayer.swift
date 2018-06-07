//
//  ServiceLayer.swift
//  RackSpace
//
//  Created by chirag agarwal on 6/7/18.
//  Copyright © 2018 chirag. All rights reserved.
//

import Foundation

class ServiceLayer{
    
    func callBackendApi(url : URL, closure : @escaping (Data)  -> Void){
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil && data != nil{
                closure(data!)
            }else{
                print(error)
            }
        }.resume()
    }
}
