//
//  NetworkService.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    func getRequest(with endpoint: NetworkConfig.Endpoint, parameters: [String: String], authToken: Bool = false, completionHandler: @escaping ((AFDataResponse<Any>) -> ())) {
        let token = AuthUser.getAuthUser()?.authToken ?? ""
        guard let url = URL(string: NetworkConfig.baseURL + endpoint.rawValue + (authToken ? token : "")) else {
            return
        }
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let json):
                print(json)
            case .failure(let error):
                print(error)
            }
            completionHandler(response)
        }
    }
}
