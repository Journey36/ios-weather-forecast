# 날씨 정보

>   현재 날씨와 5일 일기 예보를 알려주는 앱

<img width="260" alt="시연" src="https://user-images.githubusercontent.com/73573732/138604330-5247f6cf-af69-4d4a-8f3f-7569f2870666.gif"> <img width="260" alt="시연2" src="https://user-images.githubusercontent.com/73573732/138615713-1f7cdec1-1127-4e44-98d6-da3e109cf969.gif"> <img width="260" alt="시연3" src="https://user-images.githubusercontent.com/73573732/138723024-eb9260e3-cf3f-4702-9a2f-345e86bf7fcf.gif">

<br/>



## 목차

-   [프로젝트 정보](#프로젝트-정보)
-   [기능 및 트러블 슈팅](#기능-및-트러블-슈팅)
    -   [테이블 뷰 및 셀 구현](#테이블-뷰-및-셀-구현)
        -   [고민 또는 문제점](#고민-또는-문제점)
    -   [네트워크를 통한 데이터 로드](#네트워크를-통한-데이터-로드)
        -   [고민 또는 문제점](#고민-또는-문제점-2)
    -   [위치 서비스 권한 설정](#위치-서비스-권한-설정)
        -   [고민 또는 문제점](#고민-또는-문제점-3)
    -   [리프레시 컨트롤 구현](#리프레시-컨트롤-구현)
        -   [고민 또는 문제점](#고민-또는-문제점-4)
    -   [접근성 구현](#접근성-구현)
        -   [고민 또는 문제점](#고민-또는-문제점-5)

</br>



## 프로젝트 정보

-   코드 리뷰어: [delmaSong](https://github.com/delmaSong)
-   학습 키워드: `URLSession`, `CoreLocation`, `UIRefreshControl`, `UITraitCollection`

<br/>



## 기능 및 트러블 슈팅

### 테이블 뷰 및 셀 구현

|                             구조                             |
| :----------------------------------------------------------: |
| <img width="400" alt="테이블뷰 구조" src="https://user-images.githubusercontent.com/73573732/138659278-a6d1d3dc-849d-4a79-ab44-010bcb8be386.png"> |

`CurrentWeatherCell`은 현재 날씨 및 온도, 최고 및 최저 온도를 나타내고, `ForecastListCell`은 현재부터 5일 동안의 일기 예보(온도 및 날씨)를 나타냅니다.

<br/>



### 고민 또는 문제점

|                       고민                        |
| :-----------------------------------------------: |
| 앱의 뷰를 구성할 때, 어떤 방식으로 구현해야 할까? |

테이블 뷰를 구현할 때, 더 많은 방법이 있을 수 있지만, 제가 생각한 방법은 

1.   테이블뷰 헤더로 뷰를 분리하여 구현
2.   하나의 테이블 뷰의 섹션을 나누어 구현

이렇게 두 가지가 있었습니다. 첫 번째 방법은 헤더 뷰가 가지는 원래의 의미인, **해당 섹션에 대한 추가 정보를 표시하는 뷰**와는 다르게 사용하는 것 같아서 두 번째 방법을 택했습니다. 코드는 다른 사람이 읽기 쉬워야한다고 합니다. 그렇다면 그 시작은 설계자가 의도한대로 사용하는 것이 더 적절하다고 생각했습니다.

<br/>



|                     문제                     |
| :------------------------------------------: |
| 다른 두 셀의 구분선을 어떻게 숨길 수 있을까? |

테이블 뷰 전체의 separator 스타일은 `separatorStyle = .none` 으로 쉽게 적용할 수 있지만, 두 개의 다른 셀 사이의 하나의 구분선(separator)만 없애려면 해당 방법으로는 불가능했습니다. 그래서 약간의 편법으로 해당 `separatorInset`을 화면 밖으로 밀어내는 방법을 사용했습니다.

```swift
separatorInset.left = .greatestFiniteMagnitude // 유한한 값 중 가장 큰 값
```

<br/>



|                        문제                        |
| :------------------------------------------------: |
| 테이블 뷰에 배경화면을 적용하려면 어떻게 해야할까? |

`UITableView`에는 `backgroundView`라는 속성이 있어서 해당 속성에 이미지 리터럴을 넣어줬습니다. 하지만 셀이 로드되면서 해당 배경을 다 가려버리는 문제가 있었습니다.

<img width="300" alt="테이블 뷰 배경 이미지 이슈" src="https://user-images.githubusercontent.com/73573732/138690307-8655fa3c-65ae-48a2-9f72-a91ae3446ee8.gif">

해당 문제는 셀 `contentView`의 기본 배경 색상이 원인인 것 같아서 색상을 `clear`로 설정해주니 정상적으로 동작했습니다. 하지만 각 셀마다 설정해줘야 하는, 확장성이 떨어진다고 생각했습니다. 그래서 셀이 그려지기 직전에 호출되는 `tableView(_:willDisplay:forRowAt:)`에 해당 속성을 지정해주는 것이 좋겠다고 판단했습니다.

```swift
// Delegate Methods
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAtIndexPath: IndexPath) {
    cell.backgroundColor = .clear
}
```

[👆 목차로 돌아가기](#목차)

<br/>



## 네트워크를 통한 데이터 로드

|      객체      |                             설명                             |
| :------------: | :----------------------------------------------------------: |
| **URLManager** | API URL을 만들기 위한 객체입니다. `URLComponents`를 통해 `URLQueryItem`을 조합해서 생성하는 방식으로 구현했습니다. |

```swift
enum URLManager {
    private static let baseAPIURL: String = "http://api.openweathermap.org/data/2.5/"
    private static let baseIconURL: String = "https://openweathermap.org/img/wn/"
    private static let appID = Bundle.main.infoDictionary?["API_KEY"] as? String
    private static let units: String = "metric"
    
    static func setURL(_ coordinates: CurrentLocation, with type: ForecastType) throws -> URL? {
        guard let unwrappedAppID: String = appID else {
            throw ErrorTransactor.networkError(.invalidURL)
        }
        
        var components: URLComponents? = .init(string: baseAPIURL)
        components?.path += type.rawValue
        
        let latitude: URLQueryItem = .init(name: "lat", value: coordinates.latitude)
        let longitude: URLQueryItem = .init(name: "lon", value: coordinates.longitude)
        let units: URLQueryItem = .init(name: "units", value: units)
        let appID: URLQueryItem = .init(name: "appid", value: unwrappedAppID)
        components?.queryItems = [latitude, longitude, units, appID]
        return components?.url
    }

    static func setImageURL(of imageID: String) throws -> URL? {
        var components: URLComponents? = .init(string: baseIconURL)
        components?.path += "\(imageID)@2x.png"

        return components?.url
    }
}

```

| 객체                | 설명                                                         |
| ------------------- | ------------------------------------------------------------ |
| **DataTaskManager** | URLManager 타입을 활용해 URL을 만들고, 하나의 세션 생성 후, 이미지를 받아오는 작업(task)와 나머지 데이터를 받아오는 작업을 구현했습니다. 데이터를 받아오는 작업은 두 개의 다른 셀을 하나의 태스크로 처리하기 위해 제네릭 타입을 사용해 구현했습니다. `Result` 타입을 이용해 성공과 실패를 분기하여 구현했습니다. |

```swift
func fetchWeatherData<T: Decodable>(on coordinates: CurrentLocation, type: ForecastType, completion: @escaping (Result<T, ErrorTransactor>) -> Void) {
	guard let apiURL: URL = try? URLManager.setURL(coordinates, with: type) else {
		return
	}
        
	session.dataTask(with: apiURL) { (data: Data?, response: URLResponse?, error: Error?) in
		if let _: Error = error {
			completion(.failure(ErrorTransactor.networkError(.invalidURL)))
		}
            
		guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
			return completion(.failure(ErrorTransactor.networkError(.unexpactableResponse)))
		}
            
		guard let data: Data = data else {
			return completion(.failure(ErrorTransactor.networkError(.dataFetchingFailure)))
		}
            
		do {
			let decoder: JSONDecoder = .init()
			let weatherData: T = try decoder.decode(T.self, from: data)
			completion(.success(weatherData))
		} catch {
			completion(.failure(.networkError(.dataFetchingFailure)))
		}
            
	}.resume()
}
```

<br/>



### 고민 또는 문제점

|                             고민                             |
| :----------------------------------------------------------: |
| 동일한 구조의 데이터 처리 코드를 어떻게 하나로 합칠 수 있을까? |

현재 날씨를 보여주는 CurrentWeatherCell과 5일 예보를 보여주는 ForecastListCell은 보여주는 데이터만 다를 뿐, 받아오는 방법이 같습니다. 이 것을 다른 함수로, 또는 다른 태스크로 만들기에는 낭비라고 생각했습니다. 그래서 제네릭을 사용해서 하나의 함수에서 두 개의 작업을 한 번에 처리할 수 있도록 구현했습니다.

```swift
private let session: URLSession = .shared

func fetchWeatherData<T: Decodable>(on coordinates: CurrentLocation, type: ForecastType, completion: @escaping (Result<T, ErrorTransactor>) -> Void) {
        guard let apiURL: URL = try? URLManager.setURL(coordinates, with: type) else {
            return
        }
        
        session.dataTask(with: apiURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let _: Error = error {
                completion(.failure(ErrorTransactor.networkError(.invalidURL)))
            }
            
            guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure(ErrorTransactor.networkError(.unexpactableResponse)))
            }
            
            guard let data: Data = data else {
                return completion(.failure(ErrorTransactor.networkError(.dataFetchingFailure)))
            }
            
            do {
                let decoder: JSONDecoder = .init()
                let weatherData: T = try decoder.decode(T.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.networkError(.dataFetchingFailure)))
            }
            
        }.resume()
    }

```

<br/>



|                          문제                           |
| :-----------------------------------------------------: |
| API Key를 변수가 아닌 다른 방법으로 관리할 수는 없을까? |

**Info.plist**의 환경 변수로 API키를 작성하고 코드에서 해당 환경 변수를 가져오는 방법으로 처리했습니다.

(해당 방법을 사용하면 **Info.plist** 및 ***.xcconfig**를 소스코드에 올리면 아무 소용 없지만, 키가 노출되어도 크리티컬한 이슈가 아니기 때문에 확인용으로 Github에 업로드 했습니다.)

**[API Key를 숨기는 방법 정리](https://github.com/Journey36/TIL/blob/main/Xcode/HowToHideAPIKey.md)**

[👆 목차로 돌아가기](#목차)

<br/>



## 위치 서비스 권한 설정

|           앱을 사용하는 동안 허용(또는 한 번 허용)           |                          허용 안함                           |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img width="300" alt="권한 승인한 경우" src="https://user-images.githubusercontent.com/73573732/138706845-584d6f7d-a6a7-478f-b9c5-d9b9c5d29004.gif"> | <img width="300" alt="권한 거부했을 경우" src="https://user-images.githubusercontent.com/73573732/138706817-0f59dfe9-87d5-40ea-954d-4af41ca4e312.gif"> |

위치 서비스 권한을 허용하는 경우 API Key를 토대로 현재 위치의 데이터를 가지고 옵니다. 만약 위치 서비스 권한을 승인하지 않는 경우는 사용자가 위치 서비스 권한을 승인할 수 있도록 설정 앱으로 유도합니다.

<br/>



### 고민 또는 문제점

|                             문제                             |
| :----------------------------------------------------------: |
| 왜 `locationManager(_:didFailWithError:)`가 권한 승인을 하기 전에 호출될까? |
| <img width="500" alt="권한 승인 전 Fail" src="https://user-images.githubusercontent.com/73573732/138710632-ae5361ed-efd5-439c-8d2f-8db1cbfc4416.gif"> |

CLLocationManagerDelegate에서 위치 정보가 업데이트 될 때 호출되는 `locationManager(_:didUpdateLocations:)`는 항상 `locationManager(_:didFailWithError:)`와 함께 구현되어야 합니다. 이전 코드에서는 `viewDidLoad()`에서 위치 서비스를 요청했고, 일정 시간이 지나도 권한을 허용하지 않는 상황을 인지하고 `locationManager(_:didFailWithError:)`가 호출된 것입니다. 해당 메서드는 CLError 타입의 에러를 처리하는 것으로 확인했으며, 거부 의사를 표시하지 않고 다른 기타 문제가 발생했을 때는 위치 서비스 업데이트를 중지하는 처리를 했습니다.

```swift
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
	switch error {
	case CLError.denied:
		presentAlert(.locationSevicesRefusal)
	default:
		manager.stopUpdatingLocation()
	}
}
```

그리고 권한이 변경되었을 때 호출되는 메서드인 `locationManager(_:didChangeAuthorization:)`에서 상태에 따라 분기하도록  처리했습니다. 다만, 해당 메서드는 **iOS 14.0**부터 **deprecated** 됐기에, 새로운 버전으로도 표기해줬습니다.

**[`@unknown default`에 대한 정리](https://github.com/Journey36/TIL/blob/main/Swift/UnknownDefault.md)**

```swift
@available(iOS 14, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            presentAlert(.locationSevicesRefusal)
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
// MARK: - Deprecated in iOS 14.0
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            presentAlert(.locationSevicesRefusal)
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
```

<br/>



|                        고민                         |
| :-------------------------------------------------: |
| 위치 정확도에 대한 값은 어떤 것을 쓰는 것이 좋을까? |

위치 데이터의 정확도는 사용자가 앱을 사용하면서 느끼는 신뢰도의 큰 영향을 미친다고 생각합니다. 만약 정말 정확한 위치 데이터를 요구하는 서비스에서 적게는 수 백 미터에서 많게는 키로미터 단위의 오차가 난다면, 사용자는 해당 앱에 대한 신뢰도가 바닥을 칠 것입니다. 그렇다고 무작정 높은 위치 정확도 값을 사용하는 것도 그 만큼 많은 전력을 요구하기 때문에 무리가 있습니다. 날씨의 경우는 비교적 부정확한 위치 데이터를 사용해도 된다고 생각합니다. 정말 극단적으로 몇 발자국 옆에는 소나기가 오는데, 내가 있는 곳은 비가 오지 않는 그런 경우를 제외하고는 날씨는 광범위에 걸쳐서 나타나기 때문입니다. 가장 대략적인 값을 사용하는 `kCLLocationAccuracyReduced`는 **iOS 14.0**부터 지원하기 때문에 저는 `kCLLocationAccuracyThreeKilometers`를 사용했습니다.

**[Desired Accuracy Constants](https://github.com/Journey36/TIL/blob/main/iOS/Location/DesiredAccuracyConstants.md)에 대한 정리**

[👆 목차로 돌아가기](#목차)

<br/>



## 리프레시 컨트롤 구현

|                     새로고침(권한 승인)                      |                     새로고침(권한 거부)                      |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img width="300" src="https://user-images.githubusercontent.com/73573732/138734992-8bc6982f-86ba-4280-8506-b48c700379a1.gif"> | <img width="300" src="https://user-images.githubusercontent.com/73573732/138734960-44a22140-60dd-46f5-9495-813d60fa25a5.gif"> |

`UIRefreshControl`을 동작시키면 위치 정보를 업데이트함과 동시에 `UITableView`를 다시 로드하도록 구현했습니다.

<br/>



### 고민 또는 문제점

|                             문제                             |
| :----------------------------------------------------------: |
| 어떻게 데이터 로드가 완료되는 시점에 새로고침이 끝나도록 구현할까? |

`UIRefreshControl`의 타겟액션으로 지정된 함수에 업데이트와 종료 로직을 함께 구현했었습니다. 그랬을 때, 리프레시 컨트롤의 애니메이션이 먼저 종료되고 업데이트는 이후에 발생하는 문제가 있었습니다. 리로드가 빠르다면 딱히 문제점을 못 느낄 수 있지만, 네트워크 상태 또는 여러가지 원인에 의해서 로딩이 느려지는 경우는 혼란을 일으킬 수 있다고 생각했습니다. 그래서 데이터 로드가 완료되는 시점에

```swift
func finishRefreshing() {
	if forecastListView.refreshControl?.isRefreshing == true {
		manager.stopUpdatingLocation()
		DispatchQueue.main.async {
			self.refreshControl.endRefreshing()
		}
	}
}
```

해당 함수를 호출하여 해결했습니다.

[👆 목차로 돌아가기](#목차)

<br/>



## 접근성 구현

|                   다크 모드 및 볼드체 적용                   |                        다이나믹 타입                         |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img width="300" src="https://user-images.githubusercontent.com/73573732/138896860-6ee2388e-74cc-4e63-b0b4-12953a3f430d.gif"> | <img width="300" src="https://user-images.githubusercontent.com/73573732/138896521-c3843113-875a-4546-9c5a-4188dac6cbcd.gif"> |

저시력자를 위한 다이나믹 타입을 고려했습니다. 특히 **'더 큰 텍스트'** 옵션을 사용할 경우 텍스트 크기를 기존보다 5단계 더 증가할 수 있습니다. 해당 옵션의 크기를 사용했을 때, 사용자의 가독성을 위해 레이아웃이 자동으로 변경되도록 구현했습니다. 이에 따라 자동으로 볼드체 적용 옵션도 설정됩니다.

다크모드를 지원하기 위해 이미지도 두 가지 버전을 지원하며, `UILabel`도 자동으로 색상에 맞게 변경되도록 구현했습니다. 다크모드는 **iOS 13.0**부터 지원하기 때문에 `if #available`을 통해 분기처리 했습니다

<br/>



### 고민 또는 문제점

|                             문제                             |
| :----------------------------------------------------------: |
| 네트워크로 받아오는 이미지는 어떻게 다이나믹 타입으로 처리할 수 있을까? |

이미지 자체도 `adjustsImageSizeForAccessibilityContentSizeCategory` 속성을 `true`로 설정 및 오토 레이아웃을 통해 이미지 크기가 자동으로 조절되도록 할 수 있습니다. 하지만 날씨 API에서 받아오는 이미지 사이즈가 100 x 100이기 때문에 셀 높이가 너무 커져버리는 문제가 있었습니다. 그래서 이미지 사이즈를 `isAccessibilityCategory`를 통해 작은 사이즈와 큰 사이즈로 분리하여 처리했습니다.

```swift
private let imageViewHeight: CGFloat = 30
private let imageViewHeightForA11y: CGFloat = 105
//...
generalConstraints = [
    weatherIconImageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
    //...
]
accessibilityConstraints = [
    weatherIconImageView.heightAnchor.constraint(equalToConstant: 
                                                 imageViewHeightForA11y)
]
//...

private func updateLayoutConstraints() {
    //...
    if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
        NSLayoutConstraint.deactivate(generalConstraints)
        NSLayoutConstraint.activate(accessibilityConstraints)
    } else {
        NSLayoutConstraint.activate(generalConstraints)
        NSLayoutConstraint.deactivate(accessibilityConstraints)
    }
}

override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
		updateLayoutConstraints()
	}
}
```

[👆 목차로 돌아가기](#목차)
