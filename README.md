# Notes

Shell script for compiling pdf notes with pandoc.
Idea from [connermcd/notes](https://github.com/connermcd/notes).

## Usage

    notes [semester|"all"] [module]

## Examples

    notes
       compiles notes for current semester

    notes all
       compiles all notes

    notes 1
       compiles notes for semester 1

    notes 1 example
       compiles notes for semester 1 module "example"

## Dependencies
    * pandoc
    * LaTex, ghostscript (you get both with MiKTeX)
    * Font "TeX Gyre Pagella"

## Explanation

Notes are organized in a directory specified by the environment variable `$NOTES_DIR`. Inside this directory there are semesters and inside that are modules. The current semester is specified by the environment variable `$SEMESTER`.

    C:/Users/Erik/Dropbox/Notes
    ├── sem1
    │   ├── sem1.pdf
    │   ├── mod1
    │   │   ├── mod1.pdf
    │   │   ├── img
    │   │   └── Example.txt
    │   ├── mod2
    │   ├── mod3
    │   └── ...
    ├── sem2
    │   ├── sem2.pdf
    │   ├── mod1
    │   └── ...
    ├── about.md
    ├── fonts.tex
    ├── skeleton.txt
    └── slidy.html

Each file has a header indicating the title and date. For instance...

    # Module1 - Topic
    > Date: 2022-08-01
    > Instructor: McDaniel

    ![This is an image](img/image.jpg)\

This is used by the script to sort the files chronologically in the exported pdf. Images can be stored in the `img` directory for the corresponding module.

## Vim integration

View my [vimrc](https://github.com/erikrl2/dotfiles-win/blob/36e06fd33b5f751cb29786915b3bbd14c1ccbe91/vimfiles/vimrc) at line [139](https://github.com/erikrl2/dotfiles-win/blob/36e06fd33b5f751cb29786915b3bbd14c1ccbe91/vimfiles/vimrc#L139) and [168](https://github.com/erikrl2/dotfiles-win/blob/36e06fd33b5f751cb29786915b3bbd14c1ccbe91/vimfiles/vimrc#L168).
