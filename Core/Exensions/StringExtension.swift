import Foundation
import CryptoKit

public extension String {
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
