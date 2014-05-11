# hdf5.js

HDF5 compiled to JavaScript with [emscripten](https://github.com/kripken/emscripten/wiki).

## Compiling with Emscripten


Go to the emscripten build folder and configure.

```
mkdir em-build
cd em-build
emconfigure ../hdf5-1.8.12/configure --enable-cxx
```
Start making

```
emmake make
emmake make install
```

## Running examples

Go to the examples directory and build `readdata.js`.

```
emcc readdata.cpp ../em-build/hdf5/lib/libhdf5.a ../em-build/hdf5/lib/libhdf5_cpp.a -I../em-build/hdf5/include --embed-file SDS.h5 -o readdata.js
```

Run it using

```
node readdata.js
```

The current output is

```
Data set has INTEGER type
Little endian byte ordering (0)
Data size is 4
rank 2, dimensions 5 x 6
0 0 0 0 0 0 0 
0 0 0 0 0 0 0 
0 0 0 0 0 0 0 
3 4 5 6 0 0 0 
4 5 6 7 0 0 0 
5 6 7 8 0 0 0 
0 0 0 0 0 0 0 

/home/parkin/git/hdf5.js/examples/readdata.js:692481
      throw e;
            ^
abort() at Error
    at stackTrace (/home/parkin/git/hdf5.js/examples/readdata.js:1077:15)
    at Object.abort (/home/parkin/git/hdf5.js/examples/readdata.js:692571:25)
    at _abort (/home/parkin/git/hdf5.js/examples/readdata.js:7685:22)
    at _free (/home/parkin/git/hdf5.js/examples/readdata.js:685371:3)
    at _H5FL_blk_gc_list (/home/parkin/git/hdf5.js/examples/readdata.js:78428:4)
    at _H5FL_blk_free (/home/parkin/git/hdf5.js/examples/readdata.js:78258:11)
    at _H5FL_seq_free (/home/parkin/git/hdf5.js/examples/readdata.js:79192:3)
    at _H5B2_hdr_free (/home/parkin/git/hdf5.js/examples/readdata.js:24527:10)
    at _H5B2__cache_hdr_dest (/home/parkin/git/hdf5.js/examples/readdata.js:21763:9)
    at Array._H5B2__cache_hdr_flush (/home/parkin/git/hdf5.js/examples/readdata.js:21670:14)
```

So the data is read correctly, but there are still problems closing files.

# Licenses

The hdf5 [license](http://www.hdfgroup.org/ftp/HDF5/current/src/unpacked/COPYING).
The original hdf5 code has been modified to allow for building with emscripten.
