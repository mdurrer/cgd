# Makefile for building game archives
LANGS=cz de en pl
AUDIO=mp3

DIR=/Users/robert/projects/dh/dist
#DIR=/Users/spalek/Documents/dragon-history

ORIG_GFX=$(DIR)/orig-gfx
ORIG_EXE=$(DIR)/orig-exe
GFX=$(DIR)/gfx
EXE=$(DIR)/exe
STRINGS=$(DIR)/strings
CD_SAM=$(DIR)/CD.SAM
BUF=$(DIR)/buf
DUBBING=$(DIR)/dub

all: source_zips compile_game archive_game strings

clean_sources:
	@echo Cleaning BP7 files
	rm -vf `find . -name *.TPU -o -name *.EXE -o -name *.OBJ \
	  -o -name *.BAK -o -name *.DSK -o -name *.PSM`
	@echo Cleaning FP files
	rm -rvf `find . -name *.o -o -name *.ppu` \
	  compiler/k3 units/bar/upgrade \
	  editors/sound/extract{,.dSYM}
	@echo Cleaning Python files
	rm -vf `find . -name *.pyc`
	@echo Cleaning recoded player strings
	rm -rvf player/recoded
clean: clean_sources
	@echo Cleaning pruned and compiled game scripts
	rm -rvf $(GFX) $(EXE) $(STRINGS)
	@echo Cleaning archives
	rm -vf $(DIR)/*.zip
clean_all: clean
	@echo Removing dubbing
	rm -rvf $(BUF) $(DUBBING)

compiler/k3:
	cd compiler && \
	fpc -g -Cr -Co -Fu../units/gpl2 -Fu../units/bar -Fu../units/system k3
units/bar/upgrade:
	cd units/bar && \
	fpc -g -Cr -Co upgrade
editors/sound/extract: editors/sound/extract.c
	$(CC) $^ -o $@ --std=gnu99 -Wall -O2 -ggdb

width:
	cd scripts && ./fix-width.py
	git st game-scripts

$(GFX) player/recoded/texts-en.pas:
	scripts/prune-sources.py \
	  --gfx=$(ORIG_GFX) --scripts=game-scripts --output=$(GFX) \
	  --player=player
$(DIR)/new-gfx.zip: $(GFX)
	cd $(dir $(GFX)) && zip -r $@ $(notdir $(GFX))
$(DIR)/new-sources.zip: Makefile
	# Don't add the following as dependencies directly:
	make clean_sources player/recoded/texts-en.pas
	zip -r $@ * .[a-z]*
source_zips: $(DIR)/new-sources.zip $(DIR)/new-gfx.zip

$(EXE)/%/retezce.dfw: $(GFX)/%/init
	mkdir -p $(dir $@)
	compiler/k3 $(dir $<) $(dir $@)
	cd $(dir $@) && rm -v ident.* programy.* retezce.ems sam_an.dfw
	cp $(dir $<)/*.fon $(dir $@)
	cd $(ORIG_EXE)/$* && \
	  cp hra.dfw init.dfw *.exe readme.* dh.bat cmf.ins bert.ico cd.sam \
	  $(dir $@)
	@echo Language variant $* compiled
$(EXE)/%/p.exe: player/P.EXE
	cp player/P-$(shell echo $* | tr a-z A-Z).EXE $@
$(DIR)/dh-%.zip: $(EXE)/%/retezce.dfw $(EXE)/%/p.exe
	cd $(dir $<) && zip $@ *
compile_game: \
  compiler/k3 $(GFX) \
  $(foreach lang, $(LANGS), $(EXE)/$(lang)/retezce.dfw)
update_exe: \
  $(foreach lang, $(LANGS), $(EXE)/$(lang)/p.exe)
archive_game: \
  $(foreach lang, $(LANGS), $(DIR)/dh-$(lang).zip)

$(STRINGS)/recoded/retezce-%.txt: $(EXE)/%/retezce.dfw
	mkdir -p $(dir $@)
	scripts/draci_strings_extract.py -i$< -o$@
$(STRINGS)/utf-8/retezce-%.txt: $(STRINGS)/recoded/retezce-%.txt
	mkdir -p $(dir $@)
	scripts/recode-scripts-to-utf-8.py -c$* -o$(dir $@) $<
strings: \
  $(foreach lang, $(LANGS), $(STRINGS)/recoded/retezce-$(lang).txt) \
  $(foreach lang, $(LANGS), $(STRINGS)/utf-8/retezce-$(lang).txt)

$(BUF)/1.buf: $(CD_SAM)
	mkdir -p $(dir $@)
	editors/sound/extract $< $(dir $@)
$(DUBBING)/dub-%.zzz: $(BUF)/1.buf
	mkdir -p $(dir $@)
	scripts/compress-dubbing.sh $* $(dir $<) $(dir $@)
dubbing_buf: editors/sound/extract $(BUF)/1.buf
dubbing_all: dubbing_buf \
  $(foreach format, $(AUDIO), $(DUBBING)/dub-$(format).zzz)
