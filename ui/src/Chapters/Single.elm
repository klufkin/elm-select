module Chapters.Single exposing (Model, chapter_, init)

import Css
import ElmBook.Actions exposing (mapUpdateWithCmd)
import ElmBook.Chapter exposing (chapter, renderStatefulComponent)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled as Styled exposing (Html, div)
import Html.Styled.Attributes as StyledAttribs
import Select exposing (MenuItem, initState, selectIdentifier)


type alias SharedState x =
    { x
        | singleModel : Model
    }


type Msg
    = SelectMsg (Select.Msg String)


type alias Model =
    { selectState : Select.State
    , items : List (MenuItem String)
    , selectedItem : Maybe String
    }


init : Model
init =
    { selectState = initState
    , items =
        [ Select.basicMenuItem { item = "Elm", label = "Elm" }
        , Select.basicMenuItem { item = "Is", label = "Is" }
        , Select.basicMenuItem { item = "Really", label = "Really" }
        , Select.basicMenuItem { item = "Great", label = "Great" }
        ]
    , selectedItem = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectMsg sm ->
            let
                ( maybeAction, selectState, cmds ) =
                    Select.update sm model.selectState

                updatedSelectedItem =
                    case maybeAction of
                        Just (Select.Select i) ->
                            Just i |> Debug.log "Selected"

                        _ ->
                            model.selectedItem
            in
            ( { model | selectState = selectState, selectedItem = updatedSelectedItem }, Cmd.map SelectMsg cmds )


view : Model -> Html Msg
view m =
    let
        selectedItem =
            case m.selectedItem of
                Just i ->
                    Just (Select.basicMenuItem { item = i, label = i })

                _ ->
                    Nothing
    in
    div
        [ StyledAttribs.css
            [ Css.marginTop (Css.px 20)
            , Css.width (Css.pct 50)
            , Css.marginLeft Css.auto
            , Css.marginRight Css.auto
            ]
        ]
        [ Styled.map SelectMsg <|
            Select.view
                (Select.single selectedItem
                    |> Select.state m.selectState
                    |> Select.menuItems m.items
                    |> Select.placeholder "Placeholder"
                    |> Select.searchable False
                )
                (selectIdentifier "SingleSelectExample")
        ]


chapter_ : Chapter (SharedState x)
chapter_ =
    chapter "Single"
        |> renderStatefulComponent
            (\{ singleModel } ->
                view singleModel
                    |> Styled.map
                        (mapUpdateWithCmd
                            { fromState = .singleModel
                            , toState = \state singleModel_ -> { state | singleModel = singleModel_ }
                            , update = update
                            }
                        )
            )
