require "../spec_helper"

describe ViewModel::FormBuilder do
  klass = "my super text"
  value = "some value"

  context "#text_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).text_field(:text, value, {"class" => klass}) }
    it "renders id" do
      field.should match(/id="test_text_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("value=\"#{value}\""))
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders name" do
      field.should match(/name="test\[text\]"/)
    end

    it "renders tag" do
      field.should match(/<input type="text".*\/>/)
    end
  end

  context "#hidden_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).hidden_field(:hidden_field, value, {"class" => klass}) }
    it "renders id" do
      field.should match(/id="test_hidden_field_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("value=\"#{value}\""))
    end

    it "renders name" do
      field.should match(/name="test\[hidden_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="hidden".*\/>/)
    end
  end

  context "#submit" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).submit(value, {"class" => klass}) }
    it "renders id" do
      field.should match(/id="test_commit_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("value=\"#{value}\""))
    end

    it "renders name" do
      field.should match(/name="test\[commit\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="submit".*\/>/)
    end
  end

  context "#select_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).select_field(:select_field, [[1, "op1"], [2, "op2"]], 1, {"class" => klass}) }
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

  context "#label_for" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).label_for(:label_field, value, {"class" => klass}) }
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

  context "#file_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).file_field(:file_field, {"class" => klass}) }
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

  context "#password_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).password_field(:password_field, {"class" => klass}) }
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

  context "#text_area" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).text_area(:area_field, value, {"class" => klass}) }
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

  context "#checkbox_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).checkbox_field(:checkbox_field, true, {"class" => klass}) }
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

  context "#radio_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).radio_field(:radio_field, true, {"class" => klass}) }
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

  context "#date_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).date_field(:date_field, "10/10/10", {"class" => klass}) }
    it "renders id" do
      field.should match(/id="test_date_field_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("value=\"10/10/10\""))
    end

    it "renders name" do
      field.should match(/name="test\[date_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="date".*\/>/)
    end
  end

  context "#time_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).time_field(:time_field, "11:11", {"class" => klass}) }
    it "renders id" do
      field.should match(/id="test_time_field_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("value=\"11:11\""))
    end

    it "renders name" do
      field.should match(/name="test\[time_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="time".*\/>/)
    end
  end

  context "#number_field" do
    field = String.build { |s| ViewModel::FormBuilder.new(s, :test).number_field(:number_field, 2, {"class" => klass}) }
    it "renders id" do
      field.should match(/id="test_number_field_id"/)
    end

    it "renders value" do
      field.should match(Regex.new("value=\"#{2}\""))
    end

    it "renders name" do
      field.should match(/name="test\[number_field\]"/)
    end

    it "renders given html options" do
      field.should match(Regex.new("class=\"#{klass}\""))
    end

    it "renders tag" do
      field.should match(/<input type="number".*\/>/)
    end
  end
end
