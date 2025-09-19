import Foundation
import UIKit

enum UploadError: Error {
    case encodingFailed
}

class APIClient {
    static let shared = APIClient()
    private init() {}

    let baseURL = URL(string: "https://9cf0c623356c.ngrok-free.app/")!
    
    
    private let isoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    private lazy var encoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .formatted(isoFormatter)
        return enc
    }()

    private lazy var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .formatted(isoFormatter)
        return dec
    }()
    
    
    // Sending Photos
    func uploadMultipart<T: Decodable>(
          endpoint: String,
          image: UIImage,
          imageFieldName: String = "image",
          parameters: [String: String] = [:]
      ) async throws -> T {
          
          guard let url = URL(string: endpoint, relativeTo: baseURL) else {
              throw URLError(.badURL)
          }
          
          var urlRequest = URLRequest(url: url)
          urlRequest.httpMethod = "POST"
          
          let boundary = UUID().uuidString
          urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
          
          if let token = await TokenManager.shared.accessToken {
              urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
          }
          
          var body = Data()
          
          // Add extra fields
          for (key, value) in parameters {
              body.append("--\(boundary)\r\n".data(using: .utf8)!)
              body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
              body.append("\(value)\r\n".data(using: .utf8)!)
          }
          
          // Ensure safe resolution & size
          let safeImage = image.resizedToSafeSize(maxDimension: 1024)
          guard let imageData = safeImage.jpegData(compressionQuality: 0.9) else {
              throw UploadError.encodingFailed
          }



          body.append("--\(boundary)\r\n".data(using: .utf8)!)
          body.append("Content-Disposition: form-data; name=\"\(imageFieldName)\"; filename=\"receipt.jpg\"\r\n".data(using: .utf8)!)
          body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
          body.append(imageData)
          body.append("\r\n".data(using: .utf8)!)
          
          body.append("--\(boundary)--\r\n".data(using: .utf8)!)
          urlRequest.httpBody = body
          
          let (data, response) = try await URLSession.shared.data(for: urlRequest)
          
          print("Upload raw response:", String(data: data, encoding: .utf8) ?? "nil")
          
          guard let httpResponse = response as? HTTPURLResponse else {
              throw URLError(.badServerResponse)
          }
          
          if httpResponse.statusCode == 401 {
              try await TokenManager.shared.refreshAccessToken()
              return try await uploadMultipart(endpoint: endpoint, image: image, imageFieldName: imageFieldName, parameters: parameters)
          }
          
          guard (200...299).contains(httpResponse.statusCode) else {
              throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
          }
          
          return try decoder.decode(T.self, from: data)
      }


    // Generic request that retries once on 401
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {

        do {
            return try await performRequest(endpoint: endpoint, method: method, body: body, allowRetry: true)
        } catch {
            throw error
        }
    }

    // Lower-level request
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Encodable?,
        allowRetry: Bool
    ) async throws -> T {

        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add current access token
        if let token = await TokenManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            urlRequest.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // what the backend actually sends
        print("Raw response:", String(data: data, encoding: .utf8) ?? "nil")


        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 401, allowRetry {
            // refresh token
            try await TokenManager.shared.refreshAccessToken()
            // retry once with new token
            return try await performRequest(endpoint: endpoint, method: method, body: body, allowRetry: false)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: nil)
        }

        return try decoder.decode(T.self, from: data)
    }

    // Raw request for refresh calls (no auto-refresh)
    func rawRequest<T: Decodable>(
        endpoint: String,
        method: String,
        headers: [String: String],
        body: Encodable? = nil
    ) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        for (k, v) in headers {
            urlRequest.setValue(v, forHTTPHeaderField: k)
        }

        if let body = body {
            urlRequest.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(T.self, from: data)
    }
}
