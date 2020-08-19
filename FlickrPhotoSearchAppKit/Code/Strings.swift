//
//  Strings.swift
//  FlickrPhotoSearchAppKit
//
//  Created by Matthias Wagner on 19.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation

// swiftlint:disable all
public class Strings {

    public struct NavigationBar {
        /// Refresh
        public static let refresh = Strings.localized("navigation_bar_refresh", value: "Refresh")
        /// New Search
        public static let newSearch = Strings.localized("navigation_bar_new_search", value: "New Search")
    }

    public struct Global {
        /// Cancel
        public static let cancel = Strings.localized("global_cancel", value: "Cancel")
        /// Delete
        public static let delete = Strings.localized("global_delete", value: "Delete")
        /// Done
        public static let done = Strings.localized("global_done", value: "Done")
        /// No data available.
        public static let emptyTitle = Strings.localized("global_empty_title", value: "No data available.")
        /// Error loading data
        public static let errorTitle = Strings.localized("global_error_title", value: "Error loading data")
        /// No data available. Please change the filter-settings.
        public static let filterEmptyTitle = Strings.localized("global_filter_empty_title", value: "No data available. Please change the search input.")
        /// Data is loading
        public static let loadingTitle = Strings.localized("global_loading_title", value: "Data is loading")
        /// Ok
        public static let ok = Strings.localized("global_ok", value: "Ok")
        /// Reload
        public static let reload = Strings.localized("global_reload", value: "Reload")
        /// Please try again.
        public static let retryTitle = Strings.localized("global_retry_title", value: "Please try again.")
        /// N/A
        public static let unknownTitle = Strings.localized("global_unknown_title", value: "N/A")
    }

    public struct Network {
        /// An error occured. Please try again later.
        public static let errorGeneric = Strings.localized("network_error_generic", value: "An error occured. Please try again later.")
        /// Data could not be loaded. Please try again later.
        public static let errorLoadingFailed = Strings.localized("network_error_loading_failed", value: "Data could not be loaded. Please try again later.")
        /// No network connection. Please try again later.
        public static let errorNoConnection = Strings.localized("network_error_no_connection", value: "No network connection. Please try again later.")
        /// Data couldn't be transmitted. Please try again later.
        public static let errorPostingFailed = Strings.localized("network_error_posting_failed", value: "Data couldn't be transmitted. Please try again later.")
    }

    // settings this closure allows you to use a custom localization provider, such as OneSky over-the-air
    // by default, NSLocalizedString will load the strings from the main bundle's Localizable.strings file
    public static var customLocalizationClosure: ((String, String?, Bundle, String, String) -> String)? = nil

    public static func localized(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle(for: Strings.self), value: String, comment: String = "") -> String {
        if let closure = Strings.customLocalizationClosure {
            return closure(key, tableName, bundle, value, comment)
        } else {
            return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
        }
    }
}


