import AocMain
import Foundation

class ProgramState : CustomStringConvertible {
    var programCounter = 0
    var registers = [ String:Int ]()

    init() {
        registers["a"] = 0
        registers["b"] = 0
        registers["c"] = 0
        registers["d"] = 0
    }

    var description : String {
        return "pc=\(programCounter) reg=\(registers)"
    }

}

enum Instruction {
    case cpyImm( value:Int, dst:String )
    case cpyReg( src:String, dst:String )
    case inc( reg:String )
    case dec( reg:String )
    case jnz( reg:String, offset:Int )
    case jnzImm( value:Int, offset:Int )

    static func parse( _ input : String ) -> Instruction? {
        let tokens = input.components( separatedBy: " " )
        guard tokens.count > 0 else {
            return nil
        }
        switch tokens[0] {
        case "cpy":
            if let val = Int( tokens[1] ) {
                return .cpyImm( value:val, dst:tokens[2] )
            } else {
                return .cpyReg( src:tokens[1], dst:tokens[2] )
            }            
        case "inc":
            return .inc( reg:tokens[1] )
        case "dec":
            return .dec( reg:tokens[1] )
        case "jnz":
            if let offset = Int( tokens[2] ) {
                if let constant = Int( tokens[1] ) {
                    return .jnzImm( value:constant, offset:offset )
                } else {
                    return .jnz( reg:tokens[1], offset:offset )
                }
            } else {
                return nil
            }
        default:
            return nil
        }
    }

    func execute( state : ProgramState ) {
        switch self {
        case let .cpyImm( v, r ):
            state.registers[r]! = v
            state.programCounter += 1
        case let .cpyReg( s, d ):
            state.registers[d]! = state.registers[s]!
            state.programCounter += 1
        case let .inc( r ):
            state.registers[r]! += 1
            state.programCounter += 1
        case let .dec( r ):
            state.registers[r]! -= 1
            state.programCounter += 1
        case let .jnz( r, offset ):
            if state.registers[r]! == 0 {
                state.programCounter += 1                
            } else {
                state.programCounter += offset
            }
        case let .jnzImm( value, offset ):
            if value == 0 {
                state.programCounter += 1                
            } else {
                state.programCounter += offset
            }
        }
    }
}

func problem( input : String ) {
    var program = input.lines.flatMap { Instruction.parse( $0 ) }
    let state = ProgramState()
    state.registers["c"] = 1
    while state.programCounter < program.count {
        //print( state, program[state.programCounter] )
        program[state.programCounter].execute( state:state )
    }
    print( state )
}

main( problem )
