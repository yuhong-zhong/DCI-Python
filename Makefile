main_files = src/util.cu src/dci.cu
test_files = src/test/test_pipeline.c
cuda_samples_dir = /usr/local/cuda-9.0/samples
include_statements = -I include -I $(cuda_samples_dir)/common/inc/
gpu_arch = --gpu-architecture=sm_61 
python_flags = -dc -Xcompiler -fPIC
src_files = build/util.o build/dci.o
cuda = -lcublas 

all: $(main_files) $(test_files)
	mkdir build
	mkdir bin
	nvcc $(main_files) $(test_files) $(include_statements) $(gpu_arch) --shared -Xcompiler -fPIC $(cuda) -x cu -dc
	nvcc $(include_statements) $(gpu_arch) -dlink --shared -Xcompiler -fPIC util.o dci.o test_pipeline.o -o link.o
	mv *.o build
# nvcc $(gpu_arch) $(src_files) $(cuda) build/test_pipeline.o --shared -o bin/libtest.so
	gcc --shared build/test_pipeline.o $(src_files) build/link.o -L/usr/local/cuda/lib64 -lcuda -lcudart -lcublas -lcudadevrt -o bin/libtest.so
# nvcc $(gpu_arch) $(src_files) $(cuda) build/test_pipeline.o --shared -o bin/libtest.so

clean:
	-rm -r build bin
