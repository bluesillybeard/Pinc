#pragma once

#include <pinc.h>
#include <pinc_graphics.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

// Start off with useful types and functions

typedef struct RGBAColor {
    float r;
    float g;
    float b;
    float a;
} RGBAColor;

typedef struct RealColor {
    float c1;
    float c2;
    float c3;
    float c4;
} RealColor;


typedef struct Example {
    void (* start)(void);
    void (* frame)(void);
    void (* deinit)(void);
    char* name;
    char* description;
} Example;

RealColor color_to_real(RGBAColor col, int channels);

/// @brief Collects errors from Pinc and prints them out.
/// @return 1 if there was a fatal error, 0 if not.
bool collect_errors(void);

void on_error_exit(void);

// delcare variables that all examples share

int window;

int frame;
