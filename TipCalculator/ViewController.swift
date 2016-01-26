//
//  ViewController.swift
//  TipCalculator
//
//  Created by Joshua Ide on 12/01/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//  version 1.1

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //Outlets
    //----------------
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var btn25: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnCustom: UIButton!
    @IBOutlet weak var lblSplit: UILabel!
    
    //Variables
    //-----------------
    var otherTipAmnt = 0.0
    var totalBill = 0.0
    var tempInput: Double?

    //Actions
    //-----------------
    @IBAction func on15Pressed(sender: AnyObject) {
        dismissKeyboard()
        
        if ((txtInput.text?.isEmpty) == true) || txtInput.text == "." {
            let alert = UIAlertController(title: "Text Field Empty", message: "Please enter your bill subtotal.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(alertAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            calculateTip((Double(txtInput.text!))!, percentage: 15.0)
        }
    }
    
    @IBAction func on20Pressed(sender: AnyObject) {
        dismissKeyboard()
        
        if ((txtInput.text?.isEmpty) == true) || txtInput.text == "." {
            let alert = UIAlertController(title: "Text Field Empty", message: "Please enter your bill subtotal.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(alertAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            calculateTip((Double(txtInput.text!))!, percentage: 20.0)
        }
    }
    
    @IBAction func on25Pressed(sender: AnyObject) {
        dismissKeyboard()
        
        if ((txtInput.text?.isEmpty) == true) || txtInput.text == "." {
            let alert = UIAlertController(title: "Text Field Empty", message: "Please enter your bill subtotal.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(alertAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            calculateTip((Double(txtInput.text!))!, percentage: 25.0)
        }
    }
    
    @IBAction func onCalcCustomerPressed(sender: AnyObject) {
        dismissKeyboard()
        if otherTipAmnt > 0.0 {
            if ((txtInput.text?.isEmpty) == true) || txtInput.text == "." {
                let alert = UIAlertController(title: "Text Field Empty", message: "Please enter your bill subtotal.", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                alert.addAction(alertAction)
                
                presentViewController(alert, animated: true, completion: nil)
            } else {
                calculateTip((Double(txtInput.text!))!, percentage: otherTipAmnt)
            }
        } else {
            performSegueWithIdentifier("goToOther", sender: nil)
        }
    }
    
    @IBAction func onSplitPressed(sender: AnyObject) {
        dismissKeyboard()
        if totalBill != 0.0 {
            let splitPrompt = UIAlertController(title: "Split Bill", message: "Please enter the number of people in your party.", preferredStyle: UIAlertControllerStyle.Alert)
            splitPrompt.addTextFieldWithConfigurationHandler(addSplitField)
            splitPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            splitPrompt.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: splitNumEntered))
            presentViewController(splitPrompt, animated: true, completion: nil)
            dismissKeyboard()
        } else {
            let splitPrompt = UIAlertController(title: "Split Bill", message: "Please enter the number of people in your party.", preferredStyle: UIAlertControllerStyle.Alert)
            splitPrompt.addTextFieldWithConfigurationHandler(addSplitField)
            splitPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            splitPrompt.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: splitNoTotal))
            presentViewController(splitPrompt, animated: true, completion: nil)
            dismissKeyboard()
        }

    }
    
    //Functions
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        self.txtInput.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if otherTipAmnt == 0.0 {
            btnCustom.setTitle("Custom Tip Percentage", forState: .Normal)
        } else {
            btnCustom.setTitle("\(otherTipAmnt) %", forState: .Normal)
        }
        
        if tempInput != nil {
            txtInput.text = String(tempInput!)
        }
    }
    
    func calculateTip(subtotal: Double, percentage: Double) {
        var tip: Double
        tip = subtotal * percentage
        tip = tip / 100
        lblTipAmount.text = "$\(round(100*tip)/100)  |  Tip"
        totalBill = round(100 * (subtotal + tip)) / 100
        lblTotal.text = "$\(totalBill)"
    }
    
    //Text Field on Split Alert
    //--------------------------
    @IBOutlet var newSplitField: UITextField?
    
    func splitNumEntered(alert: UIAlertAction!) {
        lblSplit.text = "$\(round(100*(totalBill / (Double((newSplitField?.text)!))!))/100) |  each"
    }
    
    func splitNoTotal(alert: UIAlertAction!) {
        lblSplit.text = "$\(round(100*((Double((txtInput?.text)!))! / (Double((newSplitField?.text)!))!))/100) |  each"
    }
    
    func addSplitField(textField: UITextField!) {
        textField.placeholder = "People in party..."
        textField.keyboardType = UIKeyboardType.NumberPad
        textField.keyboardAppearance = UIKeyboardAppearance.Dark
        newSplitField = textField
    }
    //--------------------------
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 400, 35))
        doneToolbar.barStyle = UIBarStyle.Default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dismissKeyboard"))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        
        self.txtInput.inputAccessoryView = doneToolbar
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //Text delegate - ensuring valid input
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // return false to not change text
        // return true to accept change
        
        //What will be the final string
        let newString = textField.text! + string
        
        let array = Array(newString.characters)
        var pointCount = 0 //count the decimal separator
        var unitsCount = 0 //count units
        var decimalCount = 0 // count decimals
        
        for character in array { //counting loop
            if character == "." {
                pointCount++
            } else {
                if pointCount == 0 {
                    unitsCount++
                } else {
                    decimalCount++
                }
            }
        }
        if unitsCount > 10 {
            return false
        } // units maximum
        if decimalCount > 2 {
            return false
        } // decimal maximum
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9": // allowed characters
            return true
        case ".": // block to one decimal separator to get valid decimal number
            if pointCount > 1 {
                return false
            } else {
                return true
            }
        default: // manage delete key
            let array = Array(string.characters)
            if array.count == 0 {
                return true
            }
            return false
        }
    }

}