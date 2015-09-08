Pod::Spec.new do |s|
s.name         = "TWMLMatrix"
s.version      = "0.1"
s.summary      = "將 BLAS Open Library Matrix 的部分，重新封裝為Matrix Structure，並透過Swift語言特性，簡化Library的操作。"
s.description  = <<-DESC
將 BLAS Open Library Matrix 的部分，重新封裝為Matrix Structure，並透過Swift語言特性，簡化Library的操作。
DESC
s.homepage     = "https://github.com/gradyzhuo/TWMLMatrix"
s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
s.author       = { "Grady Zhuo" => "gradyzhuo@gmail.com" }
s.social_media_url = "https://www.facebook.com/gradyzhuo"
s.source       = { :git => "https://github.com/gradyzhuo/TWMLMatrix", :tag => s.version.to_s }
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'TWMLMatrix/Sources/**/*.swift'
s.frameworks   = 'Foundation'
end
