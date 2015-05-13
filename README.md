# tree-view-filter

Atom package which hides files in the tree view that don't match the provided pattern(s).

![screencast](https://raw.githubusercontent.com/monsterkodi/tree-view-filter/master/img/screencast.gif)

## Usage

Press `ctrl-alt-shift-f` or invoke `Tree View Filter:Activate` to focus the filter pattern editor, 
enter your pattern and press Enter/Return to confirm.

To restore the tree view to its unfiltered state:  
either press `Escape` when the filter editor has focus or click on the `(x)` button to the right.

## Known issues

Currently, the filter only sets the display style of the file entries to 'none'. 
When navigating the tree view with the keyboard, the invisible items still get focus.
Also, the filter only applies to the currently expanded directories. 

Changes to the [tree-view package](https://atom.io/packages/tree-view) which solve these issues have been [submitted](https://github.com/atom/tree-view/pull/414) and are currently pending review.

## Credits

* screencast generated with [dergachev/screengif](https://github.com/dergachev/screengif)
* file pattern matching by [minimatch](https://www.npmjs.com/package/minimatch)

and the usual suspects

* almost as good as coffee: [coffeescript](http://coffeescript.org/)
* a truly hackable editor: [atom](https://atom.io/)
* grunt, grunt, [grunt](http://gruntjs.com/)

[atom package](https://atom.io/packages/tree-view-filter)
