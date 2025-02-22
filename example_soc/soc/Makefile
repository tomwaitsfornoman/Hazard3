H := /home/per/hazard3/myHazard3

.PHONY: verilate
verilate:
	verilator -I${H}/hdl -I${H}/hdl/arith -I${H}/example_soc/libfpga/common -I${H}/hdl/debug/dtm -I${H}/hdl/debug/cdc  -I${H}/hdl/debug/dm -I${H}/example_soc/libfpga/busfabric -I${H}/example_soc/libfpga/mem -I${H}/example_soc/libfpga/peris/uart -I${H}/example_soc/libfpga/cdc -I${H}/example_soc/soc/peri --cc --exe --build --trace example_soc.v sim_main.cpp -Wno-fatal

.PHONY: run
run:
	${H}/example_soc/soc/obj_dir/Vexample_soc

.PHONY: sw
sw:
	make -C ${H}/test/sim/hellow hex

.PHONY: clean
clean:
	make -C ${H}/test/sim/hellow clean
