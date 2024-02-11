//
//  Bundle+Extension.swift
//  BitsoTests
//
//  Created by Néstor Valdez on 2/10/24.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type,
                              from file: String,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw TestError(description: "Failed to locate \(file) in bundle.")
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy

        return try decoder.decode(T.self, from: data)
    }
}
