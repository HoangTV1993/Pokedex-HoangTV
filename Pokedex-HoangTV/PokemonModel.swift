//
//  PokemonModel.swift
//  Pokedex-HoangTV
//
//  Created by HoangTV on 9/2/16.
//  Copyright © 2016 HoangTV. All rights reserved.
//

import UIKit
import Alamofire

class PokemonModel: NSObject {
    
    private var _name:String!
    private var _pokedexId:Int!
    private var _description:String!
    private var _type:String!
    private var _defense:Int!
    private var _height:String!
    private var _weight:String!
    private var _attack:Int!
    private var _nextEvolutionTxt:String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl:String!
    private var _pokemonUrl:String!
    
    var name:String{
        get {
            if self._name == nil {
                self._name = ""
            }
            return self._name
        }
        
    }
    
    var pokedexId :Int{
        get {
            if self._pokedexId == nil {
                self._pokedexId = 1
            }
            return _pokedexId
        }

    }

    var desc :String{
        get {
            if self._description == nil {
                self._description = ""
            }
            return _description
        }
    }
    
    var type:String{
        get {
            if self._type == nil {
                self._type = ""
            }
            return _type
        }
    }
    
    var defense:Int{
        get {
            if self._defense == nil {
                self._defense = 0
            }
            return _defense
        }
    }
    
    var height:String{
        get{
            if self._height == nil {
                self._height = ""
            }
            return _height
        }
    }
    
    var weight:String{
        get{
            if self._weight == nil {
                self._weight = ""
            }
            return _weight
        }
    }
    
    var attack:Int{
        get {
            if self._attack == nil {
                self._attack = 0
            }
            return _attack
        }
    }
    
    var nextEvolutionTxt:String {
        get {
            if self._nextEvolutionTxt == nil {
                self._nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
        
    }
    
    var nextEvolutionId:String {
        get {
            if self._nextEvolutionId == nil {
                self._nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionLvl:String {
        get {
            if self._nextEvolutionLvl == nil {
                self._nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        } 
    }
    
    init(name:String, pokedexID:Int) {
        self._name = name
        self._pokedexId = pokedexID
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)"

    }
    
    func dowloadPokemondetail(compeleted: DownloadComplete)  {
        
        let url = NSURL(string: self._pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            print("HoangTV: Alamofire_GET: \(response)")
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                
                if let weigh = dict["weight"] as? String{
                    self._weight = weigh
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name
                    }
                    
                    if types.count > 1 {
                        for index in 1 ..< types.count{
                            if let name = types[index]["name"] {
                                self._type! +=  "/\(name)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { response in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            compeleted()
                        })
                    }
                    
                } else {
                    self._description = ""
                }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0  {
                    if let to = evolutions[0]["to"] as? String {
                        
                        // Can't support mega pokemon right now but 
                        // api still has mega data
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let level = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(level)"
                                }
                            }
                        }
                    }
                }
                
                print("\(self._type)")
                print("\(self._height)")
                print("\(self._weight)")
                print("\(self._attack)")
                print("\(self._defense)")
                
            }
        }
    }
    
    init(name:String, pokedexId:Int, desc:String, type:String, defense:Int, height:String, attack:Int, nextEvolution:String ){
        self._name = name
        self._pokedexId = pokedexId
        self._description = desc
        self._type = type
        self._defense = defense
        self._height = height
        self._attack = attack
        self._nextEvolutionTxt = nextEvolution
    }
    
    func parserResponse(response : NSDictionary){
        self._name = response.objectForKey("name") as? String
        self._pokedexId = response.objectForKey("catId") as? Int
        self._description = response.objectForKey("descriptions") as? String
        self._type = response.objectForKey("alias") as? String
        self._defense = response.objectForKey("defense") as? Int
        self._height = response.objectForKey("thumb") as? String
        self._weight = response.objectForKey("weight") as? String
        self._attack = response.objectForKey("attack") as? Int
        self._nextEvolutionTxt = response.objectForKey("") as? String
    }
    
}
