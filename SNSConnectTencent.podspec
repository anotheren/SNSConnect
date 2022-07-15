Pod::Spec.new do |s|
    s.name = 'SNSConnectTencent'
    s.version = '1.0.0-beta.1'
    s.license = 'MIT'
    s.summary = 'Tencent support for SNSConnect'
    s.homepage = 'https://github.com/anotheren/SNSConnect'
    s.authors = {
        'anotheren' => 'liudong.edward@gmail.com'
    }
    s.source = { :git => 'https://github.com/anotheren/SNSConnect.git', :tag => s.version }
    s.ios.deployment_target = '13.0'
    s.swift_versions = ['5.5', '5.6']
    s.frameworks = 'Foundation'
    s.source_files = 'Sources/SNSConnectTencent/**/*.swift'
    s.dependency 'SNSConnect'
    s.dependency 'SNSConnectTencentRebuild'
end
