//
//  ViewController.swift
//  currency-app
//
//  Created by RMS2018 on 13.03.2019.
//  Copyright © 2019 RMS2018. All rights reserved.
//

import UIKit
import iOSDropDown

@IBDesignable extension UIButton{
    @IBInspectable var borderColor: UIColor?{
        set{
            guard let uiColor = newValue else {return}
            layer.borderColor=uiColor.cgColor
        }
        get{
            guard let color = layer.borderColor else {return nil}
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var cornerRadius: CGFloat{
        set{
            layer.cornerRadius = newValue
        }
        get{
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat{
        set{
            layer.borderWidth = newValue
        }
        get{
            return layer.borderWidth
        }
    }
}
class ViewController: UIViewController {

   @IBOutlet weak var currencyInDropDown: DropDown!

    @IBOutlet weak var currencyOutDropDown: DropDown!
    
    override func viewDidLoad() {

    
        super.viewDidLoad()
        currencyInDropDown.optionArray = ["AAA", "ABA", "BBB", "CAB"]
        currencyOutDropDown.optionArray = ["AAA", "ABA", "BBB", "CAB"]

       
    }


}

