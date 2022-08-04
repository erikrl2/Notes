# Notes

Shell script for compiling html notes with pandoc.

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
    * Optional (font): Fenlo

## Explanation

Notes are organized in a directory specified by the environment variable `$NOTES_DIR`. Inside this directory there are semesters and inside that are modules. The current semester is specified by the environment variable `$SEMESTER`.

    C:/Users/Erik/Dropbox/Notes
    ├── sem1
    │   ├── mod1
    │   │   ├── mod1.html
    │   │   ├── img
    │   │   ├── Example1.txt
    │   │   └── Example2.txt
    │   ├── mod2
    │   ├── mod3
    │   └── ...
    ├── sem2
    │   ├── mod1
    │   └── ...
    ├── metadata.md
    ├── notes.sh
    └── skeleton.txt

Each file has a header indicating the title and date. For instance...

    # Topic
    > Date: 2022-08-01

    ![This is an image](img/image.jpg)\

This is used by the script to sort the files chronologically in the exported pdf. Images can be stored in the `img` directory for the corresponding module.

## Vim integration

View my [vimrc](https://github.com/erikrl2/dotfiles-win/blob/main/vimfiles/vimrc).
