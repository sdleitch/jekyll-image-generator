require 'RMagick'
include Magick

module Jekyll

  class ImageGenerator < Generator
    safe true

    def write_new_images(site)
      sizes = site.config['images']['sizes']
      new_images = []
      site.data['images'].each do |img|
        if !img[1]['size']
          new_images << img
          img[1]['size'] = sizes
        end
      end
      resize_images(new_images, sizes, site)
      write_images_yml(site)
      delete_originals(new_images, site)
    end

    def write_images_yml(site)
      File.open("#{site.source}/_data/images.yml", 'w') {|f| f.write site.data['images'].to_yaml }
    end

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

    def delete_originals(images, site)
      images.each { |img| File.delete("#{site.source}/assets/images/#{img[1]['name']}.jpg") }
    end

    def generate(site)
      write_new_images(site)
    end
  end

end
