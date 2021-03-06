//
//  ListingsTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class ListingsTest: SessionTestSpec {

    func testDownloadLinks() {
        let sortTypes:[LinkSortType] = [.Controversial, .Top, .Hot, .New]
        let timeFilterTypes:[TimeFilterWithin] = [.Hour, .Day, .Week, .Month, .Year, .All]
        let subreddit = Subreddit(subreddit: "sandboxtest")
        for sortType in sortTypes {
            for filter in timeFilterTypes {
                print("Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.")
                let documentOpenExpectation = self.expectationWithDescription("Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.")
                var isSucceeded = false
                self.session?.getList(Paginator(), subreddit:subreddit, sort:sortType, timeFilterWithin:filter, completion: { (result) in
                    switch result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let listing):
                        isSucceeded = (listing.children.count >= 0)
                        for obj in listing.children {
                            isSucceeded = isSucceeded && (obj is Link)
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.")
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
        }
    }
    
    func testDownloadRandomLinks() {
        let documentOpenExpectation = self.expectationWithDescription("Check whether the random list includes two Listings.")
        self.session?.getRandom(completion: { (result) in
            var isSucceeded = false
            switch result {
            case .Failure:
                print(result.error)
            case .Success(let tuple):
                isSucceeded = (tuple.0.children.count == 1)
                isSucceeded = isSucceeded && (tuple.0.children[0] is Link)
                isSucceeded = isSucceeded && (tuple.1.children.count > 0)
                for obj in tuple.1.children {
                    isSucceeded = isSucceeded && (obj is Comment)
                }
            }
            XCTAssert(isSucceeded, "Check whether the random list includes two Listings.")
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testDownloadRandomLinksAmongSpecifiedSubreddit() {
        let documentOpenExpectation = self.expectationWithDescription("Check whether the random list among the specified subreddit includes two Listings when using withoutLink = false.")

        var isSucceeded = false
        let subreddit = Subreddit(subreddit: "sandboxtest")
        self.session?.getRandom(subreddit, completion: { (result) in
            switch result {
            case .Failure(let error):
                print(error.description)
            case .Success(let tuple):
                isSucceeded = (tuple.0.children.count == 1)
                isSucceeded = isSucceeded && (tuple.0.children[0] is Link)
                isSucceeded = isSucceeded && (tuple.1.children.count >= 0)
                for obj in tuple.1.children {
                    isSucceeded = isSucceeded && (obj is Comment)
                }
            }
            XCTAssert(isSucceeded, "Check whether the random list among the specified subreddit includes two Listings when using withoutLink = false.")
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testDownloadArticlesOfLinkWhichIsSelectedRandomlyFromTheSubreddit() {
        let sortTypes:[CommentSort] = [.Confidence, .Top, .New, .Hot, .Controversial, .Old, .Random, .Qa]
        for sort in sortTypes {
            var link:Link? = nil
            do {
                print("Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)")
                let documentOpenExpectation = self.expectationWithDescription("Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)")
                let subreddit = Subreddit(subreddit: "redditdev")
                self.session?.getList(Paginator(), subreddit:subreddit, sort:.New, timeFilterWithin:.Week, completion: { (result) in
                    switch result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let listing):
                        for obj in listing.children {
                            if obj is Link {
                                link = obj as? Link
                                break
                            }
                        }
                    }
                    XCTAssert(link != nil, "Check whether the aritcles include one Listing when using withoutLink = true.")
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            
            do {
                let documentOpenExpectation = self.expectationWithDescription("Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)")
                if let link = link {
                    self.session?.getArticles(link, sort:sort, completion: { (result) -> Void in
                        var isSucceeded = false
                        switch result {
                        case .Failure:
                            print(result.error)
                        case .Success(let tuple):
                            isSucceeded = true
                            for obj in tuple.1.children {
                                isSucceeded = isSucceeded && (obj is Comment)
                            }
                        }
                        XCTAssert(isSucceeded, "Check whether the aritcles include one Listing when using withoutLink = true.")
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
            }
        }
    }
}
