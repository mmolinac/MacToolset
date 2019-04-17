# MacToolset
Script to autoconfigure a fresh installed Mac desktop (ElCapitan or later) with my minimum toolset

The script will do the following things:

1. Install [Xcode command line developer tools](https://developer.apple.com/download/more/?=command%20line%20tools), if not already installed
2. Install [Brew](https://brew.sh)
3. Install my personal toolset of choice with the tool named above.
4. Will try to install [Slack](https://slack.com) from the App Store if you are already logged in.

Important remarks:

- [Docker Desktop for Mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac) is installed in hardware from 2010 onwards. For older Intel Macs, [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_mac/) will be installed instead.
- [XQuartz](https://www.xquartz.org/) is required by [Inkscape](https://inkscape.org) to work.
- On laptop computers, [coconutBattery](https://www.coconut-flavour.com/coconutbattery/) will be installed to monitor battery life and other details.