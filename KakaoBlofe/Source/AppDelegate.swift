//
//  AppDelegate.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit
import RxSwift
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    let serviceProvider = ServiceProvider()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("❇️ will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("✅ did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow(provider: self.serviceProvider)
        
        Flows.use(appFlow, when: .created) { root in
            self.window?.rootViewController = root
        }
        
        let nextStepper = OneStepper(withSingleStep: BlofeStep.homeIsRequired)
        self.coordinator.coordinate(flow: appFlow, with: nextStepper)
        
        return true
    }
}
