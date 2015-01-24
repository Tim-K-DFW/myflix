class CustomFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {}, &block)
    errors = object.errors[method.to_sym]
    text += ' <span class=\"error\">#{errors.first}</span>' if errors
    super(method, text.html_safe, options, &block)
  end
end