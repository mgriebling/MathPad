//
//  DetailViewController.swift
//  MathPad
//
//  Created by Mike Griebling on 25 Mar 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate {


	@IBOutlet weak var equationView: UITextView!
	
	class func dummy (v: DocumentViewController?) { println("Return notification missing") }

	var returnNotification: (DocumentViewController?) -> () = DocumentViewController.dummy
	
	var detailItem: AnyObject? {
		didSet {
		    // Update the view.
		    self.configureView()
		}
	}

	func configureView() {
		// Update the user interface for the detail item.
		if let detail: AnyObject = self.detailItem {
		    if let label = self.equationView {
		        label.text = detail.description
		    }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
		self.equationView.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - TextViewDelegate methods
	
	func textViewDidChange(textView: UITextView) {
		detailItem = textView.text
		returnNotification(self)
	}
	
	// MARK: - PopoverPresentationControllerDelegate methods
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return .OverFullScreen
	}
	
	
	// MARK: - Segues
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showOptions" {
			let pop: AnyObject = segue.destinationViewController
			if segue.destinationViewController.isKindOfClass(UIPresentationController) {
				let pop = segue.destinationViewController as UIPresentationController
				pop.delegate = self
			}
		}
	}


}

