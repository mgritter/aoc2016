import AocMain
import Foundation

enum Command {
    case swapPosition( x:Int, y:Int )
    case swapLetter( x:Character, y:Character )
    case rotateLeft( x:Int )
    case rotateRight( x:Int )
    case rotatePosition( x:Character )
    case reversePositions( x:Int, y:Int )
    case movePosition( x:Int, y:Int )

    static func parse( command : String ) -> Command? {
        // I wish I'd written that parsing library after all
        let tokens = command.components( separatedBy:" " )
        guard tokens.count > 2 else {
            return nil
        }
        switch (tokens[0], tokens[1]) {
        case ( "swap", "position" ):
            if let x = Int( tokens[2]), let y = Int( tokens[5]) {
                return .swapPosition( x:x, y:y )
            }
        case ( "swap", "letter" ):
            return .swapLetter( x:tokens[2].characters.first!,
                                y:tokens[5].characters.first! )
        case ( "rotate", "left" ):
            if let x = Int( tokens[2] ) {
                return.rotateLeft( x:x )
            }
        case ( "rotate", "right" ):
            if let x = Int( tokens[2] ) {
                return.rotateRight( x:x )
            }
        case ( "rotate", "based" ):
            return .rotatePosition( x:tokens[6].characters.first! )            
        case ( "reverse", "positions" ):
            if let x = Int( tokens[2]), let y = Int( tokens[4]) {
                return .reversePositions( x:x, y:y )
            }            
        case ( "move", "position" ):
            if let x = Int( tokens[2]), let y = Int( tokens[5]) {
                return .movePosition( x:x, y:y )
            }            
        default:
            print( "Unknown command: \(tokens)" )
        }
        return nil
    }

    func rotate( _ s : [Character], rightBy: Int ) -> [Character] {
        let rot = s.endIndex - ( rightBy % s.count )
        return [Character]( s.suffix( from:rot ) ) + s.prefix( upTo:rot )
    }

    func rotate( _ s : [Character], leftBy: Int ) -> [Character] {
        let rot = leftBy % s.count
        return [Character]( s.suffix( from:rot ) ) + s.prefix( upTo:rot )
    }

    func execute( on:inout [Character], quiet:Bool = false ) {
        let before = on
        
        switch self {
        case let .swapPosition( x, y ):
            swap( &on[x], &on[y] )
        case let .swapLetter( x, y ):
            if let i = on.index( of:x ), let j = on.index( of:y ) {
                swap( &on[i], &on[j] )
            } else {
                print( "Unknown letters: \(x) \(y) in \(on)" )
            }        
        case let .rotateLeft( x ):
            on = rotate( on, leftBy: x )
        case let .rotateRight( x ):
            on = rotate( on, rightBy:x )
        case let .rotatePosition( x ):
            if var rot = on.index( of:x ) {
                if rot >= 4 {
                    rot += 1
                }
                on = rotate( on, rightBy:rot+1 )
            } else {
                print( "Unknown letter: \(x) in \(on)" )
            }
        case let .reversePositions( x, y ):
            on = on.prefix( upTo: x ) +
              on[ x...y ].reversed() +
              on.suffix( from:y+1 )
        case let .movePosition( x, y ):
            var tmp = on
            let c = tmp.remove( at:x )
            tmp.insert( c, at:y )
            on = tmp
        }

        if !quiet {
            print( "before=\(String(before)) after=\(String(on)) \(self)" )
        }
        assert( before.count == on.count )
    }

    func reverse( on:inout [Character] ) {
        let after = on
        
        commandType: switch self {
        case let .swapPosition( x, y ):
            // self-inverse
            swap( &on[x], &on[y] )
        case let .swapLetter( x, y ):
            // self-inverse
            if let i = on.index( of:x ), let j = on.index( of:y ) {
                swap( &on[i], &on[j] )
            } else {
                print( "Unknown letters: \(x) \(y) in \(on)" )
            }        
        case let .rotateLeft( x ):
            // right is the inverse of left
            on = rotate( on, rightBy:x )
        case let .rotateRight( x ):
            on = rotate( on, leftBy:x )
        case .rotatePosition:
            // Perhaps there's something clever here, but let's just try
            // the possibilities and see which result in the correct rotation.
            for l in 0..<on.count {
                let attempt = rotate( on, leftBy:l )
                var tmp = attempt
                execute( on:&tmp, quiet:true )
                if tmp == on {
                    on = attempt
                    break commandType
                }
            }
            preconditionFailure( "No preimage found for \(self) on \(on)." )
        case let .reversePositions( x, y ):
            // self-inverse
            on = on.prefix( upTo: x ) +
              on[ x...y ].reversed() +
              on.suffix( from:y+1 )
        case let .movePosition( x, y ):
            // self-inverse with reversed coordinates
            var tmp = on
            let c = tmp.remove( at:y )
            tmp.insert( c, at:x )
            on = tmp
        }

        print( "after=\(String(after)) before=\(String(on)) \(self)" )
        assert( after.count == on.count )

        // Test that we really got a preimage
        var check = on
        execute( on:&check, quiet:true )
        assert( check == after, "Postimage is \(String(check)), not \(String(after))." )
    }

}

func problem( input : String ) {
    let commands = input.lines.flatMap( Command.parse )
    var password : [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
    //var password : [Character] = ["a", "b", "c", "d", "e"]
    for c in commands {
        c.execute( on:&password )
    }
    print( "Scrambled:", String(password) )

    var scrambled : [Character] = ["f", "b", "g", "d", "c", "e", "a", "h"]
    for c in commands.reversed() {
        c.reverse( on:&scrambled )
    }
    print( "Unscrambled:", String(scrambled) )
    
}

main( problem )
