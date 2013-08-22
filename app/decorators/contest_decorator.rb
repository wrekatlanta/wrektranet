class ContestDecorator < ApplicationDecorator
  delegate :current_page, :per_page, :offset, :total_pages, :name, :date, :venue

  def listener_ticket_label
    label_class = fraction_label_class(
      object.listener_ticket_limit,
      object.listener_tickets.size
    )

    h.content_tag :span, class: "label #{label_class}" do
      "#{object.listener_tickets.size}/#{object.listener_ticket_limit}"
    end
  end

  def staff_ticket_label
    label_class = fraction_label_class(
      object.staff_ticket_limit,
      object.staff_tickets.size
    )

    h.content_tag :span, class: "label #{label_class}" do
      "#{object.staff_tickets.size}/#{object.staff_ticket_limit}"
    end
  end

  def sent_label
    label_class = object.sent ? 'label-danger' : 'label-success'
    h.content_tag :span, class: "label #{label_class}" do
      object.sent ? 'Yes' : 'No'
    end
  end

  private
    def fraction_label_class(amount, total)
      if amount == 0
        'label-success'
      elsif amount < total
        'label-warning'
      else
        'label-danger'
      end
    end
end
