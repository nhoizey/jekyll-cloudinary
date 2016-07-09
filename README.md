# jekyll-cloudinary

Liquid tag for Jekyll to use Cloudinary for optimized responsive posts images.

## Usage

```Liquid
{% cloudinary [preset] path/to/img.jpg [attr="value"] %}
```

## Examples

```Liquid
{% cloudinary image1.jpg alt="alternate" %}
{% cloudinary onethird image2.jpg alt="other" title="yet another one" %}
```

## Configuration

Add a `cloudinary` in your `_config.yml` file:

```
cloudinary:
  api_id: …
  auto: true
  verbose: true
  presets:
    default:
      min_size: 320
      max_size: 1600
      steps: 5
      sizes: "(min-width: 50rem) 50rem, 90vw"
      attributes:
        class: onethird
```
