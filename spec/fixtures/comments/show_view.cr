require "./partials"

module Comments
  class ShowView < BaseView
    include Partials

    model comment : Comment

    def_partial body

    def_partial :with_arguments, name, value
  end
end
