module Component.AppContainer where 

import Data.Maybe (Maybe(..))
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Prelude ((+), (-), (<>), ($), show, void, pure, unit, bind)
import React.Basic (Component, JSX, StateUpdate(..), capture_, createComponent, make, send)
import React.Basic.DOM as RD
import Routing.PushState as Routing

component :: Component Props 
component = createComponent "AppContainer"

type Props = 
    { routing         :: Routing.PushStateInterface
    , initialLocation :: String 
    }

data Action 
    = ChangeLocation String 

appContainer :: Props -> JSX
appContainer = make component { initialState, update, didMount, render }
    where 
        initialState = { location: "/" }

        update = \self action -> case action of
            ChangeLocation location -> 
                Update self.state { location = location } 

        didMount = \self -> do
            location <- self.props.routing.locationState
            _ <- send self $ ChangeLocation location.path
            launchAff_ $ do 
                liftEffect $ self.props.routing.listen (routeChangeHandler self)

        render = \self -> do
          case self.state.location of 
            "/" -> 
                RD.div
                    { children: [ RD.text "Home" ] }
            _   -> 
                RD.div
                    { children: [ RD.text self.state.location ] }
            
        routeChangeHandler = \self location -> do
            send self $ ChangeLocation location.path