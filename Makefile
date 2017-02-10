SHELL:=$(shell which bash)
CC=gcc
CFLAGS=-O2 -Wall -Wextra -std=c11
LIBS=-lssl
MAIN_EXTRA_LIBS=-lcrypto
SRC_DIR=src
SRC_IMPLS=impls.c
SRC_MAIN=main.S
IMPLS_OBJF=impls.o
OUT=tgbot
TOKEN=""

all:
	@echo "[*CHECK] Checking for TOKEN "
	if [[ $(TOKEN) == "" ]]; then \
		echo " - You must set TOKEN "; \
		exit 3; \
	fi
	@echo "[*BUILD|1/2] $(SRC_DIR)/$(SRC_IMPLS)"
	$(CC) \
		$(CFLAGS) \
		$(SRC_DIR)/$(SRC_IMPLS) \
		-c \
		-o $(SRC_DIR)/$(IMPLS_OBJF) \
		$(LIBS) && echo "[+OUT|OBJF] $(IMPLS_OBJF)" || exit 1
	@echo "[*BUILD|2/2] $(SRC_DIR)/$(SRC_MAIN)"
	$(CC) \
		$(CFLAGS) \
		$(SRC_DIR)/$(IMPLS_OBJF) \
		$(SRC_DIR)/$(SRC_MAIN) \
		-o $(OUT) \
		$(LIBS) \
		$(MAIN_EXTRA_LIBS) && echo "[+OUT|EXECUTABLE] $(OUT) " || exit 2
clean:
	@echo "[*CLEAN] Cleaning up object files from $(SRC_DIR)"
	rm $(SRC_DIR)/*.o 2>/dev/null
	@echo "[+DONE] Done"

.PHONY: all,clean
ifndef VERBOSE
.SILENT:
endif
