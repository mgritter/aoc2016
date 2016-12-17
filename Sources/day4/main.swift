import AocMain
import Foundation

func parseRoom( name : String ) -> ( letters: String,
                                     sector: Int,
                                     checksum: String ) {
    let bracketStart = name.range( of: "[" )!
    let bracketEnd = name.range( of: "]" )!
    let checksum = name.substring( with: bracketStart.upperBound..<bracketEnd.lowerBound )
    let lastHyphen = name.range( of:"-", options:.backwards )!
    let sector = Int( name.substring( with: lastHyphen.upperBound..<bracketStart.lowerBound ) )
    let letters = name
      .substring( with: name.startIndex..<lastHyphen.lowerBound)
    return ( letters, sector!, checksum )
}

extension String {
    func count( numberOf c:Character ) -> Int {
        return self.characters.map( { $0 == c ? 1 : 0 } ).reduce( 0, + )
    }
}

func generateChecksum( letters:String ) -> String {
    // Sort the characters by # of occurrences, then by alphabetical order
    func comparisonOrder( _ a : Character, _ b: Character ) -> Bool {
        let countA = letters.count( numberOf:a ),
            countB = letters.count( numberOf:b )
        return ( countA > countB ) ||
          ( countA == countB && a < b )
    }
    var chars = Set( letters.characters )
    chars.remove( "-" )
    let sortedChars = chars.sorted( by:comparisonOrder )
    print( "generateChecksum \(letters) = \(sortedChars)" )
    return String( sortedChars[0...4] )
}

func validRoom( letters: String, checksum: String ) -> Bool {
    return generateChecksum( letters:letters ) == checksum
}

func decode( letters : String, by: UInt32 ) -> String {
    func decodeChar( ch : Character ) -> Character {
        // I refuse to go through the rediculous conversion
        // process *twice*.
        let scalar_a : UInt32 = 97;
          
        switch ch {
        case "a"..."z":
            let scalars = String( ch ).unicodeScalars
            let val = scalars[scalars.startIndex].value - scalar_a
            let valInc = scalar_a + ( val + by ) % 26
            return Character( UnicodeScalar( valInc )! )
            
        case "-":
                return " "
        default:
            return ch
        }          
    }
    return String( letters.characters.map( decodeChar ) )
}

func problem( input : String ) {
    var totalSectors = 0;
    for line in input.lines {
        if line == "" {
            continue
        }
        let ( letters, sector, checksum ) = parseRoom( name: line )
        if validRoom( letters:letters, checksum:checksum ) {
            let roomName = decode( letters:letters, by:UInt32(sector) )
            print( "valid \(letters) \(checksum) \(sector) \(roomName)" )
            totalSectors += sector
        } else {
            // print( "invalid \(letters) \(checksum)" )
        }
    }
    print( "Total of sectors: \(totalSectors)" )
}

main( problem )
