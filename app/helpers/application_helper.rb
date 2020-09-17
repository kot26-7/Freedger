module ApplicationHelper
  def full_title(page_title = '')
    if page_title.present?
      "#{page_title} - #{Settings.base_title}"
    else
      Settings.base_title
    end
  end

  # deadline_alert index における class 判別メソッド
  def alert_define(deadline)
    if deadline.action == Settings.deadline_expired
      'deadline_expired'
    elsif deadline.action == Settings.deadline_warning
      'deadline_warning'
    elsif deadline.action == Settings.deadline_recommend
      'deadline_recommend'
    else
      'deadline_recommend'
    end
  end
end
