module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def clicable_icon_tag(button_klass, icon_klass)
    content_tag(:button, class: 'btn '.concat(button_klass)) do
      content_tag(:span, nil, class: icon_klass, 'aria-hidden': true)
    end
  end
end
