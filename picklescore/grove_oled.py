# Custom driver for Seeed Grove OLED 0.66" (SSD1306 64x48)
# The display uses a 128x64 controller but only shows 64x48
# Column offset = 32, Page offset = 0

import framebuf

SET_CONTRAST        = const(0x81)
SET_ENTIRE_ON       = const(0xa4)
SET_NORM_INV        = const(0xa6)
SET_DISP            = const(0xae)
SET_MEM_ADDR        = const(0x20)
SET_COL_ADDR        = const(0x21)
SET_PAGE_ADDR       = const(0x22)
SET_DISP_START_LINE = const(0x40)
SET_SEG_REMAP       = const(0xa0)
SET_MUX_RATIO       = const(0xa8)
SET_COM_OUT_DIR     = const(0xc0)
SET_DISP_OFFSET     = const(0xd3)
SET_COM_PIN_CFG     = const(0xda)
SET_DISP_CLK_DIV    = const(0xd5)
SET_PRECHARGE       = const(0xd9)
SET_VCOM_DESEL      = const(0xdb)
SET_CHARGE_PUMP     = const(0x8d)

class GROVE_OLED_066:
    def __init__(self, i2c, addr=0x3C):
        self.i2c = i2c
        self.addr = addr
        self.width = 64
        self.height = 48
        self.col_offset = 32  # Grove 0.66" specific offset
        self.buf = bytearray(self.width * self.height // 8)
        self.fb = framebuf.FrameBuffer(self.buf, self.width, self.height, framebuf.MONO_VLSB)
        self.init_display()

    def write_cmd(self, cmd):
        self.i2c.writeto(self.addr, bytes([0x80, cmd]))

    def write_data(self, buf):
        self.i2c.writeto(self.addr, bytes([0x40]) + buf)

    def init_display(self):
        for cmd in [
            SET_DISP | 0x00,           # display off
            SET_MEM_ADDR, 0x00,        # horizontal addressing
            SET_DISP_START_LINE | 0x00,
            SET_SEG_REMAP | 0x01,      # column addr 127 mapped to SEG0
            SET_MUX_RATIO, 0x2F,       # 48 mux ratio (48-1=47=0x2F)
            SET_COM_OUT_DIR | 0x08,    # scan from COM[N] to COM0
            SET_DISP_OFFSET, 0x00,
            SET_COM_PIN_CFG, 0x12,
            SET_DISP_CLK_DIV, 0x80,
            SET_PRECHARGE, 0xF1,
            SET_VCOM_DESEL, 0x30,
            SET_CONTRAST, 0xFF,
            SET_ENTIRE_ON,             # output follows RAM
            SET_NORM_INV,              # not inverted
            SET_CHARGE_PUMP, 0x14,    # enable charge pump
            SET_DISP | 0x01,          # display on
        ]:
            self.write_cmd(cmd)

    def show(self):
        # Set column address with offset
        self.write_cmd(SET_COL_ADDR)
        self.write_cmd(self.col_offset)
        self.write_cmd(self.col_offset + self.width - 1)
        # Set page address
        self.write_cmd(SET_PAGE_ADDR)
        self.write_cmd(0)
        self.write_cmd(self.height // 8 - 1)
        # Write buffer
        self.write_data(self.buf)

    def fill(self, col):
        self.fb.fill(col)

    def text(self, string, x, y, col=1):
        self.fb.text(string, x, y, col)

    def pixel(self, x, y, col):
        self.fb.pixel(x, y, col)

    def line(self, x1, y1, x2, y2, col):
        self.fb.line(x1, y1, x2, y2, col)

    def rect(self, x, y, w, h, col):
        self.fb.rect(x, y, w, h, col)
