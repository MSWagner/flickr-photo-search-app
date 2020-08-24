//
//  StateFulView.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 23.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import SwiftUI
import UIKit
import Combine
import FlickrPhotoSearchAppKit

enum StateFulViewState {
    case loading
    case error
    case empty
    case content
}

protocol StateAble: ObservableObject {
    var state: StateFulViewState { get }

    var emptyTitle: String { get }
    var loadingTitle: String { get }
    var errorTitle: String { get}
}

extension StateAble {
    
    var stateTitle: String {
        switch state {
        case .empty: return emptyTitle
        case .error: return errorTitle
        case .loading: return loadingTitle
        case .content: return ""
        }
    }
}

// MARK: - StateFulView

@available(iOS 13.0, *)
struct StateFulView<Content, StateViewModel>: View where Content: View, StateViewModel: StateAble {

    @ObservedObject var viewModel: StateViewModel

    let contentBuilder: () -> Content

    init(viewModel: StateViewModel, @ViewBuilder contentBuilder: @escaping () -> Content) {
        self.contentBuilder = contentBuilder
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.state == .content {
                contentBuilder()
            } else {
                Text(viewModel.stateTitle)
                    .padding([.bottom], 8)
                    .padding([.leading, .trailing], 16)
                    .multilineTextAlignment(.center)

                if viewModel.state == .loading {
                    ActivityIndicator()
                } else {
                    Text(Strings.Global.retryTitle)
                        .multilineTextAlignment(.center)
                        .padding(16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Preview

@available(iOS 13.0, *)
class PreviewStateFulViewModel: StateAble {

    @Published var state: StateFulViewState

    let emptyTitle = Strings.Global.filterEmptyTitle
    let loadingTitle = Strings.Global.loadingTitle
    let errorTitle = Strings.Global.errorTitle

    init(state: StateFulViewState) {
        self.state = state
    }
}

@available(iOS 13.0, *)
struct StateFulView_Previews: PreviewProvider {
    static var previews: some View {
        StateFulView(viewModel: PreviewStateFulViewModel(state: .loading)) {
            Text("Content")
        }
    }
}
