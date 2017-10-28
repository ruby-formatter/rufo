# Rufo Development

## Tips for editor plugin implementors

It is especially convenient if your code is automatically _formatted on save_.
For example, surrounding a piece of code with `if ... end` will automatically indent
the code when you save. Likewise, it will be automatically unindented should you remove it.

For this to work best, the cursor position must be preserved, otherwise it becomes
pretty annoying if the cursor is reset to the top of the editor.

You should compute a diff between the old content and new content
and apply the necessary changes. You can check out how this is done in the
[Sublime Text plugin for Rufo](https://github.com/ruby-formatter/sublime-rufo):

- [diff_match_patch.py](https://github.com/ruby-formatter/sublime-rufo/blob/master/diff_match_patch.py) contains the diff algorithm (you can port it to other languages or try to search for a similar algorithm online)
- [rufo_format.py](https://github.com/ruby-formatter/sublime-rufo/blob/master/rufo_format.py#L46-L53) consumes the diff result and applies it chunk by chunk in the editor's view
