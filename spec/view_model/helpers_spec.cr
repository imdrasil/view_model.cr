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
end
