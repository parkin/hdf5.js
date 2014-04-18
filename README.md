# hdf5.js

HDF5 compiled to JavaScript with emscripten

## Compiling with Emscripten

First make a regular build with the default compilers. The HDF5 build creates some shell files that will not run properly if generated from the emmake build.

```
cd regular-build
../hdf5-1.8.9/configure --enable-cxx
make
```

Go to the emscripten build folder and configure.

```
cd ../em-build
emconfigure ../hdf5-1.8.9/configure --enable-cxx
```

Start making

```
emmake make
```

The build will fail when trying to run a couple of scripts. When they do, copy over the needed shell scripts, then continue.

```
cp ../regular-build/src/H5make_libsettings src/
chmod +x src/H5make_libsettings

emmake make

cp ../regular-build/src/H5detect src/
chmod +x src/H5detect
```

Make, install

```
emmake make

continue...
```
