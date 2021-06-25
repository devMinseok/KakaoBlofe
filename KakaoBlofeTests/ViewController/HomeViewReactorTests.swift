//
//  HomeViewReactorTests.swift
//  KakaoBlofeTests
//
//  Created by 강민석 on 2021/06/25.
//

import XCTest
import Nimble
@testable import KakaoBlofe

import RxExpect
import RxTest

class HomeViewReactorTests: XCTestCase {
    
    // MARK: - 블로그 글 받아오기 테스트
    func testFetchPostsBlog() {
        let test = RxExpect()
        let provider = StubServiceProvider()
        let reactor = test.retain(HomeViewReactor(provider: provider))

        // Action
        test.input(reactor.action, [
            Recorded.next(1, .updateFilter(.blog)),
            Recorded.next(2, .refresh)
        ])
        
        // Assertion
        test.assert(reactor.state) { events in
            let state = events.elements
            expect(state.count) == 5
            
            expect(state[0].items.count) == 0
            
            // apply filter
            expect(state[1].filterType) == .blog
            
            // refresh
            expect(state[2].isRefreshing) == true
            expect(state[3].items.count) == 25
            expect(state[4].isRefreshing) == false
        }
    }
    
    // MARK: - 카페 글 받아오기 테스트
    func testFetchPostsCafe() {
        let test = RxExpect()
        let provider = StubServiceProvider()
        let reactor = test.retain(HomeViewReactor(provider: provider))

        // Action
        test.input(reactor.action, [
            Recorded.next(1, .updateFilter(.cafe)),
            Recorded.next(2, .refresh)
        ])
        
        // Assertion
        test.assert(reactor.state) { events in
            let state = events.elements
            expect(state.count) == 5
            
            expect(state[0].items.count) == 0
            
            // apply filter
            expect(state[1].filterType) == .cafe
            
            // refresh
            expect(state[2].isRefreshing) == true
            expect(state[3].items.count) == 25
            expect(state[4].isRefreshing) == false
        }
    }
    
    // MARK: - 전체 글 받아오기 테스트
    func testFetchPostsAll() {
        let test = RxExpect()
        let provider = StubServiceProvider()
        let reactor = test.retain(HomeViewReactor(provider: provider))

        // Action
        test.input(reactor.action, [
            Recorded.next(1, .updateFilter(.all)),
            Recorded.next(2, .refresh)
        ])
        
        // Assertion
        test.assert(reactor.state) { events in
            let state = events.elements
            expect(state.count) == 5
            
            expect(state[0].items.count) == 0
            
            // apply filter
            expect(state[1].filterType) == .all
            
            // refresh
            expect(state[2].isRefreshing) == true
            expect(state[3].items.count / 2) == 25
            expect(state[4].isRefreshing) == false
        }
    }
    
    // MARK: - 검색 내역 조회 테스트
    func testSearchHistory() {
        let test = RxExpect()
        let provider = StubServiceProvider()
        let reactor = test.retain(HomeViewReactor(provider: provider))

        // Action
        test.input(reactor.action, [
            Recorded.next(1, .updateSearchWord("iOS")),
            Recorded.next(2, .updateSearchHistory)
        ])
        
        // Assertion
        test.assert(reactor.state) { events in
            let state = events.elements
            let testKeyword = "iOS"
            expect(state.count) == 3
            
            expect(state[0].query) == ""
            expect(state[1].query) == testKeyword
            expect(state[2].searchHistory.contains(testKeyword)) == true
        }
    }
    
    // MARK: - 페이징 테스트
    func testPaging() {
        let test = RxExpect()
        let provider = StubServiceProvider()
        let reactor = test.retain(HomeViewReactor(provider: provider))

        // Action
        test.input(reactor.action, [
            Recorded.next(1, .updateFilter(.blog)),
            Recorded.next(2, .refresh),
            Recorded.next(3, .loadMore)
        ])
        
        // Assertion
        test.assert(reactor.state) { events in
            let state = events.elements
            expect(state.count) == 8
            
            expect(state[0].items.count) == 0
            
            // apply filter
            expect(state[1].filterType) == .blog
            
            // refresh
            expect(state[2].isRefreshing) == true
            expect(state[3].items.count) == 25
            expect(state[4].isRefreshing) == false
            
            // loadMore
            expect(state[5].isLoading) == true
            expect(state[6].items.count) == 50
            expect(state[7].isLoading) == false
        }
    }
    
    // MARK: - 정렬 테스트
    func testSort() {
        let test = RxExpect()
        let provider = StubServiceProvider()
        let reactor = test.retain(HomeViewReactor(provider: provider))

        // Action
        test.input(reactor.action, [
            Recorded.next(1, .refresh),
            Recorded.next(2, .updateSort(.recency))
        ])
        
        // Assertion
        test.assert(reactor.state) { events in
            let state = events.elements
            expect(state.count) == 5
            
            expect(state[0].items.count) == 0
            
            // refresh
            expect(state[1].isRefreshing) == true
            expect(state[2].items.count) == 50
            expect(state[3].isRefreshing) == false
            
            // original -> sortedData(datetime)
            let sortedData = state[2].items.sorted(by: { $0.dateTime > $1.dateTime })
            
            // sort check
            expect(state[4].items) == sortedData
        }
    }
}
