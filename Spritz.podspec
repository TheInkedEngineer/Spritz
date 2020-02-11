Pod::Spec.new do |s|
    s.name             = 'Spritz'
    s.version          = File.read(".version")
    s.homepage         = "https://github.com/TheInkedEngineer/Spritz"
    s.license          = "Apache 2.0"
    s.summary          = 'An italian tax number (AKA Codice Fiscale) creator and validator.'
    s.author           = { 'Firas Safa' => 'firas@theinkedengineer.com' }
    s.source           = { :git => 'https://github.com/TheInkedEngineer/Spritz.git', :tag => s.version.to_s }
  
    s.swift_version    = '5.1'
  
    s.ios.deployment_target = '10.0'
    
    s.ios.source_files = ['Sources/*.swift']
  
    s.resource_bundles = {
      'Spritz' => ['Sources/Resources/*.csv']
    }
end