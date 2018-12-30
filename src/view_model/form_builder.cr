require "./form_tags"

module ViewModel
  # Default form builder.
  #
  # All methods print data to *io* and return `nil` that's why it is not necessary to add their return value
  # to context `String::Builder`.
  #
  # Each field gets HTML classes based on it's name, type and form name.
  #
  # ```
  # - build_form :user do |f|
  #   - f.text_field :name # "vm-form-input vm-form-text user-name"
  # ```
  class FormBuilder
    include FormTags

    property io : String::Builder

    private getter name : String, url : String, method : String, options : Hash(String, String)

    def initialize(@io, name, @url, method, @options = {} of String => String)
      @method = method.to_s
      @name = name.to_s
    end

    # Renders form tag and yields itself to the block.
    def render
      content_tag(io, :form, form_options) do
        before_form_body
        yield self
      end
    end

    def text_field(name, value = "", options = {} of String => String) : Void
      build_field(name, :text, options) { |html_options| text_tag(@io, field_name(name), value, html_options) }
    end

    def submit(value, options = {} of String => String)
      build_field(:commit, :submit, options) { |tag_options| submit_tag(@io, :commit, value, tag_options) }
    end

    def hidden_field(name, value = "", options = {} of String => String) : Void
      build_field(name, :hidden, options) { |tag_options| hidden_tag(@io, field_name(name), value, tag_options) }
    end

    def select_field(name, opts, value = nil, options = {} of String => String)
      build_field(name, :select, options) { |tag_options| select_tag(@io, field_name(name), opts, value, tag_options) }
    end

    def label_for(name, text : String? = nil, options = {} of String => String)
      build_label(name, options) { label_tag(@io, label_text(name, text), name, options) }
    end

    def label_for(name, options = {} of String => String, &block)
      build_label(name, options) do
        label_tag(@io, name, options) { yield @io }
      end
    end

    def file_field(name, options = {} of String => String)
      build_field(name, :file, options) { |tag_options| file_tag(@io, field_name(name), nil, tag_options) }
    end

    def password_field(name, options = {} of String => String)
      build_field(name, :password, options) { |tag_options| password_tag(@io, field_name(name), nil, tag_options) }
    end

    def email_field(name, options = {} of String => String)
      build_field(name, :email, options) { |tag_options| email_tag(@io, field_name(name), nil, tag_options) }
    end

    def text_area_field(name, text = "", options = {} of String => String)
      build_field(name, :textarea, options) { |tag_options| text_area_tag(@io, field_name(name), text, tag_options) }
    end

    def checkbox_field(name, value = false, options = {} of String => String) : Void
      options["checked"] = "checked" if value
      build_field(name, :checkbox, options) { |tag_options| checkbox_tag(@io, field_name(name), nil, tag_options) }
    end

    def radio_field(name, value = false, options = {} of String => String)
      options["checked"] = "checked" if value
      build_field(name, :radio, options) { |tag_options| radio_tag(@io, field_name(name), nil, tag_options) }
    end

    def date_field(name, value = nil, options = {} of String => String)
      build_field(name, :date, options) { |tag_options| date_tag(@io, field_name(name), value, tag_options) }
    end

    def time_field(name, value = nil, options = {} of String => String)
      build_field(name, :time, options) { |tag_options| time_tag(@io, field_name(name), value, tag_options) }
    end

    def number_field(name, value = nil, options = {} of String => String)
      build_field(name, :number, options) { |tag_options| number_tag(@io, field_name(name), value, tag_options) }
    end

    private def label_text(_name, text)
      text
    end

    private def build_field(name, tag_name : Symbol, options, &block)
      yield tag_options(name, tag_name, options)
    end

    private def build_label(name, options, &block)
      yield options
    end

    private def tag_options(field, tag_name : Symbol, options : Hash)
      { "id" => field_id(field), "name" => field_name(field), "class" => field_class(name, tag_name) }.merge!(options)
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
      "#{name}-form"
    end

    private def form_id
      "#{name}_form"
    end

    private def field_id(field)
      "#{name}_#{field}_id"
    end

    private def field_class(name, tag_name : Symbol)
      "vm-form-input vm-form-#{tag_name} #{name}-#{name}"
    end

    private def field_name(field)
      "#{name}[#{field}]"
    end
  end
end
