# frozen_string_literal: true

module Jekyll
  module Cloudinary

    class CloudinaryTag < Liquid::Tag
      require "fastimage"

      def initialize(tag_name, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        # Default settings
        settings_defaults = {
          "cloud_name"         => "",
          "only_prod"          => false,
          "verbose"            => false,
        }
        preset_defaults = {
          "min_width"          => 320,
          "max_width"          => 1200,
          "fallback_max_width" => 1200,
          "steps"              => 5,
          "sizes"              => "100vw",
          "figure"             => "auto",
          "attributes"         => {},
          "width_height"       => true,
          # Cloudinary transformations
          "height"             => false,
          "crop"               => "limit",
          "aspect_ratio"       => false,
          "gravity"            => false,
          "zoom"               => false,
          "x"                  => false,
          "y"                  => false,
          "format"             => false,
          "fetch_format"       => "auto",
          "quality"            => "auto",
          "radius"             => false,
          "angle"              => false,
          "effect"             => false,
          "opacity"            => false,
          "border"             => false,
          "background"         => false,
          "overlay"            => false,
          "underlay"           => false,
          "default_image"      => false,
          "delay"              => false,
          "color"              => false,
          "color_space"        => false,
          "dpr"                => false,
          "page"               => false,
          "density"            => false,
          "flags"              => false,
          "transformation"     => false,
        }

        # TODO: Add validation for this parameters
        transformation_options = {
          "height"         => "h",
          "crop"           => "c", # can include add-on: imagga_scale
          "aspect_ratio"   => "ar",
          "gravity"        => "g",
          "zoom"           => "z",
          "x"              => "x",
          "y"              => "y",
          "fetch_format"   => "f",
          "quality"        => "q", # can include add-on: jpegmini
          "radius"         => "r",
          "angle"          => "a",
          "effect"         => "e", # can include add-on: viesus_correct
          "opacity"        => "o",
          "border"         => "bo",
          "background"     => "b",
          "overlay"        => "l",
          "underlay"       => "u",
          "default_image"  => "d",
          "delay"          => "dl",
          "color"          => "co",
          "color_space"    => "cs",
          "dpr"            => "dpr",
          "page"           => "pg",
          "density"        => "dn",
          "flags"          => "fl",
          "transformation" => "t",
        }

        # Settings
        site = context.registers[:site]
        site_url = site.config["url"] || ""
        site_baseurl = site.config["baseurl"] || ""
        if site.config["cloudinary"].nil?
          Jekyll.logger.abort_with("[Cloudinary]", "You must set your cloud_name in _config.yml")
        end
        settings = settings_defaults.merge(site.config["cloudinary"])
        if settings["cloud_name"] == ""
          Jekyll.logger.abort_with("[Cloudinary]", "You must set your cloud_name in _config.yml")
        end
        url = settings["origin_url"] || (site_url + site_baseurl)

        # Get Markdown converter
        markdown_converter = site.find_converter_instance(::Jekyll::Converters::Markdown)

        preset_user_defaults = {}
        if settings["presets"]
          if settings["presets"]["default"]
            preset_user_defaults = settings["presets"]["default"]
          end
        end

        preset = preset_defaults.merge(preset_user_defaults)

        # Render any liquid variables in tag arguments and unescape template code
        rendered_markup = Liquid::Template
          .parse(@markup)
          .render(context)
          .gsub(%r!\\\{\\\{|\\\{\\%!, '\{\{' => "{{", '\{\%' => "{%")

        # Extract tag segments
        markup =
          %r!^(?:(?<preset>[^\s.:\/]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<html_attr>[\s\S]+)?$!
            .match(rendered_markup)

        unless markup
          Jekyll.logger.abort_with("[Cloudinary]", "Can't read this tag: #{@markup}")
        end

        image_src = markup[:image_src]

        # Dynamic image type
        type = "fetch"
        # TODO: URL2PNG requires signed URLs... need to investigate more
        # if /^url2png\:/.match(image_src)
        #   type = "url2png"
        #   image_src.gsub! "url2png:", ""
        # end

        if markup[:preset]
          if settings["presets"][markup[:preset]]
            preset = preset.merge(settings["presets"][markup[:preset]])
          elsif settings["verbose"]
            Jekyll.logger.warn(
              "[Cloudinary]",
              "'#{markup[:preset]}' preset for the Cloudinary plugin doesn't exist, \
              using the default one"
            )
          end
        end

        attributes = preset["attributes"]

        # Deep copy preset for single instance manipulation
        instance = Marshal.load(Marshal.dump(preset))

        # Process attributes
        html_attr = if markup[:html_attr]
                      Hash[ *markup[:html_attr].scan(%r!(?<attr>[^\s="]+)(?:="(?<value>[^"]+)")?\s?!).flatten ]
                    else
                      {}
                    end

        if instance["attr"]
          html_attr = instance.delete("attr").merge(html_attr)
        end

        # Classes from the tag should complete, not replace, the ones from the preset
        if html_attr["class"] && attributes["class"]
          html_attr["class"] << " #{attributes["class"]}"
        end
        html_attr = attributes.merge(html_attr)

        # Deal with the "caption" attribute as a true <figcaption>
        if html_attr["caption"]
          caption = markdown_converter.convert(html_attr["caption"])
          html_attr.delete("caption")
        end

        # alt and title attributes should go only to the <img> even when there is a caption
        img_attr = "".dup
        if html_attr["alt"]
          img_attr << " alt=\"#{html_attr["alt"]}\""
          html_attr.delete("alt")
        end
        if html_attr["title"]
          img_attr << " title=\"#{html_attr["title"]}\""
          html_attr.delete("title")
        end

        attr_string = html_attr.map { |a, v| "#{a}=\"#{v}\"" }.join(" ")

        # Figure out the Cloudinary transformations
        transformations = []
        transformations_string = ""
        transformation_options.each do |key, shortcode|
          if preset[key]
            transformations << "#{shortcode}_#{preset[key]}"
          end
        end
        unless transformations.empty?
          transformations_string = transformations.compact.reject(&:empty?).join(",") + ","
        end

        # Build source image URL
        is_image_remote = %r!^https?!.match(image_src)
        if is_image_remote
          # It's remote
          image_dest_path = image_src
          image_dest_url = image_src
          natural_width, natural_height = FastImage.size(image_dest_url)
          if natural_width.nil?
            Jekyll.logger.warn("remote url doesn't exists " + image_dest_url)
            return "<img src=\"#{image_dest_url}\" />"
          end
          width_height = "width=\"#{natural_width}\" height=\"#{natural_height}\""
          fallback_url = "https://res.cloudinary.com/#{settings["cloud_name"]}/image/#{type}/#{transformations_string}w_#{preset["fallback_max_width"]}/#{image_dest_url}"
        else
          # It's a local image
          is_image_src_absolute = %r!^/.*$!.match(image_src)
          if is_image_src_absolute
            image_src_path = File.join(
              site.config["source"],
              image_src
            )
            image_dest_path = File.join(
              site.config["destination"],
              image_src
            )
            image_dest_url = File.join(
              url,
              image_src
            )
          else
            image_src_path = File.join(
              site.config["source"],
              File.dirname(context["page"]["path"].chomp("/#excerpt")),
              image_src
            )
            image_dest_path = File.join(
              site.config["destination"],
              File.dirname(context["page"]["url"]),
              image_src
            )
            image_dest_url = File.join(
              url,
              File.dirname(context["page"]["url"]),
              image_src
            )
          end
          if File.exist?(image_src_path)
            natural_width, natural_height = FastImage.size(image_src_path)
            width_height = "width=\"#{natural_width}\" height=\"#{natural_height}\""
            fallback_url = "https://res.cloudinary.com/#{settings["cloud_name"]}/image/#{type}/#{transformations_string}w_#{preset["fallback_max_width"]}/#{image_dest_url}"
          else
            natural_width = 100_000
            width_height = ""
            Jekyll.logger.warn(
              "[Cloudinary]",
              "Couldn't find this image to check its width: #{image_src_path}."
            )
            fallback_url = image_dest_url
          end
        end

        # Don't generate responsive image HTML and Cloudinary URLs for local development
        if settings["only_prod"] && ENV["JEKYLL_ENV"] != "production"
          return "<img src=\"#{image_dest_url}\" #{attr_string} #{img_attr} #{width_height} crossorigin=\"anonymous\" />"
        end

        srcset = []
        steps = preset["steps"].to_i
        min_width = preset["min_width"].to_i
        max_width = preset["max_width"].to_i
        step_width = (max_width - min_width) / (steps - 1)
        sizes = preset["sizes"]

        if natural_width < min_width
          if settings["verbose"]
            Jekyll.logger.warn(
              "[Cloudinary]",
              "Width of source image '#{File.basename(image_src)}' (#{natural_width}px) \
              in #{context["page"]["path"]} not enough for ANY srcset version"
            )
          end
          srcset << "https://res.cloudinary.com/#{settings["cloud_name"]}/image/#{type}/#{transformations_string}w_#{natural_width}/#{image_dest_url} #{natural_width}w"
        else
          missed_sizes = []
          (1..steps).each do |factor|
            width = min_width + (factor - 1) * step_width
            if width <= natural_width
              srcset << "https://res.cloudinary.com/#{settings["cloud_name"]}/image/#{type}/#{transformations_string}w_#{width}/#{image_dest_url} #{width}w"
            else
              missed_sizes.push(width)
            end
          end
          unless missed_sizes.empty?
            srcset << "https://res.cloudinary.com/#{settings["cloud_name"]}/image/#{type}/#{transformations_string}w_#{natural_width}/#{image_dest_url} #{natural_width}w"
            if settings["verbose"]
              Jekyll.logger.warn(
                "[Cloudinary]",
                "Width of source image '#{File.basename(image_src)}' (#{natural_width}px) \
                in #{context["page"]["path"]} not enough for #{missed_sizes.join("px, ")}px \
                version#{missed_sizes.length > 1 ? "s" : ""}"
              )
            end
          end
        end
        srcset_string = srcset.join(",\n")

        # preset['figure'] can be 'never', 'auto' or 'always'
        if (caption || preset["figure"] == "always") && preset["figure"] != "never"
          "\n<figure #{attr_string}>\n<img src=\"#{fallback_url}\" srcset=\"#{srcset_string}\" sizes=\"#{sizes}\" #{img_attr} #{width_height} />\n<figcaption>#{caption}</figcaption>\n</figure>\n"
        else
          "<img src=\"#{fallback_url}\" srcset=\"#{srcset_string}\" sizes=\"#{sizes}\" #{attr_string} #{img_attr} #{width_height} crossorigin=\"anonymous\" />"
        end
      end
    end

  end
end

Liquid::Template.register_tag("cloudinary", Jekyll::Cloudinary::CloudinaryTag)
