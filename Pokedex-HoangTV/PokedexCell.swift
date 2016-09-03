//
//  PokedexCell.swift
//  Pokedex-HoangTV
//
//  Created by HoangTV on 9/2/16.
//  Copyright © 2016 HoangTV. All rights reserved.
//

import UIKit

class PokedexCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    var pokemon: PokemonModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: PokemonModel) {
        self.pokemon = pokemon
        self.nameLabel.text = pokemon.name.capitalizedString
        self.thumbImage.image = UIImage(named: "\(pokemon.pokedexId)")
    }
}

