//
//  MasterViewController.swift
//  MathPad
//
//  Created by Mike Griebling on 25 Mar 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class MainDocumentController: UITableViewController {

	let EXTENSION = "mpad"
	class var path : NSURL {
		struct dummy {
			static var staticPath : NSURL = MainDocumentController.getStaticPath()
		}
		return dummy.staticPath
	}
	var detailViewController: DocumentViewController? = nil
	var objects = [NSURL]()
	var activeObject: Int = 0

	// gets called to update the object state
	func updateObject (vc : DocumentViewController?) {
//		objects[activeObject] = vc?.detailItem as String
		tableView.reloadData()
	}
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
		    self.clearsSelectionOnViewWillAppear = false
		    self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()

		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
		self.navigationItem.rightBarButtonItem = addButton
		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = controllers[controllers.count-1].topViewController as? DocumentViewController
		}
		self.getExistingDocuments()   // populate the table with existing documents
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private class func getStaticPath () -> NSURL {
		let appDirs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
		let path = appDirs[0] as String
		return NSURL(fileURLWithPath: path, isDirectory: true)!
	}
	
	func getExistingDocuments () {
		let fm =  NSFileManager.defaultManager()
		var error : NSErrorPointer = nil
		let path = MainDocumentController.path
		let files = fm.contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options: .allZeros, error: error)!
		for file in files {
			objects.append(file as NSURL)
		}
		tableView.reloadData()
	}

	func insertNewObject(sender: AnyObject) {
		let number = objects.count+1
		let url = MainDocumentController.path
		let fname = url.URLByAppendingPathComponent("Unnamed \(number)").URLByAppendingPathExtension(EXTENSION)
		let fm =  NSFileManager.defaultManager()
		let doc = EqDocument(fileURL: fname)
		objects.insert(fname, atIndex: 0)
		let indexPath = NSIndexPath(forRow: 0, inSection: 0)
		self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		if !fm.fileExistsAtPath(fname.absoluteString!) {
			doc.saveToURL(fname, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: { (success) -> Void in
				if success { println("Saved document \(fname.lastPathComponent)") }
			})
		} else {
			doc.openWithCompletionHandler({ (success) -> Void in
				if success  { println("Opened document \(fname.lastPathComponent)") }
			})
		}
	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow() {
				activeObject = indexPath.row
		        let object = objects[activeObject]
		        let controller = (segue.destinationViewController as UINavigationController).topViewController as DocumentViewController
		        controller.detailItem = object
				controller.returnNotification = self.updateObject
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return objects.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
		let object = objects[indexPath.row]
		cell.textLabel!.text = object.lastPathComponent?.stringByDeletingPathExtension
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			let url = objects[indexPath.row]
			let fm =  NSFileManager.defaultManager()
			var error : NSErrorPointer = nil
			fm.removeItemAtURL(url, error: error)
		    objects.removeAtIndex(indexPath.row)
		    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}


}

