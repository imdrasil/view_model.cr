macro finished
        \{% if @type.constant("TEMPLATE_PATH").nil? %}
          TEMPLATE_PATH = \{{__FILE__.stringify}}
        \{% end %}

        \{%file_name = __FILE__.split("/")[-1].split(".")[0] %}
        \{% files = system("ls #{__FILE__.split(".")[0]}").chomp %}
        \{% if !files.empty? %}
          \{% for file in files.split("\n") %}
            def \{{file.split(".")[0].id}}
              String.build do |s|
                Kilt.embed "spec/fixtures/\{{file_name.id}}/\{{file.id}}", s
              end
            end
          \{% end %}
        \{% end %}
      end
