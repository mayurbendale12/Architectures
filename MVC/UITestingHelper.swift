#if DEBUG

import Foundation
struct UITestingHelper {
    static var isUITesting: Bool {
        CommandLine.arguments.contains("-ui-testing") ||
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }

    static var isNetworkingSuccessful: Bool {
        ProcessInfo.processInfo.environment["-networking-success"] == "1"
    }
}

#endif
