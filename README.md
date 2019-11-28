![SwiftyFlow](https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/SwiftyFlow-Logo.png)

[![Build Status](https://travis-ci.com/felipeflorencio/SwiftyFlow.svg?branch=master)](https://travis-ci.com/felipeflorencio/SwiftyFlow)
[![codecov](https://codecov.io/gh/felipeflorencio/SwiftyFlow/branch/master/graph/badge.svg)](https://codecov.io/gh/felipeflorencio/SwiftyFlow)
[![codebeat badge](https://codebeat.co/badges/20415fbf-b83f-46a7-8b53-6cdf813efa12)](https://codebeat.co/projects/github-com-felipeflorencio-swiftyflow-master)
[![Version](https://img.shields.io/cocoapods/v/SwiftyFlow.svg?style=flat)](https://cocoapods.org/pods/SwiftyFlow)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/SwiftyFlow.svg?style=flat)](https://cocoapods.org/pods/SwiftyFlow)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyFlow.svg?style=flat)](https://cocoapods.org/pods/SwiftyFlow)
[![Documentation](https://felipeflorencio.github.io/SwiftyFlow/badge.svg?style=flat)](https://felipeflorencio.github.io/SwiftyFlow/)

# SwiftyFlow

It's the first library that allow you to control your navigation as "flows", you can use both .NIB or Storyboard, you can declare the expected flow that you want to have and in a simple way create.

|           | Main Features                                                                |
| --------- | ---------------------------------------------------------------------------- |
| &#128581; | Navigate using `goNext` or `getBack`                                         |
| &#127968; | Clear architecture and simple implementation                                 |
| &#128288; | Pass and receive parameter when navigate, all typed!                         |
| &#128273; | Decoupled and facilitate your navigation                                     |
| &#9989;   | Fully unit tested                                                            |
| &#128241; | Simply need one container `ContainerFlowStack` and `FlowManager` to navigate |
| &#128640; | Finally you can test from start to end your navigation flows using Unit Test |
| &#128175; | 100% Swift code                                                              |

Beside all the possibilities the biggest advantage is the possibility to test your flow, your can unit test your flows and make sure that you did not break any of your flows / navigation, you will be able to continue upgrade and change your navigation and maintain a clear control in order to make sure you did not broke anything.

<details>
<summary>Read more...</summary>
With Swifty Flow you can pass parameter to the next view controller that you are calling and you can instantiate this next view controller already injecting those values, beside this all the values that you pass are all typed, this make sure that any change you are in control and you can test this in your tests.

The navigation can happen in two ways one if you don't want to pass any parameter you can just declare your flow navigation, and the order that you declared will happen, just need to call `goNext()` or `getBack()` simple like this.

Or you can say at any moment where you want to go or make the navigation the way that you want, for this just need to say the type of your next view controller, only using the type of the class that you declared the library will resolve all for you.

Do you want to dismiss the hole flow in one click? You want to have a callback that your flow was closed? You want to know when your flow is finished loading? You want to pass any value back when finishing your flow?!?! It's all possible with this library without need to care about delegate, notification or any other pattern in order to acomplish this simple task :D :D .

</details>

## Concept

All the navigation that you have inside your app it's a flow, today the way that we handle this in iOS using the native framework is using Navigation Controller, the down size is that we can't test, if you run unit test maybe the view does not show \*(because it's fast) and your method that call the next one or the last one will not be triggered.

I made two diagram to show you visualy the main difference between using only the native way and using the SwiftyFlow framework, take a look, you will be able to see the concept applied in the diagram for SwiftyFlow in the samples inside the project.

### UINavigationController diagram, today problem:

<details>
<summary>Show</summary>
<div align="center">
<a href="https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/UINavigationController_Concept_Diagram.png" target="_blank"><img src="https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/UINavigationController_Concept_Diagram.png?raw=true" height="460px" width="400px" border="1"  alt="Diagram showing how Navigation Controller works"><div class="caption">Click to expand</div></a>
</div>
</details>

### SwiftyFlow diagram approach:

<details>
<summary>Show</summary>

<div align="center">
<a href="https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/SwiftFlow_Concept_Diagram.png" target="_blank"><img src="https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/SwiftFlow_Concept_Diagram.png?raw=true" height="518px" width="400px" border="1" alt="Diagram showing how SwiftyFlow works"><div class="caption">Click to expand</div></a>
</div>
</details>

## Implementing SwiftyFlow - Basic

- Have one container that you declared your view controller: `ContainerFlowStack()`;
- Have one `FlowManager` instance that will be responsible for your navigation stack;
- Your class conform to `FlowNavigator` navigator protocol;

About FlowNavigator protocol:
This is how inside your class you maintain the reference to your flow manager, so when you navigate you do not need to set by yourself what is your flow navigator, everytime that we resolve your dependency we will set automatically the reference.

It's possible to not conform and still continue working?
Possible it's, but you will need to set manually, it's your choice of course.

Let's try to build a simple flow.

<details>
<summary>Implementing SwiftyFlow</summary>

Create one class that will be your "container" it's the one that will have the declaration to all your View Controller that we will navigate:

```swift
import Foundation
import SwiftyFlow

class ContainerView {

    func setupStackNavigation(using containerStack: ContainerFlowStack) {

        containerStack.registerModule(for: ViewController.self) { () -> ViewController in
            return ViewController()
        }

        containerStack.registerModule(for: FirstViewController.self) { () -> FirstViewController in
            return FirstViewController()
        }

        containerStack.registerModule(for: SecondViewController.self) { () -> SecondViewController in
            return SecondViewController()
        }

        containerStack.registerModule(for: ThirdViewController.self) { () -> ThirdViewController in
            return ThirdViewController()
        }
    }
}
```

#### What's this container? Why I need to register?

> This container is the place that we declare all the types that we want to have in this **_Flow Manager_** that we will use to navigate.

> Another important part here is that we are just declaring the types, we are for now just registering the classes that latter we will use, we do not instantiate this classes while we are declaring, only when we start the navigation and we request the **type** that our framework will ask if we have that type declared, if yes, will go to your container look for the registration and **_resolve_** the instance and return to be shown.

Inside your class, the one that you want to start your navigation flow you need to create your flow manager.

Imagine that we have a class called `AppInitialViewController` and inside this class I will create a method that will create our stack and set to our `FlowManager` which container to use.

```swift
func createOurNavigation() {
	let navigationStack = ContainerFlowStack()
    ContainerView().setupStackNavigation(using: navigationStack)

    FlowManager(root: FirstViewController.self, container: navigationStack)
}
```

One important information to know about is, how our flow manager knows that we are using Storyboard or NIB files?

When we are create our `FlowManager` by default will be created specting that our navigation will have NIB files as View Controller, if you want to use a Storyboard then you need to specify like this:

```swift
FlowManager(root: AutomaticallyInitialViewController.self,
			container: navigationStack,
			setupInstance: .storyboard("AutomaticallyNavigationFlow"))
```

- We say that we want to have this flow using storyboard and we say the name of the Storyboard.

Let's dig into and understand the "why's".

> If you pay attention actually you do not need to have that class called `ContainerView`, I just added to not have all those declaration in one place, what we need is to have one `ContainerFlowStack` and declare all our dependencies there, if you want you can make the "shortcut format":

```swift
let navigationStack = ContainerFlowStack { container in
            container.registerModule(for: SecondViewController.self, resolve: { () -> SecondViewController in
                return SecondViewController()
            })
        }

FlowManager(root: FirstViewController.self, container: navigationStack)
```

It's the same as before, but the thing is that imagine declare all those class's inside this closure, will be to much, but, it's possible ;) .

Pretty much this regarding the configurantion it self, now you are able to start.

To start you just need to call the `start()` method from your flow manager, you can set a class variable and call latter or just call direct from your flow manager as soon you instantiate, for example:

1. Call direct from the instance:

```swift
FlowManager(root: FirstViewController.self, container: navigationStack).start()

```

This will just start your navigation flow.

2. Start latter, just set the flow manager to some variable and call latter:

```swift
flowManagerVariable = FlowManager(root: FirstViewController.self, container: navigationStack)


flowManagerVariable.start()
```

Regarding start / create this is all, now regarding the navigation the simple on you will have to use basically 3 methods.

1. To navigate to the next screen using the "automatically navigation" just use the method `goNext()` to go to next screen, will follow the order that you declared in your container;

2. Go back it's the same, just call `getBack()` and will get back to the previous screen;

3. Close the flow just call at any time `dismissFlowController()`.

That's it's all, with this setup you can easily navigate.

Of course this is not even the more important, in the samples you will see many other methods that can provide even more power, like pass parameters, go to any other screen that you declared inside you container.

The most important actually it's, you can test, you can test this flow exactly way that you declared, so you can make sure that your flow it's still valid and working using unit test!

</details>

## Example

The sample project has many situation that you perhaps you will use in your daily base, and the reason basically why this project was create, here I will name each one and put a description, just run the sample and take a look in the code is the easiest way to know about.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<details>
<summary>Automatically navigation using Storyboard and pass parameter</summary>

First, what does mean have "automatically" navigation?
This mean that the order that you declared your view controllers, when you call `goNext()` and `getBack()` you will not need to specify to where.

Features in this sample:
Automatically navigation using View Controller that have View inside Storyboard.
Pass parameter from one View Controller to another View controller using the framework.

1. The navigation will use the automatically way, that use 2 methods:
1. `goNext()`
1. `getBack()`

1. To pass parameter's when using storyboard you have a little different approach, let's understand the problem:
   When you instantiate using the storyboard, what actually happen is you Storyboard that actually instantiate you instance, your view controller class.
   Because this, is not possible (until the last apple update from WWDC 2019) to pass any parameter in the initialiser, the only solution is after you have the instance you pass using method injection, variable injection.

But this is not the end, what we did in order to be able to test is, you still send when call go to the next one, specify the parameters and in your instance you "listen" to the parameter, let's see.

First, you will need to use a different method to call you next view, you will use:

```swift
navigationFlow?.goNextWith(screen: AutomaticallyFirstViewController.self, parameters: { ("Felipe", 3123.232, "Florencio", 31) })
```

- We need to specify where we want to go, which screen;
- The parameters are typed, this means that on the other side you will need to specify the type the same way that you are sending, this is one important part for the test, make sure what you are sending is being receiving the same way.

> Parameters: We are using tuple, as in generic's we need to have a type, so you can just send a tuple, that has a type that swift understand and inside declare the other values, can be just 1 item, one custom object anything.

In the class that you called, in our scenario was `AutomaticallyFirstViewController.self` you will need to implement the method that will receive.

What I did was create a method that is being called on my `func viewWillAppear(_ animated: Bool)` method that will listen, the method that will listen will be like this:

```swift
func requestData() {
        navigationFlow?.dataFromPreviousController(data: { (arguments: (String, Double, String, Int)) in
            let (first, second, third, fourth) = arguments
            debugPrint("First parameter: \(first) - Storyboard Automatically Navigation")
            debugPrint("Second parameter: \(second) - Storyboard Automatically Navigation")
            debugPrint("Third parameter: \(third) - Storyboard Automatically Navigation")
            debugPrint("Fourth parameter: \(fourth) - Storyboard Automatically Navigation")
        })
    }
```

As you can see, `dataFromPreviousController(` it's a closure, that receive a "type", the types need to be the same that we are sending on the previous screen, even the same order.

These are the main features from this sample flow, take a look into the code.

---

</details>

<details>
<summary>Automatically navigation using NIB</summary>

This is pretty much follow the same as when use the storyboard, but the difference here is that you are using NIB's and you are using the instances that will be generated.

Features in this sample:
Automatically navigation using NIB's.

> It's mandatory for the NIB have the same name as your view controller class, as when both have the same name iOS knows how to instantiate.

- Important to know here is, when you use this method, the instance that we will use is the one that you registered into the container, for example:

```swift
containerStack.registerModule(for: AutomaticallyFirstViewController.self) { () -> AutomaticallyFirstViewController in
            return AutomaticallyFirstViewController()
        }
```

When our flow manager request for the class `AutomaticallyFirstViewController` he will came to this registration and get this object / instance, if you want you can instantiate by your self, set some value using some method or even variable and return, for example:

```swift
containerStack.registerModule(for: AutomaticallyFirstViewController.self) { () -> AutomaticallyFirstViewController in
			var viewController = AutomaticallyFirstViewController()
			viewController.myVariable = "Test Data"
			viewController.myMethod("With some data")
            return viewController
        }
```

This will work's fine too, when you use NIB's I see more advantages because you have better ways of instantiate your object, in this way you can fulfil your instance with any need before you actually show, in the sample using NIB passing parameter you will see even more advantages.

1. The navigation will use the automatically way, that use 2 methods:
1. `goNext()`
1. `getBack()`

---

</details>

<details>
<summary>Automatically navigation using NIB with the possibility to go to any other view controller that you chose</summary>

This format follows the same as **Automatically navigation using NIB** but with the difference here that we are using other method to go to any view controller that we declared inside our `Container`, so we still can use the `goNext()` but we are using another one that is called `goNext(screen: ViewController.self)`.

For example, we have in this sample from `GoAnywhereFirstViewController` to `GoAnywhereSeventhViewController` the only thing that we need to do is from this flow manager use this method `goNext` specifying the type that will resolve automatically.

Example:

```swift
navigationFlow?.goNext(screen: GoAnywhereSeventhViewController.self)
```

---

</details>

<details>
<summary>Deeplink concept</summary>

This is basically an "idea" of the advantage of use this framework, deeplink sometimes it's used in order to receive some data that will redirect us to some screen / view inside the app, we do need to know where of course, and there's many ways of doing this, here I will present how you can use the framework to facilitate this.

- Example: You need to have a logic that, when we receive a deeplink user click we send some parameter, I will use as sample that your passing as parameter where you want to go, the name of the controller, and we will need to generate a new Flow Manager using the root of the navigation controller using the type.

- Another requirement is, you want to when this new "flow" that will be generate automatically when user finishes this flow you want to send back some value, like a _boolean_ that you can evaluate in your callback to know that user finished.

> \*You can use anything as parameter, as soon you have a object that receive this and "translate" to the view type that you want to initiate it's ok

Sample:

```swift
// MARK: - Create your flow dinamicaly
    private func createYourNewFlow(for view: UIViewController.Type) {

        guard let navigationStack = self.navigationFlow?.container() else { return }

        FlowManager(root: view,
                    container: navigationStack)
            .dismissedFlowWith { [weak self] closeAll in

            // Using this parameter for the situation that we want to dismiss both navigation from the top one
            if (closeAll as? Bool) == true {
                self?.navigationFlow?.dismissFlowController()
            }
        }.start()
    }
```

1. As for us know where to go we need to know any `UIViewController` type, that's why we are receiving this as parameter in this method.
2. It's mandatory for you have container where you declared all your possible view controllers that you will be able to go.
3. Create you `FlowManager`.
4. Implement the method `dismissedFlowWith` that have as parameter one closure that receive `Any` as type, you just need to check the type if you want or just if receive any value.
5. In this scenario I'm using the dismiss callback to close the flow, but you can close by yourself at the end, but as we want to validate the callback it's indicate to finish here, we finish using: `self?.navigationFlow?.dismissFlowController()`

How to finish you flow passing some call back?
It the `DeeplinkFirstViewController` we the dismiss method passing as parameter a **boolean** value:

```swift
navigationFlow?.dismissFlowController().finishFlowWith(parameter: true)
```

Other method that you will see being used in this flow to get back beside the `getBack()` or the `dismissFlowController()` it self is:

```swift
navigationFlow?.getBack(pop: .popToRoot(animated: true))
```

This method as the name suggest we just get back to the root of this navigation controller saying if we want to do this animated or not.

---

</details>

<details>
<summary>Navigation flow using NIB and with Modal view presentation</summary>

This navigation there's no difference regarding the navigation itself, the goal here is how I can open a new view using the `modal` format.

For this we have two ways of doing, both we will use a different method to show as modal, we use the method `.goNextAsModal()`, following the principle of automatic navigation, if I do not specify to which screen I want to go, we will look which screen is the next in the stack and will resolve automatically.

Going to `AutomaticallyThirdModalViewController` you will see the implementation as following:

```swift
navigationFlow?.goNextAsModal().dismissedModal(callback: { [unowned self] in
            debugPrint("Finished close modal view")
            self.getSomeDataFromClosedModal()
        })
```

- What we have here is another helper method, that is not mandatory but we used, it's `dismissModal` that is an callback when we dismiss our modal, in case that we want to know that was closed to do something, in this scenario we created a method that will get the reference to this modal view and see the parameters inside that instance:

```swift
private func getSomeDataFromClosedModal() {
        let modalViewController = self.navigationFlow?.container()?.getModuleIfHasInstance(for: AutomaticallyFourthModalViewController.self)
        // Getting from variable
        if let fromVariable = modalViewController?.someData {
            debugPrint("Getting data from modal as variable: \(fromVariable)")
        }
        // Getting from function
        if let fromFunction = modalViewController?.modalViewSampleData() {
            debugPrint("Getting data from modal as function: \(fromFunction)")
        }
    }
```

If you pay attention we have some important thing to analize here, everytime that we close any modal view, or even get back, navigation controller will always _destroy_ that object reference, so how we can still have the reference to this object that was close?

On this container, when I registered I said that I want to this object as soon was instantiate have an **_strong_** reference, this means that when we navigate back we will not destroy the reference.
The only moment that will be destroid is when we completely close our `FlowManager`.

How we register as strong:

```swift
containerStack.registerModule(for: AutomaticallyFourthModalViewController.self) { () -> AutomaticallyFourthModalViewController in
            return AutomaticallyFourthModalViewController()
        }.inScope(scope: .strong)
```

We are using the method `.inScope(scope: .strong)` that will say to our framework after instantiate do not nullify the reference to this object, and here you need to pay attention, the normal behavior that we have is when get back and go next again, we have a new instance, in this scenario will use the same instance, so, you need to pay attention.

Getting back to `getSomeDataFromClosedModal` how do we access our instance? For this we have in our flow manager the access to our **_container_**, and inside we have a method to get the object instance it's: `.getModuleIfHasInstance(for: AutomaticallyFourthModalViewController.self)`, passing the type of the instance that we want to check, if exist will return.

To dismiss the presented modal view we need to use another method, as the dismiss when presented as modal it's different, for this we use the method inside the modal view controller `navigationFlow?.getBack(pop: .modal(animated: true))`, passing the type that is **_modal_** and if will be animated or not will dismiss.

---

</details>

<details>
<summary>Navigation flow using NIB and passing parameters to the next view</summary>

Here we will follow the same principles used for a navigation using NIB files, but with the possibilitie to send parameter to the next view that we are calling.

For this we need to change how we register our view inside our **_Container_**, because we will need to say which parameter we are expecting, and for this the parameter are **typed** this mean that the type that I say that i'm expecting will need to be that one otherwise will not resolve.

Go to the class `ParameterNavigationContainer` where we register the class to this module, this is one sample:

```swift
containerStack.registerModuleWithParameter(for: ParameterInitialViewController.self) { (arguments: (String, Double, String, Int)) -> ParameterInitialViewController? in

            let (first, second, third, fourth) = arguments

            let initialViewController = ParameterInitialViewController()
            initialViewController.setParameters(first: first, second, third, fourth)

            return initialViewController
        }
```

1. First we need to register using another method, we need to use `.registerModuleWithParameter(for:`, and we have as parameter an closure that will receive the arguments, and for this we need to specify what we will receive.
2. In our scenario we will instantiate the `ParameterInitialViewController()`, and will set the parameters that we are receiving, after this we return the instance that we want to be resolved when we call this.

Now let's see how we call this class, as this change, I will show two possibilities, one is the when create our `FlowManager` that we need to specify the first view controller that will be show, and for this should be possible to pass any argument / parameter that we want.

1. FlowManager setting the parameter to the root view;

```swift
FlowManager(root: ParameterInitialViewController.self, container: container.setup(), parameters: {
                    return (("Felipe", 3123.232, "Florencio", 31))
        })
```

- As you can see we are specifying the same type and order that we spect to be resolved, so, as in our container we described that we are specting one tuple with this pattern `(String, Double, String, Int)` will be resolved with success.

2. Calling the navigation method to go next passing any argument.
3. First the sample of the registration:

```swift
containerStack.registerModuleWithParameter(for: ParameterFirstViewController.self) { (arguments: (String, Int)) -> ParameterFirstViewController? in
          let (first, second) = arguments

          let firstViewController = ParameterFirstViewController()
          firstViewController.setParameters(first: first, second)

          return firstViewController
      }
```

Now inside the `ParameterInitialViewController` we have the method that call `ParameterFirstViewController` this way:

```swift
navigationFlow?.goNextWith(screen: ParameterFirstViewController.self, parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
        })
```

3. As you can see we use the method `goNextWith` that need to know the type of the screen that we want to go and a closure that expect back the parameter that will send to the register to be resolved.

---

</details>

## Requirements

## Installation

SwiftyFlow is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyFlow'
```

### Carthage

To install Swinject with Carthage, add the following line to your `Cartfile`.

```
github "felipeflorencio/SwiftyFlow" ~> 0.5.0
```

## Documentation

Here you will have the full documentation, with explanation and samples how to use the method available.
<a href="https://felipeflorencio.github.io/SwiftyFlow/" target="_blank">Go to documentation</a>

## Author

Felipe F Garcia, felipeflorencio@me.com

## License

SwiftyFlow is available under the GPL-3.0 license. See the LICENSE file for more info.
