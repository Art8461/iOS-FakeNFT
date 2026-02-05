//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Artem Kuzmenko on 25.01.2026.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var dto: Dto? { nil }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
