//
//  UserCell.swift
//  SQLiteFirst
//
//  Created by Sujin Shrestha on 9/13/18.
//  Copyright © 2018 Sujin Shrestha. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var textName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

