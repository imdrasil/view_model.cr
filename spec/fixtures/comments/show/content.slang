- build_form(:comment, "/comments", :put) do |f|
	p asd
	div
		- f.text_field :name
	div
		- f.hidden_field :age
	div
		- f.select_field :target, [[1, "op1"], ["asd", "op2"]], 1
	div
		- f.submit "Go"