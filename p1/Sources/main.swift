import Foundation

func parse( problem : String ) -> [(String,Int)] {
    let raw = problem.components( separatedBy: ", " )
    let out = raw.map( { (token) -> (String,Int) in
                           let i = token.index( after:token.startIndex )
                           let numeral = token[i..<token.endIndex].trimmingCharacters( in:CharacterSet.whitespacesAndNewlines )
                           let num = Int( numeral, radix:10 )
                           return ( token[token.startIndex...token.startIndex],
                                    num! ) } )
    return out                      
}

func walk( steps: [(String,Int)] ) -> ( Int, Int ) {
    var orientation = 1
    var xPos = 0, yPos = 0
    var visited = Set<(Int,Int)>( [ (xPos, yPos) ] )
    for ( dir, len ) in steps {
        print( "X \(xPos) Y \(yPos) \(orientation) \(dir)\(len)" )
        switch dir {
        case "L":
            orientation -= 1
            if orientation < 1 {
                orientation += 4
            }
        case "R":
            orientation += 1
            if orientation > 4 {
                orientation -= 4
            }
        default:
            print( "Unknown direction \(dir)" )
        }
        let xOld = xPos, yOld = yPos
        switch orientation {
        case 1: // North
            yPos += len
        case 2: // East
            xPos += len
        case 3: // South
            yPos -= len
        case 4: // West
            xPos -= len
        default:              
            break
        }
        assert( xOld != xPos || yOld != yPos || len == 0 )
        visited.insert( (xPos, yPos ) )
    }
    return ( xPos, yPos )
}

func main() throws {
    do {
        guard CommandLine.argc == 2 else {
            print( "Specify the input file on the command line." )
            return
        }
        let inputFn = CommandLine.arguments[1]
        let input = try readStringFromFile( path:inputFn )
        let steps = parse( problem: input )
        let ( xPos, yPos ) = walk( steps: steps )
        print( "Final position (\(xPos),\(yPos))" )
        let distance = abs( xPos ) + abs( yPos )
        print( "Distance \(distance)" )
    } catch FileReadError.FileNotFound {
        print( "File not found." )
    } catch {
        print( "Some other error." )
    }
}

try main()

