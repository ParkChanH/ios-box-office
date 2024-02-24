//
//  NetworkManager.swift
//  BoxOffice
//
//  Created by Jin-Mac on 2/20/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unsuccessfulResponse
    case APIInvalidResponse
    case unknownError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unsuccessfulResponse:
            return "Unsuccessful Response"
        case .APIInvalidResponse:
            return "API Invalid Response"
        case .unknownError(let message):
            return "Unkown error : \(message)"
        }
    }
}

enum RequestType: CustomStringConvertible {
    case get
    case post
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

protocol NetworkManagerProtocol {
    func request(request type: RequestType, url: URL, body: Data?, completion: @escaping ((Result<(Data?, HTTPURLResponse), NetworkError>) -> Void))
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(request type: RequestType = .get, url: URL, body: Data?, completion: @escaping ((Result<(Data?, HTTPURLResponse), NetworkError>) -> Void)) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = type.description
        urlRequest.httpBody = body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.unknownError(message: error?.localizedDescription ?? "Unkown")))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.unsuccessfulResponse))
                return
            }
            
            if !(200...500).contains(response.statusCode) {
                // 서버통신 실패
                completion(.failure(.unsuccessfulResponse))
            }
            
            completion(.success((data, response)))
        }.resume()
    }
}
