Pod::Spec.new do |s|
  s.name = "SwiftRestModel"
  s.version = "1.0.0"
  s.summary = "Swift helper for REST models"
  s.homepage = "https://github.com/SwiftyJSON/SwiftyJSON"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.authors = { "Juraj Hilje" => "juraj.hilje@gmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source = { :git => "https://github.com/Rentlio/SwiftRestModel.git", :tag => "v1.0.0" }
  s.source_files = "Source/*.swift"
  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'SwiftyJSON', '~> 2.3.2'
  s.dependency 'HTTPStatusCodes', '~> 2.0.0'
end