platform :ios, '10.0'
inhibit_all_warnings!

target 'Rx2048' do
  use_frameworks!

  # DI
  pod 'Deli', '0.6.2'

  # Architecture
  pod 'ReactorKit', '1.2.1'

  # Rx
  pod 'RxAnimated', '0.5.0'
  pod 'RxCocoa', '4.3.1'
  pod 'RxGesture', '2.0.1'
  pod 'RxOptional', '3.5.0'
  pod 'RxSwift', '4.3.1'
  pod 'RxSwiftExt', '3.3.0'

  # UI
  pod 'Gradients', '0.2.1'

  target 'Rx2048Tests' do
    inherit! :complete
    pod 'Quick', '1.3.2'
    pod 'Nimble', '7.3.1'
  end
end
