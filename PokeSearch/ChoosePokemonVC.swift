//
//  ChoosePokemonVC.swift
//  PokeSearch
//
//  Created by Evgeny Vlasov on 10/7/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit

class ChoosePokemonVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate  {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    var loc: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.backgroundColor = UIColor.clear
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
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
        
        if inSearchMode {
            return filteredPokemons.count
        }
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            var poke: Pokemon!
            
            if inSearchMode {
            
                poke = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon: poke)
            } else {
                poke = pokemons[indexPath.row]
                cell.configureCell(pokemon: poke)
            }
        
            return cell
        } else {
        
            return UICollectionViewCell() }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemons[indexPath.row]

        } else {
        
            poke = pokemons[indexPath.row]
        }
        
        print(poke.pokemonId)
        
        performSegue(withIdentifier: "PokeChosen", sender: poke)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil })
            collection.reloadData()
        }
    }
    
    func dismissKeyboard() {
 
        view.endEditing(true)
    }
    
    @IBAction func backBtn(_ sender: AnyObject) {
   
        dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeChosen" {
            if let mainVC = segue.destination as? ViewController {
                if let poke = sender as? Pokemon {
                    
                    mainVC.poke = poke
                    mainVC.loc = loc
                                        
                }
            }
        }
    }
    
}






