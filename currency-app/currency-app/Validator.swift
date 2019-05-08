//
//  Validator.swift
//  Pods
//
//  Created by Just on 08/05/2019.
//
import Foundation

class Validator{
    func isValueValid(value: String?) throws -> String{
        if ( value != nil) {
            do{
                if value!.range(of: "^(\\d*\\.)?\\d+$", options: .regularExpression) == nil {
                    throw ValidationError("Invalid value to convert")
                }
            }catch{
                throw ValidationError("Invalid value to convert")
            }
            return value!
            }
        else {  throw ValidationError("Enter value to convert") }
    }
    
    func isCurrencyValid(currency: String?) throws -> String{
        if(currency == nil){
              throw ValidationError("Invalid currency to convert")
        }
        return currency!
    }
    
    func isDateValid(date: String?)throws -> String{
        if(date != nil){
            do{
                if (date!.range(of: "^\\d{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$", options: .regularExpression) == nil
                    || isDateAfterToday(date: date!)){
                     throw ValidationError("Invalid date format")
                }
            }catch{
                 throw ValidationError("Invalid date format")
            }
            return date!
        }else{
             throw ValidationError("Enter date")
        }
    }
    
    func isDateAfterToday(date: String)->Bool{
        
        let  formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let inputDate = formatter.date(from: date)
        
        if(today.timeIntervalSince(inputDate!).isLess(than: 0)){
            return true
        }
        return false
    }
}

struct ValidationError: Error{
    var message: String
    
    init(_ message: String){
        self.message = message
    }
}
