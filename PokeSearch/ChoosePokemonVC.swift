//
//  ChoosePokemonVC.swift
//  PokeSearch
//
//  Created by Evgeny Vlasov on 10/7/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit

class ChoosePokemonVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.backgroundColor = UIColor.clear
        
        collection.delegate = self
        collection.dataSource = self
        
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collection.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? UICollectionViewCell {
            
            return cell
        
        } 
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
