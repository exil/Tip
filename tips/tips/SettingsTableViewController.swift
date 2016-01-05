//
//  SettingsTableViewController.swift
//  
//
//  Created by Max Pappas on 1/3/16.
//
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var defaultTip: UITextField!
    @IBOutlet var minimumTip: UITextField!
    @IBOutlet var maximumTip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var defaultTipValue = defaults.integerForKey("defaultTipValue")
        var minimumTipValue = defaults.integerForKey("minimumTipValue")
        var maximumTipValue = defaults.integerForKey("maximumTipValue")
        
        minimumTip.text = "\(minimumTipValue)"
        maximumTip.text = "\(maximumTipValue)"
        defaultTip.text = "\(defaultTipValue)"
    }

    // MARK: - Table view data source

    @IBAction func closeModal(sender: AnyObject) {
        let fallbackTip = 15
        var minimumTipValue = minimumTip.text.toInt() ?? fallbackTip
        var maximumTipValue = maximumTip.text.toInt() ?? fallbackTip
        var defaultTipValue = defaultTip.text.toInt() ?? fallbackTip
        var tempTipValue = minimumTipValue
        var defaults = NSUserDefaults.standardUserDefaults()
        
        if (minimumTipValue > maximumTipValue) {
            minimumTipValue = maximumTipValue
            maximumTipValue = tempTipValue
        }
        
        if (defaultTipValue < minimumTipValue || defaultTipValue > maximumTipValue) {
            defaultTipValue = minimumTipValue
        }
        
        // save
        defaults.setInteger(minimumTipValue, forKey: "minimumTipValue")
        defaults.setInteger(maximumTipValue, forKey: "maximumTipValue")
        defaults.setInteger(defaultTipValue, forKey: "defaultTipValue")
        defaults.synchronize()
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clearTextField(sender: AnyObject) {
        var textField: UITextField = (sender as! UITextField)
                
        textField.text = ""
    }
    
    @IBAction func validateTip(sender: AnyObject) {
        var textField: UITextField = (sender as! UITextField)
        let fallbackTip = 15
        var tipValue = textField.text.toInt() ?? fallbackTip
        
        if (tipValue > 100) {
            tipValue = fallbackTip
        }
        
        textField.text = "\(tipValue)"
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
