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

class MathDocTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
	
	class func dummy (v: DocumentViewController?) { println("Return notification missing") }
	
	var returnNotification: (DocumentViewController?) -> () = DocumentViewController.dummy
	var calculatorView: UIView!
	var accessoryView: UIView!
	var detailItem: NSURL? {
		didSet {
			// load the document
			if let url = detailItem {
				let doc = EqDocument(fileURL: url)
				doc.openWithCompletionHandler({ (success) -> Void in
					if success  {
						println("Opened document \(url.lastPathComponent)")
						self.document = doc
					} else {
						self.document = nil
					}
				})
			}
			
			// Update the view.
			self.configureView()
		}
	}
	var document : EqDocument?
	
	// MARK: - Custom keypad methods
	
	@IBAction func addKeyToField(sender: UIButton) {
		if let key = sender.titleLabel?.text {
//			equationView.replaceRange(equationView.selectedTextRange!, withText: key)
		}
	}
	
	@IBAction func backDelete(sender: RoundButton) {
//		equationView.deleteBackward()
	}
	
	@IBAction func dismissKeyboard(sender: UIBarButtonItem) {
//		equationView.resignFirstResponder()
	}
	
	@IBAction func newKeypad(sender: RoundButton) {
		if sender.titleLabel?.text == "func" {
			loadInterface("FunctionKeys")
		} else if sender.titleLabel?.text == "0...9" {
			loadInterface("Keyboard")
		}
	}
	
	func configureView() {
		// Update the user interface for the detail item.
		// load the document
		
	}
	
	func loadInterface(name: String) {
		let myBundle = NSBundle.mainBundle()
		let calculatorNib = myBundle.loadNibNamed(name, owner: self, options: nil)
		calculatorView = calculatorNib[0] as UIView
//		self.equationView.inputView = calculatorView
//		self.equationView.reloadInputViews()
	}
	
	// MARK: - Controller Life Cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		self.configureView()
		loadInterface("Keyboard")
		
		// set up the accessory view
		let accessoryNib = NSBundle.mainBundle().loadNibNamed("Accessory", owner: self, options: nil)
		accessoryView = accessoryNib[0] as UIView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
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
		cell.equationTextField?.text = content
		cell.descriptionTextField?.text = content
//		cell.corePlotView.
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
