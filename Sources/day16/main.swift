import Foundation

let input = "11110010111001001"

// Part 1
// let diskSize = 272
// Part 2
let diskSize = 35651584

func reverseAndFlipBits( _ x : String ) -> String {
    return String( x.characters.reversed().map { $0 == "1" ? "0" : "1" } )
}

func dragon( _ a : String ) -> String {
    return a + "0" + reverseAndFlipBits( a )
}

/* Example cases
print( "1", dragon( "1" ) )
print( "0", dragon( "0" ) )
print( "11111", dragon( "11111" ) )
print( "111100001010", dragon( "111100001010" ) )
*/

var contents = input

while contents.characters.count < diskSize {
    print( "Size: \(contents.characters.count)" )
    contents = dragon( contents )
}

contents = String( contents.characters.prefix( diskSize ) )

// print( "Disk contents: \(contents)" )

// This function takes a surprisingly long time to compile if we don't
// specify the closure type (and sometimes failed.)
func pairwise( _ x : String ) -> [ (Character,Character) ] {
    let a = [Character]( x.characters )
    return ( 0..<(a.count/2) ).map { (i : Int) -> (Character, Character) in
        ( a[2*i],a[2*i+1] ) }
}

func checksum( _ x : String ) -> String {
    let reduced = pairwise( x ).map {
        (cp : (Character,Character)) -> Character in
        switch cp {
        case ("0","0"): return "1"
        case ("1","1"): return "1"
        case ("0","1"): return "0"
        case ("1","0"): return "0"
        default: return "x"
        }
    }
    print( "csum: \(reduced.count)" )
    let s = String( reduced )
    // print( s )
    if reduced.count % 2 == 1 {
        return s
    } else {
        return checksum( s )
    }
}

let cs = checksum( contents )
print( "Checksum: \(cs)" )


