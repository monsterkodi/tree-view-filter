{View} = require 'atom-space-pen-views'

module.exports =
class TreeViewFilterView extends View
    
    @content: ->
        console.log 'content'
        @div class: 'tree-view-filter block', =>
            @div class: 'tree-view-filter-container', =>
                @subview 'treeViewFilterEditor', new TextEditorView(mini: true, placeholderText: 'Filter Pattern')
        
    # constructor: (state, treeView) ->
    constructor: (treeView) ->

        console.log "TreeViewFilterView.constructor, calling super"
        super
        console.log 'super returned'
        console.log 'element', @element
        if treeView.treeView?.element?
            treeView.treeView.element.appendChild @element

    serialize: ->
        console.log("TreeViewFilterView.serialize")
        return { visible: @element.isVisible }

    destroy: ->
        @element.remove()
        console.log("TreeViewFilterView.destroy")

    getElement: ->
        @element
        
    
