import Foundation

final class APICallFake {
    func sss (forResource: String) -> Data? {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
}
