import Foundation

enum APIContants {
    enum URLs {
        static let openai = "https://api.openai.com/v1/chat/completions"
        static let gemini = "https://generativelanguage.googleapis.com/v1beta/models/"
        static let claude = "https://api.anthropic.com/v1/messages"
        static let mistral = "https://api.mistral.ai/v1/chat/completions"
    }

    enum Models {
        // OpenAI
        static let gpt3Turbo = "gpt-3.5-turbo"
        static let gpt4 = "gpt-4"

        // Google Gemini
        static let geminiPro = "gemini-pro"
        static let geminiFlash = "gemini-2.0-flash"

        // Anthropic Claude
        static let claudeInstant = "claude-instant-1"
        static let claude2 = "claude-2"

        // Mistral
        static let mistralSmall = "mistral-small"
    }
}
