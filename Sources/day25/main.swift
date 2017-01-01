import AocMain
import Foundation

enum Instruction {
    case cpy( src:String, dst:String )
    case inc( reg:String )
    case dec( reg:String )
    case jnz( reg:String, offset:String )
    case out( reg:String )
}

class ProgramState : CustomStringConvertible {
    var programCounter = 0
    var registers = [ String:Int ]()
    var program = [Instruction]()
    
    init() {
        registers["a"] = 0
        registers["b"] = 0
        registers["c"] = 0
        registers["d"] = 0
    }

    var description : String {
        return "pc=\(programCounter) reg=\(registers)"
    }

    func execute() {
        program[programCounter].execute( state:self )
    }

}

extension Instruction {
    static func parse( _ input : String ) -> Instruction? {
        let tokens = input.components( separatedBy: " " )
        guard tokens.count > 0 else {
            return nil
        }
        switch tokens[0] {
        case "cpy":
            return .cpy( src:tokens[1], dst:tokens[2] )
        case "inc":
            return .inc( reg:tokens[1] )
        case "dec":
            return .dec( reg:tokens[1] )
        case "jnz":
            return .jnz( reg:tokens[1], offset:tokens[2] )
        case "out":
            return .out( reg:tokens[1] )
        default:
            return nil
        }
    }

    func execute( state : ProgramState ) {
        switch self {
        case let .cpy( s, d ):
            if let imm = Int( s ) {
                state.registers[d]! = imm
                state.programCounter += 1
            } else if state.registers.keys.contains( d ) {
                state.registers[d]! = state.registers[s]!
                state.programCounter += 1
            } else {
                // Invalid
                state.programCounter += 1
            }
        case let .inc( r ):
            if state.registers.keys.contains( r ) {
                state.registers[r]! += 1
            }
            state.programCounter += 1
        case let .dec( r ):
            if state.registers.keys.contains( r ) {
                state.registers[r]! -= 1
            }
            state.programCounter += 1
        case let .jnz( r, offset ):
            var notZero : Bool
            if let imm = Int( r ) {
                notZero = ( imm != 0 )
            } else if let v = state.registers[r] {
                notZero = ( v != 0 )
            } else {
                // Skip the instruction?  Shouldn't happen
                notZero = false
            }
            if notZero {
                if let o = Int( offset ) {
                    state.programCounter += o
                } else if let v = state.registers[offset] {
                    state.programCounter += v
                } else {
                    state.programCounter += 1
                }                         
            } else {
                state.programCounter += 1
            }
        case let .out( r ):
            if state.registers.keys.contains( r ) {
                print( "OUTPUT: ", state.registers[r] ?? "x" )
                print( state )
            }
            state.programCounter += 1
        }
    }
}

func problem( input : String ) {
    let program = input.lines.flatMap { Instruction.parse( $0 ) }
    let state = ProgramState()
    state.program = program
    // Test value
    // state.registers["a"] = -2536
    // Production value
    state.registers["a"] = 192
    while state.programCounter < program.count {
        // print( state, state.program[state.programCounter] )
        state.execute()
    }
    print( state )
}

main( problem )
