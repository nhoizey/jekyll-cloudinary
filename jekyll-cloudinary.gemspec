$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))
require "jekyll/cloudinary/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Cloudinary::VERSION
  spec.homepage = "http://github.com/nhoizey/jekyll-cloudinary/"
  spec.authors = ["Nicolas Hoizey"]
  spec.email = ["nicolas@hoizey.com"]
  spec.files = %W(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Liquid tag for Jekyll with Cloudinary"
  spec.name = "jekyll-cloudinary"
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description = spec.description = <<-DESC
    Liquid tag to use Cloudinary for optimized responsive posts images.
  DESC

  spec.add_runtime_dependency("jekyll", ">= 3.0", "~> 3.1")

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
