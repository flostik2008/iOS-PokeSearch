//
//  Pokemon.swift
//  PokeSearch
//
//  Created by Evgeny Vlasov on 10/7/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import Foundation

class Pokemon {

    private var _name: String!
    private var _pokemonId: Int!
    private var _image: UIImage!
    
    var name: String {
        return _name
    }

    var pokemonId: Int {
        return _pokemonId
    }

    init(name: String, pokemonId: Int) {
        
        self._name = name
        self._pokemonId = pokemonId
    }
}
