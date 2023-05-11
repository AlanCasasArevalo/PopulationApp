import Foundation

internal struct RemoteUserItem : Decodable {
    internal let id: Int
    internal let firstName, lastName, maidenName: String?
    internal let age: Int?
    internal let email, phone, username, password: String?
    internal let birthDate: String?
    internal let image: String?
    internal let bloodGroup: String?
    internal let height: Int?
    internal let weight: Double?
    internal let domain, ip: String?
    internal let macAddress, university: String?
    internal let ein, ssn, userAgent: String?
}
