import AocMain
import Foundation

func splitLines( _ input : String ) -> [String] {
    return input.components( separatedBy: "\n" ).map { $0.trimmingCharacters( in:.whitespaces ) }
}

func splitNumbers( _ input : String ) -> [Int] {
    return input.replacingOccurrences( of: "\\s+", with: " ", options: .regularExpression )
      .components( separatedBy: " " ).map { Int( $0 )! } 
}

func possibleTriangle( sides : [Int] ) -> Bool {
    let inOrder = sides.sorted()
    return ( inOrder[0] + inOrder[1] > inOrder[2] )
}

func possibleTriangles( sides: [[Int]] ) -> Int {
    var count = 0
    for i in 0...2 {
        if possibleTriangle( sides: [ sides[0][i], sides[1][i], sides[2][i] ] ) {
            count += 1 
        }
    }
    return count
}

func problem( input : String ) {
    var count = 0
    var triangleBuffer : [[Int]] = []
    var vertCount = 0
    
    for line in splitLines( input ) {
        if line == "" {
            continue
        }
        let nums = splitNumbers( line )
        let possible = possibleTriangle( sides: nums )
        print( nums[0], nums[1], nums[2], possible )
        if possible {
            count += 1
        }
        triangleBuffer.append( nums )
        if triangleBuffer.count == 3 {
            vertCount += possibleTriangles( sides: triangleBuffer )
            triangleBuffer.removeAll()
        }
    }
    print( "Total possible triangles (horizontal): \(count)" )
    print( "Total possible triangles (vertical): \(vertCount)" )
}
  
main( problem )
