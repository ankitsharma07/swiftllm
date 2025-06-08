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

// This handles different chat format across the clients

// OpenAI and Mistral have similar chat completion API
// Anthropic and Gemini differs


// OpenAI


// Mistral


// Gemini


// Anthropic
