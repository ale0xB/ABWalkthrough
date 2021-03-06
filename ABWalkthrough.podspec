Pod::Spec.new do |s|
  s.name             = "ABWalkthrough"
  s.version          = "0.1"
  s.summary          = "An easy way to add a walkthrough at launch"
  s.description      = <<-DESC
                       TDBWalkthrough is a pod that allows you to add a walkthrough when the app starts.
                       DESC
  s.homepage         = "https://github.com/ale0xB/ABWalkthrough"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Alex Benito" => "alex@avrora.io" }
  s.source           = { :git => "https://github.com/ale0xB/ABWalkthrough.git", :tag => "0.1" }

  s.source_files     = 'Classes/*.{h,m}'
  s.resources        = 'Classes/*.{xib}'

  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.dependency 'AVAnimator'
  s.dependency 'AMPopTip'
  s.dependency 'TAPageControl'  
end
