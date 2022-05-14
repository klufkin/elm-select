module Chapters.Multi exposing (Model, chapter_, init)

import Css
import ElmBook.Actions exposing (mapUpdateWithCmd)
import ElmBook.Chapter exposing (chapter, renderStatefulComponent)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled as Styled exposing (Html, div)
import Html.Styled.Attributes as StyledAttribs
import Select exposing (MenuItem, initState, selectIdentifier)


type alias SharedState x =
    { x | multiModel : Model }


type Msg
    = SelectMsg (Select.Msg String)


type alias Model =
    { selectState : Select.State
    , items : List (MenuItem String)
    , selectedItems : List String
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
    , selectedItems = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectMsg sm ->
            let
                ( maybeAction, selectState, cmds ) =
                    Select.update sm model.selectState

                updatedSelectedItems =
                    case maybeAction of
                        Just (Select.Select i) ->
                            model.selectedItems ++ [ i ]

                        Just (Select.DeselectMulti item) ->
                            List.filter (\i -> item /= i) model.selectedItems

                        _ ->
                            model.selectedItems
            in
            ( { model | selectState = selectState, selectedItems = updatedSelectedItems }, Cmd.map SelectMsg cmds )


view : Model -> Html Msg
view m =
    let
        selectedItems =
            List.map (\i -> Select.basicMenuItem { item = i, label = i }) m.selectedItems
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
                (Select.multi Select.initMultiConfig selectedItems
                    |> Select.state m.selectState
                    |> Select.menuItems m.items
                    |> Select.placeholder "Placeholder"
                )
                (selectIdentifier "SingleSelectExample")
        ]


chapter_ : Chapter (SharedState x)
chapter_ =
    chapter "Multi"
        |> renderStatefulComponent
            (\{ multiModel } ->
                view multiModel
                    |> Styled.map
                        (mapUpdateWithCmd
                            { fromState = .multiModel
                            , toState = \state multiModel_ -> { state | multiModel = multiModel_ }
                            , update = update
                            }
                        )
            )
