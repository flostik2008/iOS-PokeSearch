//
//  ChoosePokemonVC.swift
//  PokeSearch
//
//  Created by Evgeny Vlasov on 10/7/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit

class ChoosePokemonVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.backgroundColor = UIColor.clear
        
        collection.delegate = self
        collection.dataSource = self
        populatingArray()
        
    }

    func populatingArray()  {
        
        var poke: Pokemon!
        
        for x in 0..<pokemon.count {

            var name: String!
            name = pokemon[x]
            
            poke = Pokemon(name: name, pokemonId: x+1)
      
            pokemons.append(poke)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            var poke: Pokemon!
            
            if inSearchMode == false {
                poke = pokemons[indexPath.row]
                cell.configureCell(pokemon: poke)
            } else {
//                poke = filteredPokemons[indexPath.row]
//                cell.configureCell(pokemon: poke)
            }
        
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
}






