//
//  Currencies.swift
//  PrecoEuroApi
//
//  Created by Luan.Lima on 30/04/23.

import Foundation

// MARK: - Currencies
public struct Currencies: Decodable {
    public let eurbrl: Brl
    
    enum CodingKeys: String, CodingKey {
        case eurbrl = "EURBRL"
    }
    
    public init(usdbrl: Brl, eurbrl: Brl) {
        self.eurbrl = eurbrl
    }
}

// MARK: - Brl
public struct Brl: Decodable {
    public let bid: String
    
    enum CodingKeys: String, CodingKey {
        case bid
    }
    
    public init(bid: String) {
        self.bid = bid
    }
}



