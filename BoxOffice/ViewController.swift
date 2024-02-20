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
        NetworkManager.shared.fetchMovieDetail(for: "20206946") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movieDetailDTO):
                    print("영화 코드: \(movieDetailDTO.movieCode)")
                    print("영화 이름: \(movieDetailDTO.movieName)")
                    print("영화 영문 이름: \(movieDetailDTO.movieNameEnglish)")
                    print("상영 시간: \(movieDetailDTO.runningTime)")
                    print("제작 년도: \(movieDetailDTO.productionYear)")
                    print("개봉일: \(movieDetailDTO.openDate)")
                    print("상태: \(movieDetailDTO.status)")
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
                        print("순위: \(movie.rank),이름: \(movie.movieName), 개봉일: \(movie.openDate), 관객 수: \(movie.audienceCount), 무비 코드: \(movie.movicode)")
                    }
                    
                case .failure(let error):
                    print("박스오피스 데이터를 가져오는 데 실패했습니다: \(error)")
                }
            }
        }
    }
}
