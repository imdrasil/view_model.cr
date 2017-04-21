require "./helpers"

module ViewModel
  struct FormBuilder
    include Helpers

    property io

    @name : String

    def initialize(@io : String::Builder, name)
      @name = name.to_s
    end

    def text_field(name, value = "", options = {} of String => String) : Void
      text_tag(@io, default_tag_options(name, value).merge(options))
    end

    def submit(value, options = {} of String => String)
      submit_tag(@io, default_tag_options(:commit, value).merge(options))
    end

    def hidden_field(name, value = "", options = {} of String => String) : Void
      hidden_tag(@io, default_tag_options(name, value).merge(options))
    end

    def select_field(name, opts, value = nil, options = {} of String => String)
      select_tag(@io, opts, default_tag_options(name, value).merge(options))
    end

    def label_for(name, text, options = {} of String => String)
      label_tag(@io, text, name, options)
    end

    def file_field(name, options = {} of String => String)
      file_tag(@io, default_tag_options(name, nil).merge(options))
    end

    def password_field(name, options = {} of String => String)
      password_tag(@io, default_tag_options(name, nil).merge(options))
    end

    def text_area(name, text = "", options = {} of String => String)
      text_area_tag(@io, HTML.escape(text).to_s, default_tag_options(name, nil).merge(options))
    end

    def checkbox_field(name, value = false, options = {} of String => String) : Void
      options["checked"] = "checked" if value
      checkbox_tag(@io, default_tag_options(name, value).merge(options))
    end

    def radio_field(name, value = false, options = {} of String => String)
      options["checked"] = "checked" if value
      radio_tag(@io, default_tag_options(name, value).merge(options))
    end

    def date_field(name, value = nil, options = {} of String => String)
      date_tag(@io, default_tag_options(name, value).merge(options))
    end

    def time_field(name, value = nil, options = {} of String => String)
      time_tag(@io, default_tag_options(name, value).merge(options))
    end

    def number_field(name, value = nil, options = {} of String => String)
      number_tag(@io, default_tag_options(name, value).merge(options))
    end

    def default_tag_options(field, value)
      hash = {"id" => "#{@name}_#{field}_id", "name" => "#{@name}[#{field}]"}
      hash["value"] = value.to_s unless value.nil?
      hash
    end
  end
end
