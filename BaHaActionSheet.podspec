Pod::Spec.new do |s|
  s.name         = "BaHaActionSheet"
  s.version      = "1.0.1"
  s.summary      = "BaHaActionSheet the Bahamut alert sheet in Swift"
  s.homepage     = "https://github.com/OneupNetwork/BaHaActionSheet-ios"
  s.license      = "MIT"
  s.author       = { "Wayne" => "wayne_lin@gamer.com.tw" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/OneupNetwork/BaHaActionSheet-ios.git", :tag => "#{s.version}" }
  s.source_files  = "BaHaActionSheet/Source/*.swift"
  s.swift_version = '4.1'
  s.requires_arc = true
end
