all: dist/elm.js dist/index.html dist/sampler-sink.png dist/device.png dist/topology.png

dist:
	mkdir -p dist

publish:
	rm -fr dist/.git && cd dist && git init && git remote add origin https://github.com/ktf/o2-tutorial && git add . && git commit -a -m'Published' && git push origin HEAD:gh-pages

dist/%.png: %.png
	cp -f $< $@

dist/index.html: index.html
	cp index.html dist/index.html

dist/elm.js: Story.elm O2Tutorial.elm DataModel.elm TutorialStyles/Styles.elm dist
	elm-make O2Tutorial.elm --output $@

.PHONY: dist publish
