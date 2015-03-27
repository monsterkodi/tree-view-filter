TreeViewFilter = require '../lib/tree-view-filter'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.

describe "TreeViewFilter", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement  = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('tree-view-filter')

  describe "when the tree-view-filter:toggle event is triggered", ->
      
    it "hides and shows the tree view filter editor", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.tree-view-filter')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'tree-view-filter:showAndFocus'

      waitsForPromise ->
          activationPromise

      runs ->
        expect(workspaceElement.querySelector('.tree-view-filter')).toExist()

        expect(atom.workspace.getActiveTextEditor).toExist()

        atom.commands.dispatch workspaceElement, 'tree-view-filter:toggle'

        expect(workspaceElement.querySelector('.tree-view-filter')).not.toExist()

    # it "hides and shows the view", ->
    #   # This test shows you an integration test testing at the view level.
    # 
    #   # Attaching the workspaceElement to the DOM is required to allow the
    #   # `toBeVisible()` matchers to work. Anything testing visibility or focus
    #   # requires that the workspaceElement is on the DOM. Tests that attach the
    #   # workspaceElement to the DOM are generally slower than those off DOM.
    #   jasmine.attachToDOM(workspaceElement)
    # 
    #   expect(workspaceElement.querySelector('.tree-view-filter')).not.toExist()
    # 
    #   # This is an activation event, triggering it causes the package to be
    #   # activated.
    #   atom.commands.dispatch workspaceElement, 'tree-view-filter:toggle'
    # 
    #   waitsForPromise ->
    #     activationPromise
    # 
    #   runs ->
    #     # Now we can test for view visibility
    #     treeViewFilterElement = workspaceElement.querySelector('.tree-view-filter')
    #     expect(treeViewFilterElement).toBeVisible()
    #     atom.commands.dispatch workspaceElement, 'tree-view-filter:toggle'
    #     expect(treeViewFilterElement).not.toBeVisible()
