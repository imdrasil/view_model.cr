require "../spec_helper"

describe ViewModel::Macros do
  comment = Comment.new
  describe "%form_tag_for" do
    it "renders form" do
      view("comments/show", comment).should match(/<form(.|\n)*<\/form>/)
    end
  end

  describe "%content_tag_for" do
    it "renders tag with nested content" do
      view("comments/index", comment).should match(/<span >.*<\/span>/)
    end
  end

  describe "%link_to_for" do
    it "renders tag with nested content" do
      view("comments/index", comment).should match(/<a href="\/all" >Text<\/a>/)
    end
  end

  describe "%label_tag_for" do
    it "renders tag with nested content" do
      view("comments/index", comment).should match(/<label >Me<\/label>/)
    end
  end

  describe "%select_tag_for" do
    it "renders tag with nested content" do
      view("comments/index", comment).should match(/<select ><option value="1">v1<\/option><option value="2">v2<\/option><\/select>/)
    end
  end

  describe "%text_area_for" do
    it "renders tag with nested content" do
      view("comments/index", comment).should match(/<text_area >some value<\/text_area>/)
    end
  end

  describe "%hidden_for" do
    it "renders tag with nested content" do
      view("comments/index", comment).should match(/<input type="hidden" value="hidden1" \/>/)
    end
  end
end
