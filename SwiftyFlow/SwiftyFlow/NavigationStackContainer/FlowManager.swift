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

enum NavigationDirection {
    case next
    case back
}

class FlowManager {
    
    // Public read variables
    var navigationController: UINavigationController?
    private(set) var containerStack: ContainerFlowStack?
    
    // Private variables
    private var rootView: UIViewController?
    internal var dismissedClosure: (() -> ())?
    internal var defaultNavigationType: ViewIntanceFrom?
    
    // Private variables for you have callback when finish you flow
    private var dismissCallBackClosure: ((Any) -> ())?
    private var dismissModalCallBackClosure: (() -> ())?
    
    // MARK: Initializers
    internal init(navigation controller: UINavigationController?,
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
    convenience init<T: UIViewController>(root instanceType: T.Type,
                                          container stack: ContainerFlowStack,
                                          withCustom navigation: UINavigationController? = nil,
                                          setupInstance type: ViewIntanceFrom = .nib,
                                          dismissed navigationFlow: (() -> ())? = nil) {
        self.init(navigation: nil, container: stack, setupInstance: type)

        let emptyParameter: () -> (Void) = {}
        let rootViewController = self._resolveInstance(viewController: type, for: instanceType, parameters: emptyParameter)

        self.initializerFunctionality(root: rootViewController, withCustom: navigation, dismissed: navigationFlow)
    }

    // MARK: - Navigation
    func start(finishedLoad presenting: (() -> ())? = nil) {
        guard let navigationController = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        presentNewFlow(navigation: navigationController, resolved: {
            presenting?()
        })
    }
    
    func goNext<T: UIViewController>(screen view: T.Type,
                                     resolve asType: ViewIntanceFrom = .nib,
                                     resolved instance: ((T) -> ())? = nil) {

        let emptyParameter: (() -> (Void)) = {}
        self.navigateUsingParameter(parameters: emptyParameter, next: view, resolve: asType, resolved: instance)
    }
    
    // Automatically resolve and go to the next view according to the order that you declared in
    // your ContainerFlowStack, if no item found will just not navigation we do not throw any error
    func goNext<T: UIViewController>(resolve asType: ViewIntanceFrom = .nib,
                                     resolved instance: ((T) -> ())? = nil) {
        
        guard let nextViewElement = self.findNextElementToNavigate() else {
            debugPrint("There's no more itens to go next or there's no declared types")
            return
        }
        
        self.goNext(screen: nextViewElement.forType as! T.Type, resolve: asType, resolved: instance)
    }
    
    // Modal presentation
    // Automatically resolve and go to the next view according to the order that you declared in
    // your ContainerFlowStack, or you can chose wich screen to pick and navigate to, if no view
    // can be satisfy will just return and print an error
    @discardableResult
    func goNextAsModal<T: UIViewController>(screen view: T.Type? = nil,
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
        
        let emptyParameter: () -> (Void) = {}
        guard let controller = self._resolveInstance(viewController: navigationType, for: view.self, parameters: emptyParameter) else {
            debugPrint("Could not retrieve the view controller to present modally")
            return
        }
        
        (controller as? FlowNavigator)?.navigationFlow = self
        instance?(controller as! T)
        
        // It's mandatory to have this in order to have track about where we are
        self.adjustViewReferenceState(for: type(of: controller.self))
        
        navigation.present(controller, animated: modalShow, completion: completion)
    }
    
    
    if let viewToGo = view {
        viewToGoNextType = viewToGo
        modalPresentation()
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
            
            // It's mandatory to have this in order to have track about where we are
            guard let view = self.whichScreenTo(pop: withStyle) else {
                debugPrint("Something really wrong happened so we can't say which screen we are getting back")
                return self
            }
            self.adjustViewReferenceState(for: view.forType, back: withStyle)
            
            navigation.popToRootViewController(animated: animated)
        case .pop(let animated):
            
            guard let view = self.whichScreenTo(pop: withStyle) else {
                debugPrint("Something really wrong happened so we can't say which screen we are getting back")
                return self
            }
            self.adjustViewReferenceState(for: view.forType, back: withStyle)
            
            navigation.popViewController(animated: animated)
        case .popTo(let animated):
            view?({ [weak self] viewToPop in
                guard let viewController = navigation.viewControllers.first(where: { viewController -> Bool in
                    return type(of: viewController) == viewToPop
                }) else {
                    debugPrint("Have no view controller with this type \"\(String(describing: viewToPop))\" in your navigation controller stack")
                    return
                }
                self?.adjustViewReferenceState(for: type(of: viewController), back: withStyle)
                
                navigation.popToViewController(viewController, animated: animated)
            })
        case .modal(let animated):
            
            guard let view = self.whichScreenTo(pop: withStyle) else {
                debugPrint("Something really wrong happened so we can't say which screen we are getting back")
                return self
            }
            self.adjustViewReferenceState(for: view.forType, back: withStyle)
            
            navigation.dismiss(animated: animated, completion: { [unowned self] in
                self.dismissModalCallBackClosure?()
            })
        }
        
        return self
    }

    @discardableResult
    func dismissFlowController(animated: Bool = true, completion: (() -> Void)? = nil) -> Self {
        
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
    
    // MARK: Private Helpers
    
    // This are our initializer functionality splitted, as when we have the scenario that we
    // are using parameters in order to initialize we have just one more item, to not fulfil
    // only one initializer we splitted, even because we could add separetely more logic regarding
    // the way that we are initializing on different methods.
    internal func initializerFunctionality(root viewController: UIViewController?,
                                           withCustom navigation: UINavigationController? = nil,
                                           dismissed navigationFlow: (() -> ())? = nil) {
        
        guard (viewController != nil) || (navigation != nil) else {
            fatalError("You need to have a root view controller instance or navigation")
        }
        
        if let customNavigation = navigation {
            self.navigationController = customNavigation
        } else {
            guard let rootView = viewController else {
                fatalError("You need to have a root view controller instance")
            }
            self.navigationController = UINavigationController(rootViewController: rootView)
        }
        
        guard let firsView = self.navigationController?.viewControllers.first else {
            fatalError("It's not possible reach here without if happen something really wrong happened")
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
    private func adjustModulesReference<T: UIViewController>(for view: T.Type, popToRoot navigation: Bool = false) {
        
        if navigation {
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
