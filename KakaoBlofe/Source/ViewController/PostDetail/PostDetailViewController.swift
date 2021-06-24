//
//  PostDetailViewController.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/24.
//

import UIKit

import ReactorKit

final class PostDetailViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = PostDetailViewReactor
    
    // MARK: Constants
    struct Metric {
        static let stackViewLeftRight = 25.f
        static let stackViewTop = 40.f
        static let thumbnailImageViewHeight = 200.f
        static let urlButtonWidth = 60.f
        static let horizontalStackViewHeight = 60.f
        static let urlButtonCornerRadius = 5.f
    }
    
    struct Font {
        static let nameLabel = UIFont.systemFont(ofSize: 15, weight: .black)
        static let titleLabel = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let contentsLabel = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let dateLabel = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    lazy var verticalStackView = UIStackView(
        arrangedSubviews: [
            thumbnailImageView,
            nameLabel,
            titleLabel,
            contentsLabel,
            dateLabel,
            horizontalStackView
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 25
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var horizontalStackView = UIStackView(
        arrangedSubviews: [
            urlLabel,
            urlButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let nameLabel = UILabel().then {
        $0.font = Font.nameLabel
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 2
    }
    
    let contentsLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = Font.dateLabel
    }
    
    let urlLabel = UILabel().then {
        $0.textColor = .systemBlue
        $0.numberOfLines = 2
    }
    
    let urlButton = UIButton().then {
        $0.setImage(UIImage(named: "urlIcon"), for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = Metric.urlButtonCornerRadius
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.verticalStackView)
    }
    
    override func setupConstraints() {
        self.verticalStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.stackViewLeftRight)
            make.right.equalToSuperview().offset(-Metric.stackViewLeftRight)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Metric.stackViewTop)
        }
        
        self.thumbnailImageView.snp.makeConstraints { make in
            make.height.equalTo(Metric.thumbnailImageViewHeight)
        }
        
        self.urlButton.snp.makeConstraints { make in
            make.width.equalTo(Metric.urlButtonWidth)
        }
        
        self.horizontalStackView.snp.makeConstraints { make in
            make.height.equalTo(Metric.horizontalStackViewHeight)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - State
        reactor.state.map { $0.thumbnail }
            .bind(to: self.thumbnailImageView.rx.image(placeholder: UIImage(named: "placeholder")))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .map { $0.htmlToAttributedString(font: Font.titleLabel, color: .black) }
            .bind(to: self.titleLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.contents }
            .map { $0.htmlToAttributedString(font: Font.contentsLabel, color: .brown) }
            .bind(to: self.contentsLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
            .subscribe(onNext: { [weak self] date in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                self?.dateLabel.text = dateFormatter.string(from: date)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.url.absoluteString }
            .bind(to: self.urlLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.kind.rawValue }
            .subscribe(onNext: { [weak self] postKind in
                self?.title = postKind
            })
            .disposed(by: disposeBag)
        
        // MARK: - View
        self.urlButton.rx.tap
            .map { Reactor.Action.navigateToURLPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
