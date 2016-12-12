
struct KeypadCoordinate : Hashable {    
    let x : Int
    let y : Int

    var hashValue : Int {
        get {
            return x ^ y
        }
    }
}

var digits = [ KeypadCoordinate : String ]()

func createDigit( _ x : Int, _ y : Int, _ k : String ) {
    digits[ KeypadCoordinate( x: x, y : y ) ] = k
}

func createStandardDigits() {
    createDigit( 0, 0, "1" )
    createDigit( 1, 0, "2" )
    createDigit( 2, 0, "3" )
    createDigit( 0, 1, "4" )
    createDigit( 1, 1, "5" )
    createDigit( 2, 1, "6" )
    createDigit( 0, 2, "7" )
    createDigit( 1, 2, "8" )
    createDigit( 2, 2, "9" )
}

func createPart2Digits() {
    createDigit( 2, 0, "1" )
    createDigit( 1, 1, "2" )
    createDigit( 2, 1, "3" )
    createDigit( 3, 1, "4" )
    createDigit( 0, 2, "5" )
    createDigit( 1, 2, "6" )
    createDigit( 2, 2, "7" )
    createDigit( 3, 2, "8" )
    createDigit( 4, 2, "9" )
    createDigit( 1, 3, "A" )
    createDigit( 2, 3, "B" )
    createDigit( 3, 3, "C" )
    createDigit( 2, 4, "D" )
}

extension KeypadCoordinate {
    func left() -> KeypadCoordinate {
        return check( KeypadCoordinate( x : x-1, y : y ) )
    }

    func right() -> KeypadCoordinate {
        return check( KeypadCoordinate( x : x+1, y : y ) )
    }

    func up() -> KeypadCoordinate {
        return check( KeypadCoordinate( x : x, y : y-1 ) )
    }

    func down() -> KeypadCoordinate {
        return check( KeypadCoordinate( x : x, y : y+1 ) )
    }

    var keypadDigit : String? {
        return digits[ self ]
    }

    func check( _ candidate: KeypadCoordinate ) -> KeypadCoordinate {
        if candidate.keypadDigit == nil {
            return self
        } else {
            return candidate
        }
    }
}

func ==(left: KeypadCoordinate, right: KeypadCoordinate) -> Bool {
    return left.x == right.x && left.y == right.y
}
