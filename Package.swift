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
    Target( name: "day7", dependencies: [ "AocMain" ] )
  ],
  dependencies: [
    .Package( url: "https://github.com/krzyzanowskim/CryptoSwift.git",
              majorVersion: 0 )
  ]
)
