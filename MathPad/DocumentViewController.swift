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
		return UIModalPresentationStyle.None  // force PopOver even on iPhones
	}
	
	func createNewItemSelected (vc: SelectItemTableViewController?, selected: Int)  {
		switch selected {
			case 0: println ("Adding an equation"); break
			case 1: println ("Adding a description"); break
			default: println ("Adding a plot"); break
		}
		vc?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: - Segues
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showOptions" {
			let vc = segue.destinationViewController as SelectItemTableViewController
			vc.popoverPresentationController?.delegate = self
			vc.rowWasSelected = createNewItemSelected	// call-back
		}
	}


}

