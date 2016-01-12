//
//  OtherViewController.swift
//  TipCalculator
//
//  Created by Joshua Ide on 12/01/2016.
//  Copyright © 2016 Fox Gallery Studios. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController, UITextFieldDelegate {

    //Outlets
    //-----------------
    @IBOutlet weak var txtOther: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    
    
    //Actions
    //-----------------
    @IBAction func onDonePressed(sender: AnyObject) {
        dismissKeyboard()
        
        //Check for unallowable input, otherwise perform the segue
        if ((txtOther.text?.isEmpty) == true) || txtOther.text == "." {
            let alert = UIAlertController(title: "Text Field Empty", message: "Please enter a tip percentage.", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(alertAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let othr = txtOther.text
            performSegueWithIdentifier("goToMain", sender: othr)
        }

    }
    
    //Functions
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtOther.delegate = self
        
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 400, 35))
        doneToolbar.barStyle = UIBarStyle.Default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("dismissKeyboard"))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        
        self.txtOther.inputAccessoryView = doneToolbar
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Pass the user input back to main and store it
        if segue.identifier == "goToMain" {
            if let mainVC = segue.destinationViewController as? ViewController {
                if let othrAmt = sender as? String {
                        mainVC.otherTipAmnt = Double(othrAmt)!
                }
            }
        }
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
        } // units maximum : here 2 digits
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
