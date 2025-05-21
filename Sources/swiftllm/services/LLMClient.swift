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

        let gemini_url = APIContants.URLs.gemini

        let request = ChatCompletionRequest(
            model: APIContants.Models.geminiPro,
            messages: [Message(role: "user", content: prompt)],
            temperature: 0.7
        )

        let requestData = try JSONEncoder().encode(request)

        var httpRequest = HTTPClientRequest(url: gemini_url)
        httpRequest.method = .POST
        httpRequest.headers.add(name: "Content-Type", value: "application/json")
        httpRequest.headers.add(name: "Authorization", value: "Bearer \(apiKey)")
        httpRequest.body = .bytes(ByteBuffer(data: requestData))

        let response = try await httpClient.execute(httpRequest, timeout: .seconds(30))

        if response.status == .ok {
            var bodyData = Data()

            for try await chunk in response.body {
                bodyData.append(Data(buffer: chunk))
            }

            do {
                let decodedResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: bodyData)
                if let firstChoice = decodedResponse.choices.first {
                    return firstChoice.message.content
                } else {
                    return "No response generated."
                }
            } catch {
                throw LLMError.decodingFailed(error.localizedDescription)
            }
        } else {
            throw LLMError.requestFailed("HTTP status: \(response.status.code)")
        }
    }
}
