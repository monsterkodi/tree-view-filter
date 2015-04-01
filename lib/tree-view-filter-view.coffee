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

        @div class: 'tree-view-filter block', =>
            @div class: 'tree-view-filter-container', =>
                @subview 'editor', new TextEditorView(mini: true, placeholderText: 'Filter Pattern')
            @div class: 'tree-view-filter-clear', =>
                @div class: 'tree-view-filter-clear-icon'

    constructor: (treeView) ->
        @treeView = treeView
        super
        @clear = @element.querySelector '.tree-view-filter-clear'
        @clear.style.display = 'none'

    focus: -> @editor.focus()
        
    show: -> 
        if @treeView?.treeView?.element?
            @treeView.treeView.element.appendChild @element
        super
    
    hide: ->
        if @treeView?.treeView?.element?
            @treeView.treeView.element.removeChild @element
        super

    serialize:  -> { visible: @isVisible() }
    getElement: -> @element

    destroy: -> @element.remove()
