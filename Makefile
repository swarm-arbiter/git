run:
		sudo docker run -it \
		-v "/home/jamie/Documents/dev/web/infrastructure/containers/gitolite/vols/githome:/home/git" \
		"cgit:$(shell cat VERSION)"

build:
	sudo docker build . -t "cgit:$(shell cat VERSION)"
