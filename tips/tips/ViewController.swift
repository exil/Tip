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
    @IBOutlet var tipSlider: UISlider!
    @IBOutlet var tipSliderLabel: UILabel!
    
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
        /*var tipPercentages = [0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]*/
        var tipPercentage = roundf(tipSlider.value)
        var billText = billField.text.stringByReplacingOccurrencesOfString("$", withString: "")
        
        var billAmount = (billText as NSString).doubleValue
        var tip = billAmount * Double(tipPercentage / 100)
        var total = billAmount + tip
        
        println("\(billField.text) \(tip) \(total)")
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        tipSliderLabel.text = "\(Int(tipPercentage))%"
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipValue = defaults.integerForKey("defaultTipValue")
        var minimumTipValue = defaults.integerForKey("minimumTipValue")
        var maximumTipValue = defaults.integerForKey("maximumTipValue")
        
        tipSlider.minimumValue = Float(minimumTipValue)
        tipSlider.maximumValue = Float(maximumTipValue)
        tipSlider.value = Float(defaultTipValue)

        tipSliderLabel.text = "\(defaultTipValue)"
        
        //tipControl.selectedSegmentIndex = defaultTip
        
        onEditingChanged(self)
        billField.becomeFirstResponder()
    }
    
    @IBAction func sliderDoneMoving(sender: AnyObject) {
        // make sure tip % is always an integer
        //sender.setValue(Float(lroundf(tipSlider.value)), animated: true)
    }
    
    @IBAction func billAmountChanged(sender: AnyObject) {
        if (count(billField.text) < 1) {
            billField.text = "$"
        }
    }
    
    func applicationResigned() {
        // keep track of when app resigned
        var lastActiveDate = NSDate()
        // set values to remember bill state
        var tipPercentage = roundf(tipSlider.value)
        var billAmount = billField.text
        var defaults = NSUserDefaults.standardUserDefaults()

        defaults.setFloat(tipPercentage, forKey: "tipPercentage")
        defaults.setValue(billAmount, forKey: "billAmount")
        defaults.setObject(lastActiveDate, forKey: "lastActiveDate")
        defaults.synchronize()
    }
    
    func applicationBecameActive() {
        // get values to remember bill state
        var defaults = NSUserDefaults.standardUserDefaults()
        var billAmount = defaults.stringForKey("billAmount")
        var tipPercentage = defaults.floatForKey("tipPercentage")
        var lastActiveDate: AnyObject? = defaults.objectForKey("lastActiveDate")
        let saveValueDuration = 600.0
        
        if (lastActiveDate != nil) {
            var secondsSinceLastActive = lastActiveDate!.timeIntervalSinceNow

            // if last accessed date is < 10 minutes, set form values
            if (secondsSinceLastActive * -1 < saveValueDuration) {
                println(secondsSinceLastActive)
                
                tipSlider.value = tipPercentage
                billField.text = billAmount
            }
        }
        
        onEditingChanged(self)
    }

}

