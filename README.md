<p align="center">
<img src="logo.png" alt="Spritz logo" width="200">
</p>

[![Twitter](https://img.shields.io/twitter/url/https/theinkedgineer.svg?label=TheInkedgineer&style=social)](https://twitter.com/theinkedgineer)

# Spritz

`Spritz` is an italian tax code (codice fiscale) generator and validator on steroids written in `Swift`.

It offers anything from simple regex validator, to complex analysis using the user's information, taking into account the [`omocodia`](https://it.wikipedia.org/wiki/Omocodia) phenomenon.

The library is fully tested and documented.


# 1. Requirements and Compatibility

| Swift               | Spritz     |  iOS     |
|-----------------|----------------|---------|
|       5.1+          | 1.0.x               |  10+     |

# 2. Installation

## Cocoapods

Add the following line to your Podfile
` pod 'Spritz' ~> '1.0.0' `


# 3. Documentation

`Spritz` is fully documented. Checkout the documentation [**here**](https://theinkedengineer.github.io/Spritz/docs/1.0.x/index.html).

# 4. Code Example

## Generating a `Codice Fiscale`

```swift
struct Person: SpritzInformationProvider {
  var firstName = "First"
  var lastName = "Last"
  var dateOfBirth = Date(timeIntervalSince1970: 602562877)
  var sex = Sex.female
  var placeOfBirth = "Cagliari"
}

let codice = try? Spritz.generateCF(from: Person())
```

## Validating a `Codice Fiscale`

```swift
  struct Person: SpritzInformationProvider {
    var firstName = "First"
    var lastName = "Last"
    var dateOfBirth = Date(timeIntervalSince1970: 602562877)
    var sex = Sex.female
    var placeOfBirth = "Cagliari"
  }
    
  let result = try? Spritz.isValid("LSTFST89B44B354F", for: Person()).get()
```

## Validating a `Codice Fiscale` with omocodia

```swift
  struct Person: SpritzInformationProvider {
    var firstName = "First"
    var lastName = "Last"
    var dateOfBirth = Date(timeIntervalSince1970: 602562877)
    var sex = Sex.female
    var placeOfBirth = "Cagliari"
  }
  // the conversion is done automatically.
  let result = try? Spritz.isValid("LSTFST89B44B35QF", for: Person()).get()
```

# 5. Contribution

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

## Generate the project

To generate this project locally, you need [xcodegen](https://github.com/yonaskolb/XcodeGen). It is a great tool to customize a project and generate it on the go.

You can either install it manually following their steps, or just run my `setup.sh` script. It automatically installs [Homebrew](https://brew.sh) if it is missing, installs `xcodegen`, removes existing (if present) `.xcodeproj`, run `xcodegen` and moves configuratiom files to their appropriate place.
