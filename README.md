# Jekyll Cloudinary Liquid tag

[![Gem Version](https://badge.fury.io/rb/jekyll-cloudinary.svg)](https://badge.fury.io/rb/jekyll-cloudinary)
[![Gem Downloads](https://img.shields.io/gem/dt/jekyll-cloudinary.svg?style=flat)](http://rubygems.org/gems/jekyll-cloudinary)

`jekyll-cloudinary` is a [Jekyll](http://jekyllrb.com/) plugin adding a [Liquid](http://liquidmarkup.org) tag to ease the use of [Cloudinary](https://nho.io/cloudinary-signup) for responsive images in your Markdown/[Kramdown](http://kramdown.gettalong.org/) posts.

It builds the HTML for responsive images in the posts, using the `srcset` and `sizes` attributes for the `<img />` tag (see [the "varying size and density" section of this post](https://jakearchibald.com/2015/anatomy-of-responsive-images/#varying-size-and-density) if this is new for you, and why it's recommended to [not use `<picture>` most of the time](https://cloudfour.com/thinks/dont-use-picture-most-of-the-time/)). URLs in the `srcset` are cloudinary URLs that [fetch on-the-fly](http://cloudinary.com/features#fetch) the post's images and resize them to several sizes.

You are in full control of the number of generated images and their sizes, and the `sizes` attribute that helps the browser decide which image to download. See the complete configuration options for details.

Here is the general syntax of this Liquid tag:

<!-- {% raw %} -->
```liquid
{% cloudinary cloudflare.png alt="Un schéma montrant l'apport de Cloudflare" caption="Un schéma montrant l'apport de Cloudflare" %}
```
<!-- {% endraw %} -->

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of contents

- [Installation](#installation)
- [Configuration](#configuration)
  - [Mandatory settings](#mandatory-settings)
  - [Optional global settings](#optional-global-settings)
    - [`only_prod` (default: `false`)](#only_prod-default-false)
    - [`verbose` (default: `false`)](#verbose-default-false)
  - [Optional (but highly recommended) presets](#optional-but-highly-recommended-presets)
    - [Default preset](#default-preset)
    - [Additional presets](#additional-presets)
  - [Detailed preset settings](#detailed-preset-settings)
    - [`figure` (default: `auto`)](#figure-default-auto)
    - [`min_width` (default: `320`)](#min_width-default-320)
    - [`max_width` (default: `1200`)](#max_width-default-1200)
    - [`fallback_max_width` (defaut: `1200`)](#fallback_max_width-defaut-1200)
    - [`steps` (default: `5`)](#steps-default-5)
    - [`sizes` (default: `"100vw"`)](#sizes-default-100vw)
    - [`attributes` (default: none)](#attributes-default-none)
- [Live example](#live-example)
- [Contributing](#contributing)
- [Do you use the plugin on a live site?](#do-you-use-the-plugin-on-a-live-site)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

[Sign up **for free** on Cloudinary!](https://nho.io/cloudinary-signup) The free account should be enough for most blogs.

Add `gem 'jekyll-cloudinary'` to the `jekyll_plugin` group in your `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'jekyll'

group :jekyll_plugins do
  gem 'jekyll-cloudinary'
end
```

Then run `bundle` to install the gem.

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
  only_prod: true
  verbose: true
  origin_url: https://another-domain.com
```

#### `only_prod` (default: `false`)

When set to `true`, this setting implies that responsive image HTML and Cloudinary URLs are generated only if the environnement is `production`.

For example:

- if you run `JEKYLL_ENV=production bundle exec jekyll build`, you'll get the code to deploy, with `srcset` and Cloudinary URLs.
- if you run `JEKYLL_ENV=development bundle exec jekyll serve`, you'll get code for local development, with standard `<img src="…">` code and local URLs.

[`JEKYLL_ENV=development` is the default value](https://jekyllrb.com/docs/configuration/#specifying-a-jekyll-environment-at-build-time).

If you don't set `only_prod` or set it to `false`, responsive image HTML and Cloudinary URLs are always generated, whatever the environment. jekyll-cloudinary had only this behavior before version 1.11.0.

#### `verbose` (default: `false`)

When set to `true`, this setting will show messages in the console when something goes wrong, such as:

```
[Cloudinary] Couldn't find this image to check its width: /path/to/jekyll/_site/assets/img.jpg
```

or

```
[Cloudinary] Natural width of source image 'img.jpg' (720px) in _posts/2016-06-09-post.md not enough for creating 1600px version
```

#### `origin_url`

When `origin_url` is set, jekyll-cloudinary will use this URL rather than `site.url` as origin of the source images.

This allows you to store your source image on a different domain than your website.

### Optional (but highly recommended) presets

You can now define the presets you need for your posts' images, starting with the default one:

#### Default preset

The default preset is the one you don't even have to mention when using the Liquid tag, and that will be used if a preset you use in the tag doesn't exist.

```yaml
cloudinary:
  …
  presets:
    default:
      min_width: 320
      max_width: 1600
      fallback_max_width: 800
      steps: 5
      sizes: "(min-width: 50rem) 50rem, 90vw"
```

This preset will generate five images 320 to 1600 pixels wide in the `srcset` and define `sizes` as `"(min-width: 50rem) 50rem, 90vw"`. The fallback image defined in the `src` will have a width of 800 pixels.

With this preset, you only have to write this in your Markdown post:

<!-- {% raw %} -->
```liquid
{% cloudinary /assets/img.jpg alt="beautiful!" %}
```
<!-- {% endraw %} -->

To get this HTML:

```html
<img
  src="http://res.cloudinary.com/<cloud_name>/image/fetch/c_limit,w_800,q_auto,f_auto/https://<your-domain>/assets/img.jpg"
  srcset="
    http://res.cloudinary.com/<cloud_name>/image/fetch/c_limit,w_320,q_auto,f_auto/https://<your-domain>/assets/img.jpg 320w,
    http://res.cloudinary.com/<cloud_name>/image/fetch/c_limit,w_640,q_auto,f_auto/https://<your-domain>/assets/img.jpg 640w
    http://res.cloudinary.com/<cloud_name>/image/fetch/c_limit,w_960,q_auto,f_auto/https://<your-domain>/assets/img.jpg 960w
    http://res.cloudinary.com/<cloud_name>/image/fetch/c_limit,w_1280,q_auto,f_auto/https://<your-domain>/assets/img.jpg 1280w
    http://res.cloudinary.com/<cloud_name>/image/fetch/c_limit,w_1600,q_auto,f_auto/https://<your-domain>/assets/img.jpg 1600w
    "
  sizes="(min-width: 50rem) 50rem, 90vw"
  alt="beautiful!"
  width="480"
  height="320"
/>
```

There is a true default `default` preset, but you're strongly encouraged to override it with your own default preset.

#### Additional presets

You can add other presets if you need several image sizes in your posts.

Here is an example for images that take only one third of the post width:

```yaml
cloudinary:
  …
  presets:
    …
    onethird:
      min_width: 110
      max_width: 535
      fallback_max_width: 300
      steps: 3
      sizes: "(min-width: 50rem) 17rem, 30vw"
      attributes:
        class: "one3rd"
```

To use this additional preset, you will have to write this in your Markdown post:

<!-- {% raw %} -->
```liquid
{% cloudinary onethird /assets/img.jpg %}
```
<!-- {% endraw %} -->

The generated element will also get a `class="one3rd"` that can be useful for example with this CSS:

```css
.one3rd {
  max-width: 33%;
  float: right;
  margin: 0 0 1em 1em;
}
```

### Detailed preset settings

#### `figure` (default: `auto`)

This setting lets you decide what to do when there is a `caption` attribute in the Cloudinary Liquid tag.

The value can be:

- `auto` (default): will generate a `<figure>` and `<figcaption>` only if there's a caption
- `never`: will always generate a `<img>`, losing the caption
- `always`: will always generate a `<figure>` and `<figcaption>`, even if there's no `caption` attribute

If a `<figure>` is generated and there are attributes in the Liquid tag, they are added to the `<img>` if they are `alt` or `title`, or to the `<figure>`.

#### `min_width` (default: `320`)

#### `max_width` (default: `1200`)

#### `fallback_max_width` (defaut: `1200`)

#### `steps` (default: `5`)

#### `sizes` (default: `"100vw"`)

#### `attributes` (default: none)

Attributes are added without transformation to the generated element.

You can obviously define the `alt` attribute, mandatory for accessibility, but you can also set a `title`, a `class`, `aria-*` attributes for enhanced accessibility, or even `data-*` attributes you would like to use later with CSS or JavaScript.

The `caption` attribute is the only one that can act differently, depending on the `figure` setting.

`alt`, `title` and `caption` attributes can contain Markdown.

## Live example

Go to this post: [https://nicolas-hoizey.com/2016/07/tout-change-rien-ne-change.html](https://nicolas-hoizey.com/2016/07/tout-change-rien-ne-change.html).

The source Markdown is here: [https://github.com/nhoizey/nicolas-hoizey.com/blob/master/_posts/2016/07/13-tout-change-rien-ne-change/2016-07-13-tout-change-rien-ne-change.md](https://github.com/nhoizey/nicolas-hoizey.com/blob/master/_posts/2016/07/13-tout-change-rien-ne-change/2016-07-13-tout-change-rien-ne-change.md).

The content is in french, yes, but look only at the images if you don't understand.

You'll find here:

- 2 logos floating on the right of the text (or centered on smaller screens): [Jekyll](http://jekyllrb.com/) and [Cloudinary](https://nho.io/cloudinary-signup)
- 2 screenshots taking the whole width of the content: the [Cloudinary pricing table](http://cloudinary.com/pricing), and [Dareboost](https://www.dareboost.com/en/home)'s performance monitoring graph

These image types need different settings to deal with different sizes and position:

- screenshot always use the full content width, if they're wide enough
- logos are centered and take one half of the content width on small screens, and are floated and take one fourth of the content width on larger screens

This is how I use the Cloudinary Liquid tag for the Cloudinary logo and prices table screenshot:

<!-- {% raw %} -->
```liquid
{% cloudinary logo /assets/logos/cloudinary.png alt="Logo de Cloudinary" %}
{% cloudinary cloudinary-pricing.png alt="Les tarifs de Cloudinary" caption="Les tarifs de Cloudinary, dont l'offre gratuite déjà généreuse" %}
```
<!-- {% endraw %} -->

The only difference is that I explicitly use the `logo` preset for the logo. The other image uses the `default` preset.

Here is the necessary configuration for this:

```yaml
cloudinary:
  cloud_name: …
  verbose: false
  presets:
    default:
      min_width: 320
      max_width: 1600
      fallback_max_width: 800
      steps: 5
      sizes: '(min-width: 50rem) 50rem, 90vw'
      figure: always
    logo:
      min_width: 80
      max_width: 400
      fallback_max_width: 200
      steps: 3
      sizes: '(min-width: 50rem) 13rem, (min-width: 40rem) 25vw, 45vw'
      figure: never
      attributes:
        class: logo
```

It generates these HTML fragments (pretty printed here), for the logo:

```html
<img
  src="https://res.cloudinary.com/nho/image/fetch/c_limit,w_200,q_auto,f_auto/https://nicolas-hoizey.com/assets/logos/cloudinary.png"
  srcset="
    https://res.cloudinary.com/nho/image/fetch/c_limit,w_80,q_auto,f_auto/https://nicolas-hoizey.com/assets/logos/cloudinary.png 80w,
    https://res.cloudinary.com/nho/image/fetch/c_limit,w_240,q_auto,f_auto/https://nicolas-hoizey.com/assets/logos/cloudinary.png 240w,
    https://res.cloudinary.com/nho/image/fetch/c_limit,w_400,q_auto,f_auto/https://nicolas-hoizey.com/assets/logos/cloudinary.png 400w"
  sizes="
    (min-width: 50rem) 13rem,
    (min-width: 40rem) 25vw,
    45vw"
  class="logo"
  alt="Logo de Cloudinary"
  width="480"
  height="350"
/>
```

And for the screenshot:

```html
<figure>
  <img
    src="https://res.cloudinary.com/nho/image/fetch/c_limit,w_800,q_auto,f_auto/https://nicolas-hoizey.com/2016/07/cloudinary-pricing.png"
    srcset="
      https://res.cloudinary.com/nho/image/fetch/c_limit,w_320,q_auto,f_auto/https://nicolas-hoizey.com/2016/07/cloudinary-pricing.png 320w,
      https://res.cloudinary.com/nho/image/fetch/c_limit,w_640,q_auto,f_auto/https://nicolas-hoizey.com/2016/07/cloudinary-pricing.png 640w,
      https://res.cloudinary.com/nho/image/fetch/c_limit,w_960,q_auto,f_auto/https://nicolas-hoizey.com/2016/07/cloudinary-pricing.png 960w,
      https://res.cloudinary.com/nho/image/fetch/c_limit,w_1208,q_auto,f_auto/https://nicolas-hoizey.com/2016/07/cloudinary-pricing.png 1208w"
    sizes="(min-width: 50rem) 50rem, 90vw"
    alt="Les tarifs de Cloudinary"
    width="1208"
    height="561"
  />
  <figcaption>Les tarifs de Cloudinary, dont l'offre gratuite déjà généreuse</figcaption>
</figure>
```

There are only 4 version in the `srcset` here because 2 of the 5 expected sizes are larger than the source image, and are replaced by one using the native source image width.

And here are the relevant parts of the accompanying CSS (in Sass form):

```sass
article {
  figure, img {
    margin: 2em auto;
    display: block;
    max-width: 100%;
    height: auto;
  }
}

.logo {
  display: block;
  margin: 1em auto;
  max-width: 50%;
  height: auto;

  @media (min-width: 40em) {
    max-width: 25%;
    float: right;
    margin: 0 0 1em 1em;
  }
}
```

## Contributing

Thanks for your interest in contributing! There are many ways to contribute to this project. [Get started here](https://github.com/nhoizey/jekyll-cloudinary/blob/master/CONTRIBUTING.md).

## Do you use the plugin on a live site?

Add it to [the "Sites" page of the wiki](https://github.com/nhoizey/jekyll-cloudinary/wiki/Sites) and please let me know on Twitter: [@nhoizey](https://twitter.com/nhoizey)
