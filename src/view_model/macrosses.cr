module ViewModel
  module Macrosses
    macro form_tag_for(name, url, method = :get, html_options = {} of String => String, &block)
      form_tag(__kilt_io__, {{name}}, {{url}}, {{method}}, {{html_options}}) {{block}}
    end

    macro content_tag_for(tag, html_options = {} of String => String, &block)
      content_tag(__kilt_io__, {{tag}}, {{html_options}}) {% if !block.nil? %} {{block}} {% end %}
    end

    macro link_to_for(path, text, html_options = {} of String => String)
      link_to(__kilt_io__, {{path}}, {{text}}, {{html_options}})
    end

    macro label_tag_for(text, _for = nil, html_options = {} of String => String)
      label_tag(__kilt_io__, {{text}}, {{_for}}, {{html_options}})
    end

    macro select_tag_for(options, html_options = {} of String => String)
      select_tag(__kilt_io__, {{options}}, {{html_options}})
    end

    macro text_area_for(text = "", html_options = {} of String => String)
      text_area_tag(__kilt_io__, {{text}}, {{html_options}})
    end

    {% for tag in [:hidden, :text, :submit, :file, :password, :checkbox, :radio, :time, :date, :number] %}
      macro {{tag.id}}_tag_for(options = {} of String => String)
        {{tag.id}}_tag(__kilt_io__, \{{options}})
      end
    {% end %}
  end
end
