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
