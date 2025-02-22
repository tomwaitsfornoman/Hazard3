ifndef SRCS
$(error Must define list of test sources as SRCS)
endif

ifndef APP
$(error Must define application name as APP)
endif

DOTF         ?= tb.f
CCFLAGS      ?=
LDSCRIPT     ?= ../common/memmap.ld
CROSS_PREFIX ?= riscv32-unknown-elf-
TBEXEC       ?= ../tb_cxxrtl/tb
TBDIR        := $(dir $(abspath $(TBEXEC)))
INCDIR       ?= ../common
MAX_CYCLES   ?= 100000
TMP_PREFIX   ?= tmp/

# Useless:
override CCFLAGS += -Wl,--no-warn-rwx-segments

###############################################################################

.SUFFIXES:
.PHONY: all run view tb clean clean_tb

all: run

run: $(TMP_PREFIX)$(APP).bin
	$(TBEXEC) --bin $(TMP_PREFIX)$(APP).bin --vcd $(TMP_PREFIX)$(APP)_run.vcd --cycles $(MAX_CYCLES)

view: run
	gtkwave $(TMP_PREFIX)$(APP)_run.vcd

hex: $(TMP_PREFIX)$(APP).hex
bin: $(TMP_PREFIX)$(APP).bin

tb:
	$(MAKE) -C $(TBDIR) DOTF=$(DOTF)

clean:
	rm -rf $(TMP_PREFIX)

clean_tb: clean
	$(MAKE) -C $(TBDIR) clean

###############################################################################

$(TMP_PREFIX)$(APP).hex: $(TMP_PREFIX)$(APP).elf
	rm -f $(TMP_PREFIX)$(APP)*.hex
	riscv32-unknown-elf-objcopy $(TMP_PREFIX)$(APP).elf -O verilog --verilog-data-width=4 $(TMP_PREFIX)$(APP)_tmp.hex
	cat $(TMP_PREFIX)$(APP)_tmp.hex | tr ' ' '\n' | sed -E 's%([^@].)(..)(..)(..)([ $$])%\4\3\2\1\5\n%g' | fromdos | grep -Pv '^$$' > $(TMP_PREFIX)$(APP)_tmp2.hex
	mv $(TMP_PREFIX)$(APP)_tmp2.hex $(TMP_PREFIX)$(APP).hex
	rm -f $(TMP_PREFIX)$(APP)_tmp.hex

$(TMP_PREFIX)$(APP).bin: $(TMP_PREFIX)$(APP).elf
	$(CROSS_PREFIX)objcopy -O binary $^ $@
	$(CROSS_PREFIX)objdump -h $^ > $(TMP_PREFIX)$(APP).dis
	$(CROSS_PREFIX)objdump -d $^ >> $(TMP_PREFIX)$(APP).dis

$(TMP_PREFIX)$(APP).elf: $(SRCS) $(wildcard %.h) $(LDSCRIPT)
	mkdir -p $(TMP_PREFIX)
	$(CROSS_PREFIX)gcc $(CCFLAGS) -I /home/per/riscboy/RISCBoy/software/include $(SRCS) -T $(LDSCRIPT) -Wl,-Map=$(TMP_PREFIX)$(APP).map $(addprefix -I,$(INCDIR)) -o $@
