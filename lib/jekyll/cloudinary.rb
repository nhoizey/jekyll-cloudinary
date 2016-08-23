module Jekyll
  module Cloudinary

    class CloudinaryTag < Liquid::Tag
      require "RMagick"

      def initialize(tag_name, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        # Default settings
        preset_defaults = {
          "min_width"          => 320,
          "max_width"          => 1200,
          "fallback_max_width" => 1200,
          "steps"              => 5,
          "sizes"              => "100vw",
          "figure"             => "auto",
          "attributes"         => {},
          "verbose"            => false
        }

        # Settings
        site = context.registers[:site]
        url = site.config["url"]
        baseurl = site.config["baseurl"] || ""
        settings = site.config["cloudinary"]

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
          .gsub(%r!\\\{\\\{|\\\{\\%!, '\{\{' => '{{', '\{\%' => '{%')

        # Extract tag segments
        markup =
          %r!^(?:(?<preset>[^\s.:\/]+)\s+)?(?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})\s*(?<html_attr>[\s\S]+)?$!
            .match(rendered_markup)

        unless markup
          Jekyll.logger.abort_with("[Cloudinary]", "Can't read this tag: #{@markup}")
        end

        image_src = markup[:image_src]

        # Build source image URL
        is_image_path_absolute = %r!^/.*$!.match(image_src)
        if is_image_path_absolute
          image_path = File.join(site.config["destination"], image_src)
          image_url = File.join(url, baseurl, image_src)
        else
          image_path = File.join(
            site.config["destination"],
            File.dirname(context["page"].url),
            image_src
          )
          image_url = File.join(
            url,
            baseurl,
            File.dirname(context["page"].url),
            image_src
          )
        end

        # Get source image natural width
        if File.exist?(image_path)
          image = Magick::Image::read(image_path).first
          natural_width = image.columns
          natural_height = image.rows
          width_height = "width=\"#{natural_width}\" height=\"#{natural_height}\""
          fallback_url = "https://res.cloudinary.com/#{settings["cloud_name"]}/image/fetch/c_limit,w_#{fallback_max_width},q_auto,f_auto/#{image_url}"
        else
          natural_width = 100_000
          width_height = ""
          Jekyll.logger.warn(
            "[Cloudinary]",
            "Couldn't find this image to check its width: #{image_path}. \
            Try to run Jekyll build a second time."
          )
          fallback_url = image_url
        end

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
        img_attr = ""
        if html_attr["alt"]
          img_attr << " alt=\"#{html_attr["alt"]}\""
          html_attr.delete("alt")
        end
        if html_attr["title"]
          img_attr << " title=\"#{html_attr["title"]}\""
          html_attr.delete("title")
        end

        attr_string = html_attr.map { |a, v| "#{a}=\"#{v}\"" }.join(" ")

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
              in #{context["page"].path} not enough for ANY srcset version"
            )
          end
          srcset << "https://res.cloudinary.com/#{settings["cloud_name"]}/image/fetch/c_limit,w_#{natural_width},q_auto,f_auto/#{image_url} #{natural_width}w"
        else
          missed_sizes = []
          (1..steps).each do |factor|
            width = min_width + (factor - 1) * step_width
            if width <= natural_width
              srcset << "https://res.cloudinary.com/#{settings["cloud_name"]}/image/fetch/c_limit,w_#{width},q_auto,f_auto/#{image_url} #{width}w"
            else
              missed_sizes.push(width)
            end
          end
          unless missed_sizes.empty?
            srcset << "https://res.cloudinary.com/#{settings["cloud_name"]}/image/fetch/c_limit,w_#{natural_width},q_auto,f_auto/#{image_url} #{natural_width}w"
            if settings["verbose"]
              Jekyll.logger.warn(
                "[Cloudinary]",
                "Width of source image '#{File.basename(image_src)}' (#{natural_width}px) \
                in #{context["page"].path} not enough for #{missed_sizes.join("px, ")}px \
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
          "<img src=\"#{fallback_url}\" srcset=\"#{srcset_string}\" sizes=\"#{sizes}\" #{attr_string} #{img_attr} #{width_height} />"
        end
      end
    end

  end
end

Liquid::Template.register_tag("cloudinary", Jekyll::Cloudinary::CloudinaryTag)
