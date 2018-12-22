class PostView < BaseView
  model post : Post

  delegate some_method, to: model

  def model
    post
  end
end
