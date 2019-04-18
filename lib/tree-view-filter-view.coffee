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
        @element.style.marginBottom = '0'
        @editor.element.className += ' filter-editor'
        @clear = @element.querySelector '.tree-view-filter-clear'
        @clear.style.display = 'none'
        @active = false
        @observer = null
        
    show: ->
        
        e = @treeView?.treeView?.element?.parentNode?.parentNode
        
        if e? and @element.parentElement != e
            e.appendChild @element
            
        if not @observer?
            @observer = new MutationObserver @onTreeChanged
            @observer.observe @treeView?.treeView?.element, childList:true, subtree:true, attributes:true
            
        if not @upDownCommands?
            console.log 'commands'
            @upDownCommands = atom.commands.add @treeView?.treeView?.element,
                'core:move-down':      => @lastDirection = 'down'
                'core:page-down':      => @lastDirection = 'down'
                'core:move-up':        => @lastDirection = 'up'
                'core:page-up':        => @lastDirection = 'up'
                'core:move-to-bottom': => @lastDirection = 'up'
        super
    
    hide: ->
        
        e = @treeView?.treeView?.element?.parentNode?.parentNode
        
        if e? and @element?.parentElement == e
            e.removeChild @element
            
        if @observer?
            @observer.disconnect()
            delete @observer
            
        if @upDownCommands?
            @upDownCommands.dispose()
            delete @upDownCommands
            
        super
        
    onTreeChanged: (mutations) =>
        
        for mutation in mutations  # re-filter list
            if mutation.addedNodes.length   
                TreeViewFilter = require './tree-view-filter'
                TreeViewFilter.editorConfirmed()
                return
                
        for mutation in mutations  # jump over hidden items
            if mutation.target.className.endsWith 'selected'
                if mutation.target.style.display == 'none' 
                    treeViewElement = @treeView?.treeView?.element
                    atom.commands.dispatch @treeView?.treeView?.element, @lastDirection == 'down' and 'core:move-down' or 'core:move-up'
                    return

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
