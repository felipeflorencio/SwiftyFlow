//
//  ContainerFlowStack+Extension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 24/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

//public protocol Resolver {
////    func resolve<Service, Arg1, Arg2>(
////        _ serviceType: Service.Type,
////        arguments arg1: Arg1, _ arg2: Arg2) -> Service?
//
//    //    public func register<Service, Arg1, Arg2>(
//    //        _ serviceType: Service.Type,
//    //        name: String? = nil,
//    //        factory: @escaping (Resolver, Arg1, Arg2) -> Service) -> ServiceEntry<Service>
//
//    func resolve<T: UIViewController, Arg1, Arg2>(for type: T, arguments args: Arg1, _ arg2: Arg2) -> T?
//
//}

extension ContainerFlowStack {
    
//    func registerModule<T: UIViewController, Arguments>(for type: T.Type, resolve: @escaping (Arguments) -> Any?) -> FlowElementContainer<UIViewController> {
    
//    @discardableResult
//    public func register<Service, Arg1, Arg2>(
//        _ serviceType: Service.Type,
//        name: String? = nil,
//        factory: @escaping (Resolver, Arg1, Arg2) -> Service) -> ServiceEntry<Service>
    
//    public func register<Service, Arg1, Arg2>(
//        _ serviceType: Service.Type,
//        name: String? = nil,
//        factory: @escaping (Resolver, Arg1, Arg2) -> Service) -> ServiceEntry<Service>
   
    @discardableResult func registerModuleWith<T: UIViewController, Resolver>(for type: T.Type, resolve: @escaping ((Resolver)) -> T?) -> FlowElementContainer<UIViewController> {
        let registerModule = _registerModule(for: type, resolve: resolve)
        
        return registerModule
    }
    
    func resolve<T: UIViewController, Resolver>(for item: T.Type, parameters data: () -> ((Resolver))) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        let fac = module?.factoryParameter
        debugPrint(fac!)
//        let args = module?.arguments as! (Arg1, Arg2)
//        debugPrint(args)
        
        let preResolved = module?.factoryParameter as! (Resolver) -> Any?
        
        let res = preResolved(data())
//        let preArguments = module?.arguments as! Arguments
        //        let test = preResolved(preArguments)
//        let resolved = module?.factoryParameter as! (Arguments) -> Any
        
        return res as! T
    }
}
