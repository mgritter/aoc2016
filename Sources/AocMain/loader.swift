import SimpleFile

public func main( _ solveProblem : (String) -> () ) {
    do {
        guard CommandLine.argc == 2 else {
            print( "Specify the input file on the command line." )
            return
        }
        let inputFn = CommandLine.arguments[1]
        let input = try readStringFromFile( path:inputFn )
        solveProblem( input )
    } catch FileReadError.FileNotFound {
        print( "File not found." )
    } catch {
        print( "Some other error." )
    }
}


