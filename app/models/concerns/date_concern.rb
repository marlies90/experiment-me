module DateConcern
  extend ActiveSupport::Concern

  def date_slug
    date&.strftime("%e %b %y")
  end
end
