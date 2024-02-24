//
//  BoxOfficeMovieDTO.swift
//  BoxOffice
//
//  Created by 박찬호 on 2/20/24.
//

import Foundation

struct BoxOfficeMovieDTO {
    let rank: String
    let movieName: String
    let openDate: String
    let audienceCount: String
    let movicode: String
    
    init(rank: String = "", movieName: String = "", openDate: String = "", audienceCount: String = "", movicode: String = "") {
        self.rank = rank
        self.movieName = movieName
        self.openDate = openDate
        self.audienceCount = audienceCount
        self.movicode = movicode
    }
}
