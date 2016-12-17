import CryptoSwift
import Foundation

let input = "ffykfhsq"
var counter = 0
var numDigits = 8
let numZeros = 5
// FIXME: what is a Swiftian way of doing this?
let zeros = "00000"
var password = "--------"

while numDigits > 0 {
    let computeString = "\(input)\(counter)"
    let digest : String = computeString.md5()
    let endOffset = digest.index( digest.startIndex, offsetBy:numZeros )
    if digest.substring( with:digest.startIndex..<endOffset ) == zeros {
        let five = digest.index( after:endOffset )
        let six = digest.index( after:five )
        if let i = Int( digest.substring( with:endOffset..<five ),
                        radix:16 ) {
            if i < numDigits {
                let passwordIndex = digest.index( digest.startIndex,
                                                  offsetBy:i )
                if password[passwordIndex] == "-" {
                    let passwordDigit = digest.substring( with:five..<six )
                    password.replaceSubrange( passwordIndex...passwordIndex,
                                              with:passwordDigit )
                }
            }
        }
        print( digest, password, counter )
    }
    counter += 1
}
