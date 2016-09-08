# NIMage
# A Python Imaging Library-esque package build on STB.

Makes use of the quite excellent STB headers.  AColley has a similar version here https://github.com/acolley/nim-stb-image (and indeed, the design of the object is based on his/her implementation).  The difference between our implementations is this one will build STB statically and link it into your application, meaning no external .so is required.  This has plusses and minuses.
