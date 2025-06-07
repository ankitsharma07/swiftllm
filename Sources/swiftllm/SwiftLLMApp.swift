import Foundation
import NIOCore
import NIOPosix

@main
struct SwiftLLMApp {
    static func main() async throws {
        print("Starting SwiftLLM test...")

        // Initialize ConfigManager
        let configManager = ConfigManager()

        // Create an instance of LLMClient
        let llmClient = LLMClient(configManager: configManager)

        // Test with a simple prompt
        do {
            let prompt = "Tell me a short joke about programming."
            print("Sending prompt: \"\(prompt)\"")

            let response = try await llmClient.generateResponse(prompt: prompt)
x
            print("\nResponse from LLM:")
            print("-------------------")
            print(response)
            print("-------------------")
        } catch LLMError.invalidApiKey {
            print("Error: Invalid API key. Please check your config.json file.")
        } catch {
            print("Error during LLM request: \(error)")
        }

        print("\nTest completed!")
    }
}
