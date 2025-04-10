# Remote Assistant Installer

This Home Assistant Addon installs and updates the Remote Assistant Custom Component. This can also be done via HACS or via a installation script.

Here you find the [main reprository of Remote Assistant](https://github.com/Looking4Cache/home-assistant-remote-assistant).

## What Remote Assistant is

Remote Assistant helps you to access your Home Assistant interface from anywhere. Without fixed IP addresses and VPN. An SSH tunnel is created between your local installation and the Remote-RED servers, allowing you to access it with our app from outside your local network.

Remote Assistant is a paid service from Remote-RED, an app that has already helped thousands of Node-RED users to use their dashboard on the go.

It's a lean, simple and affordable solution if you just want to access Home Assistant from the internet. It doesn't have the functionality of the Home Assistant app or Home Assistant Cloud and doesn't aim to.

## How to install this Installer Addon (for Home Assistant OS/Supervised)

There is a extra Addon to install Remote Assistant and keep it up to date. To install this Addon follow this steps:
- Add the reprository:
  - Use this button to add the reprository (maybe you have to insert your local Home Assistant IP adress)
[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FLooking4Cache%2Fhome-assistant-remote-assistant-installer)
  - Or add the reprository manually:
    - In Home Assistant, go to 'Settings > Add-ons' and open the 'Add-on Store'.
    - Click on the tree dots on to top right and use 'Repositories' to add https://github.com/Looking4Cache/home-assistant-remote-assistant-installer
- Search for 'Remote Assistant Installer' in the list and install it.
- After installing the Addon, start the Addon.
- The installation of the 'Remote Assistant Custom Component' will be executed automatically. See the protocol for more informations.

The Installer Addon will check every day for new versions of the Remote Assistant Custom Component.

After the installation and update of the Custom Component, a restart of Home Assistant is neccessary. This will be done automatically, but you can disable this in the configuration of the Addon.

## How to proceed from here

You can find instructions for the next steps (starting the Custom Componant and using the apps) as well as the other ways to install the Custom Componant at the main reprository: https://github.com/Looking4Cache/home-assistant-remote-assistant