//
//  ShaderModifierCollectionView.swift
//  ShaderModifierLibrary
//
//  Created by Dennis Ippel on 30/01/2019.
//  Copyright © 2019 Rozengain. All rights reserved.
//

import UIKit

class ShaderModifierCollectionView: UICollectionView {
    var shaderDataSource: ShaderModifierDataSource? {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
    }
}

extension ShaderModifierCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let shaderDataSource = shaderDataSource {
            return shaderDataSource.shaderModifiers.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shaderModifierCell", for: indexPath)
        
        if let cell = cell as? ShaderModifierCollectionViewCell,
            let shaderModifierEntry = shaderDataSource?.shaderModifiers[indexPath.row] {
            cell.imageView.image = shaderModifierEntry.previewImage
        }
        
        return cell
    }
}

extension ShaderModifierCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
