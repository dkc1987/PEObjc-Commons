Pod::Spec.new do |s|
  s.name         = "PEObjcCommons"
  s.version      = "1.0.115"
  s.license      = "MIT"
  s.summary      = "A collection of common Objective-C utilities that are not particular to any domain."
  s.author       = { "Paul Evans" => "evansp2@gmail.com" }
  s.homepage     = "https://github.com/evanspa/PEObjc-Commons"
  s.source       = { :git => "https://github.com/evanspa/PEObjc-Commons.git", :tag => "PEObjc-Commons-v#{s.version}" }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.resources    = "PEObjc-Commons/Resources/PEObjc-Commons.bundle"
  s.source_files = '**/*.{h,m}'
  s.exclude_files = "**/*Tests/*.*", "**/DemoApp/*"
  s.dependency 'BlocksKit', '~> 2.2.5'
end
