//
//  EquationCell.swift
//  MathPad
//
//  Created by Mike Griebling on 29 Mar 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class EquationCell: UITableViewCell {

	@IBOutlet weak var equationTextField: UITextField?
	@IBOutlet weak var descriptionTextField: UITextField?
	@IBOutlet weak var corePlotView: CPTGraphHostingView?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
