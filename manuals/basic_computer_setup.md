# Basic Setup

## UEFI

1. Update to the latest UEFI version for your motherboard
2. With an AMD CPU,
    1. Enable [EXPO](https://www.amd.com/en/products/processors/technologies/expo.html)
        - you do this in the UEFI settings
        - this can also be done via [Ryzen Master](https://www.amd.com/en/products/software/ryzen-master.html)
    2. Enable ReBAR (also branded as "Smart Access Memory")
        - you do this in the UEFI settings
        - run `sudo dmesg | grep -F 'BAR='` and check that `BAR >= RAM`
    3. Undervolt the CPU
        - this can be done via [Ryzen Master](https://www.amd.com/en/products/software/ryzen-master.html)

## OS

Use Linux. I typically choose

1. the latest version of Ubuntu Desktop with a minimal installation of GNOME if a GUI is required,
2. Ubuntu LTS Server otherwise.

## User-Space

I install [`georglauterbach/hermes`](https://github.com/georglauterbach/hermes) on all machines I use. I typically also copy the whole or parts of the [example configurations from this repository](https://github.com/georglauterbach/hermes/tree/main/data/examples).

To set up my GUI, I run the [`install.sh` script](../install.sh) from this repository.
