import UIKit
import Alamofire

public protocol CFURLStringConvertable {
    var URLString:String{
        get
    }
}

extension String:CFURLStringConvertable {
    public var URLString:String {
        return self
    }
}

public enum CFHTTPMethod:String {
    case GET,POST
}

public enum CFHTTPParameterEncoding {
    case URL
    case JSON
    case PropertyList(PropertyListSerialization.PropertyListFormat, PropertyListSerialization.WriteOptions)
}

public class CFNetworkEngine {

    public static let sharedInstance: CFNetworkEngine = {
       let instance = CFNetworkEngine()
       return instance
    }()
    
    public var CFHTTPStatusCode:Int?

    public func request( method: CFHTTPMethod,
                           _ url: String,
                           parameters: [String: Any]? = nil,
                           encoding: CFHTTPParameterEncoding? = CFHTTPParameterEncoding.URL,
                           headers: [String: String]? = nil,
                           success: ((_ data:NSDictionary?) -> Void)?,
                           failure: ((_ message:String) -> Void)?  = nil){
        
        var _method = HTTPMethod.get
        if method == CFHTTPMethod.POST {
            _method = HTTPMethod.post
        }
        
        guard let _ = NSURL(string: url) else { return }
        
        let memoryCapacity = 500 * 1024 * 1024; // 500 MB
        let diskCapacity = 500 * 1024 * 1024; // 500 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "cf_network_cache")
        URLCache.shared.removeAllCachedResponses()
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData //忽略本地缓存
        config.urlCache = cache
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        let manager = Alamofire.SessionManager(configuration: config)
        
        manager.request(url, method: _method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            //一定要加上这句http://stackoverflow.com/questions/30906607/about-alamofire-version-for-use-manager
            manager.session.invalidateAndCancel()
            if response.response?.allHeaderFields["Set-Cookie"] != nil {
                
                // 保存登录Cookie
                let cookie = response.response?.allHeaderFields["Set-Cookie"]!
                UserDefaults.standard.set("\(cookie!)", forKey: "Cookie")
                UserDefaults.standard.synchronize()
            }
            
            if response.result.isSuccess {
                if let data = response.result.value as? NSDictionary,let s = success {
                    s(data)
                }
            }else{
                if let f = failure {
                    f("\(response)")
                }
            }
        }
        
    }
    
}

