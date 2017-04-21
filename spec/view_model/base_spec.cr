require "./../spec_helper"

describe ViewModel::Base do
  comment = Comment.new
  post = Post.new
  describe "%def_template" do
    context "with block" do
      it "renders proper view" do
        PostView.new(post).index.should match(/<div>post index<\/div>123/)
      end
    end

    context "without block" do
      it "renders proper view" do
        CommentView.new(comment).index.should match(/<div>some text<\/div>\n<h2>some title<\/h2>/)
      end
    end
  end
end
