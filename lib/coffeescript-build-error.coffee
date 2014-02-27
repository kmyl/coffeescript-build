{View} = require 'atom'

module.exports =
class CoffeescriptBuildErrorView extends View
  @content: (params) ->
    @div class: 'coffeescript-build overlay from-top', =>
      @div class: "message", =>
        @h1 "Error!"
        @div =>
          @p params.text, class: "filename"
