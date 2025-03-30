`timescale 1ns/10ps

package systolic_config_pkg;

typedef struct packed {
    int ADDR_WIDTH; // Ширина адресной шины
    int DATA_WIDTH; // Ширина шины данных
    int ARRAY_W;    // Количество строк в массиве
    int ARRAY_L;    // Количество столбцов в массиве
    int ARRAY_W_W;  // Количество строк в массиве весов
    int ARRAY_W_L;  // Количество столбцов в массиве весов
    int ARRAY_A_W;  // Количество строк в массиве данных
    int ARRAY_A_L;  // Количество столбцов в массиве данных
} systolic_config_t;

endpackage : systolic_config_pkg
