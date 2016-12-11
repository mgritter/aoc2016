import PackageDescription

let package = Package(
  name: "aoc2016",
  targets: [
    Target( name: "day1", dependencies: [ "SimpleFile" ] ),
    Target( name: "day2", dependencies: [ "SimpleFile" ] )
  ]
)
