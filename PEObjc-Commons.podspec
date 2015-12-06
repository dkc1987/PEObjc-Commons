Pod::Spec.new do |s|
  s.name         = "PEObjc-Commons"
  s.version      = "1.0.96"
  s.license      = "MIT"
  s.summary      = "A collection of common Objective-C utilities that are not particular to any domain."
  s.author       = { "Paul Evans" => "evansp2@gmail.com" }
  s.homepage     = "https://github.com/evanspa/#{s.name}"
  s.source       = { :git => "https://github.com/evanspa/#{s.name}.git", :tag => "#{s.name}-v#{s.version}" }
  s.platform     = :ios, '8.0'
  s.source_files = '**/*.{h,m}'
  s.public_header_files = '**/*.h'
  s.exclude_files = "**/*Tests/*.*", "**/DemoApp/*"
  s.requires_arc = true
  s.resources = "#{s.name}/Resources/#{s.name}.bundle"
  s.dependency 'BlocksKit', '~> 2.2.5'

end
