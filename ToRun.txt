ASM = nasm
QEMU = qemu-system-x86_64
TARGET_MAIN = granTrakTEC_Main.bin
TARGET_EXT = granTrakTEC_Extended.bin
IMAGE = granTrakTEC.img

# Códigos ANSI para colores
GRAY=\033[38;5;250m
GREEN=\033[1;32m
RED = \033[0;31m
NC = \033[0m # No Color

# Estilos
BOLD=\033[1m
NC=\033[0m  # Resetear estilo

.PHONY: all run clean

all: $(IMAGE)

$(TARGET_MAIN): granTrakTEC_Main.asm
	@echo "${BOLD}Assembling main module (granTrakTEC_Main)...${NC}${GRAY}"
	$(ASM) -f bin $< -o $@
	@echo "${BOLD}${GREEN}Main module (granTrakTEC_Main) assembled successfully.$(NC)\n"

$(TARGET_EXT): granTrakTEC_Extended.asm
	@echo "${BOLD}Assembling extended module (granTrakTEC_Extended)...${NC}${GRAY}"
	$(ASM) -f bin $< -o $@
	@echo "${BOLD}${GREEN}Extended module (granTrakTEC_Extended) assembled successfully.$(NC)\n"

$(IMAGE): $(TARGET_MAIN) $(TARGET_EXT)
	@echo "${BOLD}Generating disk image...${NC}${GRAY}"
	cat $(TARGET_MAIN) $(TARGET_EXT) > $@
	@echo "${BOLD}${GREEN}Disk image generated successfully.$(NC)\n"

run: $(IMAGE)
	@echo "${BOLD}Starting execution...${NC}${GRAY}"
	$(QEMU) -drive format=raw,file=$(IMAGE),index=0,if=floppy -display sdl -monitor stdio
	@echo "${BOLD}${GREEN}Execution completed successfully.$(NC)\n"

clean:
	@echo "${BOLD}Cleaning generated files...${NC}${GRAY}"
	rm -f $(TARGET_MAIN) $(TARGET_EXT) $(IMAGE)
	@echo "${BOLD}${GREEN}Generated files removed successfully.$(NC)\n"