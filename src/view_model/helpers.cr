require "./form_builder"

module ViewModel
  # Includes all UI helper methods like tag helpers, partial definition and rendering.
  #
  # NOTE: if you would like to make several level of module inclusion you should include this module
  # in each module in a hierarchy.
  module Helpers
    include FormTags

    # Defines method for rendering partial.
    #
    # ```
    # module Partials
    #   include ViewModel::Helpers
    #
    #   def_partial :without_argument
    #
    #   def_partial :with, argument
    # end
    # ```
    macro def_partial(name, *args)
    end

    private macro render_def_partial
      # :nodoc:
      macro def_partial(name, *args)
        \{%
          file_name = __FILE__.split("/")[-1].gsub(/_view\.cr$|\.cr$/, "").id
          extension = (@type.constant("TEMPLATE_ENGINE") || ::ViewModel::Config.constant("TEMPLATE_ENGINE") || "slang").id
        %}

        private def \{{name.id}}(__kilt_io__ : String::Builder\{% if args.size > 0 %}, \{{args.splat}} \{% end %})
          Kilt.embed "\{{__DIR__.id}}/\{{file_name}}/_\{{name.id}}.\{{extension}}"
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
      {{name.id}}(__kilt_io__{% if args.size > 0 %}, {{args.splat}} {% end %})
    end

    # Creates a link tag of the given *text* using URL given in the *path* argument.
    #
    # You can pass a block instead of *text*
    #
    # ```text
    # - link_to "/users/2", "First Last Name", { "class" => "btn btn-small" }
    #
    # - link_to "/users/2", "delete", method: :delete
    #
    # - link_to "/users/2" do
    #   span Open
    # ```
    #
    # *method* option allows to make a `DELETE` request. Also to achieve this you should include js script
    # located in the `assets` directory.
    macro link_to(path, text = "", html_options = {} of String => String, method = nil, io_variable = __kilt_io__, &block)
      {% if block.is_a?(Block) %}
        __link_to__({{io_variable}}, {{path}}, {{html_options}}, {{method}}) {{block}}
      {% else %}
        String.build { |io| __link_to__(io, {{path}}, {{text}}, {{html_options}}, {{method}}) }
      {% end %}
    end

    # Creates form builder and yields it to the block.
    #
    # It is important not to print macro invocation to the general builder.
    #
    # ```text
    # - build_form :session, { "class" => "form new-form" } do |f|
    #   p
    #     - f.label :email, "Email"
    #     - f.email_field :email
    #   p
    #     - f.label :password, "Password"
    #     - f.password_field :password
    # ```
    macro build_form(name, url, html_options = {} of String => String, method = :post, io_variable = __kilt_io__, &block)
      __build_form__({{io_variable}}, {{name}}, {{url}}, {{html_options}}, {{method}}) {{block}}
    end

    private def __link_to__(io : String::Builder, path : String, text : String = "", html_options : Hash = {} of String => String, method : String | Symbol? = nil)
      __link_to__(io, path, html_options, method) { io << HTML.escape(text) }
    end

    private def __link_to__(io : String::Builder, path : String, html_options : Hash = {} of String => String, method : String | Symbol? = nil, &block)
      html_options["href"] = path
      html_options["data-method"] = method.to_s if method
      content_tag(io, :a, html_options) { yield io }
    end

    private def __build_form__(io : String::Builder, name, url : String, html_options : Hash = {} of String => String, method = :post)
      builder = ::ViewModel.default_form_builder.new(io, name, url, method, html_options)
      builder.render { yield builder }
    end
  end
end
