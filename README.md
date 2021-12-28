# Lite Lime

Sample showing build using Conan and CMake (based on https://github.com/Jan200101/lite-lime)

# Requirements

* CMake
* Python
	* Conan: `pip install conan`

# Building

```
mkdir build && cd build

#download and/or build dependencies
conan install .. --build=missing

#configure and build CMake project as usual
cmake ..
cmake --build .
```

# Notes

This project is not using the SDL2 recipe from Conan. It can be done just like all the others, however that recipe on Conan Center does not allow you to link with the system version. This means that you'll have to recompile the entirety of SDL2 (including all of its dependencies). 

This may or may not be desirable, but for this demo I decided to not to do it.

Changing this behavior will require the SDL2 recipe to be modified.
