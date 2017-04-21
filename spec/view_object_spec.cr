require "./spec_helper"

describe ViewModel do
  describe "%view" do
    it "renders view with given parameters" do
      c = Comment.new
      view("comment", :index, c).should match(/<div>some text<\/div>\n<h2>some title<\/h2>/)
    end
  end

  describe "%collection_view" do
    it "renders each view with given parameters" do
      c = [Comment.new, Comment.new]
      collection_view(:comment, :index, c).split(/<div>some text<\/div>\n<h2>some title<\/h2>/).size.should eq(3)
    end
  end
end
