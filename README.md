# Notes

Shell script for compiling markdown notes to html.

Original idea from [connermcd/notes](https://github.com/connermcd/notes) and html/css theme from [jez/pandoc-markdown-css-theme](https://github.com/jez/pandoc-markdown-css-theme).

## Usage

    notes [semester|"all"|"index"] [module]
    
For more information view the [source code](https://github.com/erikrl2/Notes/blob/main/notes.sh).

I use Windows, so I need to explicitly invoke the script via bash like so: `bash notes`.

## Dependencies
    * pandoc
    * Font: Menlo

## Explanation

Notes are organized in a directory specified by the environment variable `$NOTES_DIR`. Inside this directory there are semesters with modules/subjects. The current semester is specified by the environment variable `$SEMESTER`.

The script can create an index.html file that provides links to all module html files.

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
    ├── index.html
    ├── metadata.html
    ├── metadata.md
    ├── notes.sh
    └── skeleton.txt

Each text file has a header indicating the title and date. For instance...

    # Topic
    > Date: 2022-08-01

    ![This is an image](img/image.jpg)\

This is used by the script to sort the files chronologically in the exported pdf. Images can be stored in the `img` directory for the corresponding module.

## Vim integration

View my [vimrc](https://github.com/erikrl2/dotfiles-win/blob/main/vimfiles/vimrc).

## MIT License

Copyright (c) 2022 erikrl2

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
