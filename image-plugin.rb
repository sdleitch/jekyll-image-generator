require 'RMagick'
include Magick

module Jekyll

  class ImageGenerator < Generator
    safe true

    # This method will be called from generate. It will be executed when 'jekyll serve' is run
    def write_new_images(site)
      sizes = site.config['images']['sizes']
      new_images = []
      site.data['images'].each do |img|
        if !img[1]['size']
          new_images << img
          img[1]['size'] = sizes
        end
      end
      # resize any new images in the images.yml file. File must be in the /assets/images/ folder.
      resize_images(new_images, sizes, site)
      # Write the new image sizes into the yml file.
      write_images_yml(site)
      # Delete the original image files.
      delete_originals(new_images, site)
    end

    # Method to write images to YML
    def write_images_yml(site)
      File.open("#{site.source}/_data/images.yml", 'w') {|f| f.write site.data['images'].to_yaml }
    end

    # Method to resize the new images
    def resize_images(images, sizes, site)
      fullsize = []
      to_save = []
      images.each do |img|
        filepath = "#{site.source}/assets/images/#{img[1]['name']}.jpg"
        fullsize << Image::read(filepath).first
      end
      fullsize.each do |img|
        sizes.each_value { |size| to_save << img.resize_to_fit(size) }
      end
      to_save.each { |img| img.write("#{img.filename.split('.')[0]}-#{img.columns}.jpg") { self.quality = 80 } }
    end

    # Method to delete the original files.
    def delete_originals(images, site)
      images.each { |img| File.delete("#{site.source}/assets/images/#{img[1]['name']}.jpg") }
    end

    def generate(site)
      write_new_images(site)
    end
  end

end
