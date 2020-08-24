//
//  ImageDetailView.swift
//  FlickrPhotoSearchApp
//
//  Created by Matthias Wagner on 23.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import SwiftUI
import FlickrPhotoSearchAppKit

// MARK: - ImageAble

@available(iOS 13.0, *)
protocol ImageAble: StateAble {
    var image: UIImage? { get }
}

protocol ImageReloadAble {
    func reloadImage()
}

// MARK: - ImageDetailView

@available(iOS 13.0, *)
struct ImageDetailView<ImageViewModel>: View where ImageViewModel: ImageAble, ImageViewModel: ImageReloadAble {

    @ObservedObject var viewModel: ImageViewModel

    var body: some View {
        StateFulView(viewModel: viewModel) {
            Image(uiImage: self.viewModel.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .onTapGesture {
            self.viewModel.reloadImage()
        }
    }
}

// MARK: - Preview

@available(iOS 13.0, *)
class TestImageDetailViewModel: ImageAble, ImageReloadAble {

    var state: StateFulViewState = .content

    let emptyTitle = Strings.Global.filterEmptyTitle
    let loadingTitle = Strings.Global.loadingTitle
    let errorTitle = Strings.Global.errorTitle

    var image: UIImage? = UIImage(systemName: "clock.fill")

    init() {}

    func reloadImage() {}
}

@available(iOS 13.0, *)
struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(viewModel: TestImageDetailViewModel())
    }
}
