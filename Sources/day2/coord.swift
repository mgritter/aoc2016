
let xBound = 2
let yBound = 2

struct BoundedCoordinate {    
    let x : Int
    let y : Int

    func left() -> BoundedCoordinate {
        if x > 0 {
             return BoundedCoordinate( x : x - 1, y : y )
        } else {
            return self
        }
    }

    func right() -> BoundedCoordinate {
        if x < xBound {
             return BoundedCoordinate( x : x + 1, y : y )
        } else {
            return self
        }
    }

    func up() -> BoundedCoordinate {
        if y > 0 {
             return BoundedCoordinate( x : x, y : y - 1 )
        } else {
            return self
        }
        
    }

    func down() -> BoundedCoordinate {
        if y < yBound {
             return BoundedCoordinate( x : x, y : y + 1 )
        } else {
            return self
        }
    }

    var keypadDigit : String {
        get {
            switch (x,y) {
            case (0,0): return "1"
            case (1,0): return "2"
            case (2,0): return "3"
            case (0,1): return "4"
            case (1,1): return "5"
            case (2,1): return "6"
            case (0,2): return "7"
            case (1,2): return "8"
            case (2,2): return "9"
            default:
                preconditionFailure( "Bad coordinate \(x),\(y)" )
            }
        }
    }
}


func ==(left: BoundedCoordinate, right: BoundedCoordinate) -> Bool {
    return left.x == right.x && left.y == right.y
}
