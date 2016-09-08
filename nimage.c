
#include <math.h>

#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#define STBI_MALLOC
#define STBI_REALLOC
#define STBI_FREE

#include "stb_image.h"
#include "stb_image_write.h"

// nimage.nim should automaticall build the required files and statically link the libraries into the executable, 
// But if you reall want to build this on your own for some reason (sanity testing?) use these:
// TO BUILD DYNAMIC: gcc -shared -o libnimage.so -fPIC nimage.c
// OR
// TO BUILD STATIC: gcc -c -o temp_libnimage.o nimage.c
// ar rcs libnimage.a temp_libnimage.o
