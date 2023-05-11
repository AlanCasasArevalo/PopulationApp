import Foundation

final class HTTPClientFake: HTTPClient {
        
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {
    }
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func getUrl(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            completion(Result {
                if let data = self?.getJSONFromLocal(url: url) {
                    return (data, HTTPURLResponse())
                }                
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
    
    func getJSONFromLocal (url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
}
