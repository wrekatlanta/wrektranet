class ContestDecorator < ApplicationDecorator
  delegate_all
  #decorates_association :staff_tickets, with: StaffTicketDecorator

  def row_class
    fraction_class(
      object.listener_ticket_limit,
      object.listener_tickets.size
    )    
  end

  def listener_ticket_type
    object.listener_plus_one ? 'pair' : 'single'
  end

  def staff_ticket_type
    object.staff_plus_one ? 'pair' : 'single'
  end

  def listener_ticket_label
    label_class = fraction_class(
      object.listener_ticket_limit,
      object.listener_count
    )

    h.content_tag :span, class: "label label-#{label_class}" do
      "#{object.listener_tickets.size}/#{object.listener_ticket_limit}"
    end
  end

  def staff_ticket_label
    label_class = fraction_class(
      object.staff_ticket_limit,
      object.staff_count
    )

    h.content_tag :span, class: "label label-#{label_class}" do
      "#{object.staff_count}/#{object.staff_ticket_limit}"
    end
  end

  def sent_label
    label_class = object.sent ? 'danger' : 'success'
    h.content_tag :span, class: "label label-#{label_class}" do
      object.sent ? 'Yes' : 'No'
    end
  end

  private
    def fraction_class(limit, total=0)
      if total == 0
        'success'
      elsif total < limit
        'warning'
      else
        'danger'
      end
    end
end
