
# UART

### Team members

* Martin Poč 
* Elena Melicharová 


## Theoretical description and explanation

UART znamená v překladu univerzální asynchronní přijímač/vysílač. Je to kousek hardwaru, který pomocí dvou pinů (většinou označovaných jako RX a TX) odesílá a přijímá data. Jelikož se jedná o asynchronní způsob komunikace, obsahuje přijímač i vysílač vlastní generátor hodinového signálu, kterým se UART řídí. A jelikož je UART univerzální, je také možné rychlost těchto hodin řídit.

## Hardware description of demo application

Blokové schéma našeho UART projektu:
![schema_projektu](https://user-images.githubusercontent.com/124675731/235494345-95cdc9f5-c5ab-4499-8648-8e219bd22079.png)


## Software description

Receiver:
This receiver is able to receive 8 bits of serial data, one start bit, one stop bit, and no parity bit.  When receive is complete o_rx_dv will be driven high for one clock cycle.

Transmitter:
This transmitter is able to transmit 8 bits of serial data, one start bit, one stop bit, and no parity bit.  When transmit is complete o_TX_Done will be driven high for one clock cycle.

### Component(s) simulation

Simulace projektu:

![simulace](https://user-images.githubusercontent.com/124675731/235498417-585c4e42-5c76-4d58-83c0-33b1e89fee9c.png)



## Instructions

### Reciever
1. Pripojte piny k desce
2. Mate k dispozici prvnich 8 switchu a jedno reset tlacitko uprostred.
3. K tomu je jeste 8 LED

### Transmitter
1. Pripojte piny k desce
2. Mate k dispozici prvnich 8 switchu a jedno reset tlacitko uprostred. 
3. K tomu je jeste 8 LED


## References

1. [UART a jeho definice](https://uart.cz/139/arduino-a-seriova-komunikace/)
2. ...
