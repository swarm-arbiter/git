run:
	sudo docker run -it "cgit:$(shell cat VERSION)"

build:
	sudo docker build . -t "cgit:$(shell cat VERSION)"
