require "./form_tags"

module ViewModel
  class FormBuilder
    include FormTags

    property io : String::Builder

    private getter name : String, url : String, method : String, options : Hash(String, String)

    def initialize(@io, name, @url, method, @options = {} of String => String)
      @method = method.to_s
      @name = name.to_s
    end

    def render
      content_tag(io, :form, form_options) do
        before_form_body
        yield self
      end
    end

    def text_field(name, value = "", options = {} of String => String) : Void
      build_field(name, options) { |html_options| text_tag(@io, field_name(name), value, html_options) }
    end

    def submit(value, options = {} of String => String)
      build_field(:commit, options) { submit_tag(@io, :commit, value, tag_options(:commit, options)) }
    end

    def hidden_field(name, value = "", options = {} of String => String) : Void
      build_field(name, options) { hidden_tag(@io, field_name(name), value, tag_options(name, options)) }
    end

    def select_field(name, opts, value = nil, options = {} of String => String)
      build_field(name, options) { select_tag(@io, field_name(name), opts, value, tag_options(name, options)) }
    end

    def label_for(name, text = nil, options = {} of String => String)
      build_field(name, options) { label_tag(@io, label_text(name, text), name, options) }
    end

    def file_field(name, options = {} of String => String)
      build_field(name, options) { file_tag(@io, field_name(name), nil, tag_options(name, options)) }
    end

    def password_field(name, options = {} of String => String)
      build_field(name, options) { password_tag(@io, field_name(name), nil, tag_options(name, options)) }
    end

    def text_area(name, text = "", options = {} of String => String)
      build_field(name, options) { text_area_tag(@io, field_name(name), text, tag_options(name, options)) }
    end

    def checkbox_field(name, value = false, options = {} of String => String) : Void
      options["checked"] = "checked" if value
      build_field(name, options) { checkbox_tag(@io, field_name(name), nil, tag_options(name, options)) }
    end

    def radio_field(name, value = false, options = {} of String => String)
      options["checked"] = "checked" if value
      build_field(name, options) { radio_tag(@io, field_name(name), nil, tag_options(name, options)) }
    end

    def date_field(name, value = nil, options = {} of String => String)
      build_field(name, options) { date_tag(@io, field_name(name), value, tag_options(name, options)) }
    end

    def time_field(name, value = nil, options = {} of String => String)
      build_field(name, options) { time_tag(@io, field_name(name), value, tag_options(name, options)) }
    end

    def number_field(name, value = nil, options = {} of String => String)
      build_field(name, options) { number_tag(@io, field_name(name), value, tag_options(name, options)) }
    end

    private def label_text(_name, text)
      text
    end

    private def build_field(name, options, &block)
      yield tag_options(name, options)
    end

    private def tag_options(field, options)
      { "id" => field_id(field), "name" => field_name(field), "class" => field_class(name) }.merge!(options)
    end

    private def form_options
      {
        "class" => form_class,
        "id" => form_id,
        "action" => url,
        "method" => form_method
      }.merge(options)
    end

    private def before_form_body
      return if browser_supported_method?
      hidden_tag(io, "_method", method)
    end

    private def browser_supported_method?
      method == "post" || method == "get"
    end

    private def form_method
      browser_supported_method? ? method : "post"
    end

    private def form_class
      form_id
    end

    private def form_id
      "#{name}_form"
    end

    private def field_id(name)
      "#{@name}_#{name}_id"
    end

    private def field_class(name)
      "#{@name}_#{name}"
    end

    private def field_name(name)
      "#{@name}[#{name}]"
    end
  end
end
