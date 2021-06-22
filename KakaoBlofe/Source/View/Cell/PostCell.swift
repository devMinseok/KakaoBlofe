//
//  PostCell.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit

import ReactorKit

final class PostCell: BaseTableViewCell, View {
    typealias Reactor = PostCellReactor
    
    struct Font {
        static let kindLabel = UIFont.systemFont(ofSize: 20, weight: .black)
        static let nameLabel = UIFont.systemFont(ofSize: 20, weight: .medium)
        static let titleLabel = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let dateLabel = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    struct Metric {
        static let cellPadding = 15.f
        static let thumbnailSize = 100.f
        static let kindLabelWidth = 20.f
        static let nameLabelLeft = 5.f
        static let titleLabelTop = 5.f
    }
    
    let thumbnail = UIImageView()
    
    let kindLabel = UILabel().then {
        $0.font = Font.kindLabel
        $0.textColor = .orange
    }
    
    let nameLabel = UILabel().then {
        $0.font = Font.nameLabel
    }
    
    let titleLabel = UILabel().then {
        $0.numberOfLines = 2
    }
    
    let dateLabel = UILabel().then {
        $0.font = Font.dateLabel
        $0.textColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.thumbnail)
        self.contentView.addSubview(self.kindLabel)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.dateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.thumbnail.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Metric.cellPadding)
            make.width.height.equalTo(Metric.thumbnailSize)
            make.centerY.equalToSuperview()
        }
        
        self.kindLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.cellPadding)
            make.top.equalTo(Metric.cellPadding)
            make.width.equalTo(Metric.kindLabelWidth)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.kindLabel.snp.top)
            make.left.equalTo(self.kindLabel.snp.right).offset(Metric.nameLabelLeft)
            make.right.equalTo(self.thumbnail.snp.left).offset(-Metric.cellPadding)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Metric.titleLabelTop)
            make.left.equalToSuperview().offset(Metric.cellPadding)
            make.right.equalTo(self.thumbnail.snp.left).offset(-Metric.cellPadding)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metric.cellPadding)
            make.bottom.equalToSuperview().offset(-Metric.cellPadding)
            make.right.equalTo(self.thumbnail.snp.left).offset(-Metric.cellPadding)
        }
    }
    
    func bind(reactor: PostCellReactor) {
        // MARK: - action
        
        // MARK: - state
        reactor.state.map { $0.thumbnail }
            .bind(to: self.thumbnail.rx.image(placeholder: UIImage(named: "placeholder")))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.name }
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .map { $0.htmlToAttributedString(font: Font.titleLabel, color: .darkGray) }
            .bind(to: self.titleLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        //        reactor.state.map { $0.isWebPageRead }
        //            .bind(to: self.overlay.rx.isHidden)
        //            .disposed(by: disposeBag)
        
        reactor.state.map { $0.date }
            .subscribe(onNext: { [weak self] date in
                let calendar = Calendar.current
                
                if calendar.isDateInToday(date) {
                    self?.dateLabel.text = "오늘"
                } else if calendar.isDateInYesterday(date) {
                    self?.dateLabel.text = "어제"
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
                    self?.dateLabel.text = dateFormatter.string(from: date)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.kind }
            .subscribe(onNext: { [weak self] kind in
                switch kind {
                case .blog:
                    self?.kindLabel.text = "B"
                    
                case .cafe:
                    self?.kindLabel.text = "C"
                }
            })
            .disposed(by: disposeBag)
    }
}
