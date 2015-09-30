Pod::Spec.new do |s|
  s.name = 'CollapsableButton'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'A fully customizable button that can collapse to a circular shape and come back to its original shape, with nice animations.'
  s.homepage = 'https://github.com/zanadu/CollapsableButton'
  s.authors = { 'Benjamin Lefebvre' => 'benjamin@zanadu.cn' }
  s.source = { :git => 'https://github.com/zanadu/CollapsableButton.git',
               :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CollapsableButton/*.swift'

  s.requires_arc = true
end
