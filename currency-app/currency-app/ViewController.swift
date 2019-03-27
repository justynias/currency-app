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
        
        var keys:NSDictionary?
        
        if let path =  Bundle.main.path(forResource: "keys", ofType: "plist"){
            keys=NSDictionary(contentsOfFile: path)
        }
        let arrayOfKeys = keys?.allValues as! [String]
        fetchDataFromApi(apiKey: arrayOfKeys[0])
       
    }
    
    func fetchDataFromApi(apiKey: String){
        let api = "http://www.apilayer.net/api/historical?access_key="
        let endpoint = "&date=2019-03-03&currencies=USD,PLN&format=1"
        let url = URL(string: api + apiKey + endpoint)!
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                print("No data")
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            
            print("gotten json response dictionary is \n \(json)")
            // update UI using the response here
        }
        
        // execute the HTTP request
        task.resume()

    }



}

