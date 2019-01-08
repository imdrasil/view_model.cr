module Comments
  class IndexView < BaseView
    include SharedPartials

    model comment : Comment
  end
end
