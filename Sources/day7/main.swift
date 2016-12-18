import AocMain
import Foundation


class CircularBuffer {
    var buf : [Character]
    var i : Int
    let size : Int

    init( size : Int ) {
        self.size = size
        self.buf = Array( repeating: "\0", count: size )
        self.i = 0
    }

    func reset() {
        self.buf = Array( repeating: "\0", count: size )
    }
    
    func add( character : Character ) {
        i = (i + 1) % size
        buf[i] = character
    }

    func history( _ relative : Int ) -> Character {
        return buf[( i + size + relative ) % size]
    }
                
    func abbaAtEnd() -> Bool {
        // print ( self.history( -3 ), self.history( -2 ),
        //         self.history( -1 ), self.history( 0 ) )
        return self.history( 0 ) != self.history( -1 ) &&
          self.history( -1 ) == self.history( -2 ) &&
          self.history( 0 ) == self.history( -3 )
    }

    func abaAtEnd() -> String? {
        if self.history( 0 ) != self.history( -1 ) &&
             self.history( 0 ) == self.history( -2 ) {
            return String( [ self.history( -2 ), self.history( -1 ),
                             self.history( 0 ) ] )
        } else {
            return nil
        }
    }

    func babAtEnd() -> String? {
        if self.history( 0 ) != self.history( -1 ) &&
             self.history( 0 ) == self.history( -2 ) {
            // Inverted
            return String( [ self.history( -1 ), self.history( -2 ),
                             self.history( -1 ) ] )
        } else {
            return nil
        }    
    }

}

func parse( address : String ) -> ( tls : Bool,
                                    ssl : Bool ) {
    var abbaInAddress = false
    var abbaInNode = false
    var inNode = false
    var abaInAddress : Set<String> = []
    // This set should be reversed so that we match
    // xyx in the address with yxy in the string
    var abaInNode : Set<String> = []

    // 'buf' the reference is never modified even though its contents are
    let buf = CircularBuffer( size:4 )
    for c in address.characters {
        switch c {
        case "[":
            precondition( !inNode )
            inNode = true
            buf.reset()
        case "]":
            precondition( inNode )
            inNode = false
            buf.reset()
        default:
            buf.add( character: c )
            if buf.abbaAtEnd() {
                if inNode {
                    abbaInNode = true
                } else {
                    abbaInAddress = true
                }
            }
            if inNode {
                if let x = buf.babAtEnd() {
                    abaInNode.insert( x )
                }
            } else {
                if let x = buf.abaAtEnd() {
                    abaInAddress.insert( x )
                }
            }
        }
    }

    return ( abbaInAddress && !abbaInNode,
             !abaInAddress.intersection( abaInNode ).isEmpty )             
}

func problem( input : String ) {
    var tlsCount = 0, sslCount = 0
    for line in input.lines {
        if line == "" {
            continue
        }
        let ( tls, ssl ) = parse( address:line )
        print( "\(line) TLS=\(tls) SSL=\(ssl)" )
        if tls {
            tlsCount += 1
        }
        if ssl {
            sslCount += 1
        }
    }
    print( "\(tlsCount) TLS-supported addresses" )
    print( "\(sslCount) SSL-supported addresses" )
}


main( problem )
