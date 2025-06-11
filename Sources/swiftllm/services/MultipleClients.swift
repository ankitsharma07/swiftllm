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

enum LLMError: Error {
    case invalidAPIKey
    case requestFailed(String)
    case decodingFailed(String)
    case invalidProvider
    case invalidResponse
}

// OpenAI


// Mistral


// Gemini


// Anthropic
