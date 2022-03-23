NUM  := 9
AIMG := $(shell seq 1 $(NUM) | xargs -iX echo "A/AX.jpg")
BIMG := $(shell seq 1 $(NUM) | xargs -iX echo "B/BX.jpg")

all: $(AIMG) $(BIMG)

$(AIMG): A/A%.jpg: | A
	convert -background gray33 -fill gold -size 320x240 -font Roboto -pointsize 72 -gravity center label:'test A$*' -quality 25 $@

$(BIMG): B/B%.jpg: | B
	convert -background gray33 -fill gold -size 320x240              -pointsize 72 -gravity center label:'test B$*' -quality 25 $@

A B:
	mkdir -p $@

clean:
	@echo "clean the A & B manually"; echo
	@ls -l A B

mrproper:
	rm -rf A B

