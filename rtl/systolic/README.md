# Systolic array

## Programming model

### Registers (0xFE00..0xFF00)

CSR (16 bit) - control status register:
3 bit: returns if processing result was error
2 bit: reading returns processing completness
1 bit: writing to fist bit will reset device
0 bit: writing to first bit will start processing

DMS (16 bit) - Descriptor Memory Start:
0-15 bits: address of 

DMR (16 bit) - Descriptor Memory Range:
0-15 bits: size of descriptor memory

PMS (16 bit) - Payload Memory Start:

PMR (16 bit) - Payload Memory Range:

ECR (16 bit) - Error Code Register:

### Descriptor memory (0x0000..0x1000)

### Payload memory (0x1000..0x2000) 

## Use cases

### Reset

### Multiply matrices

-- -- 

2-e издение практикума по цифровому синтезу: "Цифровой синтез: RISC-V / под общ. ред. А. Ю. Романова. – М.: ДМК Пресс, 2024. – 636 с."
https://ashanpeiris.blogspot.com/2015/08/digital-design-of-systolic-array.html
