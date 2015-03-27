//
//  KeyboardViewController.swift
//  MathKeypad
//
//  Created by Mike Griebling on 27 Mar 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

	var calculatorView: UIView!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		loadInterface()
    }
	
	func loadInterface() {
		var calculatorNib = UINib(nibName: "Keyboard", bundle: nil)
		calculatorView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as UIView
		view.addSubview(calculatorView)
		view.backgroundColor = calculatorView.backgroundColor
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
 //       self.nextKeyboard.setTitleColor(textColor, forState: .Normal)
    }

}
