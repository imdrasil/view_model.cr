/**
 * Allows delete links to post for security and ease of use similar to Rails jquery_ujs
 *
 * amber - v0.11.1 - 2018-11-07
 * https://github.com/amberframework/amber
 * Copyright (c) 2017-2018 Amber Team
*/
document.addEventListener("DOMContentLoaded", function () {
  var elements = document.querySelectorAll("a[data-method='delete']");
  var i;
  for (i = 0; i < elements.length; i++) {
    elements[i].addEventListener("click", function (e) {
      e.preventDefault();
      var message = e.target.getAttribute("data-confirm") || "Are you sure?";
      if (confirm(message)) {
        var form = document.createElement("form");
        var input = document.createElement("input");
        form.setAttribute("action", e.target.getAttribute("href"));
        form.setAttribute("method", "POST");
        input.setAttribute("type", "hidden");
        input.setAttribute("name", "_method");
        input.setAttribute("value", "DELETE");
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
      }
      return false;
    })
  }
});
