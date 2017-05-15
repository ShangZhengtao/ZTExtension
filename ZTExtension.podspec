
Pod::Spec.new do |s|
s.name             = "ZTExtension"
s.version          = "1.0.0"
s.summary          = "some useful Swift Extension"
s.description      = <<-DESC
some useful Swift Extension

DESC
s.homepage         = "https://github.com/ShangZhengtao/ZTExtension"
#s.screenshots      = "https://raw.githubusercontent.com/icanzilb/EasyAnimation/master/etc/EA.png"
s.license          = 'MIT'
s.author           = { "ShangZhengtao" => "shang2net@163.com" }
s.source           = { :git => "https://github.com/ShangZhengtao/ZTExtension.git", :tag => s.version }
#s.social_media_url = 'https://twitter.com/icanzilb'

s.platform     = :ios, '9.0'
s.requires_arc = true

s.source_files = 'ZTCategories/Categories/*'
end
