all: dist/elm.js

dist:
	mkdir -p dist

dist/elm.js: Story.elm O2Tutorial.elm DataModel.elm TutorialStyles/Styles.elm dist
	elm-make O2Tutorial.elm --output $@
  
