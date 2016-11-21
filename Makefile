default: all

all:
	corebuild -pkgs async \
		lengthClient.byte \
		lengthServer.byte \
		keyValueStoreClient.byte \
		keyValueStoreServer.byte

clean:
	rm -f *.byte
	rm -rf _build
