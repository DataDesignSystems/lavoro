//
//  Onboarding.swift
//  Lavoro
//
//  Created by Manish on 29/04/20.
//  Copyright © 2020 Manish. All rights reserved.
//

import Foundation
import UIKit

struct OnboardingInfo {
    var imagename: String
    var title: String
    
    static func getOnboardingInfo() -> [OnboardingInfo]{
        return [OnboardingInfo(imagename: "onboarding_2", title: "Keeping the service industry connected"),
                OnboardingInfo(imagename: "onboarding_3", title: "Keeping the service industry connected"),
                OnboardingInfo(imagename: "onboarding_4", title: "Keeping the service industry connected")]
    }
}
