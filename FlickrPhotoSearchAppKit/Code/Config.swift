import Foundation
import Fetch

/// Global set of configuration values for this application.
public struct Config {
    static let keyPrefix = "eu.mws"

    // MARK: API

    public struct API {
        
        static var baseURL: URL {
            switch Environment.current.serverEnvironment {
            case .dev, .staging, .live:
                return URL(string: "https://api.flickr.com")!
            }
        }

        static var stubRequests: Bool {
            #if DEBUG
            if CommandLine.arguments.contains("-testing") {
                return true
            }
            #endif

            return false
        }
        static var timeout: TimeInterval = 120.0

        static var verboseLogging: Bool {
            switch Environment.current.buildConfig {
            case .debug:
                return true
            case .release:
                return false
            }
        }
    }
    
    // MARK: Cache
    
    public struct Cache {
        static let defaultExpiration: Expiration = .seconds(5 * 60.0)
    }

    // MARK: User Defaults

    public struct UserDefaultsKey {
        static let lastUpdate = Config.keyPrefix + ".lastUpdate"
    }

    // MARK: Keychain

    public struct Keychain {
        static let credentialStorageKey = "CredentialsStorage"
        static let credentialsKey = "credentials"
    }

    // MARK: Flickr

    public struct Flickr {
        static let APIKey = "2402177150b015fc655bb3de31940dc4"
    }
}
