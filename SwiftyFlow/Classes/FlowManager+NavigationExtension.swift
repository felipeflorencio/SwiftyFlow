//
//  FlowManager+NavigationExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 27/11/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

extension FlowManager {

    /**
     This is the method that we will use in order to send parameter when resolve our instance
     Remember that when declare the parameter data that you want to be resolved need to be inside
     Tuple, as for swift when resolve everything need to have a type, with this we make sure that
     always have type and the values are inside
     
     - Parameters:
        - screen: The type of the view controller that you want to next.
        - paramer: Closure that expect a `type` that will be used when resolve this screen that you are calling.
        - resolve: `optional` - How the view for this screen will be loaded, the default one is `.nib`.
        - resolved: `optional` - Convenience closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
     
     ### Usage Example: ###
     ````
        // Basic implementation
         navigationFlow?.goNextWith(screen: ParameterFirstViewController.self, parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
         })
     
        // Using the parameters available
         navigationFlow?.goNextWith(screen: ParameterFirstViewController.self, parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
         }, resolve: .nib, resolved: { resolveView in
            // resolve view
         })
     ````
     */
    public func goNextWith<T: UIViewController, Resolver>(screen view: T.Type,
                                                          parameters data: @escaping () -> ((Resolver)),
                                                          resolve asType: ViewIntanceFrom = .nib,
                                                          resolved instance: ((T) -> ())? = nil) {
        
        self.navigateUsingParameter(parameters: data, next: view.self, resolve: asType, resolved: instance)
    }
    
      /**
       Method responsible to navigate to the next screen
       
       - Parameters:
          - screen: The type of the screen that you want to go, need to be registered in your container flow stack.
          - resolve: `optional` - How the view for this screen will be loaded, the default one is `.nib`.
          - resolved: `optional` - Convenience closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
       
       ### Usage Example: ###
       ````
          navigationFlow?.goNext(screen: SecondViewController.self,
                                 resolve: .nib,
                                 resolved: { resolveViewInstance in
              resolveViewInstance.nameForTitle = "Setting value on the next view"
          })
       ````
       */
      public func goNext<T: UIViewController>(screen view: T.Type,
                                              resolve asType: ViewIntanceFrom = .nib,
                                              resolved instance: ((T) -> ())? = nil) {
          
          let emptyParameter: (() -> (Void)) = {}
          self.navigateUsingParameter(parameters: emptyParameter, next: view, resolve: asType, resolved: instance)
      }
      
      /**
       Method responsible to navigate to the next screen automatically resolve and go to the
       next view according to the order that you declared in your ContainerFlowStack, if no
       item found will just not navigation we do not throw any error
       
       - Parameters:
          - resolve: `optional` - How the view for this screen will be loaded, the default one is `.nib`.
          - resolved: `optional` - Convenience closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
       
       ### Usage Example: ###
       ````
          // Without using any parameter - Indicated to the automatically navigation
           navigationFlow?.goNext()
       
          // Using the parameters available
           navigationFlow?.goNext(resolve: .nib,
                                  resolved: { resolveViewInstance in
                  resolveViewInstance.nameForTitle = "Setting value on the next view"
           })
       ````
       */
      public func goNext<T: UIViewController>(resolve asType: ViewIntanceFrom = .nib,
                                              resolved instance: ((T) -> ())? = nil) {
          
          guard let nextViewElement = self.findNextElementToNavigate() else {
              debugPrint("There's no more itens to go next or there's no declared types")
              return
          }
          
          self.goNext(screen: nextViewElement.forType as! T.Type, resolve: asType, resolved: instance)
      }
      
      /**
       Method responsible to navigate to the next screen using `Modal Presentation`, this method can
       automatically resolve too, if you do not need any of the parameters argument just call the method
       without implement any of the arguments and will automatically resolve according to you container
       stack declared.
       
       
       - Parameters:
          - screen: `optional` - The type of the screen that you want to go, need to be registered in your container flow stack.
          - resolve: `optional` - How the view for this screen will be loaded, the default one is `.nib`.
          - animated: `optional` - If you want to show the modal view presentation animated or not, default is animated.
          - resolved: `optional` - Convenience closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
          - presentation: `optional` - How the modal will be presented, as iOS 13 is not default `fullScreen` anymore, here the default will be `fullScreen`.
          - completion: `optional` - Called when the modal view is presented, so you know when success show.
       
       - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowManager instance.
       
       ### Usage Example: ###
       ````
          // Simple implementation indicated for automatically navigation
          navigationFlow?.goNextAsModal()
       
          // Full implementation using all parameters
           navigationFlow?.goNextAsModal(screen: SecondViewController.self,
                                         resolve: .nib,
                                         animated: true,
                                         resolved: { resolveViewInstance in
                  resolveViewInstance.nameForTitle = "Setting value on the next view"
           }, completion: {
              // Finished presenting this modal.
           })
       ````
       */
      @discardableResult
      public func goNextAsModal<T: UIViewController>(screen view: T.Type? = nil,
                                                     resolve asType: ViewIntanceFrom = .nib,
                                                     animated modalShow: Bool = true,
                                                     resolved instance: ((T) -> ())? = nil,
                                                     presentation style: UIModalPresentationStyle = .fullScreen,
                                                     completion: (() -> Void)? = nil) -> Self {
        let emptyParameter: () -> (Void) = {}
        return self.navigateAsModal(screen: view,
                                    parameters: emptyParameter,
                                    instantiate: asType,
                                    animated: modalShow,
                                    resolved: instance,
                                    presentation: style,
                                    completion: completion)
      }
    
        /**
         Method responsible to navigate to the next screen using `Modal Presentation`, this method can
         automatically resolve too, if you do not need any of the parameters argument just call the method
         without implement any of the arguments and will automatically resolve according to you container
         stack declared.
         
         
         - Parameters:
            - paramer: Closure that expect a `type` that will be used when resolve this screen that you are calling.
            - screen: The type of the screen that you want to go, need to be registered in your container flow stack.
            - resolve: `optional` - How the view for this screen will be loaded, the default one is `.nib`.
            - animated: `optional` - If you want to show the modal view presentation animated or not, default is animated.
            - resolved: `optional` - Convenience closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
            - presentation: `optional` - How the modal will be presented, as iOS 13 is not default `fullScreen` anymore, here the default will be `fullScreen`.
            - completion: `optional` - Called when the modal view is presented, so you know when success show.
         
         - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowManager instance.
            You still have all the other method like the modal presentation without parameter.
         
         ### Usage Example: ###
         ````
            // Simple implementation indicated for automatically navigation
             navigationFlow?.goNextAsModalWith(parameters: {
                 return ("Any Data")
             }, screen: SecondViewController.self })
         ````
         */
    @discardableResult
    public func goNextAsModalWith<T: UIViewController, Resolver>(parameters data: @escaping () -> ((Resolver)),
                                                                 screen view: T.Type,
                                                                 resolve asType: ViewIntanceFrom = .nib,
                                                                 animated modalShow: Bool = true,
                                                                 resolved instance: ((T) -> ())? = nil,
                                                                 presentation style: UIModalPresentationStyle = .fullScreen,
                                                                 completion: (() -> Void)? = nil) -> Self {
            return self.navigateAsModal(screen: view,
                                        parameters: data,
                                        instantiate: asType,
                                        animated: modalShow,
                                        resolved: instance,
                                        presentation: style,
                                        completion: completion)
    }
    
      /**
       This is used to get back when you are navigating using flow manager, with this
       you can easy get back just one view or get back to the root view from you
       navigation controller stack, it's even possible pass say to which screen you want
       to get back passing the type.
       
       - Parameters:
          - pop: `optional` - Type of the pop action that you want to do, check NavigationPopStyle to see all possibilities, default is back one animated.
          - screen: `optional` - The type of the screen that you want to go, need to be registered in your container flow stack.
    
       - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowManager instance.

       ### Usage Example: ###
       ````
           // Basic pop, just get back one screen animated
           navigationFlow?.getBack()
       
           // Specifying what type of the pop and the view that you want to get back
           navigationFlow?.getBack(pop: .pop(animated: true), screen: { viewToGo in
                  viewToGo(FirstViewController.self)
           })
       ````
       */
      @discardableResult
      public func getBack<T: UIViewController>(pop withStyle: NavigationPopStyle = .pop(animated: true),
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
              stackState()
              
              navigation.popToRootViewController(animated: animated)
          case .pop(let animated):
              
              guard let view = self.whichScreenTo(pop: withStyle) else {
                  debugPrint("Something really wrong happened so we can't say which screen we are getting back")
                  return self
              }
              self.adjustViewReferenceState(for: view.forType, back: withStyle)
              stackState()
              
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
                  self?.stackState()
                
                  navigation.popToViewController(viewController, animated: animated)
              })
          case .modal(let animated):
              
              guard let view = self.whichScreenTo(pop: withStyle) else {
                  debugPrint("Something really wrong happened so we can't say which screen we are getting back")
                  return self
              }
              self.adjustViewReferenceState(for: view.forType, back: withStyle)
              stackState()
              
              navigation.dismiss(animated: animated, completion: { [unowned self] in
                  self.dismissModalCallBackClosure?()
              })
          }
          
          return self
      }
    
    // MARK: Private Helpers
    // As we have more than one method that can be use for modal, we abstracted our core
    // functionality to this method, so we can use the same logic between the two methods
    internal func navigateAsModal<T: UIViewController, Resolver>(screen view: T.Type? = nil,
                                                                 parameters: @escaping () -> ((Resolver)),
                                                                 instantiate asType: ViewIntanceFrom = .nib,
                                                                 animated modalShow: Bool = true,
                                                                 resolved instance: ((T) -> ())? = nil,
                                                                 presentation style: UIModalPresentationStyle = .fullScreen,
                                                                 completion: (() -> Void)? = nil) -> Self {
        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        var viewToGoNextType: T.Type?
        
        if let viewToGo = view {
            viewToGoNextType = viewToGo
        } else {
            guard let nextViewElement = self.findNextElementToNavigate() else {
                debugPrint("There's no more itens to go next or there's no declared types")
                return self
            }
            viewToGoNextType = nextViewElement.forType as? T.Type
        }
        
        guard let toGoNext = viewToGoNextType else {
            debugPrint("There's not next view to go")
            return self
        }
        
        let navigationType = self.defaultNavigationType ?? asType
        
        guard let controller = self._resolveInstance(viewController: navigationType, for: toGoNext, parameters: parameters) else {
            debugPrint("Could not retrieve the view controller to present modally")
            return self
        }
        
        (controller as? FlowNavigator)?.navigationFlow = self
        instance?(controller as! T)
        
        // It's mandatory to have this in order to have track about where we are
        self.adjustViewReferenceState(for: type(of: controller.self))
        self.stackState()
        
        controller.modalPresentationStyle = style
        navigation.present(controller, animated: modalShow, completion: completion)
        
        return self
    }
}
