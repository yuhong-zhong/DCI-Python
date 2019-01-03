main_files = src/util.cu src/dci.cu
c_files = src/interface.c
cuda_samples_dir = /usr/local/cuda/samples
include_statements = -I include -I $(cuda_samples_dir)/common/inc/
gpu_arch = --gpu-architecture=sm_61
python_flags = -dc -Xcompiler -fPIC
src_files = build/util.o build/dci.o build/interface.o build/link.o
cuda = -lcublas

all: $(main_files) $(c_files)
	mkdir build
	mkdir bin
	nvcc $(main_files) $(c_files) $(include_statements) $(gpu_arch) --shared -Xcompiler -fPIC $(cuda) -x cu -dc
	nvcc $(include_statements) $(gpu_arch) -dlink --shared -Xcompiler -fPIC util.o dci.o interface.o -o link.o
	mv *.o build
	gcc --shared $(src_files) -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas -lcudadevrt -o bin/libtest.so

clean:
	-rm -r build bin
