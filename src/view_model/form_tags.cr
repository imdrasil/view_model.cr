module ViewModel
  module FormTags
    INPUT_FIELDS = %i(hidden text submit file password checkbox radio time date number)

    alias SHash = Hash(String, String)

    #
    # String::Builder
    #

    def content_tag(io : String::Builder, tag, html_options = SHash.new)
      io << "<" << tag << " "
      html_options.each do |k, v|
        io << k << %(=") << HTML.escape(v.to_s) << %(" )
      end
      io << "/>"
      nil
    end

    def content_tag(io : String::Builder, tag, html_options = SHash.new, &block)
      io << "<" << tag << " "
      html_options.each do |k, v|
        io << k << %(=") << HTML.escape(v.to_s) << %(" )
      end
      io << ">"
      yield(io)
      io << "</" << tag << ">"
      nil
    end

    {% for tag in INPUT_FIELDS %}
      def {{tag.id}}_tag(io : String::Builder, name : String | Symbol, value = nil, options = SHash.new)
        _options = { "type" => "{{tag.id}}", "name" => name.to_s }
        _options["value"] = value.to_s if value && value != ""
        content_tag(io, :input, _options.merge!(options))
      end
    {% end %}

    def label_tag(io : String::Builder, text = nil, _for : Symbol | String? = nil, html_options = SHash.new)
      html_options["for"] = _for.to_s if _for
      content_tag(io, :label, html_options) { io << text if text }
    end

    def select_tag(io : String::Builder, name : String | Symbol, options : Array(Array), value = nil, html_options = SHash.new)
      content_tag(io, :select, html_options.merge({ "name" => name })) do
        options.each do |row|
          io << %(<option value=") << HTML.escape(row[0].to_s)
          if value && value == row[0]
            io << %(" selected>)
          else
            io << %(">)
          end
          io << HTML.escape(row[1].to_s) << "</option>"
        end
      end
    end

    def text_area_tag(io : String::Builder, name, text = "", html_options = {} of String => String)
      content_tag(io, :text_area, { "name" => name }.merge(html_options)) do
        io << HTML.escape(text)
      end
    end

    #
    # String
    #

    def content_tag(tag, html_options : Hash = {} of String => String, &block)
      String.build { |s| content_tag(s, tag, html_options) { |io| yield(io) } }
    end

    def content_tag(tag, html_options : Hash = {} of String => String)
      String.build { |s| content_tag(s, tag, html_options) }
    end

    {% for tag in INPUT_FIELDS %}
      def {{tag.id}}_tag(name : String | Symbol, value = nil, options = SHash.new)
        String.build { |io| {{tag.id}}_tag(io, name, value, options) }
      end
    {% end %}

    def label_tag(text = nil, _for : Symbol | String? = nil, html_options = {} of String => String)
      String.build { |s| label_tag(s, text, _for, html_options) }
    end

    def select_tag(name, options : Array(Array), value = nil, html_options = {} of String => String)
      String.build { |io| select_tag(io, name, options, value, html_options) }
    end

    def text_area_tag(name, text = "", html_options = {} of String => String)
      String.build { |io| text_area_tag(io, name, text, html_options) }
    end
  end
end
