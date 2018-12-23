require "../spec_helper"

def build_form(io, name = :test, url = "/", method = :post)
  ViewModel::FormBuilder.new(io, name, url, method)
end

def build_form(name = :test, url = "/", method = :post, &block)
  String.build { |io| yield build_form(io, name, url, method) }
end

macro behaves_like_form_input(name, value, type, form_name = test)
  it "renders id" do
    field.should match(/id="{{form_name.id}}_{{name.id}}_id"/)
  end

  it "renders value" do
    field.should match(Regex.new("value=\"#{ {{value}} }\""))
  end

  it "renders name" do
    field.should match(/name="{{form_name.id}}\[{{name.id}}\]"/)
  end

  it "renders tag" do
    field.should match(/<input type="{{type.id}}".*\/>/)
  end
end

describe ViewModel::FormBuilder do
  klass = "my super text"
  value = "some value"

  describe "#render" do
    it "wraps content into form tag" do
      build_form { |f| f.render { } }.should match(/<form.*><\/form>/)
    end

    it "adds generated class" do
      build_form { |f| f.render { } }.should match(/class="test_form"/)
    end

    it "adds generated id" do
      build_form { |f| f.render { } }.should match(/id="test_form"/)
    end

    it "adds additional hidden tag if form method is not natively supported by browser" do
      build_form(method: :delete) { |f| f.render { } }.should match(/<input type="hidden" name="_method" value="delete"/)
    end
  end

  describe "#text_field" do
    field = String.build { |s| build_form(s).text_field(:text, value, {"class" => klass}) }

    behaves_like_form_input(:text, value, :text)

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end
  end

  describe "#hidden_field" do
    field = String.build { |s| build_form(s).hidden_field(:hidden_field, value, {"class" => klass}) }

    behaves_like_form_input(:hidden_field, value, :hidden)

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end
  end

  describe "#submit" do
    field = String.build { |s| build_form(s).submit(value, {"class" => klass}) }

    behaves_like_form_input(:commit, value, :submit)

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end
  end

  describe "#select_field" do
    field = String.build { |s| build_form(s).select_field(:select_field, [[1, "op1"], [2, "op2"]], 1, {"class" => klass}) }

    it "renders id" do
      field.should match(/id="test_select_field_id"/)
    end

    it "renders value" do
      field.should match(/<option value="1" selected/)
    end

    it "renders name" do
      field.should match(/name="test\[select_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<select.*\>/)
    end

    it "renders options" do
      field.split("option").size.should eq(5)
    end
  end

  describe "#label_for" do
    field = String.build { |s| build_form(s).label_for(:label_field, value, {"class" => klass}) }

    it "renders for" do
      field.should match(/for="label_field"/)
    end

    it "renders text" do
      field.should match(Regex.new(">#{value}<"))
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<label.*>/)
    end
  end

  describe "#file_field" do
    field = String.build { |s| build_form(s).file_field(:file_field, {"class" => klass}) }

    it "renders id" do
      field.should match(/id="test_file_field_id"/)
    end

    it "renders name" do
      field.should match(/name="test\[file_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="file".*\/>/)
    end
  end

  describe "#password_field" do
    field = String.build { |s| build_form(s).password_field(:password_field, {"class" => klass}) }

    it "renders id" do
      field.should match(/id="test_password_field_id"/)
    end

    it "renders name" do
      field.should match(/name="test\[password_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="password".*\/>/)
    end
  end

  describe "#text_area" do
    field = String.build { |s| build_form(s).text_area(:area_field, value, {"class" => klass}) }

    it "renders id" do
      field.should match(/id="test_area_field_id"/)
    end

    it "renders value" do
      field.should match(Regex.new(">#{value}<"))
    end

    it "renders name" do
      field.should match(/name="test\[area_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<text_area.*>/)
    end
  end

  describe "#checkbox_field" do
    field = String.build { |s| build_form(s).checkbox_field(:checkbox_field, true, {"class" => klass}) }

    it "renders id" do
      field.should match(/id="test_checkbox_field_id"/)
    end

    it "renders value" do
      field.should match(/checked="checked"/)
    end

    it "renders name" do
      field.should match(/name="test\[checkbox_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="checkbox".*\/>/)
    end
  end

  describe "#radio_field" do
    field = String.build { |s| build_form(s).radio_field(:radio_field, true, {"class" => klass}) }

    it "renders id" do
      field.should match(/id="test_radio_field_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("checked=\"checked\""))
    end

    it "renders name" do
      field.should match(/name="test\[radio_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="radio".*\/>/)
    end
  end

  describe "#date_field" do
    field = String.build { |s| build_form(s).date_field(:date_field, "10/10/10", {"class" => klass}) }

    behaves_like_form_input(:date_field, "10/10/10", :date)

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end
  end

  describe "#time_field" do
    field = String.build { |s| build_form(s).time_field(:time_field, "11:11", {"class" => klass}) }

    behaves_like_form_input(:time_field, "11:11", :time)

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end
  end

  describe "#number_field" do
    field = String.build { |s| build_form(s).number_field(:number_field, 2, {"class" => klass}) }

    behaves_like_form_input(:number_field, 2, :number)

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end
  end
end
