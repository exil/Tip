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
    @IBOutlet var totalView: UIView!
    @IBOutlet var tipView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "applicationResigned", name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: "applicationBecameActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentage = roundf(tipSlider.value)
        var billText = billField.text.stringByReplacingOccurrencesOfString("$", withString: "")
        
        var billAmount = (billText as NSString).doubleValue
        var tip = billAmount * Double(tipPercentage / 100)
        var total = billAmount + tip
        
        println("\(billField.text) \(tip) \(total)")
        
        tipLabel.text = String(format: "+ $%.2f", tip)
        totalLabel.text = String(format: "= $%.2f", total)
        tipSliderLabel.text = "\(Int(tipPercentage))%"
    }

    /*@IBAction func animateViews(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            var totalViewFrame = self.totalView.frame
            var tipViewFrame = self.tipView.frame
            
            totalViewFrame.origin.y -= self.view.bounds.width
            tipViewFrame.origin.y -= self.view.bounds.width
            
            self.totalView.frame = totalViewFrame
            self.tipView.frame = tipViewFrame
            }, completion: { finished in
                
        })
    }*/
    
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
        
        // if just $, reset to initial view
        // once user has typed something, switch to full view
        if (count(billField.text) == 1) {
            resetPositions(true)
        } else {
            setPositions(true)
        }
    }
    
    /* move everything into place */
    func setPositions(doAnimate: Bool) {
        let animationDuration = doAnimate ? 0.2 : 0.0
        let billFieldOrigin: CGFloat = 90
        let totalViewOrigin: CGFloat = 233
        let tipViewOrigin: CGFloat = 63
        
        // if amount view is already full height, just return
        if (billField.frame.origin.y == billFieldOrigin) {
            return;
        }
        
        UIView.animateWithDuration(animationDuration, animations: {
            println(self.totalView.frame.origin.y)
            println(self.tipView.frame.origin.y)
            self.totalView.frame.origin.y = totalViewOrigin
            self.tipView.frame.origin.y = tipViewOrigin
            
            //self.amountView.frame.size.height = amountViewHeight
            self.billField.frame.origin.y = billFieldOrigin
        })
    }
    
    func resetPositions(doAnimate: Bool) {
        let animationDuration = doAnimate ? 0.2 : 0.0
        // if frames are already out of view, just return
        if (self.totalView.frame.origin.y > self.view.bounds.width) {
            return;
        }
        
        UIView.animateWithDuration(animationDuration, animations: {
            println(self.totalView.frame.origin.y)
            println(self.tipView.frame.origin.y)
            self.totalView.frame.origin.y += self.view.bounds.height
            self.tipView.frame.origin.y += self.view.bounds.height
            self.billField.frame.origin.y = 293
            println(self.billField.frame.origin.y)
        })
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
        
        // don't do animations on first load
        if (count(billField.text) == 1) {
            resetPositions(false)
        } else {
            setPositions(false)
        }
        
        onEditingChanged(self)
    }
}

