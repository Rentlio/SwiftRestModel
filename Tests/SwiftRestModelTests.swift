import XCTest
import SwiftyJSON

@testable import SwiftRestModel

class SwiftRestModelTests: XCTestCase {
    
    let model = SwiftRestModel(rootUrl: "http://jsonplaceholder.typicode.com/posts")
    
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
    
    func testIsNew() {
        XCTAssertTrue(model.isNew(), "model should be new")
        model.data["id"] = "id1"
        XCTAssertFalse(model.isNew(), "model should not be new")
    }
    
    func testFetchNewModel() {
        let expectation = self.expectationWithDescription("fetch")
        
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
        let expectation = self.expectationWithDescription("fetch")
        
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
    
    func testSaveNewModel() {
        let expectation = self.expectationWithDescription("save")
        
        model.save(
            data   : ["title": "Swift", "body": "REST"],
            success: {
                response in
                XCTAssertNotNil(self.model.data["id"], "response id empty")
                XCTAssertEqual(self.model.data["title"], "Swift", "response data empty")
                XCTAssertEqual(self.model.data["body"], "REST", "response data empty")
                expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testSaveExistingModel() {
        let expectation = self.expectationWithDescription("save")
        
        model.data["id"] = "1"
        model.save(
            data   : ["title": "Swift", "body": "REST"],
            success: {
                response in
                XCTAssertNotNil(self.model.data["id"], "response id empty")
                XCTAssertEqual(self.model.data["title"], "Swift", "response data empty")
                XCTAssertEqual(self.model.data["body"], "REST", "response data empty")
                expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testDestroy() {
        let expectation = self.expectationWithDescription("destroy")
        
        model.data["id"] = "1"
        model.destroy(
            success: {
                response in
                XCTAssertTrue(self.model.isNew(), "model should be new")
                expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testErrorHandler() {
        let expectation = self.expectationWithDescription("error-handler")
        
        model.rootUrl = "http://fake-domain"
        model.fetch(
            error: {
                response in
                XCTAssertNotNil(response, "response is empty")
                XCTAssertNotNil(response["error"], "response error is empty")
                expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}