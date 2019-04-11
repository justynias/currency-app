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
    /* DropDowns have reverse order -> addSubview() !! */
    @IBOutlet weak var currencyOutDropDown: DropDown!
    @IBOutlet weak var currencyInDropDown: DropDown!
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
    func convertCurrencies(curIn: String, curOut:String, date: String, value: Double){
        let key = getApiKey()
        let url = self.prepareURLToFetch(param: "historical", apiKey: key, date: date, inCurrency: curIn, outCurrency: curOut)
        
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
        
        //need a validation!!
     
       // txtDatePicker.text = convertDate(datePicker.date)
        
        if let valueToConvert = Double(valueTextField.text!),
            let inCur = currencyIn, let outCur = currencyOut,
            let date = txtDatePicker.text{
            print("in: \(inCur), out: \(outCur), value:\(valueToConvert), date: \(date)")
            convertCurrencies(curIn: inCur, curOut: outCur, date: date, value: valueToConvert)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchCurrenciesList()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onConvertClickHandler(sender:)))
        self.convertButton.addGestureRecognizer(gesture)
        
        initDropDownSelectionListeners()
        //init date picker
        showDatePicker()
    }
    
    func initDropDownSelectionListeners(){
       
        currencyOutDropDown.didSelect{(currencyOut, index, id) in
        self.currencyOut = currencyOut
        }
        currencyInDropDown.didSelect{(currencyIn, index, id) in
            self.currencyIn = currencyIn}

    }
    
    /* Date Picker */
    
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    func  showDatePicker(){
        //foramt date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        txtDatePicker.text = convertDate(date: Date())
    }
    
    func convertDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    @objc func donedatePicker(){
        txtDatePicker.text = convertDate(date: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
 
}
    
    

    
   


