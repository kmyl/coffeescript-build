CoffeescriptBuild = require '../lib/coffeescript-build'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CoffeescriptBuild", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('coffeescriptBuild')

  describe "when the coffeescript-build:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.coffeescript-build')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'coffeescript-build:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.coffeescript-build')).toExist()
        atom.workspaceView.trigger 'coffeescript-build:toggle'
        expect(atom.workspaceView.find('.coffeescript-build')).not.toExist()
