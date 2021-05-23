//
//  CounterSelectorView.swift
//  CountrySelector
//
//  Created by MoHamed Shaat on 1/24/19.
//  Copyright © 2019 shaat. All rights reserved.
//

import Foundation

protocol CounterySelectorView {
    func onSucessLoadingCountries(counteries: [Character : [Country]])
    func onSucessLoadingCountry(regionCode: String, country: Country?)
    
}
