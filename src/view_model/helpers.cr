module ViewModel
  struct FormBuilder
  end

  module Helpers
    INPUT_FIELDS = [:hidden, :text, :submit, :file, :password, :checkbox, :radio, :time, :date, :number]

    #
    # String::Builder
    #

    def form_tag(io : String::Builder, name, url, method = :get, html_options = {} of String => String, &block)
      builder = FormBuilder.new(io, name)

      html_options["action"] = url
      simple = (method == :get || method == :post)
      html_options["action"] = simple ? method.to_s : "post"
      content_tag(io, :form, html_options) do
        unless simple
          hidden_tag(io, {"name" => "_method", "value" => method.to_s})
        end
        yield(builder)
      end
    end

    def content_tag(io : String::Builder, tag, html_options = {} of String => String)
      io << "<" << tag << " "
      html_options.each do |k, v|
        io << k << %(=") << v << %(" )
      end
      io << "/>"
    end

    def content_tag(io : String::Builder, tag, html_options = {} of String => String, &block)
      io << "<" << tag << " "
      html_options.each do |k, v|
        io << k << %(=") << v << %(" )
      end
      io << ">"
      yield(io)
      io << "</" << tag << ">"
    end

    def link_to(io : String::Builder, path, text = nil, html_options = {} of String => String)
      html_options["href"] = path
      content_tag(io, :a, html_options) { io << text if text }
    end

    {% for tag in INPUT_FIELDS %}
      def {{tag.id}}_tag(io : String::Builder, options = {} of String => String)
        content_tag(io, :input, {"type" => "{{tag.id}}"}.merge(options))
      end
    {% end %}

    def label_tag(io : String::Builder, text = nil, _for : Symbol | String? = nil, html_options = {} of String => String)
      html_options["for"] = _for.to_s if _for
      content_tag(io, :label, html_options) { io << text if text }
    end

    def select_tag(io : String::Builder, options : Array(Array), html_options = {} of String => String)
      selected = html_options.delete("value")
      content_tag(io, :select, html_options) do
        options.each do |row|
          io << %(<option value=") << row[0]
          if selected && selected == row[0].to_s
            io << %(" selected>)
          else
            io << %(">)
          end
          io << row[1] << "</option>"
        end
      end
    end

    def text_area_tag(io : String::Builder, text = "", html_options = {} of String => String)
      content_tag(io, :text_area, html_options) do
        io << text
      end
    end

    #
    # String
    #

    def form_tag(name, url, method = :get, html_options = {} of String => String, &block)
      String.build do |io|
        builder = FormBuilder.new(io, name)

        io << %(<form action=") << url << %(" )
        html_options.each do |k, v|
          io << k << %(=") << v << %(" )
        end

        simple = (method == :get || method == :post)
        io << %( method=")
        if simple
          io << method << %(" )
        else
          io << %(post")
        end

        io << ">"
        unless simple
          hidden_tag(io, {"name" => "_method", "value" => method.to_s})
        end

        yield(builder)
        io << "</form>"
      end
    end

    def content_tag(tag, html_options : Hash, &block)
      String.build { |s| content_tag(s, tag, html_options) { |io| yield(io) } }
    end

    def content_tag(tag, html_options : Hash)
      String.build { |s| content_tag(s, tag, html_options) }
    end

    def link_to(path, text = nil, html_options = {} of String => String)
      html_options["href"] = path
      content_tag(:a, html_options) { |io| io << text if text }
    end

    {% for tag in INPUT_FIELDS %}
      def {{tag.id}}_tag(options = {} of String => String)
        content_tag(:input, {"type" => "{{tag.id}}"}.merge(options))
      end
    {% end %}

    def label_tag(text = nil, _for : Symbol | String? = nil, html_options = {} of String => String)
      String.build { |s| label_tag(s, text, _for, html_options) }
    end

    def select_tag(options : Array(Array), html_options = {} of String => String)
      selected = html_options.delete("value")
      content_tag(io, :select, html_options) do
        options.each do |row|
          io << %(<option value=") << row[0]
          io << " selected" if selected && selected == row[0].to_s
          io << %(">) << row[1] << "</option>"
        end
      end
    end

    def text_area_tag(text, html_options = {} of String => String)
      content_tag(io, :text_area, html_options) do
        io << text
      end
    end
  end
end