import AocMain
import Foundation

// All strings now to allow them to toggle back and forth
enum Instruction {
    case cpy( src:String, dst:String )
    case inc( reg:String )
    case dec( reg:String )
    case jnz( reg:String, offset:String )
    case tgl( offset:String )

    // Well, this was annoying.
    static func==( lhs : Instruction, rhs : Instruction ) -> Bool {
        switch lhs {
        case let .cpy( src, dst ):
            switch rhs {
            case let .cpy( src2, dst2 ): return src == src2 && dst == dst2
            default: return false
            }
        case let .inc( reg ):
            switch rhs {
            case let .inc( reg2 ): return reg == reg2
            default: return false
            }
        case let .dec( reg ):
            switch rhs {
            case let .dec( reg2 ): return reg == reg2
            default: return false
            }
        case let .tgl( o ):
            switch rhs {
            case let .tgl( o2 ): return o == o2
            default: return false
            }
        case let .jnz( a, b ):
            switch rhs {
            case let .jnz( a2, b2 ): return a == a2 && b == b2
            default: return false
            }
        }
    }
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
        // This is gross, but I'm not up for figuring it out in any more
        // detail, and the checks make sure the program is still correct.
        // 
        // Optimized multiply and add
        if programCounter == 4 &&
             program[programCounter] == Instruction.cpy( src:"b", dst:"c" ) &&
             program[programCounter + 1] == Instruction.inc( reg:"a" ) &&
             program[programCounter + 2] == Instruction.dec( reg:"c" ) &&
             program[programCounter + 3] == Instruction.jnz( reg:"c", offset:"-2" ) &&
             program[programCounter + 4] == Instruction.dec( reg:"d") &&
             program[programCounter + 5] == Instruction.jnz( reg:"d", offset:"-5" ) {
            print( "Add b \(registers["b"]) * d \(registers["d"]) to a." )
            registers["a"]! += registers["b"]! * registers["d"]!
            registers["c"] = 0
            registers["d"] = 0
            programCounter = programCounter + 5
        } else if programCounter == 21 &&
                    program[programCounter ] == Instruction.inc( reg:"a" ) &&
                    program[programCounter + 1] == Instruction.dec( reg:"d" ) &&
                    program[programCounter + 2] == Instruction.jnz( reg:"d", offset:"-2" ) {
            print( "Add d \(registers["d"]) to a." )
            registers["a"]! += registers["d"]!
            registers["d"] = 0
            programCounter = programCounter + 2
        }
                    
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
        case "tgl":
            return .tgl( offset:tokens[1] )
        default:
            return nil
        }
    }

    mutating func toggle() {
        switch self {
        case let .cpy( src, dst ):
            self = .jnz( reg:src, offset:dst )
        case let .inc( reg ):
            self = .dec( reg:reg )
        case let .dec( reg ):
            self = .inc( reg:reg )        
        case let .jnz( reg, offset ):
            self = .cpy( src:reg, dst:offset )
        case let .tgl( offset ):
            self = .inc( reg:offset )            
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
        case let .tgl( offset ):
            var instructionIndex : Int? = nil
            if let imm = Int( offset ) {
                instructionIndex = state.programCounter + imm
            } else if let v = state.registers[offset] {
                instructionIndex = state.programCounter + v
            }
            if let ii : Int = instructionIndex {
                if state.program.indices.contains( ii ) {
                    // print( "Old instruction: \(ii) \(state.program[ii])" )
                    state.program[ii].toggle()
                    // print( "New instruction: \(ii) \(state.program[ii])" )
                }
            }
            state.programCounter += 1            
        }
    }
}

func printProgram( _ state : ProgramState ) {
    for ( i, instruction ) in state.program.enumerated() {
        print( i, instruction )        
    }
}

func problem( input : String ) {
    let program = input.lines.flatMap { Instruction.parse( $0 ) }
    let state = ProgramState()
    state.program = program
    state.registers["a"] = 12
    while state.programCounter < program.count {
        print( state, state.program[state.programCounter] )
        state.execute()
    }
    print( state )
    printProgram( state )
}

main( problem )
