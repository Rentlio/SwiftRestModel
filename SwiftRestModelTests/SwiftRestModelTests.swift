import XCTest
import SwiftyJSON

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
        let expectation = self.expectation(description: "fetch")
        
        model.fetch(
            success: {
                response in
                XCTAssertNotNil(self.model.data, "response is empty")
                XCTAssertNotEqual(self.model.data.arrayValue.count, 0, "collection is empty")
                expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchExistingModel() {
        let expectation = self.expectation(description: "fetch")
        
        model.data["id"] = "1"
        model.fetch(
            success: {
                response in
                XCTAssertNotNil(self.model.data, "response is empty")
                XCTAssertEqual(self.model.data.arrayValue.count, 0, "collection is not empty")
                expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSaveNewModel() {
        let expectation = self.expectation(description: "save")
        
        model.save(
            data   : ["title": "Swift", "body": "REST"],
            success: {
                response in
                XCTAssertNotNil(self.model.data["id"], "response id empty")
                XCTAssertEqual(self.model.data["title"], "Swift", "response data empty")
                XCTAssertEqual(self.model.data["body"], "REST", "response data empty")
                expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSaveExistingModel() {
        let expectation = self.expectation(description: "save")
        
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
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDestroy() {
        let expectation = self.expectation(description: "destroy")
        
        model.data["id"] = "1"
        model.destroy(
            success: {
                response in
                XCTAssertTrue(self.model.isNew(), "model should be new")
                expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testErrorHandler() {
        let expectation = self.expectation(description: "error-handler")
        
        model.rootUrl = "http://fake-domain"
        model.fetch(
            error: {
                response in
                XCTAssertNotNil(response, "response is not empty")
                XCTAssertNotNil(response["error"], "response error is not empty")
                expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testErrorWithResponse() {
        let expectation = self.expectation(description: "error-response-handler")
        model.rootUrl = "http://jsonplaceholder.typicode.com/fakemodel"
        
        model.fetch(
            error: {
                response in
                XCTAssertNotNil(response, "response is not empty")
                XCTAssertNotNil(response["error"], "response is not empty")
                XCTAssertEqual(response["status"], 404, "status code is 404")
                expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
