# Jekyll Cloudinary Liquid tag

`jekyll-cloudinary` is a [Jekyll](http://jekyllrb.com/) plugin adding a [Liquid](http://liquidmarkup.org) tag to ease the use of [Cloudinary](http://cloudinary.com/invites/lpov9zyyucivvxsnalc5/sgyyc0j14k6p0sbt51nw) for responsive images in your Markdown/[Kramdown](http://kramdown.gettalong.org/) posts.

It builds the HTML for responsive images in the posts, using the `srcset` and `sizes` attributes for the `<img />` tag (see [the "varying size and density" section of this post by Jake Archibald](https://jakearchibald.com/2015/anatomy-of-responsive-images/#varying-size-and-density) if this is new for you). URLs in the `srcset` are cloudinary URLs that [fetch on-the-fly](http://cloudinary.com/features#fetch) the post's images and resizes them to several sizes.

You are in full control of the number of generated images and their size, and the `sizes` attribute that helps the browser decide which image to download. See the complete configuration options for details.

Here is the general syntax of this Liquid tag:

```liquid
{% cloudinary [preset] path/to/img.jpg [attr="value"] %}
```

## Using Jekyll Cloudinary

[Sign up for free on Cloudinary](http://cloudinary.com/invites/lpov9zyyucivvxsnalc5/sgyyc0j14k6p0sbt51nw). The free account should be enough for most blogs.

Add `gem 'jekyll-cloudinary'` to your `Gemfile` and run `bundle update` to install the gem.

Add `jekyll-cloudinary` to your `_config.yml` like the following:

```yaml
gems:
  - jekyll-cloudinary
```

## Configuration

### Mandatory settings

Add `cloudinary` to your `_config.yml` and your Cloudinary "Cloud name" (find it in your [Cloudinary dashboard](https://cloudinary.com/console)):

```yaml
cloudinary:
  cloud_name: <put here your Cloudinary "Cloud name">
```

### Optional global settings

You can now define some global settings

```yaml
cloudinary:
  …
  verbose: true
```

#### `verbose` (default: `false`)

When set to `true`, this setting will show messages in the console when something goes wrong, such as:

```
[Cloudinary] Couldn't find this image to check its width: /path/to/jekyll/_site/assets/img.jpg
```

or

```
[Cloudinary] Natural width of source image 'img.jpg' (720px) in _posts/2016-06-09-post.md not enough for creating 1600px version
```

### Optional (but highly recommended) presets

You can now define the presets you need for your posts' images, starting with the default one:

#### Default preset

The default preset is the one you don't even have to mention when using the Liquid tag, and that will be used if a preset you use in the tag doesn't exist.

```yaml
cloudinary:
  …
  presets:
    default:
      min_size: 320
      max_size: 1600
      steps: 5
      sizes: "(min-width: 50rem) 50rem, 90vw"
```

This preset will generate five images 320 to 1600 pixels wide in the `srcset` and define `sizes` as `"(min-width: 50rem) 50rem, 90vw"`.

With this preset, you only have to write this in your Markdown post:

```liquid
{% cloudinary /assets/img.jpg %}
```

To get this HTML:




#### Additional presets

You can add other presets if you need several image sizes in your posts, here is an example for images that take only one third of the post width:

```yaml
cloudinary:
  …
  presets:
    …
    onethird:
      min_size: 110
      max_size: 535
      steps: 3
      sizes: "(min-width: 50rem) 17rem, 30vw"
      attributes:
        class: onethird
```

#### `min_size`

#### `max_size`

#### `steps`

#### `sizes`

#### `attributes`


## Examples

```liquid
{% cloudinary image1.jpg alt="alternate" %}
{% cloudinary onethird image2.jpg alt="other" title="yet another one" %}
```

