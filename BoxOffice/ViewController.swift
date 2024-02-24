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
        jsonManager.fetchFromServer(path: "", query: URLQueryItem(name: "", value: ""), 
                                    type: BoxOfficeData.self) { networkResult in
            switch networkResult {
            case .success(let data):
                print(data)
            case .requestError(_):
                
            case .pathError:
                <#code#>
            case .serverError:
                <#code#>
            case .networkFail:
                <#code#>
            }
        }
    }
}

