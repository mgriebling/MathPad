//
//  TitleCell.swift
//  MathPad
//
//  Created by Mike Griebling on 2 Apr 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {

	@IBOutlet weak var docName: UITextField!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
