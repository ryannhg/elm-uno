module Deck exposing
    ( Deck, new
    , draw
    , isEmpty, size
    , topCard, topCards
    , reshuffle
    , view
    , fromKinds
    )

{-|

@docs Deck, new
@docs deal, draw
@docs isEmpty, size
@docs topCard, topCards
@docs reshuffle
@docs view

@docs fromKinds

-}

import Card exposing (Card)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Random
import Random.List


type Deck
    = Deck { cards : List Card }


new : Random.Seed -> Deck
new seed =
    Deck
        { cards = shuffle seed Card.unshuffledDeck
        }


isEmpty : Deck -> Bool
isEmpty (Deck { cards }) =
    List.isEmpty cards


size : Deck -> Int
size (Deck { cards }) =
    List.length cards


topCard : Deck -> Maybe Card
topCard (Deck { cards }) =
    List.head cards


topCards : Int -> Deck -> List Card
topCards count (Deck { cards }) =
    List.take count cards


reshuffle : Random.Seed -> List Card -> Deck
reshuffle seed cards =
    Deck
        { cards = shuffle seed cards
        }


draw : Int -> Deck -> { cards : List Card, deck : Deck }
draw numberOfCards (Deck { cards }) =
    -- TODO: Fail if couldn't draw enough cards
    { cards = List.take numberOfCards cards
    , deck = Deck { cards = List.drop numberOfCards cards }
    }


shuffle : Random.Seed -> List Card -> List Card
shuffle seed deck =
    let
        ( shuffledDeck, _ ) =
            Random.step (Random.List.shuffle deck) seed
    in
    shuffledDeck


view : { onClick : msg, deck : Deck } -> Html msg
view options =
    let
        (Deck { cards }) =
            options.deck
    in
    Html.div [ Html.Attributes.class "deck", Html.Attributes.id "deck" ]
        [ case List.head cards of
            Just topCard_ ->
                Html.button
                    [ Html.Attributes.attribute "aria-label" "Draw a card"
                    , Html.Events.onClick options.onClick
                    ]
                    [ Card.viewBackOfCard topCard_ ]

            Nothing ->
                Card.viewEmptyDeck
        ]


fromKinds : List Card.CardKind -> Deck
fromKinds kinds =
    Deck
        { cards = Card.fromKinds kinds
        }
