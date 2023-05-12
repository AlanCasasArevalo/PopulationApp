import Foundation

// MARK: - UserResultsModel
public struct UserResultsModel: Equatable {
    let users: [User]?
    let total, skip, limit: Int?
    
    public init(users: [User]?, total: Int?, skip: Int?, limit: Int?) {
        self.users = users
        self.total = total
        self.skip = skip
        self.limit = limit
    }
}

// MARK: - User
public struct User: Equatable {
    let id: Int?
    let firstName, lastName, maidenName: String?
    let age: Int?
    let email, phone, username, password: String?
    let birthDate: String?
    let image: String?
    let bloodGroup: String?
    let height: Int?
    let weight: Double?
    let domain, ip: String?
    let macAddress, university: String?
    let ein, ssn, userAgent: String?
    
    public init(id: Int?, firstName: String?, lastName: String?, maidenName: String?, age: Int?, email: String?, phone: String?, username: String?, password: String?, birthDate: String?, image: String?, bloodGroup: String?, height: Int?, weight: Double?, domain: String?, ip: String?, macAddress: String?, university: String?, ein: String?, ssn: String?, userAgent: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.maidenName = maidenName
        self.age = age
        self.email = email
        self.phone = phone
        self.username = username
        self.password = password
        self.birthDate = birthDate
        self.image = image
        self.bloodGroup = bloodGroup
        self.height = height
        self.weight = weight
        self.domain = domain
        self.ip = ip
        self.macAddress = macAddress
        self.university = university
        self.ein = ein
        self.ssn = ssn
        self.userAgent = userAgent
    }
}

