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

    public struct Flickr {

        public static func fetchImages(for tag: String) -> Resource<[Photo]> {
            return Resource(
                method: .get,
                path: "services/rest",
                urlParameters: [
                    "method": "flickr.photos.search",
                    "format": "json",
                    "nojsoncallback": 1,
                    "api_key": Config.Flickr.APIKey,
                    "extras": "url_sq,url_o",
                    "tags": tag
                ],
                rootKeys: ["photos", "photo"],
                shouldStub: Config.API.stubRequests,
                stub: Config.API.stubRequests ? StubResponse(statusCode: 200, data: Stub(fileName: tag).jsonData(), delay: 10) : nil
            )
        }
    }
}
