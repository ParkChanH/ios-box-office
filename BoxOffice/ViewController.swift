//
//  ViewController.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//

import UIKit



class ViewController: UIViewController {
    
    let jsonManager = JsonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBoxOfficeData()
        
    }
    
    func fetchBoxOfficeData() {
        let urlPath  = "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        let queryItems = [
            URLQueryItem(name: "key", value: "f5eef3421c602c6cb7ea224104795888"),
            URLQueryItem(name: "targetDt", value: "20211011")]
        jsonManager.fetchFromServer(path: urlPath, query: queryItems,
                                    type: BoxOfficeData.self) { networkResult in
            switch networkResult {
            case .success(let data):
                let boxoffice = data as! BoxOfficeData
                print(boxoffice.boxOfficeResult.dailyBoxOfficeList[0].movieName)
            case .requestError(_):
                return
            case .pathError:
                return
            case .InternalServerError:
                return
            case .networkFail:
                return
            }
        }
    }
}


