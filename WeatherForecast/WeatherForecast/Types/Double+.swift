//
//  Double+.swift
//  WeatherForecast
//
//  Created by Journey36 on 2021/09/25.
//

import Foundation

extension Double {
    var tenthsRounded: Double {
        return (self * 10).rounded() / 10
    }
}
