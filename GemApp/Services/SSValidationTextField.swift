//
//  SSValidationTextField.swift
//  SampleProject
//
//  Created by Al Shamas Tufail on 29/05/2015.
//  Copyright (c) 2015 Shamas Shahid. All rights reserved.
//

import UIKit
@IBDesignable
class SSValidationTextField: UITextField {
    /**
        Validity Function to check whether the input string is valid or not. Such a function should take a String parameter and return Bool.
    
        :param: validityFunction A function that would intake a String and return Bool
    */
    var validityFunction: ((String) -> Bool)?
    /**
        After how much delay (in seconds) since last input to textField should the validity check be performed. Default value is 0.5. Setting this value to 0 would never automatically call the validity function and users is expected to call it themselves.
    */
    var delaytime: TimeInterval = 0.5
    private var delayTimer: Timer? = nil
    private var errorLabel: UILabel? = nil

    @IBInspectable var errorText: String = "Invalid"
    /**
        Set color for error text message label.
    */
    var errorTextColor: UIColor = UIColor.red
    /**
        Set background color for error text message label.
    */
    var errorBackgroundColor: UIColor = UIColor.clear
    @IBInspectable var successText: String = "Ok"
    /**
        Set color for success text message label.
    */
    var successTextColor: UIColor = UIColor.green
    /** 
        Set background color for success text message label.
    */
    var successBackgroundColor: UIColor = UIColor.clear

    private var animationDuration: TimeInterval = 0.1

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    private func setup() {
        NotificationCenter.default.addObserver(self, selector: Selector(("textFieldEdited:")), name: UITextField.textDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func textFieldEdited(aNotificaiton: NSNotification) {
        if self == aNotificaiton.object! as! SSValidationTextField {
            var currentString = self.text
            if self.validityFunction != nil {
                if delaytime != 0 {
                    setTimerForValidation()
                }
            }
        }
    }

    private func setTimerForValidation() {
        if delayTimer != nil {
            delayTimer?.invalidate()
            delayTimer = nil
        }
        delayTimer = Timer.scheduledTimer(timeInterval: TimeInterval(delaytime), target: self, selector: Selector(("checkValidity")), userInfo: nil, repeats: false)
    }
/**
    When called manually, performs the validity check, sets the appropriate label and returns bool whether validation was successful or not.

    :returns: A Bool whether validation was successful or not.
*/
    func checkValidity() -> Bool {
        let currentString = self.text
        if currentString!.isEmpty {
            if errorLabel != nil {
                errorLabel!.isHidden = true
            }
            return false
        }
        if self.validityFunction!(currentString!) {
            print("yes is valid")
            self.setLabel(isValid: true)
            return true
        } else {
            print("no not valid")
            self.setLabel(isValid: false)
            return false
        }
    }

    private func setLabel(isValid: Bool) {
        if errorLabel == nil {
           // errorLabel = UILabel(frame: CGRect(8, self.frame.height - 8, self.frame.width - 16, 8))
            errorLabel?.font = UIFont.systemFont(ofSize: 10)
            self.addSubview(errorLabel!)
        }
        errorLabel!.isHidden = false
        if isValid {
            errorLabel?.textColor = successTextColor
            errorLabel?.backgroundColor = successBackgroundColor
            errorLabel!.text = successText
        } else {
            errorLabel?.textColor = errorTextColor
            errorLabel?.backgroundColor = errorBackgroundColor
            errorLabel!.text = errorText
        }
        self.animationLabel()
    }

    private func animationLabel() {
        if errorLabel != nil {
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                self.errorLabel!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }) { (completed) -> Void in
                    UIView.animate(withDuration: self.animationDuration, animations: { () -> Void in
                        self.errorLabel!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
            }
        }
    }

    override func prepareForInterfaceBuilder() {
        setup()
    }
}
