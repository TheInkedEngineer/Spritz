<p align="center">
<img src="logo.png" alt="Spritz logo" width="200">
</p>

[![Twitter](https://img.shields.io/twitter/url/https/theinkedgineer.svg?label=TheInkedgineer&style=social)](https://twitter.com/inkedengineer)
![Documentation](https://theinkedengineer.github.io/Spritz/docs/1.0.x/badge.svg)
![SwiftLang badge](https://img.shields.io/badge/language-Swift%205.1-orange.svg)

# Spritz

`Spritz` is an Italian tax code ([codice fiscale](https://en.wikipedia.org/wiki/Italian_fiscal_code)) generator and validator on steroids written in `Swift`.

It offers anything from simple regex validator, to complex analysis using the user's information, taking into account the [`omocodia`](https://it.wikipedia.org/wiki/Omocodia) phenomenon.

The library is fully tested and documented.


# 1. Requirements and Compatibility

| Swift               | Spritz     |  iOS     |
|---------------------|------------|----------|
|       5.1+          | 1.0.x      |  10+     |
|       5.3+          | 2.0.x      |  10+     |

# 2. Installation

## Swift Package Manager

#### Package.swift

Open your `Package.swift` file and add the following as your dependency. 

```swift
dependencies: [
  .package(url: "https://github.com/TheInkedEngineer/Spritz", from: "2.0.0")
]
```

Then add the following to your target's dependency:

```swift
targets: [
  .target(
    name: "MyTarget", 
    dependencies: [
      .product(name: "https://github.com/TheInkedEngineer/Spritz", package: "Spritz")
    ]
  )
]
```

#### Xcode

1. Open your app in Xcode
1. In the **Project Navigator**, click on the project
1. in the Project panel, click on the project
1. Go to the **Package Dependencies** tab
1. Click on the `+` button
1. Insert the `https://github.com/TheInkedEngineer/Spritz` url in the search bar and press **Enter**
1. Click on the `Add Package` button
1. Follow the Xcode's dialog to install the SDK

# 3. Documentation

`Spritz` is fully documented. Checkout the documentation [**here**](https://theinkedengineer.github.io/Spritz/Documentation/documentation/spritz/index.html).

# 4. Code Example

## Generating a `Codice Fiscale`

```swift
let data = Spritz.Models.CodiceFiscaleData(
  firstName: "First",
  lastName: "last",
  dateOfBirth: Spritz.Models.Date(day: 2, month: .april, year: 1987)!,
  sex: .female,
  placeOfBirth: .foreign(countryName: "francia")
)

let codice = try? Spritz.generateCF(from: data)
```

## Validating a `Codice Fiscale`

```swift
let result = Spritz.isValid("LSTFST89B44B354F")
```

## Validating a `Codice Fiscale` against data

```swift
let data = Spritz.Models.CodiceFiscaleData(
  firstName: "First",
  lastName: "last",
  dateOfBirth: Spritz.Models.Date(day: 2, month: .april, year: 1987)!,
  sex: .female,
  placeOfBirth: .foreign(countryName: "francia")
)
    
let result = Spritz.isCorrect(fiscalCode: "LSTFST89B44B354F", for: data)
```

# 5. Contribution

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)
