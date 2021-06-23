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
import DropDown
import RxGesture

import ReactorKit

final class HomeViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = HomeViewReactor
    
    // MARK: Constants
    struct Reusable {
        static let postCell = ReusableCell<PostCell>()
    }
    
    struct Metric {
        static let tableViewCellHeight = 130.f
    }
    
    struct Font {
        
    }
    
    // MARK: - Properties
    fileprivate let dataSource: RxTableViewSectionedReloadDataSource<HomeViewSection>
    
    // MARK: - UI
    let searchDropDown = DropDown()
    
    let refreshControl = RefreshControl()
    
    let searchField = UISearchBar().then {
        $0.placeholder = "검색하기"
        $0.returnKeyType = .default
        $0.enablesReturnKeyAutomatically = false
    }
    
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    
    lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(Reusable.postCell)
        $0.refreshControl = self.refreshControl
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
        self.view.addSubview(self.tableView)
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchField
        self.navigationItem.rightBarButtonItem = searchButton
        
        self.searchDropDown.anchorView = self.searchField
        self.searchDropDown.width = self.view.bounds.width - 80
        self.searchDropDown.bottomOffset = CGPoint(x: 5, y: (self.navigationController?.navigationBar.frame.height)! + 15 )
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
            .map { _ in Reactor.Action.loadSearchHistory }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.rx.isReachedBottom
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.searchField.rx.text.orEmpty
            .map(Reactor.Action.updateSearchWord)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.searchButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { [weak self] _ in
                self?.searchField.resignFirstResponder()
                return Reactor.Action.refresh
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.searchDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchDropDown.clearSelection()
            self.searchField.resignFirstResponder()
            
            self.searchField.text = item
            self.reactor?.action.onNext(.updateSearchWord(item))
            self.reactor?.action.onNext(.refresh)
        }
        
        // MARK: - state
        reactor.state.map { $0.section }
            .distinctUntilChanged()
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.query }
            .distinctUntilChanged()
            .map { $0 != "" }
            .bind(to: self.searchButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.searchHistory }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] list in
                self?.searchDropDown.dataSource = list.reversed()
            })
            .disposed(by: disposeBag)
        
        reactor.error
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: error?.errorType, message: error?.message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // MARK: - view
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .bind(to: self.tableView.rx.deselectRow)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
            .subscribe(onNext: { section in
                switch section {
                case let .postItem(cellReactor):
                    reactor.action.onNext(Reactor.Action.postSelected(cellReactor.post))
                }
            })
            .disposed(by: disposeBag)
        
        self.searchField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.searchDropDown.show()
            })
            .disposed(by: disposeBag)
        
        self.searchField.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.tableViewCellHeight
    }
}
