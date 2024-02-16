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
                    let movieInfo = movieDetailDTO.movieInfoResult.movieInfo
                    print("영화 이름: \(movieInfo.movieNm)")
                    print("영화 영문 이름: \(movieInfo.movieNmEn)")
                    print("제작년도: \(movieInfo.prdtYear)")
                    print("개봉일: \(movieInfo.openDt)")
                    print("상태: \(movieInfo.prdtStatNm)")
                    print("영화 타입: \(movieInfo.typeNm)")
                    print("장르: \(movieInfo.genres.map { $0.genreNm }.joined(separator: ", "))")
                    print("감독: \(movieInfo.directors.map { $0.peopleNm }.joined(separator: ", "))")
                case .failure(let error):
                    print("영화 상세 정보를 가져오는 데 실패했습니다: \(error)")
                }
            }
        }
    }
    
    private func fetchDailyBoxOffice() {
        NetworkManager.shared.fetchDailyBoxOffice(for: "20240215") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let boxOfficeData):
                    let movies = boxOfficeData.boxOfficeResult.dailyBoxOfficeList
                    for movie in movies {
                        print("순위: \(movie.rank), 이름: \(movie.movieName), 개봉일: \(movie.openDate), 관객 수: \(movie.audienceCount)")
                    }
                    
                case .failure(let error):
                    print("박스오피스 데이터를 가져오는 데 실패했습니다: \(error)")
                }
            }
        }
    }
}
