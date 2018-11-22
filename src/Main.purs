module Main where

import Prelude

import Component.AppContainer (appContainer)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Console (log)
import React.Basic.DOM (render)
import Routing.PushState as Routing
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window as Window


main :: Effect Unit
main = do
  nav       <- liftEffect $ Routing.makeInterface
  location  <- liftEffect $ nav.locationState
  document  <- Window.document =<< window
  container <- getElementById "app" $ toNonElementParentNode document 
  case container of 
    Nothing -> log "Error, container not found!"
    Just c  -> do
      let app = appContainer { routing: nav, initialLocation: location.path }
      render app c