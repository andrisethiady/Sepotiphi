//
//  HomeViewModel.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation

class HomeViewModel: NSObject {
    var homeUseCase: HomeUseCase
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
}
