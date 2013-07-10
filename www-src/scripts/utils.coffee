# Licensed under the Apache License. See footer for details.

utils = exports

NS_SVG   = "http://www.w3.org/2000/svg"
NS_XLINK = "http://www.w3.org/1999/xlink"

#-------------------------------------------------------------------------------
utils.createSVGElement = (name) ->
    element = document.createElementNS NS_SVG, name

    return element

#-------------------------------------------------------------------------------
utils.createSVGImage = (url) ->
    image = utils.createSVGElement "image"
    image.setAttributeNS NS_XLINK, "href", url

    return image

#-------------------------------------------------------------------------------
utils.dump = (text) ->
    $log = $ "#log"
    $log.text text
    $log.show()

#-------------------------------------------------------------------------------
utils.log = (text) ->
    $log = $ "#log"
    $log.text "#{$log.text()}\n#{text}"
    $log.show()

#-------------------------------------------------------------------------------
utils.JL = (o) -> JSON.stringify o, null, 4
utils.JS = (o) -> JSON.stringify o


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
