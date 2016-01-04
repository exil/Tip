//
//  ViewController.swift
//  tips
//
//  Created by Max Pappas on 12/31/15.
//  Copyright (c) 2015 tria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var billField: UITextField!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "applicationResigned", name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: "applicationBecameActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentages = [0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        var billAmount = (billField.text as NSString).doubleValue
        var tip = billAmount * tipPercentage
        var total = billAmount + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        println("\(tipControl.selectedSegmentIndex)")
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTip = defaults.integerForKey("defaultTip")
        
        tipControl.selectedSegmentIndex = defaultTip
        
        onEditingChanged(self)
        billField.becomeFirstResponder()
    }
    
    func applicationResigned() {
        // keep track of when app resigned
        var lastActiveDate = NSDate()
        // set values to remember bill state
        var tipIndex = tipControl.selectedSegmentIndex
        var billAmount = billField.text
        var defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setInteger(tipIndex, forKey: "tipIndex")
        defaults.setValue(billAmount, forKey: "billAmount")
        defaults.setObject(lastActiveDate, forKey: "lastActiveDate")
        defaults.synchronize()
    }
    
    func applicationBecameActive() {
        // get values to remember bill state
        var defaults = NSUserDefaults.standardUserDefaults()
        var billAmount = defaults.stringForKey("billAmount")
        var tipIndex = defaults.integerForKey("tipIndex")
        var lastActiveDate: AnyObject? = defaults.objectForKey("lastActiveDate")
        let saveValueDuration = 600.0
        
        if lastActiveDate != nil {
            var secondsSinceLastActive = lastActiveDate!.timeIntervalSinceNow

            // if last accessed date is < 10 minutes, set form values
            if secondsSinceLastActive * -1 < saveValueDuration {
                println(secondsSinceLastActive)
                
                tipControl.selectedSegmentIndex = tipIndex
                billField.text = billAmount
            }
        }
        
        onEditingChanged(self)
    }

}

