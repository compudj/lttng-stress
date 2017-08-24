
.PHONY: bin clean
bin:
	$(MAKE) bin -C bin

clean:
	$(MAKE) clean -C bin
