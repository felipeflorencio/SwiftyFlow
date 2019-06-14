![SwiftyFlow](https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/SwiftyFlow-Logo.png)

[![Build Status](https://travis-ci.com/felipeflorencio/SwiftyFlow.svg?branch=master)](https://travis-ci.com/felipeflorencio/SwiftyFlow)
[![codecov](https://codecov.io/gh/felipeflorencio/SwiftyFlow/branch/master/graph/badge.svg)](https://codecov.io/gh/felipeflorencio/SwiftyFlow)
[![codebeat badge](https://codebeat.co/badges/20415fbf-b83f-46a7-8b53-6cdf813efa12)](https://codebeat.co/projects/github-com-felipeflorencio-swiftyflow-master)
[![Version](https://img.shields.io/cocoapods/v/SwiftyFlow.svg?style=flat)](https://cocoapods.org/pods/SwiftyFlow)
[![License](https://img.shields.io/cocoapods/l/SwiftyFlow.svg?style=flat)](https://cocoapods.org/pods/SwiftyFlow)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyFlow.svg?style=flat)](https://cocoapods.org/pods/SwiftyFlow)

## BETA - In development documentation being created
# SwiftyFlow


## Swifty Flow

It's the first library that allow you control your navigation as "flows", you can use both .NIB or Storyboard, you can declare the expected flow that you want to have and in a simple way create.

Beside all the possibilities the biggest advantage is the possibility to test your flow, your can unit test your flows and make sure that you did not break any of your flows / navigation, you will be able to continue upgrade and change your navigation and maintain a clear control in order to make sure you did not broke anything.

<details>
<summary>Read more...</summary>
With Swifty Flow you can pass parameter to the next view controller that you are calling and you can instantiate this next view controller already injecting those values, beside this all the values that you pass are all typed, this make sure that any change you are in control and you can test this in your tests.

The navigation can happen in two ways one if you don't want to pass any parameter you can just declare your flow navigation, and the order that you declared will happen, just need to call `goNext()` or `back()` simple like this.

Or you can say at any moment where you want to go or make the navigation the way that you want, for this just need to say the type of your next view controller, only using the type of the class that you declared the library will resolve all for you.

Do you want to dismiss the hole flow in one click? You want to have a callback that your flow was closed? You want to know when your flow is finished loading? You want to pass any value back when finishing your flow?!?! It's all possible with this library without need to care about delegate, notification or any other pattern in order to acomplish this simple task :D :D .
</details>

## Concept

All the navigation that you have inside your app it's a flow, today the way that we handle this in iOS using the native framework is using Navigation Controller, the down size is that we can't test, if you run unit test maybe the view does not show *(because it's fast) and your method that call the next one or the last one will not be triggered.

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

Inside your class, the one that you want to start your navigation flow you need to create your flow manager.

Imagine that we have a class called `AppInitialViewController` and inside this class I will create a method that will create our stack and call.

```swift
func createOurNavigation() {
	let navigationStack = ContainerFlowStack()
    ContainerView().setupStackNavigation(using: navigationStack)
    
    FlowManager(root: FirstViewController.self, container: navigationStack)
}
```

Let's dig into and understand the "why's".

1 - If you pay attention actually you do not need to have that class called `ContainerView`, I just added to not have all those declaration in one place, what we need is to have one `ContainerFlowStack` and declare all our dependencies there, if you want you can make the "shortcut format":

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

1 - Call direct from the instance:
```
FlowManager(root: FirstViewController.self, container: navigationStack).start()
```

This will just start your navigation flow.

2 - Start latter, just set the flow manager to some variable and call latter:

```swift
flowManagerVariable = FlowManager(root: FirstViewController.self, container: navigationStack)


flowManagerVariable.start()
```

Regarding start / create this is all, now regarding the navigation the simple on you will have to use basically 3 methods.

1 - To navigate to the next screen using the "automatically navigation" just use the method `goNext()` to go to next screen, will follow the order that you declared in your container;

2 - Go back it's the same, just call `getBack()` and will get back to the previous screen;

3 - Close the flow just call at any time `dismissFlowController()`.

That's it's all, with this setup you can easily navigate.

Of course this is not even the more important, in the samples you will see many other methods that can provide even more power, like pass parameters, go to any other screen that you declared inside you container.

The most important actually it's, you can test, you can test this flow exactly way that you declared, so you can make sure that your flow it's still valid and working using unit test!

</details>


## Example

The sample project has many situation that you perhaps you will use in your daily base, and the reason basically why this project was create, here I will name each one and put a description, just run the sample and take a look in the code is the easiest way to know about.

To run the example project, clone the repo, and run `pod install` from the Example directory first.


<details>
<summary>Automatically navigation using Storyboard</summary>

First, what does mean have "automatically" navigation?
This mean that in the order that you declared your view controllers, when you call `goNext()` and `getBack()` you will not need to specify to where.

Features in this sample:
Automatically navigation using View Controller that have View inside Storyboard.
Pass parameter from one View Controller to another View controller using the framework.

</details>

<details>
<summary>Automatically navigation using NIB</summary>

</details>

<details>
<summary>Automatically navigation using NIB with the possibility to go to any other view controller that you chose</summary>

</details>

<details>
<summary>Deeplink concept</summary>

</details>

<details>
<summary>Navigation flow using NIB and with Modal view presentation</summary>

</details>

<details>
<summary>Navigation flow using NIB and passing parameters to the next view</summary>

</details>

<details>
<summary>Navigation flow using Storyboard and passing parameters to the next view</summary>

</details>

## Requirements

## Installation

SwiftyFlow is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyFlow'
```

## Author

Felipe F Garcia, felipeflorencio@me.com

## License

SwiftyFlow is available under the GPL-3.0 license. See the LICENSE file for more info.
