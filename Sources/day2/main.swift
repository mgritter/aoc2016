import Foundation
import SimpleFile

func splitLines( _ input : String ) -> [String] {
    return input.components( separatedBy: "\n" )
}

func walk( directions : String, start : KeypadCoordinate ) -> KeypadCoordinate {
    var pos = start
    for d in directions.characters {
        switch d {
        case "U": pos = pos.up()
        case "D": pos = pos.down()
        case "L": pos = pos.left()
        case "R": pos = pos.right()
        default:
            preconditionFailure( "Bad direction \(d)" )
        }
        print( "\(d) \(pos.x) \(pos.y)" )
    }
    return pos
}

func main() {
    do {
        guard CommandLine.argc == 2 else {
            print( "Specify the input file on the command line." )
            return
        }
        let inputFn = CommandLine.arguments[1]
        let input = try readStringFromFile( path:inputFn )
        let lines = splitLines( input )

        /*
        createStandardDigits()
        var pos = KeypadCoordinate( x:1, y:1 )
        */
        createPart2Digits()
        var pos = KeypadCoordinate( x:0, y:2 )
        
        var code = ""
        for l in lines {
            // Fix badly copied input
            if l == "" {
                break
            }
            
            print( "line: '\(l)'" )
            pos = walk( directions:l, start:pos )
            code += pos.keypadDigit!
        }

        print( code )
    } catch FileReadError.FileNotFound {
        print( "File not found." )
    } catch {
        print( "Some other error." )
    }
}

main()

