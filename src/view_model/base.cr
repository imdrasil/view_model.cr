require "./helpers"

module ViewModel
  abstract class Base
    include Helpers

    private abstract def content(io)
    private abstract def layout(&block)

    def render
      layout { |io| content(io) }
    end

    # Inserts view content in a layout.
    #
    # ```text
    # html
    #   head
    #     title Page
    #   body
    #     - yield_content
    # ```
    macro yield_content
      yield(__kilt_io__)
    end

    # Specifies layout file path (without extension).
    #
    # Default is `"src/views/layouts/layout"`.
    macro layout(path)
      {% if path.is_a?(StringLiteral) %}
        # :nodoc:
        LAYOUT_PATH = {{path}}
        {% if @type.constant("COMPILED") == nil %}
          # :nodoc:
          COMPILED = true
        {% end %}
        compile_layout({{path}})
      {% else %}
        compile_layout({{path}})
      {% end %}
    end

    # Specifies template engine.
    #
    # Default template engine is slang.
    macro template_engine(engine)
      TEMPLATE_ENGINE = {{engine}}
    end

    macro model(*args)
      {% for definition in args %}
        getter {{definition}}
      {% end %}

      def initialize({{args.map { |var| "@#{var.var}".id }.splat}})
      end
    end

    macro inherited
      macro compile_layout(path)
        private def layout(&block)
          String.build do |__kilt_io__|
            \{% if path.is_a?(StringLiteral) %}
              \{% extension = (@type.constant("TEMPLATE_ENGINE") || ::ViewModel::Config.constant("TEMPLATE_ENGINE") || "slang").id %}
              Kilt.embed "\{{path.id}}.\{{extension}}"
            \{% else %}
              yield __kilt_io__
            \{% end %}
          end
        end
      end

      # :nodoc:
      macro compile_template
        \{%
          file_name = __FILE__.split("/")[-1].gsub(/(_view|)\.cr$/, "").id
          path = __DIR__.id
          extension = (@type.constant("TEMPLATE_ENGINE") || ::ViewModel::Config.constant("TEMPLATE_ENGINE") || "slang").id
          layout_path = (@type.constant("LAYOUT_PATH") || "src/views/layouts/layout").id
        %}

        # :nodoc:
        private def content(__kilt_io__)
          Kilt.embed "\{{path}}/\{{file_name}}/content.\{{extension}}"
          nil
        end

        \{% if @type.constant("VIEW_COMPILED") == nil %}
          # :nodoc:
          VIEW_COMPILED = true
        \{% end %}
      end

      macro finished
        \{% if @type.superclass.has_constant?("COMPILED") && !@type.has_constant?("COMPILED") %}
          # :nodoc:
          COMPILED = true
        \{% elsif @type.constant("COMPILED") == nil %}
          # :nodoc:
          COMPILED = true
          compile_layout("src/views/layouts/layout")
        \{% end %}

        \{% view_compiled = @type.superclass.constant("VIEW_COMPILED") %}
        \{% if @type.has_constant?("VIEW_COMPILED") %}
        \{% elsif view_compiled || @type.abstract? %}
          # :nodoc:
          VIEW_COMPILED = \{{view_compiled}}
        \{% else %}
          compile_template
        \{% end %}
      end
    end
  end
end
