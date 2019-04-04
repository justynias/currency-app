//
//  Currency.swift
//  currency-app
//
//  Created by lukasz on 03/04/2019.
//  Copyright © 2019 RMS2018. All rights reserved.
//

import Foundation

struct Currency : Decodable {
    let shortName : String
    let fullName: String
    init(shortName: String, fullName: String) {
        self.shortName = shortName
        self.fullName = fullName
    }
}
