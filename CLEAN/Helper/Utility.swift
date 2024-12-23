import Foundation

class Utility {
    static var timestamp: String {
        return String(Date().getTimeIntervalSince1970())
    }

    static var hash: String {
        return String(timestamp + Constants.API.PRIVATE_KEY + Constants.API.PUBLIC_KEY).md5()
    }
}
