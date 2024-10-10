//
//  MainInjection.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation

class MainInjection: NSObject {
    class func provideHome() -> HomeUseCase {
        let homeRepository = HomeRepositories.sharedInstance
        
        return HomeIteractor(homeRepository: homeRepository)
    }
}
