# frozen_string_literal: true

module InputTransformHelper
  def add_header_css_classes_blog(description)
    headers = {
      "<h2>" => "<h2 class='text-intense h3'>",
      "<h3>" => "<h3 class='h4'>",
      "<h4>" => "<h4 class='text-intense h5'>",
      "<h5>" => "<h5 class='h6'>"
    }

    description.gsub(/<h\d>/, headers)
  end

  def add_header_css_classes_experiment(description)
    headers = {
      "<h3>" => "<h3 class='text-intense h6'>"
    }

    description.gsub(/<h\d>/, headers)
  end
end
