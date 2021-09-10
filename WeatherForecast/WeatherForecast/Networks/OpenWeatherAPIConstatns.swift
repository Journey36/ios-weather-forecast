//
//  OpenWeatherAPIList.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/03.
//

enum OpenWeatherAPIConstatns {
    static let currentWeatherAPI = OpenWeatherAPI<CurrentWeatherData>(baseURL: "https://api.openweathermap.org/data/2.5/weather",
                                                                   apiKey: "d581ffc8458e8085899bfe16c04fe7da",
                                                                   units: .metric,
                                                                   language: .korean)
    static let fiveDayForecastAPI = OpenWeatherAPI<FiveDayForecastData>(baseURL: "https://api.openweathermap.org/data/2.5/forecast",
                                                                     apiKey: "d581ffc8458e8085899bfe16c04fe7da",
                                                                     units: .metric,
                                                                     language: .korean,
                                                                     count: nil)
    static let weatherIconBaseURL = "https://openweathermap.org/img/w/"
}
