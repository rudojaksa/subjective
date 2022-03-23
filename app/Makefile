all: out

out:
	mkdir out
	chmod 777 out

clean:
	@echo "clean the out/ manually"; echo
	@ls -l out

mrproper:
	make -C img clean
	rm -rf out

