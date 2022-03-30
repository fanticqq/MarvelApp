// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum AvengerDetails {
    /// All information about this profile has been lost
    internal static let descriptionPlaceholder = L10n.tr("Localizable", "AvengerDetails.DescriptionPlaceholder")
  }

  internal enum AvengerList {
    internal enum InitialLoadingFailed {
      /// Our multiverse seems to have ceased to exist 😱
      /// Or maybe it's just a connection issue 🤔
      /// Anyway try it again!
      internal static let description = L10n.tr("Localizable", "AvengerList.InitialLoadingFailed.Description")
      /// Oups, something went wrong!
      internal static let title = L10n.tr("Localizable", "AvengerList.InitialLoadingFailed.Title")
    }
    internal enum Search {
      /// Search heroes
      internal static let hint = L10n.tr("Localizable", "AvengerList.Search.Hint")
      internal enum Empty {
        /// Try to change your request somehow
        internal static let description = L10n.tr("Localizable", "AvengerList.Search.Empty.Description")
        /// Nothing found 🔍
        internal static let title = L10n.tr("Localizable", "AvengerList.Search.Empty.Title")
      }
      internal enum Error {
        /// Your search request lost in time and space.
        /// Connection to universe seems to be failed
        internal static let description = L10n.tr("Localizable", "AvengerList.Search.Error.Description")
        /// No one can hears you request
        internal static let title = L10n.tr("Localizable", "AvengerList.Search.Error.Title")
      }
    }
  }

  internal enum LoadingFailed {
    /// Try again
    internal static let action = L10n.tr("Localizable", "LoadingFailed.Action")
    /// Something went wrong 😔
    internal static let text = L10n.tr("Localizable", "LoadingFailed.Text")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
