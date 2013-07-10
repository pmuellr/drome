# Licensed under the Apache License. See footer for details.

board = require "./board"
utils = require "./utils"

pieces = exports

#-------------------------------------------------------------------------------
class Piece 

    #---------------------------------------------------------------------------
    constructor: (@id, @side, @cs, @ma, @location) ->

        board$ = $ "#board"

        @el$ = buildPiece @id, @side, @location, board$           

        pieces[@id] = @

        @moveTo @location

    #---------------------------------------------------------------------------
    moveTo: (hexId) ->
        hex = board.hexes[hexId]
        return if !hex?

        @location = hexId

        xOffset = -45
        yOffset = -37

        x = hex.x + xOffset
        y = hex.y + yOffset

        @el$.attr
            transform:      "translate(#{x},#{y})"

    #---------------------------------------------------------------------------
    possibleMoves: (options) ->
        visitedMap = {}
        moveExplorer @location, @ma, @side, visitedMap, options



#-------------------------------------------------------------------------------
moveExplorer = (startLoc, ma, side, visitedMap, options) ->
    hex = board.hexes[startloc]

#    for direction in board.directions
#        if hex.nabors[direction]?

#-------------------------------------------------------------------------------
moveExpense = (startLoc, direction) ->
    hex = board.hexes[startloc]
    return Infinity if !hex.nabors[direction]?
    

#-------------------------------------------------------------------------------
buildPiece = (id, side, position, parent$) ->

    borderW = 10
    pieceW  = 95
    pieceH  = 95
    url     = "vendor/drome/vassal/piece-#{id}.png"

    if !position?
        hex = {x:0, y:0}
    else
        hex = board.hexes[position]

    #-----------------------------------------------
    group$ = $ utils.createSVGElement "g"
    group$.attr
        opacity:        0.7

    group$.click -> alert "clicked on #{id}"

    parent$.append group$
    
    group$.hide() if !position?

    #-----------------------------------------------
    image$ = $ utils.createSVGImage url
    image$.attr
        width:          pieceW
        height:         pieceH

    group$.append image$

    #-----------------------------------------------
    if side is "us"
        color = "red"
    else
        color = "black"

    border$ = $ utils.createSVGElement "rect"
    border$.attr
        width:          pieceW
        height:         pieceH
        rx:             20
        ry:             20
        fill:           "none"
        stroke:         color
        "stroke-width": 10

    group$.append border$

    return group$

#-------------------------------------------------------------------------------
run = ->
    new Piece "a-2",    "us", 5,  4, "0105"           
    new Piece "a-10",   "us", 5,  4, "0108"            
    new Piece "a-11",   "us", 5,  4, "0109"            
    new Piece "a-357",  "us", 4,  4, "0101"             
    new Piece "a-358",  "us", 4,  4, "0102"             
    new Piece "a-cca",  "us", 7, 10, "0106"             
    new Piece "a-ccb",  "us", 7, 10, "0110"             
    new Piece "a-ccr",  "us", 5, 10, "0111"

    new Piece "g-8",    "ge", 2,  8, "0609"           
    new Piece "g-29",   "ge", 2,  8, "0611"            
    new Piece "g-37",   "ge", 3,  8, "0808"            
    new Piece "g-38",   "ge", 2,  8, "0709"            
    new Piece "g-106",  "ge", 1,  8
    new Piece "g-452",  "ge", 3,  4, "0509"             
    new Piece "g-462",  "ge", 2,  4, "0505"             
    new Piece "g-1010", "ge", 1,  4, "0507"              
    new Piece "g-1125", "ge", 1,  4, "0401"              
    new Piece "g-1126", "ge", 1,  4, "0403"              
    new Piece "g-gar",  "ge", 1,  1, "0807"             

#-------------------------------------------------------------------------------
run()

#-------------------------------------------------------------------------------
# Copyright 2013 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
