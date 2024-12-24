import Foundation

public extension Date {
    func getTimeIntervalSince1970() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
