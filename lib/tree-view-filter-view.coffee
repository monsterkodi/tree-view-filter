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
        @editor.element.className += ' filter-editor'
        @clear = @element.querySelector '.tree-view-filter-clear'
        @clear.style.display = 'none'
        @active = false
        
    show: ->
        e = @treeView?.treeView?.element
        if e? and @element.parentElement != e
            e.appendChild @element
            s = e.querySelector '.tree-view-scroller'
            s.style['padding-bottom'] = '20px'
        super
    
    hide: ->
        e = @treeView?.treeView?.element
        if e? and @element?.parentElement == e
            e.removeChild @element
            s = e.querySelector '.tree-view-scroller'
            s.style['padding-bottom'] = '0px'
        super

    activate: ->
        @active = true
        @show()

    deactivate: ->
        @active = false
        @hide()

    toggle: ->
        if @active
            @deactivate()
        else
            @activate()        
            
    focus:      -> @editor.focus()
    serialize:  -> { active: @active }
    getElement: -> @element

    destroy: -> 
        @hide()
        @element.remove()
