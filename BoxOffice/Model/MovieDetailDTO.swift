//
//  MovieDetailDTO.swift
//  BoxOffice
//
//  Created by 박찬호 on 2/16/24.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let movieCode: String
    let movieName: String
    let movieNameEnglish: String
    let runningTime: String
    let productionYear: String
    let openDate: String
    let status: String
    let movieType: String
    let genres: [String]
    let directors: [String]
    
    private enum CodingKeys: String, CodingKey {
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case movieNameEnglish = "movieNmEn"
        case runningTime = "showTm"
        case productionYear = "prdtYear"
        case openDate = "openDt"
        case status = "prdtStatNm"
        case movieType = "typeNm"
        case genres
        case directors
    }
}
