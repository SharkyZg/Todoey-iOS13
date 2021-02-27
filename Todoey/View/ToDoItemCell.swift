//
//  ToDoItemCell.swift
//  Todoey
//
//  Created by Marko Sarkanj on 24.02.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class ToDoItemCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
