//
//  ViewController.swift
//  Pokedex-HoangTV
//
//  Created by HoangTV on 9/2/16.
//  Copyright © 2016 HoangTV. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var myCollection: UICollectionView!
    
    var musicPlayer : AVAudioPlayer!
    var pokemons = [PokemonModel]()
    var filteredPokemon = [PokemonModel]()
    var inSearchMode : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.Done
        
        let nibPokemonCell = UINib(nibName: "PokedexCell", bundle: nil)
        self.myCollection.registerNib(nibPokemonCell, forCellWithReuseIdentifier: "idPokedexCell")
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        let width = (UIScreen.mainScreen().bounds.size.width - 40)/3
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.scrollDirection = .Vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.myCollection.collectionViewLayout = flowLayout
        self.parsePokemonCSV()
        self.initAudio()
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            self.musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path))
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.numberOfLoops = -1
            self.musicPlayer.play()
        }catch let err as NSError{
            print("HoangTV - ERRO: \(err)")
        }
    }
    
    func parsePokemonCSV() {
        let patch = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: patch)
            let rows = csv.rows
            print("HoangTV: \(rows)")
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = PokemonModel(name: name, pokedexID: pokeId)
                pokemons.append(poke)
            }
        }catch let err as NSError {
            print("\(err.debugDescription)")
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.inSearchMode {
            return self.filteredPokemon.count
        }
        return pokemons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idPokedexCell", forIndexPath: indexPath) as? PokedexCell {
            
            let poke:PokemonModel!
            
            if self.inSearchMode {
                poke = self.filteredPokemon[indexPath.row]
            } else {
                poke = self.pokemons[indexPath.row]
            }
            
            cell.configureCell(poke)
            return cell
        }  else {
            return UICollectionViewCell()
        }
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        if self.musicPlayer.playing {
            self.musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            self.musicPlayer.play()
            sender.alpha = 2.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke : PokemonModel!
        if inSearchMode {
            poke = self.filteredPokemon[indexPath.row]
        } else {
            poke = self.pokemons[indexPath.row]
        }
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewPokemonDetail = storyBoard.instantiateViewControllerWithIdentifier("idPokemonDetail") as! PokemonDetailVC
        viewPokemonDetail.poke = poke
        self.navigationController?.pushViewController(viewPokemonDetail, animated: true)
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text == nil || self.searchBar.text == " " {
            self.inSearchMode = false
            self.view.endEditing(true)
            self.myCollection.reloadData()
        } else {
            self.inSearchMode = true
            let lower = self.searchBar.text!.lowercaseString
            self.filteredPokemon = self.pokemons.filter({$0.name.rangeOfString(lower) != nil})
            self.myCollection.reloadData()
        }
    }

}

