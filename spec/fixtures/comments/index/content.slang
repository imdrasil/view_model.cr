div some text
h2 some title
== content_tag(:span) do
	== link_to "/all", "Text"
== label_tag "Me"
== select_tag(:dropdown, [[1, "v1"], [2, "v2"]])
== text_area_tag(:text, "some value")
== hidden_tag(:hidden_field, "hidden1")
