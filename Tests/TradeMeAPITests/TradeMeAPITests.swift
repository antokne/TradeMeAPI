import XCTest
@testable import TradeMeAPI

final class TradeMeAPITests: XCTestCase {

	var tradeMeApi: TradeMeAPI?
	
	override func setUp() {
		
		tradeMeApi = TradeMeAPI(listings:  MockTradeMeListings())
	}
	
	func testListingsLatest() async throws {

		do {
			let result = try await tradeMeApi?.listings.getLastestListings()
			XCTAssert(result!.count == 3)
		}
		catch {
			XCTFail("\(error)")
		}
		
	}
}

private class MockTradeMeListings: TradeMeListings {
	
	override public func getLastestListings(page: Int = 1, perPage: Int = 20) async throws -> [Any] {
		
		guard let file = Bundle.module.url(forResource: "latest-listings", withExtension: "json"),
			  let data = try? Data(contentsOf: file) else {
			fatalError("Could not load lastest-listings.json.")
		}
		
		if let json = try? JSONSerialization.jsonObject(with: data) as? [Any] {
			return json
		}
		return []
	}
}
