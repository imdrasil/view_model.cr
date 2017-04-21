require "./helpers"

module ViewModel
  class Base
    include Helpers
    include Macrosses

    macro template_path(path)
      TEMPLATE_FOLDER = {{path}}
    end

    macro inherited
      {% if !@type.methods.includes?("model") %}
        \{{("getter model : " + @type.stringify.gsub(/View$/, "")).id}}
      {% end %}

      macro finished
        def initialize(@model)
        end
      end

      macro def_template(name, &block)
        \{%file_name = __FILE__.split("/")[-1].gsub(/_view\.cr/, "") %}
        def \{{name.id}}
          template = String.build do |__kilt_io__|
            Kilt.embed "\{{(@type.constant("TEMPLATE_FOLDER") || ::ViewModel::Config.constant("DEFAULT_PATH") || "src/views").id}}/\{{file_name.id}}/\{{name.id}}.slang"
          end
          \{% if block.is_a?(Block) %}
            \{{block.body}}
          \{% end %}
        end
      end
    end
  end
end
