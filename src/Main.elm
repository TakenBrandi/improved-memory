module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)

main =
    Browser.element { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }

type Msg = ClickedField Int
type FieldContent = Empty | Bomb
type Visibility = Visible | Hidden

init (numBombs, width, height) =
    ( [ List.repeat numBombs {visibility = Hidden, content = Bomb}
    , List.repeat (width * height - numBombs) {visibility = Hidden, content = Empty}
    ] |> List.concat, Cmd.none )

update msg board =
    case msg of
        ClickedField idx ->
           ( List.indexedMap (reveal idx) board, Cmd.none)

reveal target currentIdx field =
    if target == currentIdx then
        {field | visibility = Visible }
    else
        field


view fields =
    div [id "board"]
        (List.indexedMap viewField fields)

viewField idx {visibility, content} =
    case (visibility, content) of
        (Visible, Empty) -> div [] [text " "]
        (Visible, Bomb) -> div [] [text "💣"]
        _ -> div [onClick (ClickedField idx)] [text "?"]
