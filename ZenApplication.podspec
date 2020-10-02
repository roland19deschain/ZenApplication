Pod::Spec.new do |s|
  s.name             = 'ZenApplication'
  s.version          = '1.1.0'
  s.swift_version    = '5.0'
  s.summary          = 'Tools and architecture components for building mobile applications written in Swift.'
  s.description      = <<-DESC
ZenApplication represents tools and architecture components for building mobile applications written in Swift.
                       DESC
  s.homepage         = 'https://github.com/roland19deschain/ZenApplication'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexey Roik' => 'roland19deschain@gmail.com' }
  s.source           = { :git => 'https://github.com/roland19deschain/ZenApplication.git', :tag => s.version }
  s.requires_arc     = true
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.source_files     = 'ZenApplication/**/*{swift}'
end
