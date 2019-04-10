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
    
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var currencyInDropDown: DropDown!

    @IBOutlet weak var currencyOutDropDown: DropDown!
    
    @IBOutlet weak var convertButton : UIButton!
    
    @IBOutlet weak var convertedValueLabel: UILabel!
    var currencyIn : String?
    var currencyOut : String?
    
    
    
    func getApiKey() -> String {
        var keys:NSDictionary?
        if let path =  Bundle.main.path(forResource: "keys", ofType: "plist"){
            keys=NSDictionary(contentsOfFile: path)
        }
        let arrayOfKeys = keys?.allValues as! [String]

        return arrayOfKeys[0]
    }
    func prepareURLToFetch(param: String, apiKey: String, date: String="", inCurrency: String="", outCurrency: String="") -> String{
        let api = "http://www.apilayer.net/api/\(param)"
        let accessKey = "?access_key=\(apiKey)"
        if(param == "list"){
            return api + accessKey
        }
        let endpoint = "&date=\(date)&currencies=\(inCurrency),\(outCurrency)&format=1"
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
        var newArray : Array<Currency> = Array()
        let key = self.getApiKey()
        let url = self.prepareURLToFetch(param: "list", apiKey: key)
        self.fetchDataFromApi(url: url) {
            // Callback for data fetched
            result in
            let currencies = result["currencies"]
            for(key, value) in currencies {
                newArray.append(Currency(shortName: key, fullName: value.stringValue))
            }
            // Populate dropdowns after data has been fetched with Array mapped only to its shortName
            self.populateDropdowns(currencies: newArray.map( { $0.shortName } ))
        }
    }
    func convertCurrencies(){
        
        let key = self.getApiKey()
        let currencies = ["PLN", "EUR"]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        let url = self.prepareURLToFetch(param: "historical", apiKey: key, date: result, inCurrency: currencies[0], outCurrency: currencies[1])
        
        self.fetchDataFromApi(url: url){
            result in
            print(result)
        }
    }
    func calculateCurrencies(base: Float, to: Float, ammount: Float) -> Float{
        return ammount*(base/to)
    }
    func populateDropdowns(currencies : Array<String>){
        self.currencyInDropDown.optionArray = currencies
        self.currencyOutDropDown.optionArray = currencies
        
    }
    @objc func onConvertClickHandler(sender: UITapGestureRecognizer){
        if let valueToConvert = valueTextField.text,
            let inCur = currencyIn, let outCur = currencyOut{
        print("in: \(inCur), out: \(outCur) value:\(valueToConvert)")}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCurrenciesList()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onConvertClickHandler(sender:)))
        self.convertButton.addGestureRecognizer(gesture)
        initDropDownSelectionListeners()
    }
    
    func initDropDownSelectionListeners(){
       
        currencyOutDropDown.didSelect{(currencyOut, index, id) in
        self.currencyOut = currencyOut
        }
        currencyInDropDown.didSelect{(currencyIn, index, id) in
            self.currencyIn = currencyIn}

    }
    
    @IBAction func currencyInEditingEnd(_ sender: Any) {
        print("ended")
    }
}
    
    

    
   


