//
//  MainBuilder.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation
import UIKit

class MainBuilder: NSObject {
    class func getView(module: ModuleEnum) -> UIViewController {
        switch module {
        case .home:
            let homeViewController = HomeViewController()
            homeViewController.homeViewModel = HomeViewModel(homeUseCase: MainInjection.provideHome())
            homeViewController.modalPresentationStyle = .fullScreen
            
            return homeViewController
        }
    }
}
