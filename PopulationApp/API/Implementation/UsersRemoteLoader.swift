import Foundation

public final class UsersRemoteLoader: UsersLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = UsersLoaderResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.getUrl(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(UsersRemoteLoader.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map (data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try UsersRemoteItemMapper.map(data, from: response)
            return .success(items.toModels())
        } catch let error {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteUserItem {
    func toModels() -> [User] {
        return map {
            User(
                id: $0.id,
                firstName: $0.firstName,
                lastName: $0.lastName,
                maidenName: $0.maidenName,
                age: $0.age,
                email: $0.email,
                phone: $0.phone,
                username: $0.username,
                password: $0.password,
                birthDate: $0.birthDate,
                image: $0.image,
                bloodGroup: $0.bloodGroup,
                height: $0.height,
                weight: $0.weight,
                domain: $0.domain,
                ip: $0.ip,
                macAddress: $0.macAddress,
                university: $0.university,
                ein: $0.ein,
                ssn: $0.ssn,
                userAgent: $0.userAgent
            )
        }
    }
}

