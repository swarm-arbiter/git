run:
		sudo docker run -itd \
		-v "/docker/git/home:/home/git" \
		"cgit:$(shell cat VERSION)"

build:
	sudo docker build . -t "registry.terry.cloud/core/cgit:$(shell cat VERSION)"
