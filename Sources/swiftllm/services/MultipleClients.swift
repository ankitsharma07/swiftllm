import Foundation
import AsyncHTTPClient
import NIOCore
import NIOHTTP1
import NIOFoundationCompat

// Common types
enum LLMProvider: String, CaseIterable {
    case openai = "openai"
    case mistral = "mistral"
    case gemini = "gemini"
    case claude = "claude"
}

enum MultiLLMError: Error {
    case invalidAPIKey
    case requestFailed(String)
    case decodingFailed(String)
    case invalidProvider
    case invalidResponse
}

// OpenAI
struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let temperature: Double?
    let maxTokens: Int?
    let topP: Double?
}

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

// Mistral (Similar to OpenAI)
typealias MistralMessage = OpenAIMessage
typealias MistralRequest = OpenAIRequest
typealias MistralResponse = OpenAIResponse



// Gemini


// Anthropic
