//
//  ImageService.swift
//  Lavoro
//
//  Created by Manish on 09/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit

class ImageService: BaseModuleService {
    func uploadImage(_ image: UIImage, completionHandler: @escaping ((Bool, String?) -> ())) {
        if let data = image.pngData() {
            NS.uploadImage(data: data) { (response) in
                switch response.result {
                case .success(let json):
                    print(json)
                    if let json = json as? [String: Any], let data = json["data"] as? [String: Any], let url = data["image"] as? String {
                        completionHandler(true, url)
                    } else {
                        completionHandler(false, nil)
                    }
                case .failure(let error):
                    print(error)
                    completionHandler(false, nil)
                }
            }
        } else {
            completionHandler(false, nil)
        }
    }
}
