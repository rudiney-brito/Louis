//
//  NetworkManager.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode
    case invalidData
}

protocol NetworkManagerProtocol {
    func getResource<T: Decodable>(url: URL, decoder: JSONDecoder) async throws -> T
}

extension NetworkManagerProtocol {
    func getResource<T: Decodable>(url: URL, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: .init(url: url))
            guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                throw NetworkError.invalidStatusCode
            }
//            guard let url = Bundle.main.url(forResource: "customer", withExtension: "json") else {
//                throw NetworkError.invalidStatusCode
//            }
//            guard let data = try? Data(contentsOf: url) else {
//                throw NetworkError.invalidData
//            }
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw error
        }
    }

}

extension URLSession: NetworkManagerProtocol {}

class NetworkManager: NetworkManagerProtocol {
        
    let session: NetworkManagerProtocol
    
    init(session: NetworkManagerProtocol = URLSession.shared) {
        self.session = session
    }    
}
