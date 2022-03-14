//
//  BaseAPIService.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import Alamofire

class AccessTokenAdapter: RequestAdapter {

    private let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if (urlRequest.url?.absoluteString) != nil {
            urlRequest.setValue("JWT " + accessToken, forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}

class BaseAPIService: NetworkAPIInterface {
    
    private enum ResponseStatus {
        case success
        case failure
        case no
    }
    
    var serverUrl: String?
    
    var accessToken: String = "" {
        didSet {
            self.sessionManager.adapter = AccessTokenAdapter(accessToken: accessToken)
        }
    }

    private let sessionManager = SessionManager()
    private var request: DataRequest?
    
    var apiVersion = APIConstants.version
    
    func cancelRequest() {
        self.request?.cancel()
    }
    
    func downloadFile(fullUrlString: String? = nil, path: String, serverUrl: String, parameters: Parameters? = nil, fileName: String, completed: ((Data, URL) -> Void)?, loading: @escaping (Progress) -> Void, failure: FailureCallback?) {
        guard Reachability.isConnectedToNetwork() else {
            failure?(ErrorsFactory.General.connection)
            return
        }
        
        let urlString = fullUrlString ?? (serverUrl + self.apiVersion + path)
        let requestHeaders = prepareHeaders()
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Logger.shared.log("🚀 (download) \(urlString)", type: .requests)
        self.sessionManager.download(urlString, method: .get, parameters: parameters, headers: requestHeaders, to: destination)
            .downloadProgress { (progres: Progress) in
                Logger.shared.log("downloading total:\(progres.totalUnitCount) fraction:\(progres.fractionCompleted)%", type: .requests)
                loading(progres)
            }
            .responseData { response in
                if let data = response.result.value, let fileUrl = response.destinationURL {
                    Logger.shared.log("🏁 (download) " + (response.request?.url?.absoluteString ?? ""), type: .requests)
                    Logger.shared.log("temp file dir " + fileUrl.absoluteString, type: .requests)
                    
                    completed?(data, fileUrl)
                } else {
                    failure?(response.error as NSError?)
                }
            }
    }
    
    func uploadFile(path: String, serverUrl: String, data: Data, name: String, parameters: Parameters? = nil, fileName: String, mimeType: String, success: SuccessCallback?, failure: FailureCallback?) {
        guard Reachability.isConnectedToNetwork() else {
            failure?(ErrorsFactory.General.connection)
            return
        }
        
        let url = serverUrl + self.apiVersion + path
        
        let requestHeaders = prepareHeaders()
        
        Logger.shared.log("🚀 (upload) \(url)", type: .requests)
        self.sessionManager.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
            for (key, value) in requestHeaders {
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON {[weak self] response in
                    switch response.result {
                    case .success:
                        Logger.shared.log(response.debugDescription, type: .responses)
                        Logger.shared.log("🏁 (finished) " + (response.request?.url?.absoluteString ?? ""), type: .requests)
                        var foundCountString = ""
                        if let headers = response.response?.allHeaderFields as? [String: Any] {
                            foundCountString = headers[caseInsensitive: "total-found"] as? String ?? ""
                        }
                        let totalCount: Int = Int(foundCountString) ?? 0
                        success?(response.data, totalCount)
                        break
                    case .failure:
                        self?.handleErrorResponse(response, callback: failure)
                        break
                    }
                }
                break
            case .failure:
                break
            }
        }
    }
    
    @discardableResult
    func sendRequest(_ method: HTTPMethod, serverUrl: String, path: String, isURLWithVersion: Bool = true, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, success: SuccessCallback?, failure: FailureCallback?) -> DataRequest? {
        
        guard Reachability.isConnectedToNetwork() else {
            failure?(ErrorsFactory.General.connection)
            return nil
        }
        
        let url = isURLWithVersion ? serverUrl + self.apiVersion + path :  serverUrl + path
        
        Logger.shared.log("🚀 (\(method)) \(url)", type: .requests)
        self.request = self.sessionManager.request(url, method: method, parameters: parameters, headers: prepareHeaders(headers))
            .validate()
            .responseJSON {[weak self] response in
                switch response.result {
                case .success:
                    let bcf = ByteCountFormatter()
                    bcf.allowedUnits = [.useKB, .useBytes]
                    bcf.countStyle = .file
                    let size = bcf.string(fromByteCount: Int64(exactly: response.data?.count ?? 0) ?? 0)
                    Logger.shared.log("🏁 (finished) " + (response.request?.url?.absoluteString ?? "") + " with response size: \(size)" + " headers: \(response.request?.allHTTPHeaderFields ?? [: ])" + " parameters: \(parameters ?? [: ])", type: .requests)
                    
                    //print(response.response?.allHeaderFields)
                    var totalCountString = ""
                    if let headers = response.response?.allHeaderFields as? [String: Any] {
                        totalCountString = headers[caseInsensitive: "total"] as? String ?? ""
                    }
                    let totalCount = Int(totalCountString) ?? 0
                    success?(response.data, totalCount)
                    break
                case .failure:
                    self?.handleErrorResponse(response, callback: failure)
                    Logger.shared.log("🏳️ (finished with error) " + (response.request?.url?.absoluteString ?? "") + " headers: \(response.request?.allHTTPHeaderFields ?? [: ])" + " parameters: \(parameters ?? [: ])", type: .requests)
                    break
                }
            }
        return self.request
    }

    // MARK: - Private
    private func prepareHeaders(_ headers: [String: String]? = nil) -> [String: String] {
        var result = headers ?? [String: String]()
        result["Client"] = "ios"
        
        if let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            result["App-version"] = version
        }
        
        return result
    }
    
    private func handleErrorResponse(_ response: DataResponse<Any>, callback: FailureCallback?) {
        let error = self.parseError(response)
        Logger.shared.log(error, descriptions: response.debugDescription)
        if error.code == 0 {
            callback?(ErrorsFactory.General.connection)
            return
        }
        
        callback?(error)
    }

    private func parseError(_ response: DataResponse<Any>?) -> NSError {
        var message: String? = ""
        var errorsText: String?
        let statusCode: Int = (response?.response?.statusCode ?? 0)

        if let data = response?.data, data.count > 0 {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    message = json["message"] as? String
                    
                    if message?.isEmpty == true {
                        message = json["error"] as? String
                    }
                    
                    if let errorsArray = (json["errors"] as? [String: Any])?["errors"] as? [[String: String]] {
                        for errorDictionary in errorsArray {
                            if let errorText = errorDictionary["title"] {
                                if errorsText == nil {
                                    errorsText = errorText
                                } else {
                                    errorsText! += "\n" + errorText
                                }
                            }
                        }
                    }
                    
                    if message?.isEmpty == true && errorsText == nil {
                        return ErrorsFactory.General.unknown
                    }
                    
                }
            } catch {
                return ErrorsFactory.General.unknown
            }
        }

        return NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: (message ?? ""), "ServerErrorsText": errorsText as Any])
    }
    
}
