![SwiftyFlow](https://raw.githubusercontent.com/felipeflorencio/SwiftyFlow/master/screenshots/SwiftyFlow-Logo.png)

[![Build Status](https://travis-ci.com/felipeflorencio/SwiftyFlow.svg?branch=master)](https://travis-ci.com/felipeflorencio/SwiftyFlow)
[![codecov](https://codecov.io/gh/felipeflorencio/SwiftyFlow/branch/master/graph/badge.svg)](https://codecov.io/gh/felipeflorencio/SwiftyFlow)
[![codebeat badge](https://codebeat.co/badges/20415fbf-b83f-46a7-8b53-6cdf813efa12)](https://codebeat.co/projects/github-com-felipeflorencio-swiftyflow-master)

## BETA - In development documentation being created
# SwiftyFlow


## Swifty Flow

It's the first library that allow you control your navigation as "flows", you can use both .NIB or Storyboard, you can declare the expected flow that you want to have and in a simple way create.

Beside all the possibilities the biggest advantage is the possibility to test your flow, your can unit test your flows and make sure that you did not break any of your flows / navigation, you will be able to continue upgrade and change your navigation and maintain a clear control in order to make sure you did not broke anything.

With Swifty Flow you can pass parameter to the next view controller that you are calling and you can instantiate this next view controller already injecting those values, beside this all the values that you pass are all typed, this make sure that any change you are in control and you can test this in your tests.

The navigation can happen in two ways one if you don't want to pass any parameter you can just declare your flow navigation, and the order that you declared will happen just simple need to call `goNext()` of `back()` simple like this.

Or you can say at any moment where you want to go or make the navigation the way that you want, for this just need to say the type of your next view controller, only using the type of the class that you declared the library will resolve all for your self.

Do you want to dismiss the hole flow in one click? You want to have a callback that your flow was closed? You want to know when your flow is finished loading? You want to pass any value back when finishing your flow?!?! It's all possible with this library without need to care about delegate, notification or any other pattern in order to acomplish this simple task :D :D

