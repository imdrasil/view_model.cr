# ViewModel [![Build Status](https://travis-ci.org/imdrasil/view_model.cr.svg)](https://travis-ci.org/imdrasil/view_model.cr)

ViewModel pattern implementation with simple and effective form builder.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  view_object:
    github: imdrasil/view_model.cr
```

It uses `kilt` for template rendering so you also need to add template engine you want to use and require it as well.

## Usage

### ViewModel

Putting page rendering into action class (like in kemalyst) could provide to creating fat helpers (like in rails) or putting a lot of view logic into itself or template. So much more suitable alternative will be have separate class which knows how to render corresponding object for some case (action or part of a page) and includes all representation logic.

To do that load ViewModel
```crystal
requrie "view_model"
require "kilt/slang" # or any other template engine supported by kilt
```

Adds `views` folder under your `src` where all classes and templates will be defined. Also root location could be customized:

```crystal
ViewModel::Config.view_path "spec/fixtures"
```

Here is example of folders structure:

```
src
├── views
│   ├── comment
│   │   ├── index.slang
│   │   ├── show.slang
│   ├── post
│   │   ├── index.slang
│   ├── comment_view.cr
│   ├── post_view.cr
```

All view models are named like `<model name>_view.cr`. Here is example of such classes:

```crystal
class CommentView < ViewModel::Base
  def_template index
  def_template show
end

class PostView < ViewModel::Base
  template_path "spec/fixtures"
  getter model : Post
  
  delegate some_method, to: model
  
  def_template index do
    template + "123"
  end
end
```

To create object of view-model you should pass object being rendered to constructor

```crystal
c = Comment.new
CommentView.new(c)
```
By default view-model will suppose that it will get object of class named same as it but without "View" part. This could be override adding to class definition direct declaration of `getter model : Post`. `model` - getter which give access to passed object. Also template location path for particular class could be redefined inside of it.

To declare actions that could be rendered use `def_template` macros which accepts name of action and optional block. Template for action will be loaded from file named after action located inside of the folder named after it at the same level.

Given block could access the rendered template via `template` local variable.

Render action of such view-model anywhere is easy - just add:
```crystal
c = Comment.new
view("comment", :index, c)
```

`view` macros accepts 3 arguments: view-model name (without view part), action and object to represent.

To render collection use

```crystal
 c = [Comment.new, Comment.new]
 collection_view(:comment, :index, c)
```

It will render each given object and concatenate all results.

### Html helpers

Also this shard provided html generating helper methods for some tags. They look like in the rails `action_view` but because of crystal template rendering mechanism works in slightly in another way.

There are two modules: 
- `Helers` - includes all methods to generate tags and form;
- `Macrosses` - includes macrosses to simplify calling helper methods with string builder inside of view (useful inside of templates.

All helper methods have 2 variant: using given string builder to append content and just returning string. First one are much more effective so prefer to use it.

Methods description:
- `form_tag` - yields `FormBuilder` to generate flexible forms; append `_method` hidden input if given method is not `get` or `post`
- `content_tag` - builds given tag; could accept block
- `link_to` - builds `a` tag
- `label_tag` - builds `label`
- `select_tag` - builds `select` tag; automatically generates `option` for given array
- `text_area_tag` - builds `text_are`
- `hidden_tag`
- `text_tag`
- `submit_tag`
- `file_tag`
- `password_tag`
- `checkbox_tag`
- `radio_tag`
- `time_tag`
- `date_tag`
- `number_tag`

All macrosses are named after correspond methods with adding `_for` at the end.

#### FormBuilder

To build form with automatically generated names and ids of elements:

```slim
- for_tag_for(:some_form, "/posts", :post) do |f|
    p here could be some other html
    div
        - f.text_field :name
    - f.select_field :tag, [[1, "crystal"], [2, "ruby"]], 1
    - f.submit "Save"
```

Because crystal loads template and build it inside of methods using `String::Builder` to generate content `-` should be used instead of `=` - content will be added to builder inside of method so there is no need to do it manually.

## Development

There are still a lot of work to do. Tasks for next versions:

- [ ] add spec2 matchers
- [ ] rewrite to use spec2
- [ ] add more html helpers
- [ ] add `multiple` support for select
- [ ] add array support in name generation
- [ ] add `button_to`

## Contributing

1. [Fork it]( https://github.com/imdrasil/view_model.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

Please ask me before starting work on smth.

Also if you want to use it in your application (for now shard is almost ready for use in production) - ping me please, my email you can find in my profile.

To run test use regular `crystal spec`. 

## Contributors

- [imdrasil](https://github.com/imdrasil) Roman Kalnytskyi - creator, maintainer
