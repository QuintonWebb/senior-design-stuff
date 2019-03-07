/*
 * File:   test_code.c
 * Author: quint_000
 *
 * Created on October 17, 2018, 3:23 PM
 */


#include "../EE3310_2188_header.h"
#include <stdio.h>
#include <stdlib.h>
#include <p24EP32MC202.h>

#define enable  _RA0
#define data_in _RA1
#define clk     _RA2

int note = 1; // increments each cycle A=1, B=2, C=3, etc.
int chord[5][7]; // array that stores the intensity of each note 1 - 10
int dutyStage = 0;  // keeps track of the duty cycle stage 1 - 10
int count;

void ConfigIO(void){
    
    TRISA = 0b00000;           //All port A pins are outputs
    TRISB = 0x0000;            //All port B pins are outputs
    ANSELA = 0b00000;          //Analog OFF for Port A
    ANSELB = 0x0000;           //Analog OFF for Port B
    LATA = 0b00000;
    LATB = 0x0000;
}

void Timer1(void){
    T1CON = 0x0000;
    PR1 = 151;
    TMR1 = 0;
    _T1IP = 1;
    _T1IF = 0;
    _T1IE = 1;
}

void __attribute__((__interrupt__,no_auto_psv))_T1Interrupt(void){
    TMR1 = 0;
    _T1IF = 0;
    int i;
    
    if(chord[1][note] > dutyStage){
        data_in = 1;
    }
    else{
        data_in = 0;
    }
    
    for (i = 0; i<2; i++){}
    
    clk = 1;
    for (i = 0; i<2; i++){}
    clk = 0;
    for (i = 0; i<2; i++){}
    
    data_in = 0;
    for (i = 0; i<2; i++){}
    
    note++;
        
    if(note > 7){
        enable = 1;
        for (i = 0; i<2; i++){}
        enable = 0;

        note = 1;

        dutyStage++;

        if(dutyStage >= 10){
            dutyStage = 0; 
        }
    }
    
}




int main(void) {
    
    ConfigIO();
    Timer1();
    
chord[1][1] = 4;
chord[1][2] = 5;
chord[1][3] = 6;
chord[1][4] = 7;
chord[1][5] = 8;
chord[1][6] = 9;
chord[1][7] = 10;

    T1CONbits.TON = 1;
    
    while(1){}
    return 0;
}

