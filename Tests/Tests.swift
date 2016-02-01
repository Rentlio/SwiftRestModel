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
    
    func testIsNew() {
        XCTAssertTrue(model.isNew(), "model should be new")
        model.data["id"] = "1"
        XCTAssertFalse(model.isNew(), "model should not be new")
    }
    
}