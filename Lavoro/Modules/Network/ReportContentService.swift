//
//  ReportContentService.swift
//  Lavoro
//
//  Created by Manish Agrawal on 15/11/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

enum AbuseType: String {
    case report = "report"
    case block = "block"
}

enum PostType: String {
    case feed = "post_id"
    case feedDetailComment = "comment_id"
    case publicProfileComment = "user_comment_id"
}

class ReportContentService: BaseModuleService {
    static let blockAllUserPosts = "block_all_user_posts"
    static let abuseType = "abuse_type"
    static let comments = "comments"
    
    func reportAbuse(with id: String, postType: PostType, blockAllUsers: Bool, abuseType: AbuseType, comments: String, completionHandler: @escaping ((Bool, String?) -> ())) {
        NS.postRequest(with: .reportAbuse, parameters: [postType.rawValue: id, ReportContentService.blockAllUserPosts: (blockAllUsers ? "yes" : "no"), ReportContentService.abuseType: abuseType.rawValue, ReportContentService.comments: comments], authToken: true) { [weak self] (response) in
            switch response.result {
            case .success(let json):
                if self?.getCode(from: json) == 201 {
                    completionHandler(true, self?.getMessage(from: json))
                } else {
                    completionHandler(false, self?.getMessage(from: json))
                }
            case .failure( _):
                completionHandler(false, "")
            }
        }
    }
}
