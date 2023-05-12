import Foundation

protocol MainLoader {
    typealias Result = Swift.Result<MainModel, Error>
    
    func load(completion: @escaping (Result) -> ())
}
