//
//  HomeViewController.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit
import Then
import ReusableKit
import RxDataSources
import RxViewController

import ReactorKit

final class HomeViewController: BaseViewController, View {
    
    typealias Reactor = HomeViewReactor
    
    // MARK: Constants
    struct Reusable {
        static let postCell = ReusableCell<PostCell>()
    }
    
    struct Metric {
        
    }
    
    struct Font {
        
    }

    // MARK: - Properties
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<HomeViewSection>

    // MARK: - UI
    let searchField = UISearchBar().then {
        $0.placeholder = "검색하기"
    }
    
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    
    lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(Reusable.postCell)
    }
    
    static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<HomeViewSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                let cell = tableView.dequeue(Reusable.postCell, for: indexPath)
                switch sectionItem {
                case let .postItem(reactor):
                    cell.reactor = reactor
                    return cell
                }
            }
        )
    }

    // MARK: - Initializing
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        self.dataSource = Self.dataSourceFactory()
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tableView)
        
        self.navigationItem.titleView = searchField
        self.navigationItem.rightBarButtonItem = searchButton
    }

    override func setupConstraints() {
        super.setupConstraints()
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configuring
    func bind(reactor: Reactor) {
        // MARK: - action
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        
        // MARK: - state
        reactor.state.map { $0.section }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
