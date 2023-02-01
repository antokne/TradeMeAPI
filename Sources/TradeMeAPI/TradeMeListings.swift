//
//  TradeMeListings.swift
//  
//
//  Created by Antony Gardiner on 1/02/23.
//

import Foundation

enum ListingsError : Error {
	case invalidUrl
	case sessionFailed
	case noJSON
}

public class TradeMeListings: NSObject {
	
	/// Get the current latest listings
	/// Note currently just returns the first page. Needs to add paramater for page number.
	/// - Returns:
	/// - Parameters:
	///   - page: page to retrieve
	///   - perPage: number of listings per page
	public func getLastestListings(page: Int = 1, perPage: Int = 20) async throws -> [Any] {
		
		guard let url = URL(string: "https://api.tmsandbox.co.nz/v1/listings/latest.json?page=\(page)&rows=\(perPage)") else {
			throw ListingsError.invalidUrl
		}
		
		var request = URLRequest(url: url)
		
		request.httpMethod = "GET"
		// This is obviously hard coded for the test. Normally any tokens would be stored in the keychain.
		request.addValue("Content-Type: application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.addValue("OAuth oauth_consumer_key=A1AC63F0332A131A78FAC304D007E7D1,oauth_signature_method=PLAINTEXT,oauth_signature=EC7F18B17A062962C6930A8AE88B16C7&", forHTTPHeaderField: "Authorization")

		let session = URLSession.shared
		do {
			let (data, response) = try await session.data(for: request)
			
			guard let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200 else {
				throw ListingsError.sessionFailed
			}
					
			let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
			
			guard let json else {
				throw ListingsError.noJSON
			}
			
			if let list = json["List"] as? [Any] {
				return list
			}
		}
		catch {
			throw ListingsError.sessionFailed
		}
		
		return []
	}
	
	
}
