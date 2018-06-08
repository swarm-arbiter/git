run:
		sudo docker run -itd \
		-v "/docker/git/home:/home/git" \
		"cgit:$(shell cat VERSION)"

build:
	sudo docker build . -t "cgit:$(shell cat VERSION)"
