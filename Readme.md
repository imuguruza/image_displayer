# Image Displayer

This design displays 100x100 8-color images for a 640x480 display.
It also allows to load new images sending it through serial, using
serial_img_send python script (under sw folder).

## Prerequisites

You need to have installed the next tools:
- Yosys
- FuseSoc

To add this design to your FuseSoC libraries :
```
cd $PATH && git clone https://github.com/imuguruza/image_displayer
fusesoc library add imagedisplayer $PATH
```

## Targets

The target of the design is the [Alhambra II board](https://alhambrabits.com/alhambra/).

To synthesize the design execute `fusesoc run --target=top imagedisplayer`.

There are also three different test benches you can execute:

-  `fusesoc run --target=top_tb imagedisplayer`, which checks the top module design
-  `fusesoc run --target=uartrx_tb imagedisplayer`, which checks if uart rx works
-  `fusesoc run --target=baudgen_tb imagedisplayer`, which checks if the baud generator
    works

## Material and pinout

I have used a [VGA Pmod](https://store.digilentinc.com/pmod-vga-video-graphics-array/) to create the RGB[8] and VGA control signals.

You can find the pinout in `data/pinout.pcf`.

In addition to this, you need to connect `GND` and `3v3` to feed the VGA Pmod

## More info

More info about the design, in my blog!

## TODO

The script `serial_img_send` sends images that are split in lines and coded in hex format, but without `0x`. This is because of verilog `$readmemh` used to store the
default image in RAM at synth.
