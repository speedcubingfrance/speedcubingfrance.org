require 'active_support/concern'

module WcaModel
  extend ActiveSupport::Concern

  class_methods do
    def wca_create_or_update(wca_object, additional_attrs={})
      attributes, obj_id = get_attr(wca_object, true, additional_attrs)
      obj = find_or_initialize_by(id: obj_id)
      [obj.update(attributes), obj]
    end

    def wca_new(wca_object, additional_attrs={})
      attributes, _ = get_attr(wca_object, false, additional_attrs)
      new(attributes)
    end

    def get_attr(wca_object, require_id, additional_attrs={})
      wca_object = handle_camel_case(wca_object)
      obj_params = ActionController::Parameters.new(wca_object)
      accepted_params = class_variable_get(:@@obj_info) || {}
      obj_attr = obj_params.permit(accepted_params)
      obj_attr.merge!(additional_attrs)
      obj_id = require_id ? obj_params.require(:id) : nil
      [obj_attr, obj_id]
    end

    def handle_camel_case(json)
      attrs = class_variable_get(:@@obj_info) || {}
      camel_case_attr = attrs.map { |a| a.camelize(:lower) }
      camel_case_attr.each do |key|
        json[key.underscore] = json.delete(key) if json.include?(key)
      end
      json
    end
  end
end
