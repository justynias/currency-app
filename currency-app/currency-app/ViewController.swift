//
//  ViewController.swift
//  currency-app
//
//  Created by RMS2018 on 13.03.2019.
//  Copyright © 2019 RMS2018. All rights reserved.
//

import UIKit
import iOSDropDown
import SwiftyJSON

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
    
    var currenciesArray : Array<Currency> = Array()
    
    func getApiKey() -> String {
        var keys:NSDictionary?
        if let path =  Bundle.main.path(forResource: "keys", ofType: "plist"){
            keys=NSDictionary(contentsOfFile: path)
        }
        let arrayOfKeys = keys?.allValues as! [String]

        return arrayOfKeys[0]
    }
    func prepareURLToFetch(param: String, apiKey: String, date: String="", inCurrenncy: String="", outCurrency: String="") -> String {
        let api = "http://www.apilayer.net/api/\(param)"
        let accessKey = "?access_key=\(apiKey)"
        if(param == "list"){
            return api + accessKey
        }
        let endpoint = "&date=\(date)&currencies=\(inCurrenncy),\(outCurrency)&format=1"
        return api + accessKey + endpoint
        
    }
    func fetchDataFromApi(url: String, completionHandler:@escaping (_ result: JSON) -> Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let mainURL = URL(string: url)
        
        let task = session.dataTask(with: mainURL!) { data, response, error in
            
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
            
            // serialise the data / NSData object into JSON OBJECT
            let jsonObj = JSON(content)
            completionHandler(jsonObj)
            
        }
        // execute the HTTP request
        task.resume()
        
    }
    func fetchCurrenciesList(){
        let key = getApiKey()
        let url = prepareURLToFetch(param: "list", apiKey: key)
        self.fetchDataFromApi(url: url) {
            result in
            let currencies = result["currencies"]
            for(key, value) in currencies {
                self.currenciesArray.append(Currency(shortName: key, fullName: value.stringValue))
            }
        }
    }
    func populateDropdowns(){
        DispatchQueue.global(qos: .background).async {
            self.fetchCurrenciesList()
            print(self.currenciesArray)
        }
        
        let shortNames = currenciesArray.map({ $0.shortName })
        currencyInDropDown.optionArray = shortNames
        currencyOutDropDown.optionArray = shortNames
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateDropdowns()
      
    }
}
    
    

    
   


