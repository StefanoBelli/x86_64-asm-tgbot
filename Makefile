SHELL:=$(shell which bash)
CC=gcc
CFLAGS=-O2 -Wall -Wextra -std=c11
LIBS=-lssl
EXTRA_LIBS=-lcrypto
SRC_DIR=src
SRC_IMPLS=impls.c
SRC_MAIN=main.S
SRC_NETWORKING=networking.S
SRC_UTIL=util.S
SRC_MAIN_BOT_LOOP=main_bot_loop.S
UTIL_OBJF=util.o
NETWORKING_OBJF=networking.o
IMPLS_OBJF=impls.o
MAIN_BOT_LOOP_OBJF=main_bot_loop.o
OUT=tgbot
ALL_OBJF_PATTERN="*.o"
TOKEN=""
MAX_SRCS=5

all:
	@echo "[*CHECK] Checking for TOKEN "
	if [[ $(TOKEN) == "" ]]; then \
		echo " - You must set TOKEN "; \
		exit 3; \
	fi
	@echo "[+TOKEN] $(TOKEN)"
	@echo "[*BUILD|1/$(MAX_SRCS)] $(SRC_DIR)/$(SRC_IMPLS)"
	$(CC) \
		$(CFLAGS) \
		$(SRC_DIR)/$(SRC_IMPLS) \
		-DTOKEN=\"$(TOKEN)\" \
		-o $(SRC_DIR)/$(IMPLS_OBJF) \
		-c && echo "[+OUT|OBJF] $(IMPLS_OBJF)" || exit 1
	@echo "[*BUILD|2/$(MAX_SRCS)] $(SRC_DIR)/$(SRC_UTIL)"
	$(CC) \
		$(SRC_DIR)/$(SRC_UTIL) \
		-o $(SRC_DIR)/$(UTIL_OBJF) \
		-c && echo "[+OUT|OBJF] $(UTIL_OBJF)" || exit 1 
	@echo "[*BUILD|3/$(MAX_SRCS)] $(SRC_DIR)/$(SRC_NETWORKING)"
	$(CC) \
		$(SRC_DIR)/$(SRC_NETWORKING) \
		-o $(SRC_DIR)/$(NETWORKING_OBJF) \
		-c \
		$(LIBS) \
		$(EXTRA_LIBS) && echo "[+OUT|OBJF] $(NETWORKING_OBJF)" || exit 1
	@echo "[*BUILD|4/$(MAX_SRCS)] $(SRC_DIR)/$(SRC_MAIN_BOT_LOOP)"
	$(CC) \
		$(SRC_DIR)/$(SRC_MAIN_BOT_LOOP) \
		-o $(SRC_DIR)/$(MAIN_BOT_LOOP_OBJF) \
		-c \
		$(LIBS) \
		$(EXTRA_LIBS) && echo "[+OUT|OBJF] $(MAIN_BOT_LOOP_OBJF)" || exit 1
	@echo "[*BUILD|5/$(MAX_SRCS)] $(SRC_DIR)/$(SRC_MAIN)"
	$(CC) \
		$(SRC_DIR)/*.o \
		$(SRC_DIR)/$(SRC_MAIN) \
		-o $(OUT) \
		$(LIBS) \
		$(EXTRA_LIBS) && echo "[+OUT|EXECUTABLE] $(OUT) " || exit 2
	@echo "[+DONE] Done. Enjoy"
clean:
	@echo "[*CLEAN] Cleaning up object files from $(SRC_DIR)"
	rm $(SRC_DIR)/*.o 2>/dev/null
	@echo "[+DONE] Done"

.PHONY: all,clean
ifndef VERBOSE
.SILENT:
endif
