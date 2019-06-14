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

## Example

The sample project has many situation that you perhaps will you in you daily base, and the reason basically why this project was create, here I will name each one and put a description, just run the sample and take a look in the code is the easiest way to know about.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<details>
<summary>Automatically navigation using Storyboard</summary>

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
