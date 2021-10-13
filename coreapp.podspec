Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "coreapp"
s.summary = "coreapp used for kyc process."
s.requires_arc = true

# 2
s.version = "1.0.0"

# 3
s.license = {
    type: "MIT",
    text: File.open("LICENSE").read
  }

# 4 - Replace with your name and e-mail address
s.author = { "Mohanasundaram" => "mohanasundaram.flairlabs.ext.idfy.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://gitlab.com/mohanasundaram.flairlabs"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://gitlab.com/mohanasundaram.flairlabs/core.git",
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "core/**/*.{swift}"

# 9
s.resources = "core/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
