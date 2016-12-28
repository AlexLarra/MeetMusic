module ApplicationHelper
  def clicable_icon_tag(button_klass, icon_klass, id = nil)
    content_tag(:button, class: 'btn '.concat(button_klass), id: id) do
      content_tag(:span, nil, class: icon_klass, 'aria-hidden': true)
    end
  end
end
