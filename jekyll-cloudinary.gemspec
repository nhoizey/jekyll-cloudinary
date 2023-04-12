# frozen_string_literal: true

require_relative "lib/jekyll/cloudinary/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Cloudinary::VERSION
  spec.name          = "jekyll-cloudinary"
  spec.version       = Jekyll::Cloudinary::VERSION
  spec.authors       = ["Nicolas Hoizey", "Mavaddat Javid"]
  spec.email         = ["nicolas@hoizey.com","info@mavaddat.ca"]
  spec.files = %w(Rakefile Gemfile README.md RELEASES.md LICENSE) + Dir["lib/**/*"]
  spec.summary       = "Jekyll plugin providing Cloudinary-powered responsive image generation"
  spec.description   = <<-DESC
  A plugin to enable a Jekyll-native (Liquid markup) `Cloudinary` tag that generates responsive images srcsets from an optimal number of versions for every image. It does this by finding the minimum number of image versions per file size reductions between each version. The set of breakpoints are based on a difference in the actual image file size at different widths. This means: 
   - Deciding which image resolutions to select 
   - Calculating how many different image versions to include
  Devs call these 'responsive breakpoints' or 'responsive image breakpoints'.

  Breakpoints for responsive design allow the same images to be displayed in various dimensions. One image for all screen resolutions and different devices is leads to cache or packet inefficiencies. This tool uploads one image and dynamically resizes it to match different screen sizes.
  DESC
  spec.homepage      = "https://mavaddat.github.io/jekyll-cloudinary/"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mavaddat/jekyll-cloudinary"
  spec.metadata["changelog_uri"] = "https://github.com/mavaddat/jekyll-cloudinary/blob/main/RELEASES.md"

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

  spec.add_runtime_dependency "fastimage", "~> 2.2"
  spec.add_runtime_dependency "jekyll", "~> 4.2"
  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rubocop", "~> 1.50.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "rubocop-rspec", "~> 2.5"
  spec.add_development_dependency "rubocop-rails", "~> 2.13"
  spec.add_development_dependency "rubocop-performance", "~> 1.13"
  spec.add_development_dependency "cloudinary", "~> 1.21"
  spec.add_development_dependency "bundler"
end
