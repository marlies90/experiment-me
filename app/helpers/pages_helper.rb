# frozen_string_literal: true

module PagesHelper
  def image_with_alt_tag(name)
    requested_image = Image.find_by(name: name)
    return unless requested_image&.image&.attached?

    image_tag(url_for(requested_image.image), alt: requested_image.alt)
  end
end
