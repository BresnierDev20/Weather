//
//  Extensions.swift
//  Weather
//
//  Created by Bresnier Moreno on 21/11/24.
//

import SwiftUI

extension Image {
    func renderIcon() -> some View {
      return self
        .resizable()
        .scaledToFit()
    }
}

extension WBarNavigation {
    class Constants {
        static let spacing: CGFloat = 0
        static let imageWidth: CGFloat = 14
        static let imageHeight: CGFloat = 14
        static let height: CGFloat = 40
        static let paddingBottom: CGFloat = 20
    }
}

extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragVisibility: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: @escaping () -> ()
    ) -> some View {
        self
            .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                content()
                    .presentationDetents(presentationDetents)
                    .presentationDragIndicator(dragVisibility)
                    .interactiveDismissDisabled(interactiveDisabled)
                    .onAppear{
                        guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return}
                        
                        if let controller = windows.windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController {
                            
                            if isTransparentBG{
                                controller.view.backgroundColor = .clear
                            }
                            controller.presentingViewController?.view.tintAdjustmentMode = .normal
                            sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                            sheet.preferredCornerRadius = sheetCornerRadius
                            
                        }else {
                            
                        }
                    }
            }
    }
}
