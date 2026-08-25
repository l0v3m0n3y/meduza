import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class Meduza {
    private let api = "https://meduza.io/api/w5"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"application/json",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "Host":"meduza.io",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getBanners() async throws -> Any {
        return try await fetchJSON(from: "\(api)/banners")
    }
    
    public func getNews() async throws -> Any {
        return try await fetchJSON(from: "\(api)/screens/news")
    }
    
    public func newSearch(chrono: String="news",page: Int=0,perPage: Int=20,locale: String="ru") async throws -> Any {
        let urlString = "\(api)/new_search"
        
        let queryParameters: [String: String] = [
            "chrono": chrono,
            "page": String(page),
            "per_page": String(perPage),
            "locale": locale
        ]
        
        return try await fetchJSON(from: urlString,method: .get,queryParameters: queryParameters)
    }
    
    public func getNewsPage(feature: String) async throws -> Any {
        //https://meduza.io/api/w5/feature/2026/04/24/v-2024-godu-v-mosgordumu-ne-vzyali-ni-odnogo-voennogo-zato-teper-moskva-sama-prodvigaet-na-vybory-v-gosdumu-kak-minimum-chetyreh-veteranov-svo
        //or https://meduza.io/api/w5/episodes/2026/04/24/iz-za-voyny-na-blizhnem-vostoke-rastut-tseny-na-aviabilety-tysyachi-reysov-otmenyayutsya-sletat-v-otpusk-ne-poluchitsya
        return try await fetchJSON(from: "\(api)/\(feature)")
    }
    
    public func getPodcastsList() async throws -> Any {
        return try await fetchJSON(from: "\(api)/screens/specials/podcasts-list")
    }
    
    public func underTheSun() async throws -> Any {
        return try await fetchJSON(from: "\(api)/screens/specials/under-the-sun")
    }
}
