import AocMain
import Foundation

class ParserOutput {
    var length : Int = 0

    func append( _ c : Character ) {
        length += 1
    }

    func appendCopy( length : Int,
                     numCopies : Int ) {
        self.length += length * numCopies
    }
}

/* This version recurses forever 
func isWhitespace( _ c : Character ) -> Bool {
    return !( CharacterSet.whitespaces.isDisjoint(
                with:CharacterSet( charactersIn:String( c ) ) ) )
}
*/

func isWhitespace( _ c : Character ) -> Bool {
    let ws = CharacterSet.whitespacesAndNewlines
    for scalar in String( c ).unicodeScalars {
        if ws.contains( scalar ) {
            return true
        }
    }
    return false
}

protocol ParserState {
    func visit( input : Character,
                output : ParserOutput ) -> ParserState

}

// The initial, default state that just copies characters
class CopyState : ParserState {
    func visit( input : Character,
                output : ParserOutput ) -> ParserState {
        switch input {
        case "(":
            return CommandState()
        case let c where isWhitespace( c ):
            return self
        default:
            output.append( input )
            return self
        }
    }

    func finish( output : ParserOutput ) {
    }
}

// Parsing a command until the 'x''
class CommandState : ParserState {
    var length : String = ""
    
    func visit( input : Character,
                output : ParserOutput ) -> ParserState {
        switch input {
        case "x":
            print( "Length: \(Int(length))" )
            return CommandState2( length : Int(length)! )
        case let c where isWhitespace( c ):
            return self
        default:
            length.append( input )
            return self
        }
    }
}

// Parsing a command until the ')'
class CommandState2 : ParserState {
    var length : Int
    var numCopies : String = ""
    
    init( length : Int  ) {
        self.length = length
    }

    func visit( input : Character,
                output : ParserOutput ) -> ParserState {
        switch input {
        case ")":
            let nc = Int(numCopies)!
            print( "Num copies: \(nc)" )
            if length == 0 || nc == 0 {
                return CopyState()
            } else {
                return ArgumentState( numCopies : nc,
                                      length : length )
            }
        case let c where isWhitespace( c ):
            return self
        default:
            numCopies.append( input )
            return self
        }
    }
}

// Reading the argument of a copy command, a fixed number
// of characters.
class ArgumentState : ParserState {
    var length : Int;
    var numCopies : Int
    var argument : String = ""
    
    init( numCopies : Int,
          length : Int ) {
        self.length = length
        self.numCopies = numCopies
    }

    func visit( input : Character,
                output : ParserOutput ) -> ParserState {
        switch input {
        case let c where isWhitespace( c ):
            return self
        default:
            argument.append( input )
            length -= 1
            if length == 0 {
                print( "\(numCopies) copies of '\(argument)'" )
                let dl = decompressedLength( input: argument );
                output.appendCopy( length:dl,
                                   numCopies:numCopies )
                return CopyState()
            } else {
                return self
            }
        }
    }
}

func decompressedLength( input : String ) -> Int {
    var p : ParserState = CopyState()
    let o = ParserOutput()
    for c in input.characters {
        p = p.visit( input:c, output:o )
    }
    return o.length
}

func problem( input : String ) {
    let l = decompressedLength( input:input )
    print( "Input length: \(input.characters.count)" )
    print( "Result: '\(l)'" )
}

main( problem )
