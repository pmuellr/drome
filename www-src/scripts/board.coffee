# Licensed under the Apache License. See footer for details.

board = exports

offsetX = 320
offsetY =  45
hexW    = 116
hexH    = 137.5

#-------------------------------------------------------------------------------
board.hexes = {}

#-------------------------------------------------------------------------------
run = ->
    board.hexes = buildHexes()
    buildTerrain()
    buildRoads()
    buildRivers()

#-------------------------------------------------------------------------------
class Hex

    constructor: (@row, @col) ->
        @id  = "#{right20 col}#{right20 row}"

        if @col%2
            evenOffset = 0
        else
            evenOffset = hexH / 2

        @x  = offsetX + (col-1)*hexW
        @y  = offsetY + (row-1)*hexH + evenOffset

        @terrain = "clear"
        @roads   = {}
        @rivers  = {}
        @nabors  = {}

#-------------------------------------------------------------------------------
buildHexes = () ->

    hexes = {}

    for col in [1..9]
        for row in [1..11]
            hex = new Hex row, col
            hexes[hex.id] = hex

    directions = ["n", "ne", "se", "s", "sw", "nw"]

    for id, hex of hexes
        for direction in directions
            hex.nabors[direction] = calcNeighbor hexes, hex, direction

    return hexes

#-------------------------------------------------------------------------------
calcNeighbor = (hexes, hex, direction) ->
    {row, col} = hex

    if @col%2
        evenOffset = 0
    else
        evenOffset = 1

    switch direction
        when "n"  then nrow = row - 1;              ncol = col
        when "ne" then nrow = row - 1 + evenOffset; ncol = col + 1
        when "se" then nrow = row     + evenOffset; ncol = col + 1
        when "s"  then nrow = row + 1;              ncol = col
        when "sw" then nrow = row     + evenOffset; ncol = col - 1
        when "nw" then nrow = row - 1 + evenOffset; ncol = col - 1

    id  = "#{right20 ncol}#{right20 nrow}"
    return hexes[id]

#-------------------------------------------------------------------------------
right20 = (s) ->
    s = "#{s}"
    while s.length < 2
        s = "0#{s}"
    return s

#-------------------------------------------------------------------------------
oppositeDirection = (direction) ->

    switch direction
        when "n"  then return "s"
        when "ne" then return "sw"
        when "se" then return "nw"
        when "s"  then return "n"
        when "sw" then return "ne"
        when "nw" then return "se"

#-------------------------------------------------------------------------------
buildRoads = () ->
    roads = [
        [ "0101", "sw" ]
        [ "0101", "ne" ]
        [ "0103", "nw" ]
        [ "0103", "se" ]
        [ "0104", "sw" ]
        [ "0104", "ne" ]
        [ "0105", "nw" ]
        [ "0105", "s"  ]
        [ "0106", "n"  ]
        [ "0106", "sw" ]
        [ "0106", "se" ]
        [ "0107", "sw" ]
        [ "0107", "se" ]
        [ "0110", "sw" ]
        [ "0110", "ne" ]
        [ "0203", "se" ]
        [ "0203", "sw" ]
        [ "0202", "nw" ]
        [ "0204", "ne" ]
        [ "0204", "s"  ]
        [ "0205", "n"  ]
        [ "0205", "s"  ]
        [ "0206", "n"  ]
        [ "0206", "se" ]
        [ "0206", "s"  ]
        [ "0206", "nw" ]
        [ "0207", "n"  ]
        [ "0207", "s"  ]
        [ "0208", "n"  ]
        [ "0208", "ne" ]
        [ "0208", "s"  ]
        [ "0208", "nw" ]
        [ "0209", "n"  ]
        [ "0209", "ne" ]
        [ "0209", "s"  ]
        [ "0209", "sw" ]
        [ "0210", "n"  ]
        [ "0210", "se" ]
    ]

    for road in roads
        buildRoad road[0], road[1]

#-------------------------------------------------------------------------------
buildRoad = (id1, dir, id2) ->
    board.hexes[id1].roads[dir] = true

    return if !id2
    dir = oppositeDirection dir

    board.hexes[id2].roads[dir] = true

#-------------------------------------------------------------------------------
buildRivers = () ->

#-------------------------------------------------------------------------------
buildTerrain = () ->
    rough = [
        "0501"
        "0306"
        "0307"
        "0308"
        "0309"
        "0609"
        "0610"
        "0611"
        "0711"
        "0810"
        "0811"
        "0911"
    ]

    forest = [
        "0105"
        "0202"
        "0301"
        "0302"
        "0303"
        "0305"
        "0310"
        "0311"
        "0401"
        "0402"
        "0403"
        "0404"
        "0408"
        "0409"
        "0410"
        "0411"
        "0502"
        "0503"
        "0504"
        "0505"
        "0507"
        "0508"
        "0509"
        "0602"
        "0603"
        "0604"
        "0605"
        "0606"
        "0608"
        "0903"
        "0904"
        "0909"
        "0910"
    ]

    town = [
        "0701"
        "0304"
        "0206"
        "0208"
        "0209"
        "0807"
    ]

    fortified = [
        "0806"
        "0706"
        "0606"
        "0507"
        "0508"
        "0509"
        "0609"
        "0709"
    ]

    for id in rough
        board.hexes[id].terrain = "rough"

    for id in forest
        board.hexes[id].terrain = "forest"

    for id in town
        board.hexes[id].terrain = "town"

    for id in fortified
        board.hexes[id].terrain = "fortified"

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
