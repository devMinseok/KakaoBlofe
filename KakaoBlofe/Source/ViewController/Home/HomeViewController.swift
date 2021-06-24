//
//  HomeViewController.swift
//  KakaoBlofe
//
//  Created by 강민석 on 2021/06/21.
//

import UIKit
import Then
import ReusableKit
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
    
    // MARK: - UI
    let searchDropDown = DropDown()
    let filterDropDown = DropDown()
    
    let refreshControl = RefreshControl()
    
    let searchField = UISearchBar().then {
        $0.placeholder = "검색하기"
        $0.returnKeyType = .default
        $0.enablesReturnKeyAutomatically = false
    }
    
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    
    let tableViewHeader = FilterHeaderView(frame: CGRect(x: 0, y: 0, width: .zero, height: 50))
    
    lazy var tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(Reusable.postCell)
        $0.refreshControl = self.refreshControl
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
        self.view.addSubview(self.tableView)
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = self.tableViewHeader
        
        self.navigationItem.titleView = searchField
        self.navigationItem.rightBarButtonItem = searchButton
        
        self.searchDropDown.anchorView = self.searchField
        self.searchDropDown.width = self.view.bounds.width - 80
        self.searchDropDown.bottomOffset = CGPoint(x: 5, y: (self.navigationController?.navigationBar.bounds.height)! + 10)
        
        self.filterDropDown.anchorView = self.tableViewHeader
        self.filterDropDown.width = self.view.bounds.width - 80
        self.filterDropDown.bottomOffset = CGPoint(x: 5, y: self.tableViewHeader.bounds.height)
        
        self.filterDropDown.dataSource = ["All", "Cafe", "Blog"]
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Configuring
extension HomeViewController {
    func bind(reactor: Reactor) {
        // MARK: - Action
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
        
        let searchButtonTap = self.searchButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .share()
        
        searchButtonTap
            .subscribe(onNext: { [weak self] in
                self?.searchField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        searchButtonTap
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchButtonTap
            .map { Reactor.Action.updateSearchHistory }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.searchDropDown.selectionAction = { [unowned self] index, item in
            self.searchDropDown.clearSelection()
            self.searchField.resignFirstResponder()
            
            self.searchField.text = item
            reactor.action.onNext(.updateSearchWord(item))
            reactor.action.onNext(.refresh)
            reactor.action.onNext(.updateSearchHistory)
        }
        
        self.filterDropDown.selectionAction = { [unowned self] index, item in
            self.filterDropDown.clearSelection()
            self.searchField.resignFirstResponder()
            
            switch item {
            case "All":
                self.tableViewHeader.filterButton.setTitle("All", for: .normal)
                reactor.action.onNext(.updateFilter(.all))
                
            case "Cafe":
                self.tableViewHeader.filterButton.setTitle("Cafe", for: .normal)
                reactor.action.onNext(.updateFilter(.cafe))
                
            case "Blog":
                self.tableViewHeader.filterButton.setTitle("Blog", for: .normal)
                reactor.action.onNext(.updateFilter(.blog))
                
            default:
                return
            }
            
            reactor.action.onNext(.refresh)
        }
        
        self.tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { model in
                reactor.action.onNext(Reactor.Action.postSelected(model))
            })
            .disposed(by: disposeBag)
        
        self.tableViewHeader.sortButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let titleAction = UIAlertAction(title: "Title", style: .default) { _ in
                    reactor.action.onNext(.updateSort(.titleAsc))
                }
                let dateTimeAction = UIAlertAction(title: "Datetime", style: .default) { _ in
                    reactor.action.onNext(.updateSort(.recency))
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                [titleAction, dateTimeAction, cancelAction].forEach(actionSheet.addAction)
                self?.present(actionSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.items }
            .distinctUntilChanged()
            .bind(to: self.tableView.rx.items) { tableView, index, element in
                guard let cell = tableView.dequeue(Reusable.postCell) else { return UITableViewCell() }
                cell.reactor = PostCellReactor(post: element, provider: reactor.provider)
                return cell
            }
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
        
        // MARK: - View
        self.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .bind(to: self.tableView.rx.deselectRow)
            .disposed(by: disposeBag)
        
        self.searchField.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.searchDropDown.show()
            })
            .disposed(by: disposeBag)
        
        self.tableViewHeader.filterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.filterDropDown.show()
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
