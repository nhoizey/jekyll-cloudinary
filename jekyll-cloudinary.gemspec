# frozen_string_literal: true

require_relative "lib/jekyll/cloudinary/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Cloudinary::VERSION
  spec.name          = "jekyll-cloudinary"
  spec.version       = Jekyll::Cloudinary::VERSION
  spec.authors       = ["Mavaddat Javid"]
  spec.email         = ["info@mavaddat.ca"]
  spec.files = %w(Rakefile Gemfile README.md RELEASES.md LICENSE) + Dir["lib/**/*"]
  spec.summary       = "Jekyll plugin providing Cloudinary-powered responsive image generation"
  spec.description   = <<-DESC
  A Jekyll-native (Liquid markup) `Cloudinary` tag that can generate responsive images with breakpoints, automatically:
   - Deciding which image resolutions to select 
   - Calculating how many different image versions to include
  These are 'responsive breakpoints' or 'responsive image breakpoints'.

  Breakpoints for responsive design allows the same images to be displayed in various dimensions. One image for all screen resolutions and different devices is not enough. This tool uploads one image and dynamically resizes it to match different screen sizes.
  DESC
  spec.homepage      = "https://mavaddat.github.io/jekyll-cloudinary/"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mavaddat/jekyll-cloudinary"
  spec.metadata["changelog_uri"] = "https://github.com/mavaddat/jekyll-cloudinary/blob/main/CHANGELOD.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fastimage"
  spec.add_runtime_dependency "jekyll"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rspec", "~> 3.2"
end
