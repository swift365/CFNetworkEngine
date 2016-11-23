Pod::Spec.new do |s|
s.name = 'CFNetworkEngine'
s.version = '0.1.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'CFNetworkEngine is a Swift module for adding extension to uiview.'
s.homepage = 'https://github.com/swift365/CFNetworkEngine'
s.authors = { 'chengfei.heng' => 'hengchengfei@sina.com' }
s.source = { :git => 'https://github.com/swift365/CFNetworkEngine.git', :tag => "0.1.0" }
s.ios.deployment_target = '9.0'
s.source_files = "CFNetworkEngine/Classes/*.swift", "CFNetworkEngine/Classes/**/*.swift"
s.dependency 'Alamofire'
end

