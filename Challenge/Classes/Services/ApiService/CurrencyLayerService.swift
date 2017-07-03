//
//  CurrencyLayerService.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import SwiftyJSON

class CurrencyLayerService {
    private let apiKey: String
    private let source: String

    private var loadAvailableTask: URLSessionDataTask?
    private var loadRatesTask: URLSessionDataTask?

    init(apiKey: String, source: String) {
        self.apiKey = apiKey
        self.source = source
    }

    deinit {
        loadAvailableTask?.cancel()
        loadRatesTask?.cancel()
    }

    func loadAvailableCurrencies(_ completion: @escaping (Response<JSON>) -> Void) {
        guard let url = urlWith(basePath: CurrencyLayer.URL.list) else {
            return
        }

        let request = URLRequest(url: url)
        loadAvailableTask = URLSession.shared.dataTask(with: request) { [weak self] responseData in
            self?.handleResponse(responseData: responseData, completion: completion)
        }

        loadAvailableTask?.resume()
    }

    func loadExchangeRates(_ completion: @escaping (Response<JSON>) -> Void) {
        guard let url = urlWith(basePath: CurrencyLayer.URL.live) else {
            return
        }

        let request = URLRequest(url: url)
        loadRatesTask = URLSession.shared.dataTask(with: request) { [weak self] responseData in
            self?.handleResponse(responseData: responseData, completion: completion)
        }

        loadRatesTask?.resume()
    }

    private func urlWith(basePath: String) -> URL? {
        let path = "\(basePath)\(CurrencyLayer.Keys.accessKey)=\(apiKey)&\(CurrencyLayer.Keys.source)=\(source)"
        return URL(string: path)
    }

    private func handleResponse(responseData: (Data?, URLResponse?, Error?), completion: (Response<JSON>) -> Void) {
        let (_data, _, _error) = responseData
        guard _error == nil else {
            completion(.failure(CurrencyLayer.Error.general))
            return
        }

        guard let data = _data else {
            completion(.failure(CurrencyLayer.Error.general))
            return
        }

        let json = JSON(data: data)

        if json[CurrencyLayer.Keys.success].bool ?? false {
            completion(.success(json))
        } else {
            completion(.failure(CurrencyLayer.Error.service))
        }
    }
}
