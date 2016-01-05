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

    @IBOutlet var totalLabel: UILabel!pr
    @IBOutlet var billField: UITextField!
    @IBOutlet var tipControl: UISegmentedControl!
    @IBOutlet var tipSlider: UISlider!
    @IBOutlet var tipSliderLabel: UILabel!
    @IBOutlet var totalView: UIView!
    @IBOutlet var tipView: UIView!
    @IBOutlet var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaults()
        
        // Do any additional setup after loading the view, typically from a nib.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "applicationResigned", name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: "applicationBecameActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaults() {
        // sets default tip values if not set already
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipValue: AnyObject? = defaults.objectForKey("defaultTipValue")
        
        if (defaultTipValue == nil) {
            defaults.setInteger(15, forKey: "minimumTipValue")
            defaults.setInteger(25, forKey: "maximumTipValue")
            defaults.setInteger(20, forKey: "defaultTipValue")
        }
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentage = roundf(tipSlider.value)
        var locale = NSLocale.currentLocale()
        var formatter = NSNumberFormatter()
        var billText = billField.text
        var billAmount = (billText as NSString).doubleValue
        
        // format billText for regional purposes
        var billFormatted = NSNumberFormatter().numberFromString(billText)
        if let billFormatted = billFormatted {
            billAmount = Double(billFormatted)
        }
        
        var tip = billAmount * Double(tipPercentage / 100)
        var total = billAmount + tip

        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = locale
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
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
        // if empty, reset to initial view
        // once user has typed something, switch to full view
        if (count(billField.text) == 0) {
            resetPositions(true)
        } else {
            setPositions(true)
        }
    }
    
    /* move everything into place */
    func setPositions(doAnimate: Bool) {
        let animationDuration = doAnimate ? 0.2 : 0.0
        let billFieldOriginY: CGFloat = 90
        let totalViewOriginY: CGFloat = 233
        let tipViewOriginY: CGFloat = 63
        
        // if amount view is already full height, just return
        if (billField.frame.origin.y == billFieldOriginY) {
            return;
        }
        
        UIView.animateWithDuration(animationDuration, animations: {
            self.totalView.frame.origin.y = totalViewOriginY
            self.tipView.frame.origin.y = tipViewOriginY
            
            //self.amountView.frame.size.height = amountViewHeight
            self.billField.frame.origin.y = billFieldOriginY
            self.currencyLabel.frame.origin.y = billFieldOriginY
            self.currencyLabel.alpha = 0
        })
    }
    
    func resetPositions(doAnimate: Bool) {
        let animationDuration = doAnimate ? 0.2 : 0.0
        let billFieldOriginY: CGFloat = 200
        // if frames are already out of view, just return
        if (self.totalView.frame.origin.y > self.view.bounds.width) {
            return;
        }
        
        UIView.animateWithDuration(animationDuration, animations: {
            self.totalView.frame.origin.y += self.view.bounds.height
            self.tipView.frame.origin.y += self.view.bounds.height
            self.billField.frame.origin.y = billFieldOriginY
            self.currencyLabel.frame.origin.y = billFieldOriginY
            self.currencyLabel.alpha = 1
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
                tipSlider.value = tipPercentage
                billField.text = billAmount
            }
        }
        
        // set currency symbol
        var locale = NSLocale.currentLocale()
        var formatter = NSNumberFormatter()
        formatter.locale = locale
        currencyLabel.text = formatter.currencySymbol
        
        // don't do animations on first load
        if (count(billField.text) == 0) {
            resetPositions(false)
        } else {
            setPositions(false)
        }
        
        onEditingChanged(self)
    }
}

