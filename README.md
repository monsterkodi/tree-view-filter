# tree-view-filter package

Filters the Atom tree-view to only display files that match certain pattern(s).

![screencast](https://raw.githubusercontent.com/monsterkodi/tree-view-filter/master/screencast.gif)

## usage

Press `alt-cmd-shift-f` or invoke `Tree View Filter:Show` to focus the filter pattern editor, 
enter your pattern and press Enter/Return to confirm.

Clear the pattern editor and press Enter/Return to restore the tree-view to it's unfiltered state.

## known issues

* The filter only sets the display style of the file entries to 'none'. 
When navigating the tree-view with the keyboard, the invisible items still get focus.

## todo

* simple (X) button to clear filter
* nicer style (blend in with status bar)
* update filter when directory is expanded
* get esc/cancel to work
* remember state

## credits

* screencast generated with [dergachev/screengif](https://github.com/dergachev/screengif)
* file pattern matching by [minimatch](https://www.npmjs.com/package/minimatch)

and the usual suspects

* almost as good as coffee: [coffeescript](http://coffeescript.org/)
* a truly hackable editor: [atom](https://atom.io/)
* grunt, grunt, [grunt](http://gruntjs.com/)

## warning

This is my first Atom plugin, hacked together in an evening.  
It probably won't break anything (e.g. delete all your code :)  
but still: use at your own risk!
