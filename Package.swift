import PackageDescription

let package = Package(
  name: "aoc2016",
  targets: [
    Target( name: "AocMain", dependencies: ["SimpleFile"] ),
    Target( name: "day1", dependencies: [ "AocMain" ] ),
    Target( name: "day2", dependencies: [ "AocMain" ] )
  ]
)
