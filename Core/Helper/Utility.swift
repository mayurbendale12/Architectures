import Foundation

public class Utility {
    public static var timestamp: String {
        return String(Date().getTimeIntervalSince1970())
    }

    public static var hash: String {
        return String(timestamp + Constants.API.PRIVATE_KEY + Constants.API.PUBLIC_KEY).md5()
    }
}
