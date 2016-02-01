import XCTest
import SwiftyJSON

@testable import SwiftRestModel

class SwiftRestModelTests: XCTestCase {
    
    let model = SwiftRestModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testModelNotNil() {
        XCTAssertNotNil(model, "model is nil")
    }
    
    func testParse() {
        let data: JSON = model.data
        model.parse()
        XCTAssertEqual(data.rawString(), model.data.rawString(), "parse method modified data")
    }
    
    func testFetchNewModel() {
        let expectation = self.expectationWithDescription("fetch posts")
        
        model.rootUrl = "http://jsonplaceholder.typicode.com/posts"
        model.fetch(
            success: {
                response in
                XCTAssertNotNil(self.model.data, "response is empty")
                XCTAssertNotEqual(self.model.data.arrayValue.count, 0, "collection is empty")
                expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testFetchExistingModel() {
        let expectation = self.expectationWithDescription("fetch posts")
        
        model.rootUrl = "http://jsonplaceholder.typicode.com/posts"
        model.data["id"] = "1"
        model.fetch(
            success: {
                response in
                XCTAssertNotNil(self.model.data, "response is empty")
                XCTAssertEqual(self.model.data.arrayValue.count, 0, "collection is not empty")
                expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testIsNew() {
        XCTAssertTrue(model.isNew(), "model should be new")
        model.data["id"] = "id1"
        XCTAssertFalse(model.isNew(), "model should not be new")
    }
    
}