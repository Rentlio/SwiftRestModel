Pod::Spec.new do |s|
  s.name = "SwiftRestModel"
  s.version = "2.0.4"
  s.summary = "Swift helper for REST models"
  s.homepage = "https://github.com/Rentlio/SwiftRestModel"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.authors = { "Juraj Hilje" => "juraj.hilje@gmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  s.source = { :git => "https://github.com/Rentlio/SwiftRestModel.git", :tag => s.version }
  s.source_files = "Source/*.swift"
  s.dependency 'Alamofire', '~> 4.0.1'
  s.dependency 'SwiftyJSON', '~> 3.1.0'
  s.dependency 'HTTPStatusCodes', '~> 3.1.0'
end