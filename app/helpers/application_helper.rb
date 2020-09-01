module ApplicationHelper
  def full_title(page_title = '')
    if page_title.present?
      "#{page_title} - #{Settings.base_title}"
    else
      Settings.base_title
    end
  end
end
