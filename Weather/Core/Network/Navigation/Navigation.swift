//
//  Navigation.swift
//  WeatherTest
//
//  Created by Angelber Castro on 15/11/24.
//

import SwiftUI

struct Navigation {
    static func getMainNavigationController() -> UINavigationController? {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive })
            as? UIWindowScene {
            let navigationController = windowScene.windows
                .first { $0.isKeyWindow }?
                .rootViewController
            if let navController = findNavigationController(viewController: navigationController) {
                return navController
            } else {
            #if DEBUG
                print("Error: not found navigation controller")
            #endif
            }
        }
        return nil
    }

    static func popToRootView() {
        getMainNavigationController()?.popToRootViewController(animated: true)
    }

    static func pop() {
        getMainNavigationController()?.popViewController(animated: true)
    }

    static func dismiss() {
        getMainNavigationController()?.dismiss(animated: true)
    }

    static func push<V: View>(view: V, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        getMainNavigationController()?.pushViewController(viewController, animated: animated)
    }

    static func present<V: View>(view: V, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        getMainNavigationController()?.present(viewController, animated: animated)
    }

    static func enableSwipeToPopGesture(active: Bool = true) {
        getMainNavigationController()?.interactivePopGestureRecognizer?.isEnabled = active
    }

    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }

        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }

        for childViewController in viewController.children {
            if let navigationController = findNavigationController(viewController: childViewController) {
                return navigationController
            }
        }
        return nil
    }

    static func popToViewController<V: View>(view _: V.Type) {
        guard let navigationController = getMainNavigationController() else {
            return
        }
        let viewType = UIHostingController<V>.self
        for viewController in navigationController.viewControllers {
            if viewController.isKind(of: viewType) {
                navigationController.popToViewController(viewController, animated: true)
                return
            }
        }
        popToRootView()
    }

    static func popToPreviousView() {
        guard let navigationController = getMainNavigationController() else {
            return
        }

        let viewControllers = navigationController.viewControllers
        if viewControllers.count >= 3 {
            let viewControllerToRemove = viewControllers[viewControllers.count - 2]
            navigationController.setViewControllers(
                viewControllers.filter { $0 != viewControllerToRemove },
                animated: true
            )
        }
    }

    static func presentOverTabBar<V: View>(view: V, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .coverVertical

        if let navigationController = getMainNavigationController() {
            navigationController.present(viewController, animated: animated)
        } else {
            print("Error: No navigation controller found.")
        }
    }

    static func presentSheet<V: View>(view: V, animated: Bool = true) {
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = .pageSheet
        viewController.modalTransitionStyle = .coverVertical
        getMainNavigationController()?.present(viewController, animated: animated)
    }
}
