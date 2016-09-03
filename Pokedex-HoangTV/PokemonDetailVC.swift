//
//  PokemonDetailVC.swift
//  Pokedex-HoangTV
//
//  Created by HoangTV on 9/2/16.
//  Copyright © 2016 HoangTV. All rights reserved.
//

import UIKit
import MBProgressHUD

class PokemonDetailVC: UIViewController {
 
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var curenEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    var progressBar:MBProgressHUD!
    
    var poke:PokemonModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HoangTV : \(self.poke.name)")
        
        self.progressBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.progressBar.showAnimated(true)
        self.nameLabel.text = poke.name
        self.mainImage.image = UIImage(named: "\(poke.pokedexId)")
        self.curenEvoImage.image = UIImage(named: "\(poke.pokedexId)")
        
        self.poke.dowloadPokemondetail {
            // this will be called affter dowload is done
            print("Done")
            self.updateUI()
        }
    }
    
    func updateUI()  {
        self.descLabel.text = poke.desc
        self.typeLabel.text = poke.type
        self.defenseLabel.text = "\(poke.defense)"
        self.heightLabel.text = poke.height
        self.weightLabel.text = poke.weight
        self.attackLabel.text = "\(poke.attack)"
        self.idLabel.text = "\(poke.pokedexId)"
        if poke.nextEvolutionId == "" {
            self.evoLabel.text = "No Evolution"
            self.nextEvoImage.hidden = true
        } else {
            self.nextEvoImage.hidden = false
            self.nextEvoImage.image = UIImage(named: "\(poke.nextEvolutionId)")
            var str = "Next Evolution: \(poke.nextEvolutionTxt)"
            if poke.nextEvolutionLvl != "" {
                str += " -LVL \(poke.nextEvolutionLvl)"
            }
            self.evoLabel.text = str
        }
        self.progressBar.hideAnimated(true)
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   
}
