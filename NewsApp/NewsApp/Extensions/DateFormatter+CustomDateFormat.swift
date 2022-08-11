//
//  DateFormatter+CustomDateFormat.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/11/22.
//

import Foundation

public enum CustomDateFormat: String {
    case apiDate = "yyyy-MM-dd'T'HH:mm:ssZ"
}

extension DateFormatter {
    convenience init(customDateFormat: CustomDateFormat) {
        self.init()
        self.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormat = customDateFormat.rawValue
    }
}
