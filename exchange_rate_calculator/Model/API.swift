//
//  API.swift
//  exchange_rate_calculator
//
//  Created by kiakim on 1/18/24.
//

import Foundation



extension ViewController {
    
    func getExchangeRate(completionHandler: @escaping (Bool) -> Void) {
        let key = "53b376d6c42f0954c7fa770d5dc2ee6a&currencies=KRW,%20JPY,%20PHP&source=USD&format=1"
        let requestURL = "http://apilayer.net/api/live?access_key=\(key)"
        
        guard let url = URL(string: requestURL) else {
            completionHandler(false)
            return
        }
        //네트워크 요청 수행
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error!: \(error.localizedDescription)")
                completionHandler(false)
                return
            }
            guard let data = data else {
                completionHandler(false)
                return
            }
            do {
                let decoder = JSONDecoder()
                let exchangeRateResponse = try decoder.decode(ExchangeRateResponse.self, from: data)
                
                // UI update
                DispatchQueue.main.async {
                    
                    //optionalDoble
                    let valueKRW = exchangeRateResponse.quotes["USDKRW"]
                    let valueJPY = exchangeRateResponse.quotes["USDJPY"]
                    let valuePHP = exchangeRateResponse.quotes["USDPHP"]
                    
                    
                    if let selectCurrency = self.recipentCountryButton.titleLabel?.text{
                        
                        switch selectCurrency {
                        case CurrencyType.KRW.rawValue :
                            
                            if let unwrappedValueKRW = valueKRW {
                                self.exchangeRatePrice.text = self.formatDoubleToString(unwrappedValueKRW)
                                self.pureExchangeRate = unwrappedValueKRW
                            }
                            
                        case CurrencyType.JPY.rawValue :
                            if let unwrappedValueJPY = valueJPY {
                                self.exchangeRatePrice.text = self.formatDoubleToString(unwrappedValueJPY)
                                self.pureExchangeRate = unwrappedValueJPY
                            }
                        case CurrencyType.PHP.rawValue:
                            if let unwrappedValuePHP = valuePHP {
                                self.exchangeRatePrice.text = self.formatDoubleToString(unwrappedValuePHP)
                                self.pureExchangeRate = unwrappedValuePHP
                            }
                        default:
                            if let unwrappedValueKRW = valueKRW {
                                self.exchangeRatePrice.text = self.formatDoubleToString(unwrappedValueKRW)
                                self.pureExchangeRate = unwrappedValueKRW
                            }
                        }
                    }
                    completionHandler(true)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                print("Your monthly usage limit has been reached. ")
                completionHandler(false)
            }
        }
        task.resume()
    }
    
    
    func formatDoubleToString(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if let formattedString = formatter.string(from: NSNumber(value: value)) {
            return formattedString
        } else {
            return "\(value)"
        }
    }
    
    
}
