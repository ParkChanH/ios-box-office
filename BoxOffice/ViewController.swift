//
//  ViewController.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetail()
        fetchDailyBoxOffice()
    }
    
    private func fetchMovieDetail() {
        let movieCode = "20236180"
        NetworkManager.shared.fetchMovieDetail(for: movieCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movieDetailDTO):
                    print("영화 코드: \(movieDetailDTO.movieCode)")
                    print("영화 이름: \(movieDetailDTO.movieName)")
                    print("영화 영문 이름: \(movieDetailDTO.movieNameEn)")
                    print("상영 시간: \(movieDetailDTO.runningTime)")
                    print("제작 년도: \(movieDetailDTO.productionYear)")
                    print("개봉일: \(movieDetailDTO.openDate)")
                    print("영화 타입: \(movieDetailDTO.movieType)")
                    print("장르: \(movieDetailDTO.genres.joined(separator: ", "))")
                    print("감독: \(movieDetailDTO.directors.joined(separator: ", "))")
                case .failure(let error):
                    print("영화 상세정보 못가져옴: \(error)")
                }
            }
        }
    }
    
    private func fetchDailyBoxOffice() {
        NetworkManager.shared.fetchDailyBoxOffice(for: "20240218") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let boxOfficeMovies):
                    for movie in boxOfficeMovies {
                        print("-----------------------------")
                        print("순위: \(movie.rank)")
                        print("영화 이름: \(movie.movieName)")
                        print("개봉일: \(movie.openDate)")
                        print("관객 수: \(movie.audienceCount)명")
                        print("무비 코드: \(movie.movicode)")
                        print("-----------------------------")
                    }
                case .failure(let error):
                    print("박스오피스 데이터를 가져오는데 실패 \(error)")
                    
                }
            }
        }
    }
    
    private func fatchMovieDatail() {
        let movieCode = "20236180"
        
        NetworkManager.shared.fetchMovieDetail(for: movieCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movieDetail):
                    print("-----------------------------")
                    print("영화 코드: \(movieDetail.movieCode)")
                    print("영화 이름: \(movieDetail.movieName)")
                    print("영화 영문 이름: \(movieDetail.movieNameEn)")
                    print("상영 시간: \(movieDetail.runningTime)분")
                    print("제작 연도: \(movieDetail.productionYear)")
                    print("개봉일: \(movieDetail.openDate)")
                    print("영화 타입: \(movieDetail.movieType)")
                    print("장르: \(movieDetail.genres.joined(separator: ", "))")
                    
                    if !movieDetail.directors.isEmpty {
                        print("감독: \(movieDetail.directors.joined(separator: ", "))")
                    } else {
                        print("감독 정보 없음")
                    }
                    
                    print("-----------------------------")
                case .failure(let error):
                    print("영화 상세 정보를 가져오는데 실패했습니다: \(error)")
                }
            }
        }
    }
}
