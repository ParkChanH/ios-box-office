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
    func fetchDailyBoxOffice(for date: String, completion: @escaping (Result<[BoxOfficeMovieDTO], NetworkError>) -> Void) {
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
                let boxOfficeMovies = result.boxOfficeResult.dailyBoxOfficeList.map { dailyBoxOffice -> BoxOfficeMovieDTO in
                    return BoxOfficeMovieDTO(
                        rank: dailyBoxOffice.rank,
                        movieName: dailyBoxOffice.movieName,
                        openDate: dailyBoxOffice.openDate,
                        audienceCount: dailyBoxOffice.audienceCount,
                        movicode: dailyBoxOffice.movieCd
                    )
                }
                completion(.success(boxOfficeMovies))
            } catch {
                print("파싱 중 에러가 발생했습니다: \(error)")
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
    
    func fetchMovieDetail(for movieCd: String, completion: @escaping (Result<MovieDetailDTO, NetworkError>) -> Void) {
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
                
                let movieInfoResponse = try decoder.decode(MovieInfoResponse.self, from: data)
                
                let movieInfo = movieInfoResponse.movieInfoResult.movieInfo
                let movieDetailDTO = MovieDetailDTO(
                    movieCode: movieInfo.movieCd,
                    movieName: movieInfo.movieNm,
                    movieNameEnglish: movieInfo.movieNmEn,
                    runningTime: movieInfo.showTm,
                    productionYear: movieInfo.prdtYear,
                    openDate: movieInfo.openDt,
                    status: movieInfo.prdtStatNm,
                    movieType: movieInfo.typeNm,
                    genres: movieInfo.genres.map{ $0.genreNm },
                    directors: movieInfo.directors.map{$0.peopleNm}
                )
                completion(.success(movieDetailDTO))
            } catch {
                print("파싱 중 에러가 발생했습니다: \(error)")
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
}
