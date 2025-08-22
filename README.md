A container based systemd service in userspace for the pCloud console client.

- It uses the more actively maintained fork at https://github.com/lneely/pcloudcc-lneely

## How to use

1. Build the container first which builds *pcloudcc* from source (adjust for your timezone of course):

        podman build . -t pcloudcc --build-arg TZ=Europe/Berlin

2. Run the container interactively:

        podman run --rm -it --cap-add SYS_ADMIN --device /dev/fuse -v ~/.config/pcloudcc:/root/.pcloud pcloudcc bash

3. In the container, login to pCloud for the first time and let the password be stored in the DB (configured by the `-s` flag of the container CMD):

        pcloudcc -s -u user@example.com

   Use the command line arguments `-d` for running it in the background and `-k` for issuing sub-commands to set up sync folders.

4. Once the config is done and everything works as expected, stop the interactive container and install it with systemd by adjusting and copying `pcloudcc.container` to `~/.config/containers/systemd/pcloudcc.container` and

        systemctl --user daemon-reload
        systemctl --user start pcloudcc
