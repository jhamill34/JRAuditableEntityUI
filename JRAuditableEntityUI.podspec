Pod::Spec.new do |s|
  s.name          = "JRAuditableEntityUI"
  s.version       = "1.0.0"
  s.summary       = "Makes use of JRAuditableEntity and provides ViewControllers to display."
  s.description   = "Provides ViewControllers and Views to property display the data generated from JRAuditableEntity"
  s.homepage      = "https://github.com/xlr8runner/JRAuditableEntityUI"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Joshua L. Rasmussen" => "xlr8runner@gmail.com" }
  s.source        = { :git => "https://github.com/xlr8runner/JRAuditableEntityUI.git", :tag => "1.0.0" }
  s.source_files  = "JRAuditableEntityUI/**/*.{h,m}"
  s.platform      = :ios, '9.0'
  s.dependency "JRAuditableEntity", "~> 1.0"
end
