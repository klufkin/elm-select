.PHONY: elm-book-live
elm-book-live:
	ELMLIVE=$$(${Y} bin elm-live) && cd ui && $$ELMLIVE src/Main.elm --pushstate --port=8080
