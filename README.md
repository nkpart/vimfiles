nkpart's vim files
==================

It's vim files, not much more to say.

Using it
--------

    $ git clone http://github.com/nkpart/vimfiles.git .vim
    $ cd .vim && ln -s vimrc ~/.vimrc

Then fire up vim and run `:BundleInstall`.

After that, command-t needs some help:

    $ cd ~/.vim/bundle/command-t/ruby/command-t
    $ rvm use system
    $ ruby extconf.rb
    $ make

I use it for with vanilla vim in a terminal, but everything should work in the guis as well.


Contents
--------
Aside from the bundles and the custom vimrc, I've applied a haskell vimball.


