# desktop - Agent Guide

This project delivers programs and configuration for my graphical user interface (desktop).

## Associated Projects

1. [`github.com/georglauterbach/hermes`](https://github.com/georglauterbach/hermes): Like this project, but for the command line
2. [`github.com/georglauterbach/evergruv`](https://github.com/georglauterbach/evergruv): My color scheme for everything
3. [`github.com/georglauterbach/linter`](https://github.com/georglauterbach/linter): A composite linter for all of my projects

## Repository Layout

| Path            | Purpose                                              |
| :-------------- | :--------------------------------------------------- |
| `.github/`      | GitHub-related content like CI/CD, issues, etc.      |
| `data/home/`    | files that go one-to-one into `${HOME}`              |
| `data/manuals/` | written manuals for all kinds of work on the desktop |
| `data/theme/`   | contains patches to the Yaru GTK theme for Evergruv  |
| `programs/`     | contains all code I build from source for my desktop |

## Custom-Built Programs

I build my most of my Wayland-based desktop applications, libraries and associated tools from source in a container. This container, described by [`programs/Containerfile`](./programs/Containerfile), uses scripts in [`programs/build_scripts/`](./programs/build_scripts/) to build projects like `wayland-protocols`, `SwayFx`, `Alacritty`, ..., when the container image itself is built. Afterwards, the content of the container's `/usr/local/` directory is copied onto the host file system and linked into the host's `/usr/local/` directory. The scripts to do that live in [`programs/scripts/`](./programs/scripts/).
