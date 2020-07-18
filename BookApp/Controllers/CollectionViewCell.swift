//
//  CollectionViewCell.swift
//  BookApp
//
//  Created by Beyza Nur Çebi on 18.04.2020.
//  Copyright © 2020 Beyza Nur Çebi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       imageView.makerRoundCorners(byRadius: 10)
    }
    
}


extension UIImageView {
   func makerRoundCorners(byRadius rad: CGFloat) {
      self.layer.cornerRadius = rad
      self.clipsToBounds = true
   }
}
