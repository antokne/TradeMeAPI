public class TradeMeAPI {

	public static let shared: TradeMeAPI = TradeMeAPI()
	
	public let listings: TradeMeListings
	
	public init(listings: TradeMeListings = TradeMeListings()) {
		self.listings = listings
    }
}
