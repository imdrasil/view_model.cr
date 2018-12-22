require "./../spec_helper"

describe ViewModel::Base do
  comment = Comment.new
  post = Post.new

  describe ".yield_content" do
    content = <<-HTML
    <html>
      <head>
        <title>Custom</title>
      </head>
      <body><p>Content</p>
      </body>
    </html>
    HTML
    it { PostWithLayoutView.new.render.should eq(content) }
  end

  describe ".layout" do
    it { PostWithLayoutView.new.render.should match(/<title>Custom/) }

    context "without layout" do
      it { PostWithoutLayoutView.new.render.should eq("<p>Content</p>") }
    end
  end

  describe ".template_engine" do
    pending "add"
  end

  describe ".model" do
    context "with specified model" do
      it { Comments::ShowView.new(comment) }
      it { Comments::ShowView.new(comment).comment.should eq(comment) }
    end

    context "without specified model" do
      it { PostWithLayoutView.new.responds_to?(:comment).should be_false }
      it { PostWithLayoutView.new }
    end
  end

  describe ".compile_template" do
    it "recompiles template" do
      Comments::OverriddenPartialShowView.new(comment).render.should eq("<p>Overridden content</p>")
    end
  end

  describe "#render" do
    describe "inherited" do
      it { Comments::InheritedShowView.new(comment).render.should eq(Comments::ShowView.new(comment).render) }
    end
  end
end
