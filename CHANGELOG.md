# CHANGELOG

All notable changes to the project will be documented in this file. \
`Spritz` adheres to [Semantic Versioning](https://semver.org).

## 2.0.0

### Added

- Add support for MacOS 10.15
- Add support for `Swift Package Manager`
- Add new Date format `Spritz.Models.Date`
- Add new way to select the place of birth format `Spritz.Models.PlaceOfBirth`
- Add concrete object that implements `SpritzInformationProvider` in `Spritz.Models.CodiceFiscaleData`
- Add new public errors `Spritz.Error`
- Add `isValid(_: CodiceFiscale) -> Bool` to validate if a fiscal code is valid - supports omocodia
- Add `isCorrect(fiscalCode: CodiceFiscale, for: SpritzInformationProvider) -> Bool` to validate a fiscal code against data

### Changed

- Move Sex under `Spritz.Models`
- Foreign countries are found even if not 100% identical. Example: `Cocos` will return `Isole Cocos`
- Changed data normalizer

### Fixed

- Fix SpritzInformationProvider properties to getters only.

### Removed

- Remove throwing functions from public API
- Remove `isProperlyStructured` regex validator.
- Remove `CodiceFiscaleFields`. Validation should happen on all fields.
- Remove Xcodegen
- Remove setup.sh
- Remove IDETemplateMacros.plist
- Remove support for CocoaPods

## 1.0.1
### Fixed
- Fix a bug with the letters representation of the month.

## 1.0.0
### Added
- Initial release
