//
//  API.swift
//  exchange_rate_calculator
//
//  Created by kiakim on 1/18/24.
//

import Foundation



extension ViewController {
    
    func getExchangeRate(completionHandler: @escaping (Bool) -> Void) {
        let key = "81f7e820bf5ff21df050b52a3d6c5297&currencies=KRW,%20JPY,%20PHP&source=USD&format=1"
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
                //데이터 파싱
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]                {
                    
                    print("Received JSON: \(jsonDict)")

                    //UI 업데이트
                    DispatchQueue.main.async {
//                        self.weatherConditon = conditionCode
                     completionHandler(true)
                    }
                } else {
                    completionHandler(false)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completionHandler(false)
            }
        }
        task.resume()
    }
    
}
