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
            @div class: 'tree-view-filter-container tool-panel panel-bottom', =>
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
        e = @treeView?.treeView?.element
        if e? and @element.parentElement != e
            e.appendChild @element
            s = e.querySelector '.tree-view-scroller'
            s.style['padding-bottom'] = '20px'
        super
    
    hide: ->
        e = @treeView?.treeView?.element
        if e?
            e.removeChild @element
            s = e.querySelector '.tree-view-scroller'
            s.style['padding-bottom'] = '0px'
            s.removeChild @placeholder
        super

    serialize:  -> { visible: @isVisible() }
    getElement: -> @element

    destroy: -> 
        @hide()
        @element.remove()
