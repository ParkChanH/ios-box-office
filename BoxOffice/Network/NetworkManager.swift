//
//  NetworkManager.swift
//  BoxOffice
//
//  Created by 박찬호 on 2/20/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "f5eef3421c602c6cb7ea224104795888"
    private let session = URLSession(configuration: .default)
    
    private init() {}
    
    private func performRequest<T: Decodable>(with url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.requestFiled))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
    
    func fetchDailyBoxOffice(for date: String, completion: @escaping (Result<[BoxOfficeMovieDTO], NetworkError>) -> Void) {
        var components = URLComponents(string: "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "targetDt", value: date)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.badURL))
            return
        }
        
        performRequest(with: url) { (result: Result<BoxOfficeData, NetworkError>) in
            switch result {
            case .success(let data):
                let boxOfficeMovies = data.boxOfficeResult.dailyBoxOfficeList.map { boxOffice -> BoxOfficeMovieDTO in
                    BoxOfficeMovieDTO(rank: boxOffice.rank,
                                      movieName: boxOffice.movieName,
                                      openDate: boxOffice.openDate,
                                      audienceCount: boxOffice.audienceCount,
                                      movicode: boxOffice.movieCd)
                }
                completion(.success(boxOfficeMovies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetail(for movieCd: String, completion: @escaping (Result<MovieDatailDTO, NetworkError>) -> Void) {
        var components = URLComponents(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "movieCd", value: movieCd)
        ]
        
        guard let url = components?.url else {
            completion(.failure(.badURL))
            return
        }
        
        performRequest(with: url) { (result: Result<MovieInfoResponse, NetworkError>) in
            switch result {
            case .success(let data):
                let movie = data.movieInfoResult.movieInfo
                let movieDetail = MovieDatailDTO(movieCode: movie.movieCode,
                                                 movieName: movie.movieName,
                                                 movieNameEn: movie.movieNameEn,
                                                 runningTime: movie.runningTime,
                                                 productionYear: movie.productionYear,
                                                 openDate: movie.openDate,
                                                 movieType: movie.movieType,
                                                 genres: movie.genres.map { $0.genreName },
                                                 directors: movie.directors.map{ $0.peopleName }
                )
                completion(.success(movieDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
