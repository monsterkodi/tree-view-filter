{View, TextEditorView} = require 'atom-space-pen-views'

###
000   000  000  00000000  000   000
000   000  000  000       000 0 000
 000 000   000  0000000   000000000
   000     000  000       000   000
    0      000  00000000  00     00
###

module.exports =
class TreeViewFilterView extends View
    
    @content: ->
        # console.log 'content'
        @div class: 'tree-view-filter block', =>
            @div class: 'tree-view-filter-container', =>
                @subview 'editor', new TextEditorView(mini: true, placeholderText: 'Filter Pattern')

    constructor: (treeView) ->

        console.log "TreeViewFilterView.constructor, calling super"
        super
        # console.log 'super returned, element: ', @element
        @treeView = treeView
        @

    focus: -> 
        console.log 'focus', @editor
        @editor.focus()
        
    show: -> 
        console.log 'show'
        if @treeView?.treeView?.element?
            @treeView.treeView.element.appendChild @element
        super
    
    hide: ->
        console.log 'hide'
        if @treeView?.treeView?.element?
            @treeView.treeView.element.removeChild @element
        super

    serialize: ->
        console.log("TreeViewFilterView.serialize")
        return { visible: @element.isVisible }

    destroy: ->
        @element.remove()
        console.log("TreeViewFilterView.destroy")

    getElement: ->
        @element
        
    
