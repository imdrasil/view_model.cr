class PostView < ViewModel::Base
  getter model : Post
  delegate some_method, to: model
  template_path "spec/fixtures"
  def_template index do
    template + "123"
  end
end
