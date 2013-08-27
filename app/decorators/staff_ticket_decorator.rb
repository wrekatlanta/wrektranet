class StaffTicketDecorator < ApplicationDecorator
  delegate_all

  def status_label
    label_class = object.awarded ? 'success' : 'default'
    h.content_tag :span, class: "label label-#{label_class}" do
      object.awarded ? 'Received' : 'Pending'
    end
  end
end
