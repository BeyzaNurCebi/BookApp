//
//  TableViewCell.swift
//  BookApp
//
//  Created by Beyza Nur Çebi on 29.04.2020.
//  Copyright © 2020 Beyza Nur Çebi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
