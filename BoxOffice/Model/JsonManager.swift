//
//  JsonManager.swift
//  BoxOffice
//
//  Created by Jin-Mac on 2/22/24.
//

import Foundation

typealias UseCaseResult<T> = ((Result<T, NetworkError>) -> Void)

struct JsonManager {
    let network: NetworkManagerProtocol
    
    init() {
        self.network = NetworkManager()
    }
    
//    private func decodeJson<T: Decodable>(url: URL, jsonType type: T.Type, completion: @escaping UseCaseResult<Decodable>) {
//        network.request(request: .get, url: url, body: nil) { result in
//            switch result {
//            case .success(let data):
//                guard let response = try? JSONDecoder().decode(type.self, from: data) else {
//                    completion(.failure(.invalidURL))
//                    return
//                }
//                completion(.success(response))
//            case .failure(_):
//                completion(.failure(.unsuccessfulResponse))
//            }
//        }
//    }
    
    func fetchFromServer<T: Decodable>(path: String, query: [URLQueryItem], type: T.Type, completion: @escaping (NetworkResult<T>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "kobis.or.kr"
        urlComponents.path = path
        urlComponents.queryItems = query
        guard let url = urlComponents.url else { print("badUrl"); return }
        
//        var pasingData: Data = Data()
        network.request(request: .get, url: url, body: nil) { result in
            switch result {
            case .success((let data, let response)):
                let networkResult = judgeStatus(by: response.statusCode, data, type: type)
                completion(networkResult)
                
            case .failure(_):
                completion(.networkFail)
            }
        }
        
//        var resultData: T
//        decodeJson(url: url, jsonType: type) { result in
//            switch result {
//            case .success(let successData):
//                print(successData)
//                completion(.success(successData))
//                return
//            case .failure(_):
//                completion(.failure(.invalidURL))
//            }
//        }
    }
}

enum NetworkResult<T> {
    case success(T)
    case requestError(T)
    case pathError
    case InternalServerError
    case networkFail
}

// 디코딩 작업, 디코딩 결과로 상태 코드별 분기처리
func judgeStatus<T: Decodable>(by statusCode: Int, _ data: Data?, type: T.Type) -> NetworkResult<T> {
    let decoder = JSONDecoder()
    guard let data = data,
          let decodedData = try? decoder.decode(T.self, from: data) else {
        return .pathError
    }
    
    switch statusCode {
    case 200..<300:
        return .success(decodedData)
    case 400..<500:
        return .requestError(decodedData)
    case 500..<600:
        return .InternalServerError
    default:
        return .networkFail
    }
}
