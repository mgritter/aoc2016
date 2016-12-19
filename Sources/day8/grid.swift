
class Grid : CustomStringConvertible {
    var matrix : [[Bool]]
    let width : Int
    let height : Int
    
    init( width : Int, height : Int ) {
        self.width = width
        self.height = height
        let row = [Bool]( repeating:false, count:width )
        // Arrays are copy-by-value, right?
        matrix = [[Bool]]( repeating:row, count:height )
    }

    func rect( width : Int, height : Int ) {
        for y in 0..<height {
            for x in 0..<width {
                matrix[y][x] = true
            }
        }
    }

    static func rotate( vec:[Bool], by:Int ) -> [Bool] {
        let shift = by % vec.count
        // to shift right by 1, take the 1 entry at the end,
        // followed by the N-1 entries at the beginning
        return Array( vec.suffix( shift ) + vec.prefix( vec.count - shift ) )
    }
    
    func rotateRow( y : Int, by : Int ) {
        matrix[y] = Grid.rotate( vec:matrix[y], by:by )
    }

    func column( x : Int ) -> [Bool] {
        return (0..<height).map { matrix[$0][x] }
    }

    func setColumn( x : Int, values : [Bool] ) {
        (0..<height).forEach { matrix[$0][x] = values[$0] }
    }
    
    func rotateColumn( x : Int, by : Int ) {
        setColumn( x:x, values:Grid.rotate( vec:column( x:x ), by: by ) )
    }

    var description : String {
        return ( 0..<height ).map(
          { y in
            ( 0..<width )
              .map( { x in matrix[y][x] ? "o" : " "} ) 
              .reduce( "", + ) + "\n"
          }
        ).reduce( "", + )
    }

    var count : Int {
        return ( 0..<height ).map(
          { y in
            ( 0..<width )
              .map( { x in matrix[y][x] ? 1 : 0 } ) 
              .reduce( 0, + )
          }
        ).reduce( 0, + )
    }
}
