//
//  EqDocument.swift
//  MathPad
//
//  Created by Michael Griebling on 26Mar2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class EqDocument: UIDocument {
	
	// The equation document comprises a set of objects which can either be equations, textual descriptions, or graphical plots
	// An equation document also implicitly saves the state of all variables, functions, and number formatting options.
	
	var objects : [Equation] = []
	
	private static let kVersion   = "EqDocument.version"
	private static let kEquations = "EqDocument.objects"
	private static let kNumberOfObjects = "EqDocument.numberOfObjects"
	
	// Typical subclasses will implement this method to do reading. UIKit will pass NSData typed contents for flat files and NSFileWrapper typed contents for file packages.
	// typeName is the UTI of the loaded file.
	override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		if var data = contents as? NSData {
			var reader = NSKeyedUnarchiver(forReadingWithData: data)
			let version = reader.decodeIntegerForKey(EqDocument.kVersion)
			
			// read the equation objects
			let numberOfObjects = reader.decodeIntegerForKey(EqDocument.kNumberOfObjects)
			self.objects = []
			for var i = 0; i < numberOfObjects; i++ {
				let object = reader.decodeObject() as! Equation
				self.objects.append(object)
			}
			
			// read the variables, functions, and states
			nState = NumbState(decoder: reader)
			Functions.Load(reader)
			Variables.Load(reader)
		}
		return true
	}
	
	// Typical subclasses will implement this method and return an NSFileWrapper or NSData encapsulating a snapshot of their data to be written to disk during saving.
	// Subclasses that return something other than a valid NSFileWrapper or NSData instance, or don't override this method must override one of the writing methods 
	// in the Advanced Saving section to write data to disk.
	override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
		var data = NSMutableData()
		var writer = NSKeyedArchiver(forWritingWithMutableData: data)
		writer.encodeInteger(1, forKey: EqDocument.kVersion)
		
		// read the equation objects
		writer.encodeInteger(self.objects.count, forKey: EqDocument.kNumberOfObjects)
		for object in self.objects {
			writer.encodeObject(object)
		}
		
		// read the variables, functions, and states
		nState.Save(writer)
		Functions.Save(writer)
		Variables.Save(writer)
		writer.finishEncoding()
		return data // NSData(data: data)
	}
	
}

