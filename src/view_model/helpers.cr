require "./form_builder"

module ViewModel
  # Includes all UI helper methods like tag helpers, partial definition
  #
  # NOTE: if you would like to make several level of module inclusion you should include this module
  # in each module in a hierarchy.
  module Helpers
    include FormTags

    # Defines method for rendering partial.
    macro def_partial(name, *args)
    end

    private macro render_def_partial
      # :nodoc:
      macro def_partial(name, *args)
        \{%
          file_name = __FILE__.split("/")[-1].gsub(/_view\.cr$|\.cr$/, "").id
          path = __DIR__.id
          extension = (@type.constant("TEMPLATE_ENGINE") || ::ViewModel::Config.constant("TEMPLATE_ENGINE") || "slang").id
        %}

        private def \{{name.id}}(__kilt_io__\{% if args.size > 0 %}, \{{args.splat}} \{% end %})
          Kilt.embed "\{{path}}/\{{file_name}}/_\{{name.id}}.\{{extension}}"
        end

        def \{{name.id}}(\{{args.splat}})
          String.build do |io|
            \{{name.id}}(io\{% if args.size > 0 %}, \{{args.splat}} \{% end %})
          end
        end
      end
    end

    macro included
      macro inherited
        render_def_partial
      end

      render_def_partial
    end

    # Renders partial with name *name* and passes *args* to it.
    macro render_partial(name, *args)
      {{name.id}}(__kilt_io__, *{{args}})
    end

    macro link_to(path, text = nil, method = nil, html_options = {} of String => String, &block)
      {% if block.is_a?(Block) %}
        __link_to__(__kilt_io__, {{path}}, {{method}}) {{block}}
      {% else %}
        String.build { |io| __link_to__(io, {{path}}, {{text}}, {{method}}, {{html_options}}) }
      {% end %}
    end

    # Creates form builder and yield it to the block.
    #
    # This macro assumes that in a current context `__kilt_io__` local variable is defined and.
    macro build_form(name, url, method = :get, html_options = {} of String => String, &block)
      __build_form__(__kilt_io__, {{name}}, {{url}}, {{method}}, {{html_options}}) {{block}}
    end

    private def __link_to__(io, path : String, text : String? = nil, method : String | Symbol? = nil, html_options : Hash = {} of String => String)
      __link_to__(io, path, method, html_options) { io << HTML.escape(text) if text }
    end

    private def __link_to__(io : String::Builder, path : String, method : String | Symbol? = nil, html_options : Hash = {} of String => String, &block)
      html_options["href"] = path
      html_options["data-method"] = method.to_s if method
      content_tag(io, :a, html_options) { yield io }
    end

    private def __build_form__(io : String::Builder, name, url : String, method = :get, html_options : Hash = {} of String => String)
      builder = ::ViewModel.default_form_builder.new(io, name, url, method, html_options)
      builder.render { yield builder }
    end
  end
end
