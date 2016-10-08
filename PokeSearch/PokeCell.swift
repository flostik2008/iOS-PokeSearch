//
//  PokeCell.swift
//  PokeSearch
//
//  Created by Evgeny Vlasov on 10/7/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var pokeLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon){
    
        pokeImg.image = UIImage(named: "\(pokemon.pokemonId)")
        pokeLbl.text = pokemon.name.capitalized
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    
}
