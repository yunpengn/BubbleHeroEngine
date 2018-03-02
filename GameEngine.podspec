#
#  Be sure to run `pod spec lint GameEngine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
# You can also run `pod spec lint GameEngine.podspec --allow-warnings` to ignore warnings.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name               = "GameEngine"
s.version            = "0.0.6"
s.summary            = "Game engine (physics engine & renderer) for Bubble Blast Saga"
s.description        = <<-DESC
CS3217 Software Engineering on Modern Application Platforms
2018 @ NUS SoC
Problem Set 4 - Game Engine
DESC
s.homepage           = "https://github.com/cs3217/2018-ps4-yunpengn"
s.license            = 'MIT'
s.author             = { "Niu Yunpeng" => "neilniuyunpeng@gmail.com" }
s.source             = { :git => "git@github.com:cs3217/2018-ps4-yunpengn.git", :branch => 'cocoapod'}
s.swift_version      = '4.0.3'
s.social_media_url = 'https://www.facebook.com/groups/cs3217/'
s.platform           = :ios, '11.2'
s.source_files       = 'BubbleHeroEngine/GameEngine/*.swift'
end
