import AocMain
import Foundation

func problem( input : String ) {
    let g = Grid( width: 50, height: 6 )
    let cs = CharacterSet( charactersIn:" x=" )
    for line in input.lines {
        if line == "" {
            continue
        }
        let tokens = line.components( separatedBy: cs )
        switch ( tokens[0], tokens[1] ) {
        case ( "rect", let widthText ):
            let heightText = tokens[2]
            g.rect( width:Int( widthText )!,
                    height:Int( heightText )! )                
        case ( "rotate", "row" ):
            let yText = tokens[3]
            let byText = tokens[5]
            g.rotateRow( y:Int( yText )!,
                         by:Int( byText )! )
        case ( "rotate", "column" ):
            let xText = tokens[4]
            let byText = tokens[6]
            g.rotateColumn( x:Int( xText )!,
                            by:Int( byText )! )
        default:
            preconditionFailure( "Unknown command: \(tokens)" )
        }
    }
    
    print( "Grid:\n\(g)" )   
    print( "Weight\n\(g.count)" )   
}

func example() {
    let g = Grid( width: 7, height: 3 )
    print( "Start:\n", g, separator:"" )
    g.rect( width: 3, height: 2 )
    print( "rect:\n", g, separator:"" )
    g.rotateColumn( x:1, by:1 )
    print( "rotate x=1 by 1:\n", g, separator:"" )
    g.rotateRow( y:0, by:4 )
    print( "rotate y=0 by 4:\n", g, separator:"" )
    g.rotateColumn( x:1, by:1 )
    print( "rotate x=1 by 1:\n", g, separator:"" )
}

// example()
main( problem )
