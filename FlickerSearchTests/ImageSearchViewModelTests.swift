//
//  ImageSearchView.swift
//  FlickerSearch
//
//  Created by Massen Elarabi on 11/20/24.
//

import XCTest
@testable import FlickerSearch

final class ImageSearchViewModelTests: XCTestCase {
    
    var sut: ImageSearchViewModel!

    override func setUpWithError() throws {
        super.setUp()
        sut = ImageSearchViewModel(webService: MockWebServiceSuccess())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testFetchMealsDetailsSuccess() async {
        let expectation = self.expectation(description: "searching...")
        await sut.debounceSearch(searchText: "tree")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 3)
        let images = sut.images
        guard !images.isEmpty else {
           XCTFail("Images array is nil or empty")
           return
        }
        XCTAssertEqual(images.first?.title, "title2")
        XCTAssertEqual(images.first?.description, "description2\n\n")
        XCTAssertEqual(images.first?.media.imageLink, "www.image2.com")
        XCTAssertEqual(images.last?.title, "title3")
        XCTAssertEqual(images.last?.description, "description3")
        XCTAssertEqual(images.last?.media.imageLink, "www.image3.com")
    }
    
    func testProcessData() async {
        let expectation = self.expectation(description: "searching...")
        await sut.debounceSearch(searchText: "dog")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 3)
        let images = sut.images
        guard !images.isEmpty else {
           XCTFail("Images array is nil or empty")
           return
        }
        XCTAssertEqual(images.first!.description.stripHTMLTags(), "description1")
        XCTAssertEqual(images.first!.publishedDate.toFormattedDate(), "Nov 19, 2024")
        XCTAssertEqual(images[1].description.stripHTMLTags(), "description2 ")
        XCTAssertEqual(images[1].publishedDate.toFormattedDate(), "Dec 19, 2024")
    }
    
    func testFetchMealsFail() async {
        sut = ImageSearchViewModel(webService: MockWebServiceFail())
        let expectation = self.expectation(description: "searching...")
        await sut.fetchImages(searchItem: "dog")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 3)
        let error = sut.error
        XCTAssertEqual(error, "Unexpected HTTP status code: 400")
    }

}
