# frozen_string_literal: true

module InputTransformHelper
  def transform_blog_input(description)
    description_with_header_classes = add_css_classes_blog(description)
    description_with_all_css_classes = transform_figcaption_tag(description_with_header_classes)
    create_image_tags(description_with_all_css_classes)
  end

  def add_css_classes_blog(description)
    headers = {
      "<h2>" => "<h2 class='text-intense h3'>",
      "<h3>" => "<h3 class='h4'>",
      "<h4>" => "<h4 class='text-intense h5'>",
      "<h5>" => "<h5 class='h6'>"
    }

    description.gsub(/<h\d>/, headers)
  end

  def transform_figcaption_tag(description)
    description.gsub("<figcaption>", "<figcaption class='figure-caption text-center'>")
  end

  def add_header_css_classes_experiment(description)
    headers = {
      "<h3>" => "<h3 class='text-intense h5'>",
      "<h4>" => "<h4 class='text-intense h6'>"
    }

    description.gsub(/<h\d>/, headers)
  end

  def create_image_tags(description)
    matches = description.scan(/image:\w*/)

    matches.to_a.each do |match|
      image_name = match.remove("image:")
      image_tag = image_with_alt_tag(image_name)
      next unless image_tag

      description = description.sub!(match, image_tag)
    end

    description
  end
end
