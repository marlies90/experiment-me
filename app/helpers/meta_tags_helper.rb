# frozen_string_literal: true

module MetaTagsHelper
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
  end

  def meta_description
    if content_for?(:meta_description)
      content_for(:meta_description)
    else
      DEFAULT_META["meta_description"]
    end
  end

  def robots_content
    content_for(:robots)
  end
end
