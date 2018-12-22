require "./show_view"

module Comments
  class OverriddenPartialShowView < ShowView
    compile_template

    def_partial body
  end
end
