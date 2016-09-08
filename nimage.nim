
#{.link: "libnimage.so".}
{.passl: "-lm".}
{.passc: "-lm".}
{.compile: "nimage.c".}

#const
  #LIBRARY_NAME = "libnimage.so"
  #LIBRARY_NAME = "libnimage.a"

proc stbi_load(filename: string, x, y, comp: var uint32, req_comp: int): ptr uint8 
  {.importc.}
  #{.cdecl, importc: "stbi_load", staticLib: LIBRARY_NAME.}
  #{.cdecl, importc: "stbi_load", dynlib: LIBRARY_NAME.}

proc stbi_write_png(filename: string, w, h, comp: uint32, data: ptr uint8) {.importc.}

proc stbi_image_free(data: ptr uint8) {.importc.}

proc failure_reason*(): string {.importc.}

# Higher level wrappers

type
  Image* = object
    width*: uint32
    height*: uint32
    depth*: uint32
    data*: ptr uint8

proc new*(width, height, depth : uint32): Image =
  result = Image(
    width: width,
    height : height,
    depth : depth,
    data : nil
  )    

proc load*(filename: string): Image =
  var
    width: uint32
    height: uint32
    depth: uint32

  let data = stbi_load(filename, width, height, depth, 0)

  result = Image(
    width: width,
    height: height,
    depth: depth,
    data: data
  )

proc save*(img: Image, filename: string) =
  case filename[^3..^0] #foo.png 012.456 654.210
    of "png":
      stbi_write_png(filename, img.width, img.height, img.depth, img.data);
#[
    of "bmp":
      stbi_write_bmp(filename, img.width, img.height, img.depth, img.data);
    of "tga":
      stbi_write_tga(filename, img.width, img.height, img.depth, img.data);
    of "hdr":
      stbi_write_hdr(filename, img.width, img.height, img.depth, img.data);
]#

proc free*(img: Image) =
  stbi_image_free(img.data)

when isMainModule:
  proc main() =
    var im = load("testImage.png")
  main()
