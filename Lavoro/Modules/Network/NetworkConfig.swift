//
//  NetworkConfig.swift
//  Lavoro
//
//  Created by Manish on 06/06/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation

struct NetworkConfig {
    static let baseURL: String = "https://api.lavoro.network/"
    
    enum Endpoint: String{
        case login = "api/login/0/"
        case pinRequest = "api/send-pin-request/0/"
        case pinValidation = "api/validate-pin-request/0/"
        case facebookAuthentication = "api/facebook-login/0/"
        case updateUserAccountType = "api/update-user-account-type/"
        case updateUserProfile = "api/update-user-profile/"
        case imageUpload = "api/upload-image/"
        case dashboard = "api/get-my-dashboard/"
        case whoIFollow = "api/get-who-i-follow-list/"
        case followingMe = "api/get-my-following-list/"
        case addUserToFollow = "api/add-user-to-follow/"
        case removeUserToFollow = "api/remove-user-to-follow/"
        case userPublicProfile = "api/get-user-public-profile/"
        case addCommentsToPublicProfile = "api/add-comment-to-public-profile/"
        case searchUserByUsername = "api/search-user-by-username/"
        case followUser = "api/follow-user/"
        case removeFollowUser = "api/remove-follow-user/"
        case tagline = "api/tagline/"
        case addCheckinCheckout = "api/add-checkin-checkout/"
        case getMyQRcode = "api/get-my-qrcode/"
        case followUserByQR = "api/follow-user-by-qr/"
        case getMyWorkLocations = "api/get-my-work-locations/"
        case getMyUserProfile = "api/get-my-user-profile/"
        case sendGroupMessage = "api/send-group-message/"
        case getTheCheckinProfile = "api/get-the-checkin-profile/"
        case addCommentToCheckin = "api/add-comment-to-checkin/"
        case updateCheckinLike = "api/update-checkin-like/"
        case getMyBlacklist = "api/get-my-blacklist/"
        case updateMyBlacklist = "api/update-my-blacklist/"
        case addToMyCalendar = "api/add-to-my-calendar/"
        case getMyCalendar = "api/get-my-calendar/"
        case removeFromMyCalendar = "api/remove-from-my-calendar/"
        case getWhosWorkingListByDate = "api/get-whos-working-list-by-date/"
        case reportAbuse = "api/report-abuse/"

    }
}
