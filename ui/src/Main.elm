module Main exposing (main)

import Chapters.Multi as Multi
import Chapters.Single as Single
import Chapters.SingleNative as SingleNative
import ElmBook exposing (withChapterGroups, withStatefulOptions)
import ElmBook.ElmCSS exposing (Book, book)
import ElmBook.StatefulOptions


type alias SharedState =
    { singleModel : Single.Model
    , multiModel : Multi.Model
    }


initialState : SharedState
initialState =
    { singleModel = Single.init, multiModel = Multi.init }


main : Book SharedState
main =
    book "elm-select"
        |> withStatefulOptions [ ElmBook.StatefulOptions.initialState initialState ]
        |> withChapterGroups
            [ ( "Variants"
              , [ Single.chapter_
                , SingleNative.chapter_
                , Multi.chapter_
                ]
              )
            ]
