require "kilt"
require "./view_model/config"
require "./view_model/helpers"
require "./view_model/macros"
require "./view_model/form_builder"
require "./view_model/base"

module ViewModel
  VERSION = "0.1.0"
end

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
