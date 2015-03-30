//
//  MathDocTableViewController.swift
//  MathPad
//
//  Created by Mike Griebling on 29 Mar 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
}

class RoundLabel: UILabel {
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
}

class MathDocTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
	
	private class func dummy (v: MathDocTableViewController?) { println("Return notification missing") }
	
	var returnNotification: (MathDocTableViewController?) -> () = MathDocTableViewController.dummy
	private var calculatorView: UIView!
	private var accessoryView: UIView!
	var detailItem: NSURL? {
		didSet {
			// load the document
			if let url = detailItem {
				let doc = EqDocument(fileURL: url)
				self.closeDocument()	// save/close the existing document -- if any
				doc.openWithCompletionHandler({ (success) -> Void in
					if success  {
						println("Opened document \(url.lastPathComponent)")
						self.document = doc
					} else {
						self.document = nil
					}
				})
			}
			
			// Update the view
			self.tableView.reloadData()
		}
	}
	private var document : EqDocument?
	private var activeField : UITextField?
	private var activeIndex : NSIndexPath?
	private let myBundle = NSBundle.mainBundle()
	
	// MARK: - Custom keypad methods
	
	@IBAction func addKeyToField(sender: UIButton) {
		if let key = sender.titleLabel?.text {
			if let field = activeField {
				field.replaceRange(field.selectedTextRange!, withText: key)
			}
		}
	}
	
	@IBAction func backDelete(sender: RoundButton) {
		activeField?.deleteBackward()
	}
	
	@IBAction func dismissKeyboard(sender: UIBarButtonItem) {
		activeField?.resignFirstResponder()
	}
	
	@IBAction func newKeypad(sender: RoundButton) {
		if sender.titleLabel?.text == "func" {
			loadInterface("FunctionKeys")
		} else if sender.titleLabel?.text == "0...9" {
			loadInterface("Keyboard")
		}
	}
	
	func loadInterface(name: String) {
		let calculatorNib = myBundle.loadNibNamed(name, owner: self, options: nil)
		calculatorView = calculatorNib[0] as UIView
		activeField?.inputView = calculatorView
		activeField?.reloadInputViews()
	}
	
	// MARK: - Text field delegate
	
	func textFieldDidBeginEditing(textField: UITextField) {
		// keep track of the active text field and its location in the tableview
		activeField = textField
		activeIndex = tableView.mdIndexPathForRowContainingView(textField)
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		if let doc = document {
			if let index = activeIndex?.row {
				doc.objects[index].CommandLine = textField.text
			}
		}
	}
	
	// MARK: - Helper functions
	
	private func enableEdit () {
		let editButton = self.navigationItem.rightBarButtonItems?[1] as UIBarButtonItem
		editButton.enabled = document?.objects.count > 0
	}
	
	private func closeDocument () {
		// save any changes to the document and close it
		document?.closeWithCompletionHandler({ (success) -> Void in
			if success { self.document = nil; println("Saved & closed document...") }
		})
	}
	
	// MARK: - Controller Life Cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		self.navigationItem.rightBarButtonItems?.append(self.editButtonItem())
		loadInterface("Keyboard")
		
		// set up the accessory view
		let accessoryNib = NSBundle.mainBundle().loadNibNamed("Accessory", owner: self, options: nil)
		accessoryView = accessoryNib[0] as UIView
		enableEdit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		closeDocument()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()		
	}

    // MARK: - Table view data source
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
		if let doc = self.document {
			return doc.objects.count
		} else {
			return 0
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var identifier = "EquationCell"
		var content: String = ""
		if let object = document?.objects[indexPath.row] {
			content = object.CommandLine
			if object is Description {
				identifier = "DescriptionCell"
			} else if object is Plot {
				identifier = "PlotCell"
			}
		}
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as EquationCell

        // Configure the cell...
		if let textField = cell.equationTextField {
			textField.text = content
			textField.inputView = calculatorView
			textField.inputAccessoryView = accessoryView
			textField.delegate = self
			textField.reloadInputViews()
		}
		cell.descriptionTextField?.text = content
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
		return document?.objects.count > 0
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
			document?.objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			if document?.objects.count == 0 {
				// change Edit button back to done
				self.setEditing(false, animated: true)
				enableEdit()
			}
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
	
	// MARK: - PopoverPresentationControllerDelegate methods
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None  // force PopOver even on iPhones
	}
	
	func createNewItemSelected (vc: SelectItemTableViewController?, selected: Int)  {
		var item: Equation
		switch selected {
			case 0: item = Equation(command: "e = m c²"); println ("Adding an equation"); break
			case 1: item = Description(); println ("Adding a description"); break
			default: item = Plot(); println ("Adding a plot"); break
		}
		document?.objects.insert(item, atIndex: 0)
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		vc?.dismissViewControllerAnimated(true, completion: nil)
		enableEdit()
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
