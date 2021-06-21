//
//  BaseViewController.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    deinit {
        self.activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Layout Constraints
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
        
//        self.setupStyle()
        self.view.addSubview(self.activityIndicatorView)
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupConstraints() {
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    func setupStyle() {
        self.activityIndicatorView.color = .black
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .systemGray
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = backItem
    }
}
