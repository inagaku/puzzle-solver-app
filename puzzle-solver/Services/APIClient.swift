import Foundation
import UIKit

enum HTTPError: Error {
    case invalidURL, invalidResponse, statusCode(Int), invalidData, imageDecoding
}

struct APIClient {
    static let shared = APIClient()
    private init() {}
    
    // MARK: - Generic request
    func requestData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        var request = URLRequest(url: url)
        let apiKey = "DT4JUsbT4aaSLvh0gWYvSglV7z9RanY1CHn96fR6"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw HTTPError.invalidResponse
        }
        guard 200..<300 ~= http.statusCode else {
            throw HTTPError.statusCode(http.statusCode)
        }
        return data
    }
    
    // MARK: - Upload image via multipart/form-data
    func uploadImage(
        image: UIImage,
        to urlString: String
    ) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw HTTPError.invalidURL
        }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw HTTPError.invalidData
        }

    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let apiKey = "<place_your_api_key_here>"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        

        let (responseData, response) = try await URLSession.shared.upload(for: request, from: imageData)
        print(response)
        
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw HTTPError.statusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        

        guard let base64String = String(data: responseData, encoding: .utf8),
              let decoded = Data(base64Encoded: base64String),
              let returnedImage = UIImage(data: decoded) else {
            throw HTTPError.imageDecoding
        }
        return returnedImage
    }
}
