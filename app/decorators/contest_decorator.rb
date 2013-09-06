class ContestDecorator < ApplicationDecorator
  delegate_all

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
      object.listener_tickets.size
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
    label_class = object.sent ? 'success' : 'danger'
    h.content_tag :span, class: "label label-#{label_class}" do
      object.sent ? 'Yes' : 'No'
    end
  end

  private
    def fraction_class(amount, total=0)
      if amount == 0
        'success'
      elsif amount < total
        'warning'
      else
        'danger'
      end
    end
end
