# jekyll-image-generator
A Jekyll plugin to generate different sizes of images to be used in layouts from a single original.

NOTE: This is very much a work in progress. A lot of the options are unique to my blog. In the future hope to make more versatile.

To use, include `image-plugin.rb` in your `_plugins` directory.

Then, in `config.yml` you will need to add:

```yaml
images:
  sizes: { small: 320, med: 640, large: 1280 }
```

or:

```yaml
images:
  sizes:
    small: 320
    med: 640
    large: 1280
```

`sizes:` will dictate the width of images generated. You can have as many or as few as you like.

You'll also need a `_data/images.yml` file. Images are found and resized to `assets/images/`
