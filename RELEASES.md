# Releases

## [v1.13.0](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.13.0)

Add cross-origin support to prevent opaque responses in Service Workers. See
https://cloudfour.com/thinks/when-7-kb-equals-7-mb/

## [v1.12.4](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.12.4)

Improving gem summary and description to help people find it. There was no mention of "plugin" in it… 🤔

## [v1.12.3](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.12.3)

Strings are now immutable by default, be careful. ([ca68ba7](https://github.com/nhoizey/jekyll-cloudinary/commit/ca68ba7743b69983836b993761d1004494197795))

## [v1.12.2](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.12.2)

Match jekyll's coding style thanks to [@DirtyF](https://github.com/DirtyF) with a little help from [Rubocop](http://rubocop.readthedocs.io/).

## [v1.12.1](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.12.1)

Break early if there is no `cloud_name` in `_config.yml`.

## [v1.12.0](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.12.0)

Thanks to [@suprafly](https://github.com/suprafly)'s [Pull Request](https://github.com/nhoizey/jekyll-cloudinary/pull/29), you can now host your source images on an origin domain different from your website domain.

## [v1.11.0](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.11.0)

Thanks to [Pascal Brokmeier](https://github.com/pascalwhoop)'s [Pull Request](https://github.com/nhoizey/jekyll-cloudinary/pull/34), you can now have responsive images HTML and Cloudinary URLs generated only when you build for production.

Just make sure to:

- set the new option `only_prod` to `true`
- and set the environment to `production` before building: `JEKYLL_ENV=production bundle exec jekyll build`

## [v1.10.0](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.10.0)

Fixes an issue caused by Jekyll 3.8.1 introducing a change to content's path, adding an `/#excerpt` at the end in case of an excerpt.

See https://github.com/nhoizey/jekyll-cloudinary/commit/5372e37e4d31bf1934d90665692b9e14f2ac2147

## [v1.9.1](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.9.1)

Better warning message when the local source image is missing.

## [v1.9.0](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.9.0)

Get the dimensions of the picture from the source path instead of the destination one ([#19](https://github.com/nhoizey/jekyll-cloudinary/issues/19))

## [v1.8.1](https://github.com/nhoizey/jekyll-cloudinary/releases/tag/v1.8.1)

Fixes an issue with local images.

## v1.8.0

Image size detection now uses FastImage instead of RMagick to remove imagemagick dependency, thanks to [@aarongustafson](https://github.com/aarongustafson) ([#25](https://github.com/nhoizey/jekyll-cloudinary/issues/25))

## v1.7.0

It is now possible to use all effects and transformations from the Cloudinary API, thanks to [@aarongustafson](https://github.com/aarongustafson) ([#24](https://github.com/nhoizey/jekyll-cloudinary/issues/24))

## v1.4.0

Now supports sites with baseurl ([#10](https://github.com/nhoizey/jekyll-cloudinary/issues/10))

## v1.3.1

Restores natural width if some computed ones are missing.

## v1.3.0

Restores `width` and `height` attributes.

## v1.2.17

Fixes a little typo with huge impact…

## v1.2.16

Code improvements thanks to Rubocop, initialized by [@DirtyF](https://github.com/DirtyF)

## v1.2.15

Fixed bugs:
- Don’t add `<img>` `height` & `width` attributes ([#7](https://github.com/nhoizey/jekyll-cloudinary/issues/7))
- Dont’t wrap `alt` text in `<p>` ([#8](https://github.com/nhoizey/jekyll-cloudinary/issues/8))
- `require 'rmagick'` tripped me up ([#11](https://github.com/nhoizey/jekyll-cloudinary/issues/11))

Thanks [@eeeps](https://github.com/eeeps) for catching these issues!
