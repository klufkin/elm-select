module Main exposing (main)

import Chapters.Single
import ElmBook exposing (withChapters)
import ElmBook.ElmCSS exposing (Book, book)


main : Book ()
main =
    book "elm-select"
        |> withChapters
            [ Chapters.Single.chapter_
            ]
