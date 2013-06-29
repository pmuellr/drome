# Licensed under the Apache License. See footer for details.

board = require "./board"

pieces = exports

#-------------------------------------------------------------------------------
run = ->
    new Piece "a-2",    "us", "0105"           
    new Piece "a-10",   "us", "0108"            
    new Piece "a-11",   "us", "0109"            
    new Piece "a-357",  "us", "0101"             
    new Piece "a-358",  "us", "0102"             
    new Piece "a-cca",  "us", "0106"             
    new Piece "a-ccb",  "us", "0110"             
    new Piece "a-ccr",  "us", "0111"             

    new Piece "g-8",    "ge", "0609"           
    new Piece "g-29",   "ge", "0611"            
    new Piece "g-37",   "ge", "0808"            
    new Piece "g-38",   "ge", "0709"            
    new Piece "g-106",  "ge"
    new Piece "g-452",  "ge", "0509"             
    new Piece "g-462",  "ge", "0505"             
    new Piece "g-1010", "ge", "0507"              
    new Piece "g-1125", "ge", "0401"              
    new Piece "g-1126", "ge", "0403"              
    new Piece "g-gar",  "ge", "0807"             

#-------------------------------------------------------------------------------
class Piece 

    #---------------------------------------------------------------------------
    constructor: (@id, @side, @location) ->

        board$ = $ "#board"

        buildPiece @id, @side, @location, board$           

        pieces[@id] = @

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
    group$ = $ createSVGElement "g"
    group$.attr
        transform:      "translate(#{hex.x},#{hex.y})"
        opacity:        0.7

    group$.click -> alert "clicked on #{id}"

    parent$.append group$
    
    group$.hide() if !position?

    #-----------------------------------------------
    image$ = $ createSVGImage url
    image$.attr
        width:          pieceW
        height:         pieceH

    group$.append image$

    #-----------------------------------------------
    if side is "us"
        color = "red"
    else
        color = "black"

    border$ = $ createSVGElement "rect"
    border$.attr
        width:          pieceW
        height:         pieceH
        rx:             20
        ry:             20
        fill:           "none"
        stroke:         color
        "stroke-width": 10

    group$.append border$

    return

#-------------------------------------------------------------------------------
createSVGElement = (name) ->
    svgNS   = "http://www.w3.org/2000/svg"

    element = document.createElementNS svgNS, name

    return element

#-------------------------------------------------------------------------------
createSVGImage = (url) ->

    image = createSVGElement "image"
    image.setAttributeNS "http://www.w3.org/1999/xlink", "href", url

    return image

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
