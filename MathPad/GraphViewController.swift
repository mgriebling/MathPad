//
//  GraphViewController.swift
//  MathPad
//
//  Created by Mike Griebling on 3 Apr 2015.
//  Copyright (c) 2015 Computer Inspirations. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

	@IBOutlet var hostView: CPTGraphHostingView!
	var graph: graphObject?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		graph = graphObject()
		graph?.renderInGraphHostingView(hostView, withTheme: nil, animated: true)
    }
	
	override func viewDidAppear(animated: Bool) {
		graph?.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
