require "./../spec_helper"

class CustomFormBuilder < ViewModel::FormBuilder
  private def form_class
    "#{name}_form_class"
  end
end

class MockView
  include ViewModel::Helpers

  def __build_form(name, url, html_options = {} of String => String, method = :get)
    String.build do |__kilt_io__|
      build_form(name, url, html_options, method) { |f| yield f }
    end
  end

  def __link_to(path, text = nil, method = nil, html_options = {} of String => String)
    link_to(path, text, html_options, method)
  end

  def __link_to(path, method = nil, html_options = {} of String => String, &block)
    String.build do |__kilt_io__|
      link_to(path, method: method, html_options: html_options) { |io| yield io }
    end
  end
end

describe ViewModel::Helpers do
  obj = MockView.new

  {% for method in %i(hidden text submit file password checkbox radio time date number) %}
    describe "#{{{method.stringify}}}_tag" do
      it "returns String" do
        obj.{{method.id}}_tag(:field).should be_a(String)
      end

      it "generates correct field" do
        obj.{{method.id}}_tag(:field).should match(/<input type="{{method.id}}" name="field"/)
      end
    end
  {% end %}

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

  describe ".build_form" do
    it "builds form" do
      (obj.__build_form(:name, "/") {}).should eq("<form class=\"name-form\" id=\"name_form\" action=\"/\" method=\"get\" ></form>")
    end

    context "with custom form builder" do
      it do
        begin
          ViewModel.default_form_builder = CustomFormBuilder
          (obj.__build_form(:name, "/") {}).should eq("<form class=\"name_form_class\" id=\"name_form\" action=\"/\" method=\"get\" ></form>")
        ensure
          ViewModel.default_form_builder = ::ViewModel::FormBuilder
        end
      end
    end
  end

  describe ".link_to" do
    context "with block" do
      it do
        (obj.__link_to("/") { |io| io << "text" }).should eq("<a href=\"/\" >text</a>")
      end
    end

    context "with method" do
      it do
        obj.__link_to("/", "delete", :delete).should eq("<a href=\"/\" data-method=\"delete\" >delete</a>")
      end
    end
  end
end
