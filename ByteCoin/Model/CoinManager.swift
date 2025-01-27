//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
  func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
  func didFailWithError(error: Error)
}


struct CoinManager {
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
  let apiKey = "4772B840-EDEF-46B6-967B-A376F4DCEA6D"
  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  var delegate: CoinManagerDelegate?
  
  func getCoinPrice(for currency: String) {
    fetchCoin(for: currency)
  }
  
  func fetchCoin(for currencyName: String){
    let urlString = "\(baseURL)/\(currencyName)?apikey=\(apiKey)"
    performRequest(with: urlString)
  }
  
  func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        if let safeData = data {
          if let coin = self.parseJSON(safeData) {
            self.delegate?.didUpdateCoin(self, coin: coin)
          }
        }
      }
      
      task.resume()
    }
  }
  
  func parseJSON(_ coinData: Data) -> CoinModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(CoinData.self, from: coinData)
      let time = decodedData.time
      let asset_id_base = decodedData.asset_id_base
      let asset_id_quote = decodedData.asset_id_quote
      let rate = decodedData.rate
      return CoinModel(time: time, asset_id_base: asset_id_base, asset_id_quote: asset_id_quote, rate: rate)
    } catch {
      self.delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
