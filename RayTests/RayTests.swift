//
//  RayTests.swift
//  RayTests
//
//  Created by Роман Васильев on 11.05.2023.
//

import XCTest
@testable import Ray
class HomeViewModelTests: XCTestCase {
    var apiManager: MockAPIManager!
    var favoritesManager: MockFavoritesManager!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        
        apiManager = MockAPIManager()
        favoritesManager = MockFavoritesManager()
        viewModel = HomeViewModel(apiManager: apiManager, favoritesManager: favoritesManager)
    }
    
    override func tearDown() {
        apiManager = nil
        favoritesManager = nil
        viewModel = nil
        
        super.tearDown()
    }
    
    func testAddToFavorites() {
        let image = UIImage()
        let description = "Test description"
        
        viewModel.query.value = description
        viewModel.addToFavorites(image: image)
        
        XCTAssertTrue(favoritesManager.addCalled)
        XCTAssertEqual(favoritesManager.addedImage, image)
        XCTAssertEqual(favoritesManager.addedDescription, description)
    }
    
    func testFetchImageSuccess() {
        let query = "Test query"
        let image = UIImage()
        
        apiManager.fetchImageResult = .success(image)
        
        viewModel.fetchImage(withQuery: query)
        
        XCTAssertTrue(apiManager.fetchImageCalled)
        XCTAssertEqual(viewModel.query.value, query)
        XCTAssertEqual(viewModel.image.value, image)
        XCTAssertNil(viewModel.error.value)
        
        XCTAssertFalse(viewModel.isLoading.value)
    }
    
    func testFetchImageFailure() {
        let query = "Test query"
        let error = APIError.unknown
        
        apiManager.fetchImageResult = .failure(error)
        
        viewModel.fetchImage(withQuery: query)
        
        XCTAssertTrue(apiManager.fetchImageCalled)
        XCTAssertEqual(viewModel.query.value, query)
        XCTAssertNil(viewModel.image.value)
        XCTAssertEqual(viewModel.error.value as? APIError, error)
        
        XCTAssertFalse(viewModel.isLoading.value)
    }
}

class MockAPIManager: APIManager {
    var fetchImageCalled = false
    var fetchImageQuery: String?
    var fetchImageResult: Result<UIImage, Error>?
    
    override func fetchImage(withQuery query: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        fetchImageCalled = true
        fetchImageQuery = query
        if let result = fetchImageResult {
            completion(result)
        }
    }
}

class MockFavoritesManager: FavoritesManager {
    var addCalled = false
    var addedImage: UIImage?
    var addedDescription: String?
    
    override func add(image: UIImage, description: String) {
        addCalled = true
        addedImage = image
        addedDescription = description
    }
}
