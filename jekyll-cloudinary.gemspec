# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/cloudinary/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Cloudinary::VERSION
  spec.homepage = "https://nhoizey.github.io/jekyll-cloudinary/"
  spec.authors = ["Nicolas Hoizey"]
  spec.email = ["nicolas@hoizey.com"]
  spec.files = %w(Rakefile Gemfile README.md RELEASES.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Jekyll plugin adding a Liquid tag for Cloudinary, for better responsive images"
  spec.name = "jekyll-cloudinary"
  spec.license = "MIT"
  spec.require_paths = ["lib"]
  spec.description = <<-DESC
    This Jekyll plugin adds a Liquid tag that helps using Cloudinary, a SaaS solution for images management and transformation.

    It helps using responsive images (picture, srcset, etc.) to optimize performance of websites.
  DESC

  spec.add_runtime_dependency "fastimage", "~> 2.0"
  spec.add_runtime_dependency "jekyll", ">= 3.6", "< 5"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rubocop", "~> 0.91.1"
end
