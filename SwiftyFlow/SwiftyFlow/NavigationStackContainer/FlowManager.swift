//
//  FlowManager.swift
//  SwiftyFlow
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
    case modal(animated: Bool)
}

class FlowManager: NavigationFlow {
    
    // Public read variables
    var navigationController: UINavigationController?
    private(set) var containerStack: ContainerFlowStack?
    
    // Private variables
    private var rootView: UIViewController?
    internal var dismissedClosure: (() -> ())?
    private var defaultNavigationType: ViewIntanceFrom?
    
    // Private variables for you have callback when finish you flow
    private var dismissCallBackClosure: ((Any) -> ())?
    private var dismissModalCallBackClosure: (() -> ())?
    
    // MARK: Initializers
    init(navigation controller: UINavigationController?,
         container stack: ContainerFlowStack,
         setupInstance type: ViewIntanceFrom? = nil) {
        self.navigationController = controller
        self.containerStack = stack
        self.defaultNavigationType = type
    }
    
    deinit {
        debugPrint("Deallocating FlowManager")
    }
        
    // We have two ways of loading
    // 1 - When we are already in one storyboard, and we want to load another viewcontroller
    //     that is inside this storyboard you can resolve using `rootInstance` to resolve and
    //     will be set to as your root view controller inside your navigation controller
    // 2 - When you are loading a completely new storyboard, as you will need to resolve your
    //     first / root view controller using the reference from the storyboar as it's not loaded
    //     yet, so for this scenario you only pass the type of the first one that will be resolved
    //     so we hande this resolution for you, otherwise will load with a black screen your navigation
    @discardableResult convenience init<T: UIViewController>(root instanceType: T.Type,
                                                             container stack: ContainerFlowStack,
                                                             withCustom navigation: UINavigationController? = nil,
                                                             setupInstance type: ViewIntanceFrom = .nib,
                                                             finishedLoad presenting: (() -> ())? = nil,
                                                             dismissed navigationFlow: (() -> ())? = nil) {
        self.init(navigation: nil, container: stack, setupInstance: type)
        
        let rootViewController = self.resolveInstance(viewController: type, for: instanceType)
        
        guard let rootView = rootViewController else {
            fatalError("You need to have a root view controller instance")
        }
        
        if let customNavigation = navigation {
            self.navigationController = customNavigation
        } else {
            self.navigationController = UINavigationController(rootViewController: rootView)
        }
        
        guard let navigationController = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        presentNewFlow(navigation: navigationController, resolved: {
            presenting?()
        })
        
        self.dismissedClosure = navigationFlow
    }
    
    // MARK: - Navigation
    func goNext<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> (),
                                     resolve asType: ViewIntanceFrom = .nib,
                                     resolved instance: ((T) -> ())? = nil) {
        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        view({ [weak self] viewToGo in

            let navigationType = self?.defaultNavigationType ?? asType
            
            guard let controller = self?.resolveInstance(viewController: navigationType, for: viewToGo.self) else {
                debugPrint("Could not retrieve the view controller to push")
                return
            }
            
            (controller as? NavigationFlow)?.navigationFlow = self
            instance?(controller as! T)
            
            navigation.pushViewController(controller, animated: true)
        })
    }
    
    // Automatically resolve and go to the next view according to the order that you declared in
    // your ContainerFlowStack, if no item found will just not navigation we do not throw any error
    func goNext<T: UIViewController>(resolve asType: ViewIntanceFrom = .nib,
                                     resolved instance: ((T) -> ())? = nil) {
        self.goNext(screen: { [weak self] nextView in
            guard let nextViewElement = self?.findNextElementToNavigate() else {
                debugPrint("There's no more itens to go next or there's no declared types")
                return
            }
            
            nextView(nextViewElement.forType as! T.Type)
        }, resolve: asType, resolved: instance)
    }
    
    // Modal presentation
    // Automatically resolve and go to the next view according to the order that you declared in
    // your ContainerFlowStack, or you can chose wich screen to pick and navigate to, if no view
    // can be satisfy will just return and print an error
    @discardableResult
    func goNextAsModal<T: UIViewController>(screen view: (((T.Type) -> ()) -> ())? = nil,
                                            resolve asType: ViewIntanceFrom = .nib,
                                            animated modalShow: Bool = true,
                                            resolved instance: ((T) -> ())? = nil,
                                            completion: (() -> Void)? = nil) -> Self {

        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        var viewToGoNextType: T.Type?
        
        let modalPresentation: () -> Void = {
            guard let view = viewToGoNextType else {
                debugPrint("There's not next view to go")
                return
            }
            let navigationType = self.defaultNavigationType ?? asType
            
            guard let controller = self.resolveInstance(viewController: navigationType, for: view.self) else {
                debugPrint("Could not retrieve the view controller to present modally")
                return
            }
            
            (controller as? NavigationFlow)?.navigationFlow = self
            instance?(controller as! T)
            
            navigation.present(controller, animated: modalShow, completion: completion)
        }
        
        
        if let viewToGo = view {
            viewToGo({ nextView in
                viewToGoNextType = nextView
                modalPresentation()
            })
        } else {
            guard let nextViewElement = self.findNextElementToNavigate() else {
                debugPrint("There's no more itens to go next or there's no declared types")
                return self
            }
            viewToGoNextType = nextViewElement.forType as? T.Type
            modalPresentation()
        }
        
        return self
    }
    
    // This is used to get back when you are navigating using storyboard, with this
    // you can easy get back to the root view from you navigation controller stack
    // or you can pass on type of view that you registered before and go to that view
    @discardableResult
    func getBack<T: UIViewController>(pop withStyle: NavigationPopStyle = .pop(animated: true),
                                      screen view: (((T.Type) -> ()) -> ())? = nil) -> Self {
        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        switch withStyle {
        case .popToRoot(let animated):
            navigation.popToRootViewController(animated: animated)
            self.resetModulesInstanceReference()
        case .pop(let animated):
            navigation.popViewController(animated: animated)
            self.adjustModulesReference()
        case .popTo(let animated):
            view?({ [weak self] viewToPop in
                guard let viewController = navigation.viewControllers.first(where: { viewController -> Bool in
                    return type(of: viewController) == viewToPop
                }) else {
                    debugPrint("Have no view controller with this type \"\(String(describing: viewToPop))\" in your navigation controller stack")
                    return
                }
                
                navigation.popToViewController(viewController, animated: animated)
                self?.adjustModulesReference()
            })
        case .modal(let animated):
            navigation.dismiss(animated: animated, completion: { [unowned self] in
                self.adjustModulesReference()
                self.dismissModalCallBackClosure?()
            })
        }
        
        return self
    }

    @discardableResult
    func dismissFlowController(animated: Bool = true, completion: (() -> Void)? = nil) -> Self {
        if self.rootView == nil {
            debugPrint("You dont't have any root view controller that is being used")
        }
        
        self.rootView?.dismiss(animated: animated, completion: { [weak self] in
            self?.resetModulesInstanceReference()
            self?.dismissedClosure?()
            completion?()
        })
        
        return self
    }
    
    // MARK: Callback's when dismiss / close your flow
    func finishFlowWith(parameter data: Any) {
        dismissCallBackClosure?(data)
    }
    
    // This should be called only when you instantiate your FlowManager as it's intended
    // only to pass parameter back that you perhaps want like a response after finish
    @discardableResult
    func dismissedFlowWith(parameter invoker: @escaping (Any) -> ()) -> Self {
        dismissCallBackClosure = invoker
        return self
    }
    
    @discardableResult
    func dismissedModal(_ invoker: @escaping () -> ()) -> Self {
        dismissModalCallBackClosure = invoker
        return self
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
            // FOR this we need to add some new interface method that update our FlowElementContainer object and pass to the caller back
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
        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        containerStack?.updateModulesReference(for: navigation.viewControllers, coordinator: self)
    }
    
    // This should be used only when call "dismiss()" or "popToRoot()"
    private func resetModulesInstanceReference() {
        containerStack?.destroyInstanceReferenceWhenToRoot()
    }
    
    internal func presentNewFlow(navigation controller: UINavigationController,
                                resolved instance: (() -> ())? = nil) {
        // When we go deeper in the navigation level, there's different instances that actually
        // is the one that is one top, with this, as you are looking for the most top view
        // to present you new UINavigationController you will be able to do otherwise you will
        // see an error that is not the "most on top" view controller to present
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        self.rootView = topController
        
        self.adjustModulesReference()
        
        self.rootView?.present(controller, animated: true) {
            // Finished load
            instance?()
        }
    }
    
    // Navigation stack automatically identify next or back item according to the navigation view controllers
    private func findNextElementToNavigate() -> FlowElementContainer<UIViewController>? {
        guard let actualView = self.navigationController?.visibleViewController else {
            return  nil
        }
        
        guard let actualViewPosition: Int = self.containerStack?.modules.firstIndex(where: { $0.forType == type(of: actualView)}) else {
            debugPrint("The view that is now is \(String(describing: actualView)), and is not registered in you container stack")
            return nil
        }
        let nextViewToShow = self.containerStack?.modules[safe: (actualViewPosition + 1)]
        
        return nextViewToShow
    }
}
