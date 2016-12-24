import PackageDescription

let package = Package(
  name: "aoc2016",
  targets: [
    Target( name: "AocMain", dependencies: ["SimpleFile"] ),
    Target( name: "day1", dependencies: [ "AocMain" ] ),
    Target( name: "day2", dependencies: [ "AocMain" ] ),
    Target( name: "day3", dependencies: [ "AocMain" ] ),
    Target( name: "day4", dependencies: [ "AocMain" ] ),
    Target( name: "day5", dependencies: [] ),
    Target( name: "day6", dependencies: [ "AocMain" ] ),
    Target( name: "day7", dependencies: [ "AocMain" ] ),
    Target( name: "day8", dependencies: [ "AocMain" ] ),
    Target( name: "day9", dependencies: [ "AocMain" ] ),
    Target( name: "day10", dependencies: [ "AocMain" ] ),
    Target( name: "day11", dependencies: [] ),
    Target( name: "day12", dependencies: [ "AocMain" ] ),
    Target( name: "day13" ),
    Target( name: "day23", dependencies: [ "AocMain" ] )
  ],
  dependencies: [
    .Package( url: "https://github.com/krzyzanowskim/CryptoSwift.git",
              majorVersion: 0 ),
    .Package( url: "https://github.com/davecom/SwiftPriorityQueue.git",
              majorVersion: 1 )
  ]
)
