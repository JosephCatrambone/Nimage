
#{.link: "libnimage.so".}
{.passl: "-lm".}
{.passc: "-lm".}
{.compile: "nimage.c".}

proc stbi_load(filename: string, x, y, comp: var uint32, req_comp: int): ptr seq[uint8]
  {.importc.}
  #{.cdecl, importc: "stbi_load", staticLib: LIBRARY_NAME.}
  #{.cdecl, importc: "stbi_load", dynlib: LIBRARY_NAME.}

proc stbi_write_png(filename: string, w, h, comp: uint32, data: ptr seq[uint8]) {.importc.}
proc stbi_write_bmp(filename: string, w, h, comp: uint32, data: ptr seq[uint8]) {.importc.}
proc stbi_write_tga(filename: string, w, h, comp: uint32, data: ptr seq[uint8]) {.importc.}
proc stbi_write_hdr(filename: string, w, h, comp: uint32, data: ptr seq[uint8]) {.importc.}

proc stbi_image_free(data: ptr seq[uint8]) {.importc.}

# Higher level wrappers
type
  Image* = object
    width*: uint32
    height*: uint32
    depth*: uint32
    data*: ref seq[uint8]

proc new*(width, height, depth : uint32): Image =
  var data : ref seq[uint8] = new seq[uint8]
  data[] = @[]
  result = Image(
    width: width,
    height : height,
    depth : depth,
    data : data
  )
  for i in 0..width*height*depth:
    result.data[].add(0)

proc load*(filename: string): Image =
  var
    width: uint32
    height: uint32
    depth: uint32

  let img_data_ptr : ptr seq[uint8] = stbi_load(filename, width, height, depth, 0)
  echo "Got back ", $img_data_ptr[0], $img_data_ptr[1]

  result = Image(
    width: width,
    height: height,
    depth: depth,
    data: new seq[uint8]
  )

  # Copy the contents of the data pointer into the result buffer.
  result.data[] = @[]
  for i in countup(0, width*height*depth):
    result.data[].add(img_data_ptr[i])

  stbi_image_free(data)

proc save*(img: Image, filename: string) =
  case filename[^3..^0] #foo.png 012.456 654.210
    of "png":
      stbi_write_png(filename, img.width, img.height, img.depth, addr img.data[]);
    of "bmp":
      stbi_write_bmp(filename, img.width, img.height, img.depth, addr img.data[]);
    of "tga":
      stbi_write_tga(filename, img.width, img.height, img.depth, addr img.data[]);
    of "hdr":
      stbi_write_hdr(filename, img.width, img.height, img.depth, addr img.data[]);

when isMainModule:
  proc main() =
    var im = load("testImage.png")
    save(im, "test.png")
  main()
