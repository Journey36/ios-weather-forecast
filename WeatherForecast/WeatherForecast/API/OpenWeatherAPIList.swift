//
//  OpenWeatherAPIList.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/09/03.
//

enum OpenWeatherAPIList {
    static let currentWeather = OpenWeatherAPI<CurrentWeatherData>(baseURL: "https://api.openweathermap.org/data/2.5/weather",
                                                                   apiKey: "d581ffc8458e8085899bfe16c04fe7da",
                                                                   units: .metric,
                                                                   language: .korean)
    static let fiveDayForecast = OpenWeatherAPI<WeatherForecastData>(baseURL: "https://api.openweathermap.org/data/2.5/forecast",
                                                                     apiKey: "d581ffc8458e8085899bfe16c04fe7da",
                                                                     units: .metric,
                                                                     language: .korean,
                                                                     count: 2)
}
