import Foundation
import Alamofire
import Fetch

public class API {
    
    public static func setup() {
        APIClient.shared.setup(with: Fetch.Config(
            baseURL: Config.API.baseURL,
            timeout: Config.API.timeout,
            eventMonitors: [APILogger(verbose: Config.API.verboseLogging)],
            cache: MemoryCache(defaultExpiration: Config.Cache.defaultExpiration),
            shouldStub: Config.API.stubRequests))
    }
}
