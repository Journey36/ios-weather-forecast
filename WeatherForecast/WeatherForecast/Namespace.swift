//
//  Namespace.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/18.
//

import UIKit

enum TableView {
    static let separateInset: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
    static let numberOfSections: Int = 2

    static func estimateRowHeight(of section: Int) -> CGFloat {
        return section == 0 ? 60 : 30
    }
}

enum Units {
    static let temperatureUnit: String = "\u{2103}"
}
