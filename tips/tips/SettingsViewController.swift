//
//  SettingsViewController.swift
//  
//
//  Created by Max Pappas on 1/2/16.
//
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var defaultTipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTip = defaults.integerForKey("defaultTip")
        
        println("loading \(defaultTip)")
        defaultTipControl.selectedSegmentIndex = defaultTip
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeModal(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tipChanged(sender: AnyObject) {
        var defaultTip = defaultTipControl.selectedSegmentIndex
        var defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setInteger(defaultTip, forKey: "defaultTip")
        defaults.synchronize()
        
        println("saving \(defaultTip)")
    }
}
