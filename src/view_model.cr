require "kilt"
require "./view_model/config"
require "./view_model/helpers"
require "./view_model/form_builder"
require "./view_model/base"

module ViewModel
  VERSION = "0.2.0"

  class_property default_form_builder : ::ViewModel::FormBuilder.class = ::ViewModel::FormBuilder

  macro view(name, *arguments)
    {{name.id.split("/").map { |e| e.camelcase }.join("::").id}}View.new(*{{arguments}}).render
  end

  macro collection_view(name, collection)
    String.build do |s|
      {{collection}}.each do |col|
        s << view({{name}}, col)
      end
    end
  end
end
