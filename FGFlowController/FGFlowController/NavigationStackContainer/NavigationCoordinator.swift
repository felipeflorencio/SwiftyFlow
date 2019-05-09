//
//  NavigationCoordinator.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

enum ViewIntanceFrom {
    case nib
    case storyboard(String)
}

enum NavigationPopStyle {
    case pop(animated: Bool)
    case popTo(animated: Bool)
    case popToRoot(animated: Bool)
}

class NavigationCoordinator: NavigationStack {
    
    var containerStack: NavigationContainerStack?
    var screenOwner: (() -> NavigationStack)?
    
    private(set) var navigationController: UINavigationController
    private var rootView: UIViewController?
    private var dismissedClosure: (() -> ())?
    
    init(navigation controller: UINavigationController,
         container stack: NavigationContainerStack) {
        self.navigationController = controller
        self.containerStack = stack
    }
    
    deinit {
        debugPrint("Deallocating NavigationCoordinator")
    }
    
    init<T: UIViewController>(withRoot controller: () -> T?,
                              container stack: NavigationContainerStack,
                              withCustom navigation: UINavigationController? = nil,
                              finishedLoad presenting: (() -> ())? = nil,
                              dismissed navigationFlow: (() -> ())? = nil) {
        self.containerStack = stack
        
        guard let rootViewController = controller() else {
            fatalError("You need to have a root view controller instance")
        }
        
        if let customNavigation = navigation {
            self.navigationController = customNavigation
        } else {
        	self.navigationController = UINavigationController(rootViewController: rootViewController)
        }
        
        presentNewFlow(navigation: self.navigationController, resolved: { [weak self] in
            self?.adjustModulesReference()
            presenting?()
        })
        
        self.dismissedClosure = navigationFlow
    }
    
    func goNext<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> (),
                                     resolve asType: ViewIntanceFrom = .nib,
                                     resolved instance: ((T) -> ())? = nil) {
        view({ [weak self] viewToGo in

            guard let controller = self?.resolveInstance(viewController: asType, for: viewToGo.self) else {
                debugPrint("Could not retrieve the view controller to push")
                return
            }
            
            (controller as? NavigationStack)?.navigationCoordinator = self
            instance?(controller as! T)
            
            self?.navigationController.pushViewController(controller, animated: true)
        })
    }
    
    // This is used to get back when you are navigating using storyboard, with this
    // you can easy get back to the root view from you navigation controller stack
    // or you can pass on type of view that you registered before and go to that view
    func getBack<T: UIViewController>(pop withStyle: NavigationPopStyle = .pop(animated: true),
                                      screen view: (((T.Type) -> ()) -> ())? = nil) {
        
        switch withStyle {
        case .popToRoot(let animated):
            self.navigationController.popToRootViewController(animated: animated)
            self.resetModulesInstanceReference()
        case .pop(let animated):
            self.navigationController.popViewController(animated: animated)
            self.adjustModulesReference()
        case .popTo(let animated):
            view?({ [weak self] viewToPop in
                guard let viewController = self?.navigationController.viewControllers.first(where: { viewController -> Bool in
                    return type(of: viewController) == viewToPop
                }) else {
                    debugPrint("Have no view controller with this type \"\(String(describing: viewToPop))\" in your navigation controller stack")
                    return
                }
                
                self?.navigationController.popToViewController(viewController, animated: animated)
                self?.adjustModulesReference()
            })
        }
    }
    
    func dismissFlowController(animated: Bool = true, completion: (() -> Void)? = nil) {
        if self.rootView == nil {
            debugPrint("You dont't have any root view controller that is being used")
        }
        
        self.rootView?.dismiss(animated: animated, completion: { [weak self] in
            self?.resetModulesInstanceReference()
            self?.dismissedClosure?()
            completion?()
        })
    }
    
    // MARK: Helpers
    // Resolve instances in a generic way according to the type, if from storybooard of if from nib
    private func resolveInstance<T: UIViewController>(viewController from: ViewIntanceFrom, for view: T.Type) -> UIViewController? {
        switch from {
        case .storyboard(let storyboard):
            let storyboardName = storyboard.count == 0 ? "Main" : storyboard
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: view.self))
            
            // As here we have a different instance, we need to update our navigation stack weak object reference with this new one
            // just to be able if we need to have the right reference variable in order to be able to pass some parameters or any one
            // need that is mandatory in order to have the right reference
            // FOR this we need to add some new interface method that update our WeakContainer object and pass to the caller back
            // using protocol this new value as reference so the one that instantiate can use
            containerStack?.replaceInstanceReference(for: view, instance: { () -> UIViewController in
                return controller
            })
            
            return controller
        case .nib:
            let resolvedInstance = containerStack?.resolve(for: view)
            return resolvedInstance
        }
    }
    
    // This is to "clean" the references when we navigate back, in order to avoid use the same
    // instance as soon we already navigated away from those views, make safe instantiate next
    // time that we call again this view
    private func adjustModulesReference() {
        // We adjust our modules list reference, we "destroy" the reference's that we have in order
        // to next time we load again to avoid problems trying to reuse the same one twice
        // beside this we automatically set the coordinator reference on our navigation view controller,
        // so we do not need to care about, but if we do not have the type is ok too will just not set, so
        // pay atention
        containerStack?.updateModulesReference(for: self.navigationController.viewControllers, coordinator: self)
    }
    
    // This should be used only when call "dismiss()" or "popToRoot()"
    private func resetModulesInstanceReference() {
        containerStack?.destroyInstanceReferenceWhenToRoot()
    }
    
    private func presentNewFlow(navigation controller: UINavigationController,
                                resolved instance: (() -> ())? = nil) {
        guard let rootView = UIApplication.shared.keyWindow?.rootViewController else { return }
        self.rootView = rootView
        rootView.present(controller, animated: true) {
            // Finished load
            instance?()
        }
    }
}
