//
//  RelativeDateTimeFormatterType.swift
//  Moments
//
//  Created by Jake Lin on 25/7/21.
//

import Foundation

protocol RelativeDateTimeFormatterType {
    var unitsStyle: RelativeDateTimeFormatter.UnitsStyle { get set }

    func localizedString(for date: Date, relativeTo referenceDate: Date) -> String
}

extension RelativeDateTimeFormatter: RelativeDateTimeFormatterType { }
