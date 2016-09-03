//
//  APIClient.swift
//  Pokedex-HoangTV
//
//  Created by HoangTV on 9/3/16.
//  Copyright © 2016 HoangTV. All rights reserved.
//

import Foundation
import Alamofire

class APIClient: NSObject {
    
    static let sharedInstance = APIClient()
    
    let URL_BASE = "http://pokeapi.co/api"
    let URL_POKEMON = "/v2/pokemon/"
    
    func requestHTTPJson2(url : String, params : NSDictionary? = nil, completion: (response: NSDictionary) -> Void) {
        Alamofire.request(.GET, url, parameters: params as? [String : AnyObject])
            .responseJSON{ response in
                
                switch response.result {
                    
                case .Success:
                    print("Validation Successful")
                    let dictionary = response.result.value as! NSDictionary
                    completion(response: dictionary)
                    break
                    
                case .Failure(let error):
                    print(error)
                    
                }
        }
    }
    
    static func paramNewsDetail(name : NSString,catid : NSInteger,start:NSInteger, rowsPerPage : NSInteger ) -> NSDictionary {
        let param = ["name" : name,"catid" : catid,"start" : start, "rowsPerPage" : rowsPerPage]
        return param
    }

    
}