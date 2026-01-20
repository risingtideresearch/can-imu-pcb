# CAN IMU

A carrier PCB for a Microstrain 3DM-CV7 Inertial Measurement Unit to act as a CAN / NMEA 2000
device.

It is designed to fit in the Hammond [1554E2GY](https://www.hammfg.com/part/1554E2GY) enclosure.

## Assembly

The BOM can be found [here](output/CAN_IMU_rev1_BOM.csv), and includes most parts, but there are
some additional parts not included there:

- The case: Hammond 1554E2GY
- Brass solderable nuts for securing the microstrain: SMTSOB-256-2ET (qty 3)
- M3x8 screws for securing the PCB in the enclosure
- M12 connector: [T4130012051-000](https://www.digikey.com/en/products/detail/te-connectivity-amp-connectors/T4130012051-000/7927438)
- 5-pin PH connector housing for wiring the M12 to the board:
  [PHR-5](https://www.digikey.com/en/products/detail/jst-sales-america-inc/PHR-5/608605) (plus the
  appropriate crimp pins or pre-crimped wires)
