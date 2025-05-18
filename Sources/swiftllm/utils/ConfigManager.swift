import Foundation

struct ConfigManager {
    private let configFilePath: String
    private var config: [String: String] = [:]

    init() {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser.path
        print("Home Director: \(homeDirectory)")

        configFilePath = "\(homeDirectory)/.swiftllm/config.json"
        loadConfig()
    }

    private mutating func loadConfig() {
        let fileManager = FileManager.default

        let configDirectory = URL(fileURLWithPath: configFilePath).deletingLastPathComponent().path
        if !fileManager.fileExists(atPath: configDirectory) {
            try? fileManager.createDirectory(atPath: configDirectory, withIntermediateDirectories: true)
        }

        if fileManager.fileExists(atPath: configFilePath),
            let data = try? Data(contentsOf: URL(fileURLWithPath: configFilePath)),
            let loadedConfig = try? JSONDecoder().decode([String: String].self, from: data) {
            config = loadedConfig
        }
    }

    func getValue(for key: String) -> String? {
        return config[key] ?? ProcessInfo.processInfo.environment[key]
    }

    mutating func setValue(_ value: String, for key: String) throws {
        var updatedConfig = config
        updatedConfig[key] = value

        let data = try JSONEncoder().encode(updatedConfig)
        try data.write(to: URL(fileURLWithPath: configFilePath))
        config = updatedConfig
    }
}
