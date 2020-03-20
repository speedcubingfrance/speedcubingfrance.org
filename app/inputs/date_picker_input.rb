# frozen_string_literal: true

class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    set_html_options
    set_value_html_option
    datepicker_data = {
      provide: "datepicker",
      'date-language': I18n.locale.to_s,
      'date-format': "yyyy-mm-dd",
    }
    template.content_tag :div, class: 'input-group date', data: datepicker_data do
      # leave StringInput do the real rendering
      addon_icon + super(wrapper_options) + error_span
    end
  end

  def input_html_classes
    super.push '' # 'form-control'
  end

  private

  def addon_icon
    template.content_tag :div, class: 'input-group-prepend input-group-addon' do
      template.content_tag :span, class: 'input-group-text' do
        template.content_tag :i, '', class: 'fa fa-calendar'
      end
    end
  end

  def error_span
    template.content_tag :span, class: 'invalid-feedback' do
      error
    end
  end

  def set_html_options
    input_html_options[:type] = 'text'
    #input_html_options[:data] ||= {}
    #input_html_options[:data][:'date-language'] = I18n.locale.to_s
    #input_html_options[:data][:'date-format'] = "yyyy-mm-dd"
    # This enables datepicker
    #input_html_options[:data][:provide] = "datepicker"
  end

  def set_value_html_option
    return unless value.present?
    input_html_options[:value] ||= value.is_a?(String) ? value : I18n.localize(value, format: "%Y-%m-%d")
  end

  def value
    object.send(attribute_name) if object.respond_to? attribute_name
  end
end
