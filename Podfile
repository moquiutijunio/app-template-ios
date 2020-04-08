platform :ios, '10.0'

target 'AppTemplateiOS' do
  use_frameworks!
  inhibit_all_warnings!
  
  #Utilities
  pod 'R.swift'
  pod 'SwiftLint'
  pod 'Kingfisher'
  pod 'YangMingShan'
  pod 'INSPullToRefresh'
  pod 'IGListKit', '~> 3.2' #OBJC
  
  #Layout
  pod 'Material'
  pod 'Cartography'
  
  #Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  
  #Analytics
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'

  #Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  
  #API
  pod 'Moya/RxSwift'
  
  #Third SDK
  pod 'GoogleSignIn', '~> 4.3.0'
  pod 'FacebookSDK/LoginKit', '~> 5.2.2'
end

target 'AppTemplateiOSTests' do
  inherit! :search_paths
  
  pod 'R.swift'
end

target 'AppTemplateiOSUITests' do
  inherit! :search_paths
  
  pod 'R.swift'
end
