//
//  UILabel+.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/10/06.
//

import UIKit

extension UILabel {
    func setDynamicType(style: UIFont.TextStyle) {
        adjustsFontForContentSizeCategory = true
        font = .preferredFont(forTextStyle: style)
    }
}
