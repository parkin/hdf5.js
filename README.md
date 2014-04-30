# hdf5.js

HDF5 compiled to JavaScript with emscripten

## Compiling with Emscripten


Go to the emscripten build folder and configure.

```
mkdir em-build
cd em-build
emconfigure ../hdf5-1.8.9/configure --enable-cxx
```

Copy the modified makefile to the new src directory

```
cp ../hdf5-modifications/Makefile src/
```

Start making

```
emmake make
emmake make install
```

To be continued...
