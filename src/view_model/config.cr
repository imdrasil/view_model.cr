module ViewModel
  class Config
    macro view_path(path)
      class ::ViewModel::Config
        DEFAULT_PATH = {{path}}
      end
    end

    macro view_path1
      {{@type.constant("VIEW_PATH") || "./src/views"}}
    end
  end
end
