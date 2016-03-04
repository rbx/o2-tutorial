module DataModel where
import Html exposing (..)

type alias Background = {
  template: Html
}

type alias ImageStep = 
  {
    header : String,
    image : String
  }

type Pane = ShellPane { shell : String }
          | EditorPane { editor : String, filename : String }

type alias TwoPanesStep =
  {
    header : String,
    leftPane : Pane,
    rightPane : Pane
  }

type alias SinglePaneStep = 
  {
    header : String,
    pane: Pane
  }
