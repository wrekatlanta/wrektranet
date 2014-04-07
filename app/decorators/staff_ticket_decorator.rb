class StaffTicketDecorator < ApplicationDecorator
  delegate_all

  def status_label
    if object.awarded
      label_class = 'success'
      label_message = 'Received'
    elsif object.contest.sent || (object.contest.staff_ticket_limit == object.contest.staff_count)
      label_class = 'danger'
      label_message = 'Not received'
    else
      label_class = 'default'
      label_message = 'Pending'
    end

    h.content_tag :span, label_message, class: "label label-#{label_class}"
  end
end
