# Jekyll Cloudinary Liquid tag

`jekyll-cloudinary` is a [Jekyll](http://jekyllrb.com/) plugin adding a [Liquid](http://liquidmarkup.org) tag to ease the use of [Cloudinary](http://cloudinary.com/invites/lpov9zyyucivvxsnalc5/sgyyc0j14k6p0sbt51nw) for responsive images in your Markdown/[Kramdown](http://kramdown.gettalong.org/) posts.

It builds the HTML for responsive images in the posts, using the `srcset` and `sizes` attributes for the `<img />` tag (see [the "varying size and density" section of this post by Jake Archibald](https://jakearchibald.com/2015/anatomy-of-responsive-images/#varying-size-and-density) if this is new for you). URLs in the `srcset` are cloudinary URLs that [fetch on-the-fly](http://cloudinary.com/features#fetch) the post's images and resizes them to several sizes.

You are in full control of the number of generated images and their size, and the `sizes` attribute that helps the browser decide which image to download. See the complete configuration options for details.

## Using Jekyll Cloudinary

[Sign up for free on Cloudinary](http://cloudinary.com/invites/lpov9zyyucivvxsnalc5/sgyyc0j14k6p0sbt51nw). The free account should be enough for mosts blogs.

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

#### `auto`

#### `verbose`


### Optional (but highly recommended) presets

```yaml
cloudinary:
  …
  presets:
    default:
      min_size: 320
      max_size: 1600
      steps: 5
      sizes: "(min-width: 50rem) 50rem, 90vw"
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

## Usage

This is the Liquid tag syntax:

```Liquid
{% cloudinary [preset] path/to/img.jpg [attr="value"] %}
```

## Examples

```Liquid
{% cloudinary image1.jpg alt="alternate" %}
{% cloudinary onethird image2.jpg alt="other" title="yet another one" %}
```
