module ApplicationHelper
  def login_helper
    if current_user.present?
      content_tag(:li, link_to("Dashboard", dashboard_overview_path, class: "nav-link"), class: "nav-item") +
      content_tag(:li, link_to("Log out", destroy_user_session_path, class: "nav-link"), class: "nav-item")
    else
      content_tag(:li, link_to("Register", new_user_registration_path, class: "nav-link"), class: "nav-item") +
      content_tag(:li, link_to("Log in", new_user_session_path, class: "nav-link"), class: "nav-item")
    end
  end
end
