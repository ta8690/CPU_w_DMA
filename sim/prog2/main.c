#include <stdint.h>

#define MIP_MEIP (1 << 11) // External interrupt pending
#define MIP_MTIP (1 << 7)  // Timer interrupt pending
#define MIP 0x344

volatile unsigned int *WDT_addr = (int *) 0x10010000;
volatile unsigned int *dma_addr_boot = (int *) 0x10020000;

extern char _test_start;
extern char _binary_image_bmp_start;
extern char _binary_image_bmp_end;
extern unsigned int _binary_image_bmp_size;


void timer_interrupt_handler(void) {
  asm("csrsi mstatus, 0x0"); // MIE of mstatus
  WDT_addr[0x40] = 0; // WDT_en
  asm("j _start");
}

void external_interrupt_handler(void) {
	volatile unsigned int *dma_addr_boot = (int *) 0x10020000;
	asm("csrsi mstatus, 0x0"); // MIE of mstatus
	dma_addr_boot[0x40] = 0; // disable DMA
} 

void trap_handler(void) {
    uint32_t mip;
    asm volatile("csrr %0, %1" : "=r"(mip) : "i"(MIP));
	
    if ((mip & MIP_MTIP) >> 7) {
        timer_interrupt_handler();
    }

    if ((mip & MIP_MEIP) >> 11) {
        external_interrupt_handler();
    }
}

int main(void) {

    char* test_start = &_test_start;
    char* bmp_start = &_binary_image_bmp_start;
    unsigned int size = (unsigned int)(&_binary_image_bmp_size);

    // 複製 BMP 檔頭 (前 54 bytes)
    for (int i = 0; i < 54; i++) {
        test_start[i] = bmp_start[i];
    }

    // 處理 BMP 像素資料 (從第 54 byte 開始)
    for (int i = 54; i < size; i += 3) {
        char* target_pixel = &test_start[i];
        char* source_pixel = &bmp_start[i];

        char r = source_pixel[0]; // Red 分量
        char g = source_pixel[1]; // Green 分量
        char b = source_pixel[2]; // Blue 分量

        if (r == g && r == b) {
            // 如果 RGB 分量相等，直接複製該值作為灰階
            target_pixel[0] = r;
            target_pixel[1] = r;
            target_pixel[2] = r;
        } else {
            // 加權計算灰階值
            char gray_value = (r * 11 + g * 59 + b * 30) / 100;
            target_pixel[0] = gray_value;
            target_pixel[1] = gray_value;
            target_pixel[2] = gray_value;
        }
    }

    return 0;
}
