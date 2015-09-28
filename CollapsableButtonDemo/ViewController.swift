//
//  ViewController.swift
//  CollapsableButtonDemo
//
//  Created by Benjamin Lefebvre on 9/28/15.
//  Copyright © 2015 zanadu. All rights reserved.
//

import UIKit

import CollapsableButton

class ViewController: UIViewController {

    @IBOutlet weak var validationButton: CollapsableButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func onValidationButtonTapped(sender: AnyObject) {
        validationButton.switchState()
    }
}

