#include <stdarg.h>
#include <stdio.h>
#include <stdbool.h>

void main_Grobbit_16__();

void Print(int n) {
    printf("%d\n", n);
}

void Print_F(double n) {
    printf("%lf\n", n);
}

void PrintN(int count, ...) {
    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; i++) {
        if (i > 0) {
            printf(" ");
        }
        int num = va_arg(args, int);
        printf("%d", num);
    }
    printf("\n");
    va_end(args);
}

void PrintN_F(int count, ...) {
    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; i++) {
        if (i > 0) {
            printf(" ");
        }
        double num = va_arg(args, double);
        printf("%lf", num);
    }
    printf("\n");
    va_end(args);
}


int main() {
    main_Grobbit_16__();
}
