import Foundation
import AsyncHTTPClient
import NIOCore
import NIOFoundationCompat
import NIOHTTP1

// Multiple clients
// Gemini, Mistral, OpenAI, Claude

struct Message: Codable {
    let role: String
    let content: String
}

struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double?
}

struct ChatCompletionResponse: Codable {
    struct Choice: Codable {
            struct Message: Codable {
                let role: String
                let content: String
            }
            let message: Message
        }

    let choices: [Choice]
}

enum LLMError: Error {
    case invalidApiKey
    case requestFailed(String)
    case decodingFailed(String)
}

struct GeminiPart: Codable { let text: String }

struct GeminiContent: Codable {
    let role: String?
    let parts: [GeminiPart]
}

struct GeminiRequest: Codable {
    let contents: [GeminiContent]
    let generationConfig: GenerationConfig
    struct GenerationConfig: Codable { let temperature: Double? }
}

struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            let parts: [GeminiPart]
        }
        let content: Content
    }
    let candidates: [Candidate]
}


class LLMClient {
    private let httpClient: HTTPClient
    private let configManager: ConfigManager

    init(configManager: ConfigManager) {
        self.configManager = configManager
        self.httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
    }

    deinit {
        try? httpClient.syncShutdown()
    }

    func generateResponse(prompt: String) async throws -> String {
        guard let apiKey = configManager.getValue(for: "GEMINI_API_KEY") else {
            throw LLMError.invalidApiKey
        }

        let geminiModel = APIContants.Models.geminiFlash
        let gemini_url = "\(APIContants.URLs.gemini)\(geminiModel):generateContent?key=\(apiKey)"

        print("Gemini URL: \(gemini_url)")

        let request = GeminiRequest(contents: [.init(role: "user",
                                                parts: [.init(text: prompt)])],
                                generationConfig: .init(temperature: 0.7))

        let requestData = try JSONEncoder().encode(request)

        var httpRequest = HTTPClientRequest(url: gemini_url)
        httpRequest.method = .POST
        httpRequest.headers.add(name: "Content-Type", value: "application/json")
        httpRequest.body = .bytes(ByteBuffer(data: requestData))

        let response = try await httpClient.execute(httpRequest, timeout: .seconds(30))

        guard response.status == .ok else {
            throw LLMError.requestFailed("HTTP status: \(response.status.code)")
        }

        var bodyData = Data()
        for try await chunk in response.body { bodyData.append(Data(buffer: chunk)) }

        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: bodyData)
        return decoded.candidates.first?
               .content.parts.first?
               .text ?? "No response generated."
    }
}
