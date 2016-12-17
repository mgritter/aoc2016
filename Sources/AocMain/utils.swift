import Foundation

extension String {
    public var lines : [String] {
        get {
            return self.components( separatedBy: "\n" ).map { $0.trimmingCharacters( in:.whitespaces ) }
        }
    }
}
