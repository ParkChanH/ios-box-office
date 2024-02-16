//
//  NetworkManager.swift
//  BoxOffice
//
//  Created by 박찬호 on 2/16/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
}

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "f5eef3421c602c6cb7ea224104795888"
    private let session = URLSession(configuration: .default)

    private init() {}
    
    // 오늘의 일일 박스오피스 조회
    func fetchDailyBoxOffice(for date: String, completion: @escaping (Result<BoxOfficeData, NetworkError>) -> Void) {
        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apiKey)&targetDt=\(date)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(BoxOfficeData.self, from: data)
                completion(.success(result))
            } catch {
                print("파싱 중 에러가 발생했습니다: \(error)")
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
    
    // 영화 개별 상세 조회
    func fetchMovieDetail(for movieCd: String, completion: @escaping (Result<MovieInfoResponse, NetworkError>) -> Void) {
        let urlString = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json?key=\(apiKey)&movieCd=\(movieCd)"

        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.requestFailed))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MovieInfoResponse.self, from: data)
                completion(.success(result))
            } catch {
                print("파싱 중 에러가 발생했습니다: \(error)")
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
}
