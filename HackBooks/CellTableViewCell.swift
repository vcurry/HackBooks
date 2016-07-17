//
//  CellTableViewCell.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 12/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var authors: UILabel!

    @IBOutlet weak var bookImage: UIImageView!
    
    let cellId: NSString = "customCell"
    
    let cellHeight: CGFloat = 75.0
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
