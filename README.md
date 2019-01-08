# ViewModel [![Build Status](https://travis-ci.org/imdrasil/view_model.cr.svg)](https://travis-ci.org/imdrasil/view_model.cr)

ViewModel pattern implementation with simple and effective form builder and view helpers.

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

Putting page rendering into action class ends with having fat helpers (like in rails) or putting a lot of view logic inside of templates. Also lack of native reusability in kilt makes you to define local variables with right name to be able to reuse them in a partials. Therefor much more suitable alternative is to have a separate class which encapsulates specific logic for a corresponding view. For such purpose this shard is created.

To do that load ViewModel

```crystal
require "view_model"
require "kilt/slang" # or any other template engine supported by kilt
```

Create a base view class:

```crystal
class ApplicationView < ViewModel::Base
end
```

By default layout path is `"src/views/layouts/layout.slang"` but this can be easily redefined by `.layout` macro:

```crystal
class ApplicationView < ViewModel::Base
  layout "app/views/layouts/layout"
end
```

> Pay special attention - layout path doesn't include file extension.

If you'd like to render your view without a layout - pass `false` as an argument.

Next define specified layout:

```slang
html
  head
    title Page title
  body
    - yield_content
```

`yield_content` macro is just a alias for `yield(__kilt_io__)` - it yields `IO` to view `#content` method which renders content.

Now we can specify a view class.

```crystal
# src/views/posts/show_view.cr
module Posts
  class ShowView < ViewModel::Base
    model post : Post

    delegate :title, :content, to: post
  end
end
```

`.model` macro creates getter for given attributes and generates constructor accepting them.

Content for a post object:

```slang
.header
  h3 = title
.content
  = content
```

By a convention this template file should be located in `<view_class_folder>/<view_class_name_without_view/content.slang>`, in our case it will be `src/views/posts/show/content.slang`.

For a view rendering `.view` macro can be used - just pass view name and required arguments:

```crystal
view("posts/show", post)
# or for a collection
collection_view("posts/show", posts)
```

### Partials

If you would like to define some shared templates or separate your view into several partials use `.def_partial` macro:

```crystal
module SharedPartials
  include ViewModel::Helpers

  def_partial button, color
end

module Posts
  class ShowView < ApplicationView
    include SharedPartials

    def_partial body
  end
end
```

If you need to define a module with partials - include `ViewModel::Helpers` module into it. `.def_partial` accepts partial name as a first argument and partial arguments as all others. All partial template paths are calculated same was as for content files of view objects. The only difference is that partial files name has a `_` symbol prefix: `src/views/shared_partials/_button.slang`.

To render a partial use `.render_partial` macro:

```slang
.buttons
  - render_partial :button, :read
```

### Html helpers

Also this shard provides HTML helper methods. All methods are automatically included in `ViewModel::Base`.

Methods description:

- `content_tag` - builds given tag with given options; could accept block for nested content
- `link_to` - builds link
- `label_tag` - builds `label`
- `select_tag` - builds `select` tag; automatically generates `option` tags for given array
- `text_area_tag`
- `hidden_tag`
- `text_tag`
- `submit_tag`
- `file_tag`
- `password_tag`
- `email_tag`
- `checkbox_tag`
- `radio_tag`
- `time_tag`
- `date_tag`
- `number_tag`

#### FormBuilder

To build form with automatically generated names and ids of inputs :

```slang
- build_form(:some_form, "/posts", :post) do |f|
    p here could be some other html
    div
      - f.text_field :name
    - f.select_field :tag, [[1, "crystal"], [2, "ruby"]], 1
    - f.submit "Save"
```

`.build_form` macro creates `ViewModel::FormBuilder` and passes it to the block. Form builder provides a set of methods similar to ones described above. All inputs will get own id and class based on it's name.

All form builder methods manipulate `__kilt_io__` directly and returns `nil` so it isn't important the way to call them: with `-`, `=` or `==`.

If you specify a form method different from `get` and `post` - form builder will add additional hidden input with name `_method` for the given method and set current form method to `post`.

### link_to

Also HTML helper includes `.link_to` macro. It allows to generate `<a>` tag with all needed data.

```slang
== link_to "Show", "/posts/23", { "class" => "special-link" }

== link_to "/order/12" do
  span
    b Open
```

If you want to make a link to do a non-GET request (e.g. delete button), you can specify `method` argument and additionally load `libs/view_model/assets/view_model.js` file.

```slang
== link_to "delete", "/comments/56", :delete
```

## Development

There are still a lot of work to do. Tasks for next versions:

- [ ] add spec matchers
- [ ] add more html helpers
- [ ] add array support in name generation

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
