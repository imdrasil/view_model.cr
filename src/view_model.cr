require "kilt"
require "./view_model/config"
require "./view_model/helpers"
require "./view_model/macrosses"
require "./view_model/form_builder"
require "./view_model/base"

module ViewModel
end

macro view(name, method, *arguments)
  {{name.camelcase.id}}View.new(*{{arguments}}).{{method.id}}
end

macro collection_view(name, method, collection)
  String.build do |s|
    {{collection}}.each do |col|
      s << view({{name}}, {{method}}, col)
    end
  end
end
