dotfiles-editors
================

My editing-related configuration / dotfiles.

This is a [`vcsh`][vcsh]-managed repository for my editing-related
dotfiles. I follow a *grouped* software schema for my dotfiles rather
than software-specific repos (to keep it tidier). If the need arises
later (a particular piece of software deserves its own repo), I will
shift the contents out.

Currently, software/config that I classify under "editing tools"
includes:

  -	`vim`
  -	`gedit`

I do have other settings for other programs which I will migrate in.
My Vim folder could do with a bit of a clean-out too.

Special Considerations
----------------------

gedit has a bit of a funky directory presence. It dumps everything in
config, and relies heavily on `gtk-sourceview3.0` which has its own
place. I have symlinked a lot of this content, there's no point
repeating plugins so I need to tidy this up before I migrate these
settings in.

### Vim Configuration

#### General

##### Key bindings

I tried to disable the arrow keys to teach myself not to use them but
it totally breaks mouse scrolling which *just works* for me. You can
explicitly [re-enable this](http://nvie.com/posts/how-i-boosted-my-vim/)
but I really don't like the fact this solution involves switching
between mouse in vim, and mouse in terminal with an explicit button
press.

##### Appearance

###### Transparency

Transparent backgrounds are a little awkward. I can't not use them now
as it's a valuable way of being able to see information behind the
terminal window. With a reasonable opacity, there's a nice balance
between distraction and exposure. It's easy enough to support this in
vim (though some colour schemes need tweaking), but there are some
side effects:

  - Folds look clunky with non-transparent bg, but removing it reduces
	their distinction. 
  - A number of elements benefit from backgrounds, removing it reduces
	scope for semantic highlighting. This is a downward slope, though.
	The more you remove, the worse remaining elements with background
	look.
  - There is no support in vim for transparent colouring (AFAIK).

###### Folds

Aside from the concerns about transparency, folds look a little ugly
by default with the presence of a colour column. They overlay it
(removing the colbg from the intersection point) and they trail off
the screen. I suspect this can be fixed, but... (TODO)

###### Whitespace

I flip back and forth on this. Git likes to complain about trailing
whitespace in diffs (which it probably should). The default behaviour
of smartindent/autoindent is to introduce a blank line:

	Non-indented content
	....Indented content
		
	....Continuation

...*and* I set up Vim to strip trailing whitespace on buffer writing.

Now, I set up listchars to show whitespace and gave it a shortcut
(<`\l`>). The listchars I chose honestly look better when whitespace
always meet the indentation level. I either configure things to keep
this so it looks like:

	Non-indented content
	....Indented content
	....	
	....Continuation

and both prevent whitespace being stripped from blank lines and get
Git to shut up in its diffs (I suspect this is configurable). Or, I
live with the default behaviour, perhaps choosing different whitespace
characters that don't look best with the vertical continuation.
Ideally I'd like it to look like the following, though:

	for (i=0; i<n; ++i) {
	|   /* some comment */
	|   	
	|   do-something
	}

	for var in sequence:
	|	# comment
	|
	|	do-something
	

#### python.vim

##### Folding

Folding python is a little difficult. After some research I originally
settled on indent folding as it seemed simplest to implement. Some
observations:

  - Folding on the indent can look a little messy as it leaves the
	definition line (e.g. `class ClassName(object):` unfolded. On the
	flipside, this does benefit from syntax highlighting which isn't
	possible within a fold's text.
  - I often found that indent folding is a little brittle. I need to
	re-test this (TODO) but I found from experience that line breaks
	and whitespace tended to prevent the fold from catching everything
	it should do. I've sorted out whitespace issues a little bit now
	so it would be interesting to re-evaluate with this new
	consistency.

More recently, I found a python folding plugin SimpylFold, the
frustrating name aside, it seemed to be very effective initially (to
the point I committed to it). With more use, it's simple no BS
algorithm is undermined by a few quirks:

  - Folding docstrings doesn't always work cleanly, if `>` represents
	a tab character, and `_` represents a space:
		
		def func():
		>   """Summary.
		    
		>   Description.
		
		>	Some list:
		
		>   __-_Item 1
		>   __-_Item 2
		>   >   Item 2 continuation		# <---- tab 2 here breaks it
		                                # Replace with spaces works
		>   Closing remark.
		
		>   """
	
	This is a common pattern for me using markdown style lists. I'd
	rather not work around that as it makes life easier. This *could*
	be fixed by some sort of auto-replace-leading-tabs-in-lists
	wizardry but.. eh. It turns out that replacing that extra leading
	tab just breaks things on the second list item anyway. ...and if
	you put the tab back it doesn't still breaks on the second list
	item. FU SimpylFold you crazy.
  - It updates whilst typing, so if the regex results in a temporary
	change (e.g. whilst typing out a yet-to-be-terminated docstring)
	the fold below will break until everything is terminated properly.
  - Folding everything removes a lot of visual clarity due to the lack
	of syntax highlighting in the folds.

Both of these things can be fixed, but I'd rather it *just worked*. It
might be pertinent to investigate other alternatives again. I am aware
that it's easier said than done, however.


TODO
----

  - Consider aliases for fugitive commands. start using it, it's good.
  - See whether folds can be rendered differently (i.e. not to trail
	off the screen/overlay the colorcolumn)
  - Re-test python indent folding.
  - Investigate yet more python folding solutions.
  - Do more evaluation of whitespace management options and settle on
	something.
