run:
	sudo docker run -it \
		-v "$(shell pwd)/vols/hostkeys:/etc/ssh/hostkeys" \
		-v "$(shell pwd)/vols/githome:/home/git" \
		"gitolite:$(shell cat VERSION)"

build:
	sudo docker build . -t "gitolite:$(shell cat VERSION)"

clean:
	sudo rm -rf vols/hostkeys
