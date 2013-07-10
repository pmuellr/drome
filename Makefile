# Licensed under the Apache License. See footer for details.

.PHONY: vendor

BROWSERIFY = node_modules/.bin/browserify
COFFEE     = node_modules/.bin/coffee
COFFEEC    = $(COFFEE) --bare --compile

#-------------------------------------------------------------------------------
help:
	@echo "available targets:"
	@echo "   watch         - watch for changes, then build, then serve"
	@echo "   build         - build the server"
	@echo "   clean         - erase built files"
	@echo "   vendor        - get vendor files"
	@echo "   help          - print this help"
	@echo ""
	@echo "You will need to run 'make vendor' before duing anything useful."

#-------------------------------------------------------------------------------
clean: make-writeable
	-rm -rf tmp/* www/*

#-------------------------------------------------------------------------------
clean-all: clean
	-rm -rf vendor/* node_modules/* node_modules/.bin

#-------------------------------------------------------------------------------
watch:
	make build
	@wr "make build" tools vendor www-src Makefile

#-------------------------------------------------------------------------------
build: make-writeable build_ make-read-only

#-------------------------------------------------------------------------------
build_:
	@-rm -rf  www/*
	@mkdir -p www 
	@mkdir -p www/css
	@mkdir -p www/images
	@mkdir -p www/scripts

	@mkdir -p tmp/scripts

	@cp -p www-src/*.html             www
	@cp -p www-src/css/*              www/css
	@cp -p www-src/images/*           www/images
	@cp -p www-src/scripts/*.coffee   www/scripts

	@cp -R vendor 					  www

	@echo "compiling coffee files"
	@$(COFFEEC) --output www/scripts  www/scripts/*.coffee 

	@echo "browserifying"
	@$(BROWSERIFY) \
		--debug \
		--outfile www/scripts/all-modules.js \
		www/scripts/main.js

	@$(COFFEE) tools/split-sourcemap-data-url.coffee www/scripts/all-modules.js

#-------------------------------------------------------------------------------
make-writeable: 
	@-chmod -R +w www/*

#-------------------------------------------------------------------------------
make-read-only: 
	@-chmod -R -w www/*

#-------------------------------------------------------------------------------
vendor: 

	npm install

	@-rm -rf  vendor/*
	@mkdir -p vendor

	#------------------------------------------
	@echo ""
	@echo "downloading jQuery"
	@curl --progress-bar --output vendor/jquery.js   $(JQUERY_URL).js

	#------------------------------------------
	@echo ""
	@echo "downloading d3"
	@curl --progress-bar --output vendor/d3.js       $(D3_URL)/d3.js

	#------------------------------------------
	@echo ""
	@echo "downloading bootstrap"
	@mkdir -p vendor/bootstrap
	@curl --progress-bar --output vendor/bootstrap/bootstrap.zip $(BOOTSTRAP_URL)

	@unzip -q vendor/bootstrap/bootstrap.zip -d vendor/bootstrap
	@mv       vendor/bootstrap/bootstrap/*      vendor/bootstrap
	@rm -r    vendor/bootstrap/bootstrap
	@rm       vendor/bootstrap/bootstrap.zip
	@rm       vendor/bootstrap/css/*.min.css
	@rm       vendor/bootstrap/js/*.min.js

	#------------------------------------------
	@echo ""
	@echo "downloading font-awesome"
	@mkdir -p vendor/font-awesome
	@curl --progress-bar --output vendor/font-awesome/font-awesome.zip $(FONTAWESOME_URL)
	@unzip -q vendor/font-awesome/font-awesome.zip -d vendor/font-awesome
	@mv       vendor/font-awesome/font-awesome/*      vendor/font-awesome
	@rm -rf   vendor/font-awesome/font-awesome
	@rm       vendor/font-awesome/font-awesome.zip
	@rm       vendor/font-awesome/css/*.min.css
	@rm -rf   vendor/font-awesome/less
	@rm -rf   vendor/font-awesome/scss

	#------------------------------------------
	@echo ""
	@echo "downloading Drive on Metz stuff"
	@mkdir -p vendor/drome/vassal/tmp

	@curl --progress-bar \
		--header "User-Agent: $(USER_AGENT)" \
		--output vendor/drome/rules.pdf \
		http://victorypointgames.com/documents/DOM_rules.pdf

	@curl --progress-bar \
		--header "User-Agent: $(USER_AGENT)" \
		--output vendor/drome/rules-optional.pdf \
		http://victorypointgames.com/documents/DOM_optional_rules.pdf

	@curl --progress-bar \
		--header "User-Agent: $(USER_AGENT)" \
		--output vendor/drome/vassal/tmp/dl.zip \
		http://victorypointgames.com/documents/DOM_Vassal.zip

	@unzip -q -o vendor/drome/vassal/tmp/dl.zip     -d vendor/drome/vassal/tmp
	@unzip -q -o vendor/drome/vassal/tmp/metzv1.dat -d vendor/drome/vassal/tmp

	@cp vendor/drome/vassal/tmp/images/CRT.png          vendor/drome/vassal/chart-CRT.png
	@cp vendor/drome/vassal/tmp/images/SOP.png          vendor/drome/vassal/chart-SOP.png
	@cp vendor/drome/vassal/tmp/images/TEC.png          vendor/drome/vassal/chart-TEC.png

	@cp vendor/drome/vassal/tmp/images/Metzmap2.jpg		vendor/drome/vassal/map.jpg

	@cp vendor/drome/vassal/tmp/images/MA7ACCA.PNG 		vendor/drome/vassal/piece-a-cca.png
	@cp vendor/drome/vassal/tmp/images/MA7ACCB.PNG 		vendor/drome/vassal/piece-a-ccb.png
	@cp vendor/drome/vassal/tmp/images/MA7ACCR.PNG 		vendor/drome/vassal/piece-a-ccr.png
	@cp vendor/drome/vassal/tmp/images/MA52.PNG 		vendor/drome/vassal/piece-a-2.png
	@cp vendor/drome/vassal/tmp/images/MA510.PNG 		vendor/drome/vassal/piece-a-10.png
	@cp vendor/drome/vassal/tmp/images/MA511.PNG 		vendor/drome/vassal/piece-a-11.png
	@cp vendor/drome/vassal/tmp/images/MA90357.PNG 		vendor/drome/vassal/piece-a-357.png
	@cp vendor/drome/vassal/tmp/images/MA90358.PNG 		vendor/drome/vassal/piece-a-358.png

	@cp vendor/drome/vassal/tmp/images/MG3PG.PNG 		vendor/drome/vassal/piece-g-8.png
	@cp vendor/drome/vassal/tmp/images/MG3PG29.PNG 		vendor/drome/vassal/piece-g-29.png
	@cp vendor/drome/vassal/tmp/images/MG17SS37.PNG 	vendor/drome/vassal/piece-g-37.png
	@cp vendor/drome/vassal/tmp/images/MG17SS38.PNG 	vendor/drome/vassal/piece-g-38.png
	@cp vendor/drome/vassal/tmp/images/MG106.PNG 		vendor/drome/vassal/piece-g-106.png
	@cp vendor/drome/vassal/tmp/images/MG452.PNG 		vendor/drome/vassal/piece-g-452.png
	@cp vendor/drome/vassal/tmp/images/MG462Utrfhr.PNG 	vendor/drome/vassal/piece-g-462.png
	@cp vendor/drome/vassal/tmp/images/MG4621010.PNG 	vendor/drome/vassal/piece-g-1010.png
	@cp vendor/drome/vassal/tmp/images/MG5591125.PNG 	vendor/drome/vassal/piece-g-1125.png
	@cp vendor/drome/vassal/tmp/images/MG5591126.PNG 	vendor/drome/vassal/piece-g-1126.png
	@cp vendor/drome/vassal/tmp/images/MGGarM.png 		vendor/drome/vassal/piece-g-gar.png

	@convert -crop 1095x1589+285+0  vendor/drome/vassal/map.jpg  vendor/drome/vassal/map-thin.jpg

	@echo "files in this directory from Victory Point Games site"  >> vendor/drome/vassal/README.txt
	@echo "for the game Drive on Metz, at:"                        >> vendor/drome/vassal/README.txt
	@echo "    http://victorypointgames.com/details.php?prodId=61" >> vendor/drome/vassal/README.txt

	@rm -rf vendor/drome/vassal/tmp

no-drm:
	@pdf2ps vendor/drome/rules.pdf          vendor/drome/rules.ps
	@pdf2ps vendor/drome/rules-optional.pdf vendor/drome/rules-optional.ps

	@ps2pdf vendor/drome/rules.ps 			vendor/drome/rules.pdf         
	@ps2pdf vendor/drome/rules-optional.ps 	vendor/drome/rules-optional.pdf

	@rm vendor/drome/rules.ps
	@rm vendor/drome/rules-optional.ps

#-------------------------------------------------------------------------------
JQUERY_URL      = http://code.jquery.com/jquery-2.0.2
D3_URL          = https://raw.github.com/mbostock/d3/v3.1.5
ANGULAR_URL     = https://ajax.googleapis.com/ajax/libs/angularjs/1.1.5
BOOTSTRAP_URL   = http://twitter.github.io/bootstrap/assets/bootstrap.zip
CODEMIRROR_URL  = https://raw.github.com/marijnh/CodeMirror/v3.12
FONTAWESOME_URL = http://fortawesome.github.io/Font-Awesome/assets/font-awesome.zip
USER_AGENT      = Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36

#-------------------------------------------------------------------------------
icons:
	@echo converting icons with ImageMagick

	@convert -resize 032x032 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-032.png
	@convert -resize 057x057 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-057.png
	@convert -resize 064x064 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-064.png
	@convert -resize 072x072 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-072.png
	@convert -resize 096x096 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-096.png
	@convert -resize 114x114 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-114.png
	@convert -resize 128x128 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-128.png
	@convert -resize 144x144 vendor/DOM_Vassal/piece-a-cca.png  www-src/images/icon-144.png

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

