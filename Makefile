CXX := g++
PYTHON_BIN_PATH = python

LYING_RELU_SRCS = $(wildcard tensorflow_lying_relu/cc/kernels/*.cc) $(wildcard tensorflow_lying_relu/cc/ops/*.cc)

TF_CFLAGS := $(shell $(PYTHON_BIN_PATH) -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_compile_flags()))')
TF_LFLAGS := $(shell $(PYTHON_BIN_PATH) -c 'import tensorflow as tf; print(" ".join(tf.sysconfig.get_link_flags()))')

CFLAGS = ${TF_CFLAGS} -fPIC -O2 -std=c++11
LDFLAGS = -shared ${TF_LFLAGS}

LYING_RELU_TARGET_LIB = tensorflow_lying_relu/python/ops/_lying_relu_ops.so

lying_relu_op: $(LYING_RELU_TARGET_LIB)

$(LYING_RELU_TARGET_LIB): $(LYING_RELU_SRCS)
	$(CXX) $(CFLAGS) -o $@ $^ ${LDFLAGS}

lying_relu_test: tensorflow_lying_relu/python/ops/lying_relu_ops_test.py tensorflow_lying_relu/python/ops/lying_relu_ops.py $(LYING_RELU_TARGET_LIB)
	$(PYTHON_BIN_PATH) tensorflow_lying_relu/python/ops/lying_relu_ops_test.py

lying_relu_pip_pkg: $(LYING_RELU_TARGET_LIB)
	./build_pip_pkg.sh make artifacts

clean:
	rm -f $(LYING_RELU_TARGET_LIB)
