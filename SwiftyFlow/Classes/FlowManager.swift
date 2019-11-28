//
//  FlowManager.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

/**
 Enum that will be utilized when create your flow manager to identify which type is the views that we will need to resolve
 */
public enum ViewIntanceFrom: Equatable {
    case nib
    case storyboard(String)
    
    public static func == (lhs: ViewIntanceFrom, rhs: ViewIntanceFrom) -> Bool {
        switch (lhs, rhs) {
        case (.nib, .nib): return true
        case (let .storyboard(first), let .storyboard(second)):
            return first == second
        default: return false
        }
    }
}

/**
 Enum type that will be utilized when we are navigating back, `poping` the navigation, this is important in order to correct dismiss you screen.
 */
public enum NavigationPopStyle {
    case pop(animated: Bool)
    case popTo(animated: Bool)
    case popToRoot(animated: Bool)
    case modal(animated: Bool)
}

/**
 Flow Manager is the core of our navigation system, it's using this thay you will be able to make your navigation flow, it's the important piece for you test your flows.
 */
public class FlowManager {
    
    // Public set / read variable
    /**
    Flow Manager presentation style, as our flow start on top always, it's a modal with navigation controller, by default is `fullScreen`, but with iOS 13 you can change
     this behaviour to have different style's how to start / present your flow,
    
    - Variable:
       - flowPresentationStyle: This is the variable that you should change / set before call `start()` the flow;
    */
    public var flowPresentationStyle: UIModalPresentationStyle = .fullScreen
    
    // Public read variables
    private(set) var navigationController: UINavigationController?
    private(set) var containerStack: ContainerFlowStack?
    
    // Private variables
    private var rootView: UIViewController?
    internal var dismissedClosure: (() -> ())?
    internal var defaultNavigationType: ViewIntanceFrom?
    
    // Private variables for you have callback when finish you flow
    private var dismissCallBackClosure: ((Any) -> ())?
    internal var dismissModalCallBackClosure: (() -> ())?
    internal var parameterFactory: AnyObject?
    
    // MARK: Initializers
    /**
     Flow Manager initialiser
     
     - Parameters:
        - navigation: This is the basic and convenient custom UINavigationController instance if you want to have your custom one, to work is mandatory, so, if use this you need to set, when set, we will check if first view controller is there and set the navigation flow.
        - container: It's the `ContainerFlowStack` instance, it's where we will look for the registered View Controller types in order to resolve and show on the screen.
        - setupInstance: It's how will be our navigation, it's a enum, if you don't set we will assume that is nib view that you will be using.
        - dismissed: `optional` - Closure optional that can tell you when this navigation controller was completely closed.

     */
    public init(navigation controller: UINavigationController?,
                container stack: ContainerFlowStack,
                setupInstance typeOfView: ViewIntanceFrom? = .nib,
                dismissed navigationFlow: (() -> ())? = nil) {
        self.navigationController = controller
        self.containerStack = stack
        self.defaultNavigationType = typeOfView
        self.dismissedClosure = navigationFlow
        
        if let customNavigation = controller, let firstViewController = customNavigation.viewControllers.first {
            // We need to register our first view controller, if don't when we try to `getBack` after just navigate
            // one level in, will not get back as there's no "previous" screen, but there's the root there.
            containerStack?.registerRootViewModule(for: UIViewController.self, root: firstViewController)
            (firstViewController as? FlowNavigator)?.navigationFlow = self
        }
    }
    
    deinit {
        debugPrint("Deallocating FlowManager")
    }
    
    // MARK: - Navigation
    /**
     The method responsible to start the flow, we do not start automatically when instantiate our FlowManager, so you can start as soon you want.
     
     - Parameter finishedLoad: `optional` - Convenience closure that will let you know when you finished the flow.
     */
    public func start(finishedLoad presenting: (() -> ())? = nil) {
        guard let navigationController = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        presentNewFlow(navigation: navigationController, resolved: {
            presenting?()
        })
    }
    
    /**
     This method is only intended when you want to have just a navigation controller but only when start decide which view controller will be the root of that navigation controller.
     
     It's basically the same behaviour as the initialiser that you need to pass the type of the view controller to be resolve, but with more
     options, in the scenario that only when you call start you want to check and validation which screen you want to have as the root, or even have a more generic way to show.
     
     Using this, is mandatory to you have the view controller that you intend to use be registered in your `Container` so we can resolve.
     
     - Parameters:
        - root: The view controller type that you will have as `root` view controller for you navigation controller.
        - resolved: Closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
        - finishedLoad: `optional` - Convenience closure that will let you know when you finished the flow.
     
     ### Usage Example: ###
         ````
            flowManager.startWith(root: { () -> UIViewController.Type in
                // This is just a way to have some implementation that check the type
                // and will select the type according to the view controller, would be
                // your view controller type
                switch self.flowType {
                case .normal:
                    return UIViewController.self
                case .withConfirmation:
                    return UIViewController.self
                case .awareness:
                    return UIViewController.self
                }
            }, resolved: { rootViewInstance in
                rootInstance.variable = "Any data that you want"
            })
         ````
     */
    public func startWith<T: UIViewController>(root instanceType: () -> T.Type,
                                               resolved instance: (T) -> (),
                                               finishedLoad presenting: (() -> ())? = nil) {
        guard let navigationController = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        guard let viewInstantiationType = self.defaultNavigationType else {
            debugPrint("Something went wrong that we do not have the type of the view and we can't continue")
            return
        }
        
        // Helper to set the root view controller for our navigation controller and present
        let setRootAndPresent: (UIViewController) -> () =  { [unowned self] viewController in
            navigationController.setViewControllers([viewController], animated: false)
            (viewController as? FlowNavigator)?.navigationFlow = self

            self.presentNewFlow(navigation: navigationController, resolved: {
                presenting?()
            })
        }
        
        let emptyParameter: (() -> (Void)) = {}
        guard let rootViewController = self._resolveInstance(viewController: viewInstantiationType,
                                                             for: instanceType(),
                                                             parameters: emptyParameter) else {
                debugPrint("Could't find the view controller of this type and with this parameters to set as root for our navigation controller")
                return
        }
        
        instance(rootViewController as! T)
        setRootAndPresent(rootViewController)
    }

    /**
     This method is only intended when you want to have just a navigation controller but only when start decide which view controller will be the root of that navigation controller, but without parameter to be passed during the instantiation.
     
     It's basically the same behaviour as the initialiser that you need to pass the type of the view controller to be resolve, but with more options, in the scenario that only when you call start you want to check and validation which screen you want to have as the root, or even have a more generic way to show.
     
     Using this, is mandatory to you have the view controller that you intend to use be registered in your `Container` so we can resolve.
     
     - Parameters:
        - root: The view controller type that you will have as `root` view controller for you navigation controller.
        - finishedLoad: `optional` - Convenience closure that will let you know when you finished the flow.
     
     ### Usage Example: ###
         ````
            flowManager.startWith(root: { () -> UIViewController.Type in
                // This is just a way to have some implementation that check the type
                // and will select the type according to the view controller, would be
                // your view controller type
                switch self.flowType {
                case .normal:
                    return UIViewController.self
                case .withConfirmation:
                    return UIViewController.self
                case .awareness:
                    return UIViewController.self
                }
            })
         ````
     */
    public func startWith<T: UIViewController>(root instanceType: () -> T.Type,
                                               finishedLoad presenting: (() -> ())? = nil) {
        guard let navigationController = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        guard let viewInstantiationType = self.defaultNavigationType else {
            debugPrint("Something went wrong that we do not have the type of the view and we can't continue")
            return
        }
        
        // Helper to set the root view controller for our navigation controller and present
        let setRootAndPresent: (UIViewController) -> () =  { [unowned self] viewController in
            navigationController.setViewControllers([viewController], animated: false)
            (viewController as? FlowNavigator)?.navigationFlow = self

            self.presentNewFlow(navigation: navigationController, resolved: {
                presenting?()
            })
        }
                
        let emptyParameter: () -> (Void) = {}
        guard let rootViewController = self._resolveInstance(viewController: viewInstantiationType,
                                                       for: instanceType(),
                                                       parameters: emptyParameter) else {
                debugPrint("Could't find the view controller of this type to set as root for our navigation controller")
                return
        }
        setRootAndPresent(rootViewController)
    }

    
    /**
     Method used to dismiss completely your flow.
     
     - Parameters:
     - animated: `optional` - If you want to animated the dismiss of your flow default is `true`.
     - completion: `optional` - Closure that you will receive an callback that you flow finished dismiss *(remember that if your instance is not strong you may not get this callback called.
     
     - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowManager instance.
     
     ### Usage Example: ###
     ````
        // Basic call, withoud parameters
        navigationFlow?.dismissFlowController()
     
        // Calling passing parameters
        navigationFlow?.dismissFlowController(animated: true, completion: {
            // Finished dismiss flow
        })
     ````
     */
    @discardableResult
    public func dismissFlowController(animated: Bool = true, completion: (() -> Void)? = nil) -> Self {
        
        defer {
            self.resetModulesInstanceReference()
            self.dismissedClosure?()
            completion?()
        }
        
        if self.rootView == nil {
            debugPrint("You dont't have any root view controller that is being used")
        }
        
        self.rootView?.dismiss(animated: animated, completion: nil)
        
        return self
    }
    
    // MARK: Callback's when dismiss / close your flow
    /**
     Method used to pass `Any` parameter back when finish flow, as soon you implement the closure
     to receive parameter back when flow finish as soon you pass using this method, the parameter
     will be sent, it's not typed, it's `Any` so you need to cast if you want to identify and have
     typed parameter back, It's recommended to use after call the `dismissFlowController()` method.
     
     - Parameter parameter: Any value that you want to pass back when flow finish.
     
     ### Usage Example: ###
     ````
        // Basic call, withoud parameters
        navigationFlow?.dismissFlowController().finishFlowWith(parameter: "Finished")
     ````
     */
    public func finishFlowWith(parameter data: Any) {
        dismissCallBackClosure?(data)
    }
    
    /**
     This should be called only when you instantiate your FlowManager as it's intended
     only to pass parameter back that you perhaps want like a response after finish
     
     - Parameter parameter: Any value that you want to pass back when flow finish.
     
     - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowManager instance.
     
     ### Usage Example: ###
     ````
        // Here we set after intantiate the `Flow Manager` that when dismiss
        // we want to `listen` any paramter that will be sent back
         FlowManager(root: view,
                     container: navigationStack).dismissedFlowWith { [weak self] closeAll in
     
            // Using this parameter for the situation that we want to dismiss both navigation from the top one
            if (closeAll as? Bool) == true {
                self?.navigationFlow?.dismissFlowController()
            }
         }.start()
     
        // And for use, to pass back we just need when dismiss call the method `.finishFlowWith(parameter: )`
        navigationFlow?.dismissFlowController().finishFlowWith(parameter: true)
     ````
     */
    @discardableResult
    public func dismissedFlowWith(parameter invoker: @escaping (Any) -> ()) -> Self {
        dismissCallBackClosure = invoker
        return self
    }
    
    /**
     This is intended to you know when you dismiss your presented modal view controller and
     you want to know if already finished close the presented one.
     
     - Parameter parameter: Any value that you want to pass back when flow finish.
     
     - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowManager instance.
     
     ### Usage Example: ###
     ````
         navigationFlow?.goNextAsModal().dismissedModal(callback: { [unowned self] in
            debugPrint("Finished close modal view")
            self.getSomeDataFromClosedModal()
         })
     ````
     */
    @discardableResult
    public func dismissedModal(callback invoker: @escaping () -> ()) -> Self {
        dismissModalCallBackClosure = invoker
        return self
    }
    
    // MARK: Public variable accessor
    /**
     Helper method that you can get the instance reference to the
     `UINavigationController` in case you do not provided a custom one
     */
    public func managerNavigation() -> UINavigationController? {
        return self.navigationController
    }
    
    /**
     Helper method that give you back the container flow stack reference
     */
    public func container() -> ContainerFlowStack? {
        return self.containerStack
    }
    
    
    // MARK: Private Helpers
    // This are our initializer functionality splitted, as when we have the scenario that we
    // are using parameters in order to initialize we have just one more item, to not fulfil
    // only one initializer we splitted, even because we could add separetely more logic regarding
    // the way that we are initializing on different methods.
    internal func initializerFunctionality(root viewController: UIViewController?,
                                           withCustom navigation: UINavigationController? = nil,
                                           dismissed navigationFlow: (() -> ())? = nil) {
        
        if let customNavigation = navigation {
            self.navigationController = customNavigation
            if let rootView = viewController {
                self.navigationController?.setViewControllers([rootView], animated: false)
            }
        } else {
            guard let rootView = viewController else {
                fatalError("You did not specify any Navigation Controller, them you need to specify one root to the default creation of the navigation controller")
            }
            self.navigationController = UINavigationController(rootViewController: rootView)
        }
        
        guard let firsView = self.navigationController?.viewControllers.first else {
            fatalError("You can't continue without root view controller, something is really wrong check if how you initialise")
        }
        (firsView as? FlowNavigator)?.navigationFlow = self
        
        self.dismissedClosure = navigationFlow
    }
    
    // Resolve instances in a generic way according to the type, if from storybooard of if from nib
    // In order to centralize the resolver methods that because how swift works and in order
    // to be able to be generic enough we are using types to describe how many parameter do we
    // have in order to be able to know which resolve we will call
    internal func _resolveInstance<T: UIViewController, Resolver>(viewController from: ViewIntanceFrom, for view: T.Type, parameters resolver: (() -> ((Resolver)))? = nil) -> UIViewController? {
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
            var resolvedInstance: T?
            
            // If we sucess cast our value to this type of closure, this means that we are using
            // no parameter's in order to try to satisfy our `resolve`, how we can check which
            // type of resolve we can use as is generic and we can only validate checking the type
            // because when we call our `_resolveInstance` from a place that I do now want to have
            // any parameter it's not possible just to set nil, you need to have some type because
            // otherwise the compiler will complaing that he can't identify the type as is generic
            if let _ = resolver as? () -> (Void) {
                resolvedInstance = containerStack?.resolve(for: view)
            } else {
                guard let resolverParameters = resolver else {
                    debugPrint("Check if you properly set any argument(s) as we don't have so something is missing")
                    return nil
                }
                resolvedInstance = containerStack?.resolve(for: view, parameters: resolverParameters)
            }
            
            return resolvedInstance
        }
    }
    
    // This is to "clean" the references when we navigate back, in order to avoid use the same
    // instance as soon we already navigated away from those views, make safe instantiate next
    // time that we call again this view
    private func adjustModulesReference<T: UIViewController>(for view: T.Type, popToRoot navigationBack: Bool = false) {
        
        if navigationBack {
            containerStack?.modules.forEach({ element in
                debugPrint("View: \(view)")
                debugPrint("Element: \(element.forType)")
                
                // here is still where we are we need to check for the root of the stack / navigation
                if element.forType != view {
                    containerStack?.adjustModuleReference(for: element.forType)
                }
            })
        } else {
            containerStack?.adjustModuleReference(for: view)
        }
    }
    
    // This should be used only when call "dismiss()" or "popToRoot()"
    private func resetModulesInstanceReference() {
        defer {
            containerStack = nil
        }
        
        self.rootView = nil
        self.navigationController = nil
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
        
        // First we adjust the reference as is an important step, and after we call the navigation
        // otherwise we can happen that we try to set the reference for the navigation but the view
        // controller itself is not yet fully loaded creating `running problem`
        
        self.adjustViewReferenceState(for: type(of: controller.viewControllers.first!))
        controller.modalPresentationStyle = flowPresentationStyle
        self.rootView?.present(controller, animated: true, completion: {
            instance?()
        })
    }
    
    // The idea is to always have the reference of the view that we are presenting, and
    // make sure always one, as we can't rely on navigation controller stack as when you
    // are testing you don't have the stack, for unit testing most probably will not even
    // show you screen so the stack is not even create, for this reason we need to maintain
    // a `reference` for what is happen
    internal func adjustViewReferenceState(for typeView: UIViewController.Type, back navigation: NavigationPopStyle? = nil) {
        
        // Inner function that set the previous or next view that is set as showing to false
        func setViewShownStateToFalseBack() {
            if let viewAlreadySet = self.containerStack?.modules.first(where: { $0.viewShowing }) {
                self.adjustModulesReference(for: viewAlreadySet.forType)
                viewAlreadySet.showingView(false)
            }
        }
        
        func setViewShownStateToFalseNext(next viewToShow: FlowElementContainer<UIViewController>) {
            if let viewAlreadySet = self.containerStack?.modules.first(where: { $0.viewShowing }) {
                
                // Verifying if the next view is the same that already was presented and destroy
                // the weak reference, on validation
                if viewToShow.forType == viewAlreadySet.forType {
                    self.adjustModulesReference(for: viewAlreadySet.forType)
                }
                
                viewAlreadySet.showingView(false)
            }
        }
        
        
        if navigation == nil, let view = self.containerStack?.modules.first(where: { $0.forType == typeView }) {
            // If find we always check if already has another view that is set for being `show`
            // and remove that, this is to avoid have more than one view that is being shown
            
            setViewShownStateToFalseNext(next: view)
            
            view.showingView(true)
        } else {
            guard let navigationStyle = navigation else {
                debugPrint("Failed trying to identify which screen we are trying to get back")
                return
            }
            
            // It's important to get the previous view that we want to get back before we adjust
            // the view state, otherwise after `destroy` will not be possible and we will be on
            // dead end how to know where to go
            let screenThatWeAreGoingBack = self.whichScreenTo(pop: navigationStyle)
            
            // As we are getting back, we need to set that this view is not being shown anymore
            // so first we go there and set that the view that we are now is not the one that is
            // being shown and after this we set the view that we want that is the one that will
            // show
            setViewShownStateToFalseBack()
            
            screenThatWeAreGoingBack?.showingView(true)
            
            // This need to be done in order to validate if is root, and if is we will destroy
            // all the reference for the other `screens` / instances as we are getting back to
            // root, but, always only for week reference here.
            if let navStyle = navigation, let rootScreen = screenThatWeAreGoingBack {
                switch navStyle {
                case .popToRoot(animated: _):
                    adjustModulesReference(for: rootScreen.forType, popToRoot: true)
                default: break
                }
            }
        }
        
    }
    
    // Navigation stack automatically identify next or back item according to the navigation view controllers
    internal func findNextElementToNavigate() -> FlowElementContainer<UIViewController>? {
        
        guard let actualViewPosition: Int = self.containerStack?.modules.firstIndex(where: { $0.viewShowing }) else {
            debugPrint("Something went wrong about get the actual view")
            return nil
        }
        let nextViewToShow = self.containerStack?.modules[safe: (actualViewPosition + 1)]
        
        return nextViewToShow
    }
    
    internal func whichScreenTo(pop style: NavigationPopStyle) -> FlowElementContainer<UIViewController>? {
        
        // Inner function
        func previousView() -> FlowElementContainer<UIViewController>? {
            guard let actualViewPosition: Int = self.containerStack?.modules.firstIndex(where: { $0.viewShowing }) else {
                debugPrint("Something went wrong about get the actual view to pop")
                return nil
            }
            let previousView = self.containerStack?.modules[safe: (actualViewPosition - 1)]
            
            return previousView
        }
        
        switch style {
        case .popToRoot(animated: _):
            return self.containerStack?.modules.first
        case .pop(animated: _):
            return previousView()
        case .popTo(animated: _):
            // For popTo we don't need to check as we receive this as parameter
            return nil
        case .modal(animated: _):
            return previousView()
        }
    }
}
