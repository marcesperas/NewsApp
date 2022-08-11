//
//  String+Extension.swift
//  NewsApp
//
//  Created by Marc Jardine Esperas on 8/11/22.
//

import Foundation

extension String {
    func apiDate() -> Date? {
        let dateFormatter = DateFormatter(customDateFormat: .apiDate)
        return dateFormatter.date(from: self)
    }
}
