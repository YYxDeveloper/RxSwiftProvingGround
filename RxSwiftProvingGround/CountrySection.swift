//
//  CountrySection.swift
//  RxCollectionViewExample
//
//  Created by Alper Akinci on 28/12/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation
import RxDataSources

struct CountrySection {
    var header: String
    var countries: [String]
}

extension CountrySection: SectionModelType {

    typealias Item = String

    var items: [String] {
        return countries
    }

    init(original: CountrySection, items: [String]) {
        self = original
        self.countries = items
    }
}
