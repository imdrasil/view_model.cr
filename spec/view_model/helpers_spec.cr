require "./../spec_helper"

class MockView
  include ViewModel::Helpers
end

describe ViewModel::Helpers do
  obj = MockView.new

  context "string methods" do
    {% for method in [:hidden, :text, :submit, :file, :password, :checkbox, :radio, :time, :date, :number] %}
      describe "#{{{method.stringify}}}_tag" do
        it "returns String" do
          obj.{{method.id}}_tag.should be_a(String)
        end

        it "generates correct field" do
          obj.{{method.id}}_tag.should match(/<input type="{{method.id}}"/)
        end
      end
    {% end %}
  end

  describe ".def_partial" do
    comment = Comment.new
    comments_show_body = "<div>Some Title</div>"

    context "without arguments" do
      it { Comments::ShowView.new(comment).body.should eq(comments_show_body) }
    end

    context "with arguments" do
      expected_content = "<div>\n  name\n</div>\n<div>\n  value\n</div>"
      it { Comments::ShowView.new(comment).with_arguments("name", "value").should eq(expected_content) }
    end

    context "with string builder" do
      it { Comments::ShowView.new(comment).body.should eq(comments_show_body) }
    end

    context "when inherited" do
      it { Comments::ShowView.new(comment).body.should eq(Comments::InheritedShowView.new(comment).body) }

      context "when overridden" do
        it { Comments::ShowView.new(comment).body.should_not eq(Comments::OverriddenPartialShowView.new(comment).body) }
        it { Comments::OverriddenPartialShowView.new(comment).body.should eq("<div>New Body</div>") }
      end
    end

    context "when included" do
      it { Comments::IndexView.new(comment).basic.should eq("<p>Shared Partial</p>") }
    end

    context "with nested inclusion" do
      it { Comments::ShowView.new(comment).basic.should eq("<p>Overridden partial</p>") }
    end
  end
end
