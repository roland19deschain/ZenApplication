Pod::Spec.new do |spec|
  spec.name             = 'ZenApplication'
  spec.version          = '2.3.2'
  spec.swift_version    = '5.10'
  spec.summary          = 'Tools and architecture components for building mobile applications written in Swift.'
  spec.description      = <<-DESC
ZenApplication represents tools and architecture components for building mobile applications written in Swift.
                       DESC
  spec.homepage         = 'https://github.com/roland19deschain/ZenApplication'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Alexey Roik' => 'roland19deschain@gmail.com' }
  spec.source           = { :git => 'https://github.com/roland19deschain/ZenApplication.git', :tag => spec.version }
  spec.requires_arc     = true
  spec.ios.deployment_target = '14.0'
  spec.tvos.deployment_target = '14.0'
  spec.osx.deployment_target = '10.15'
  spec.watchos.deployment_target = '6.0'
  spec.source_files     = 'Sources/**/*{swift}'
  spec.dependency 'ZenSwift'
end
