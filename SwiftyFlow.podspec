#
# Be sure to run `pod lib lint SwiftyFlow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyFlow'
  s.version          = '0.2.0'
  s.summary          = 'SwiftyFlow is a navigation manager that let you create your flow using a declarative format, being able to unit test the hole flow.'

  s.description      = <<-DESC
  It's the first library that allow you control your navigation as "flows", you can use both .NIB or Storyboard, you can declare the expected flow that you want to have and in a simple way create.

  Beside all the possibilities the biggest advantage is the possibility to test your flow, your can unit test your flows and make sure that you did not break any of your flows / navigation, you will be able to continue upgrade and change your navigation and maintain a clear control in order to make sure you did not broke anything.
                       DESC

  s.homepage         = 'https://github.com/felipeflorencio/SwiftyFlow'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.documentation_url = 'https://felipeflorencio.github.io/SwiftyFlow/'
  s.license          = { :type => 'GPL-3.0', :file => 'LICENSE' }
  s.author           = { 'Felipe F Garcia' => 'felipeflorencio@me.com' }
  s.source           = { :git => 'https://github.com/felipeflorencio/SwiftyFlow.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dr_nerd'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'
  s.source_files = 'SwiftyFlow/Classes/**/*'

end
