# MarvelApp

MarvelApp is a compact app that gives you interface to marvel characters search.

## Screenshots
<table>
  <tr>
    <td>Characters list</td>
    <td>Character Details</td>
  </tr>
  <tr>
    <td><img src="screenshots/list.png" width=375></td>
    <td><img src="screenshots/details.png" width=375></td>
  </tr>
 </table>

## Features
* Communication with REST API via URLSession
* MVVM architecture based on Combine
* Assets generation with SwiftGen

## Requirements

* Xcode 13+
* [Cocoapods](https://cocoapods.org)

## Project overview

### Acrhitecture
* `MVVM` is used as an architecture for presentation layer, because it works great with both `UIKit` and `SwiftUI` and provides easy controlled UI-state consistency.

### Presentation layer
* Screens are located in `MarvelApp/Modules` folder.
* `CharacterList` supports infinite scrolling, search and tap on a cell.
* `CharacterDetails` shows you an information about selected character and also displays a list of its respective comics.

### Tooling
* `Swiftlint` is used to lint code files and maintain consistency of code style.
* `SwiftGen` is used to generate enums for compile-time safety of assets and localizable strings.

## License

Copyright 2022 Igor Zarubin.

Licensed under MIT License: https://opensource.org/licenses/MIT