# notes (idea from [connermcd/notes](https://github.com/connermcd/notes))

Shell script for compiling pdf notes with pandoc.

## Usage

    notes [semester|"all"] [module]

## Examples

    notes
       compiles notes for current year/module

    notes all
       compiles all notes

    notes 1
       compiles notes for year 1

    notes 1 example
       compiles notes for year 1 module "example"

## Dependencies
    * pandoc
    * LaTex, ghostscript (you get both with MiKTeX)
    * Font "TeX Gyre Pagella"

## Explanation

Notes are organized in a directory specified by the environment variable `$NOTES_DIR`. Inside this directory there are semesters and inside that, there are modules.

    /home/connermcd/Dropbox/Courses/Notes aka $NOTES_DIR
    ├── sem1
    │   ├── sem1.pdf
    │   ├── mod1
    │   │   ├── img
    │   │   └── Example-Topic.txt
    │   ├── mod2
    │   ├── mod3
    │   └── ...
    ├── sem2
    │   ├── sem2.pdf
    │   ├── mod1
    │   └── ...
    ├── about.md
    ├── fonts.tex
    ├── html.md
    └── slidy.html

Each file has a header indicating the title and date. For instance...

    # Example-Topic
    > Date: 22-08-01
    > Instructor: McDaniel

    ![This is an image](img/image.jpg)\ 

This is used by the script to sort the files chronologically in the exported pdf. Images can be stored in the `img` directory for the corresponding module.

## Vim/bash integration

View my [vimrc](https://github.com/erikrl2/dotfiles-win/blob/main/vimfiles/vimrc) at this point of time.
