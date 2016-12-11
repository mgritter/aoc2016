// From: https://gist.github.com/erica/7aee99db9753a1636e0fbed8d68b5845


#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public enum FileReadError : Error {
    case FileNotFound
}

public func readStringFromFile(path: String) throws -> String {
    let fp = fopen(path, "r")
    if fp == nil {
        throw FileReadError.FileNotFound
    }
    defer { fclose(fp) }
    var outputString = ""
    let chunkSize = 1024
    let buffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer.allocate(capacity: chunkSize + 1)
    defer { buffer.deallocate( capacity: chunkSize + 1) }
    repeat {
        let count: Int = fread(buffer, 1, chunkSize, fp)
        guard ferror(fp) == 0 else { break }
        buffer[count] = 0
        if count > 0 {
            let ptr = unsafeBitCast(buffer, to: UnsafePointer<CChar>.self)
            if let newString = String(validatingUTF8: ptr) {
                outputString += newString
            }
        }
    } while feof(fp) == 0
    
    return outputString
}
    
