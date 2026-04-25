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
    
    public func get_banners() async throws -> Any {
        guard let url = URL(string: "\(api)/banners") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_news() async throws -> Any {
        guard let url = URL(string: "\(api)/screens/news") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func new_search(chrono: String="news",page: Int=0,per_page: Int=20,locale: String="ru") async throws -> Any {
        guard let url = URL(string: "\(api)/new_search?chrono=\(chrono)&page=\(page)&per_page=\(per_page)&locale=\(locale)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_news_page(feature: String) async throws -> Any {
        //https://meduza.io/api/w5/feature/2026/04/24/v-2024-godu-v-mosgordumu-ne-vzyali-ni-odnogo-voennogo-zato-teper-moskva-sama-prodvigaet-na-vybory-v-gosdumu-kak-minimum-chetyreh-veteranov-svo
        //or https://meduza.io/api/w5/episodes/2026/04/24/iz-za-voyny-na-blizhnem-vostoke-rastut-tseny-na-aviabilety-tysyachi-reysov-otmenyayutsya-sletat-v-otpusk-ne-poluchitsya
        guard let url = URL(string: "\(api)/\(feature)") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_podcasts_list() async throws -> Any {
        guard let url = URL(string: "\(api)/screens/specials/podcasts-list") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func under_the_sun() async throws -> Any {
        guard let url = URL(string: "\(api)/screens/specials/under-the-sun") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
}
