div some text
h2 some title
- content_tag_for(:span) do
	- link_to_for "/all", "Text"
- label_tag_for "Me"
- select_tag_for([[1, "v1"], [2, "v2"]])
- text_area_for("some value")
- hidden_tag_for({"value" => "hidden1"}) 