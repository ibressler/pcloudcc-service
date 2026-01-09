A container based systemd service in userspace for the pCloud console client.

- It uses the more actively maintained fork at https://github.com/lneely/pcloudcc-lneely

## How to use

1. Build the container first which builds *pcloudcc* from source (adjust for your timezone of course):

        podman build . -t pcloudcc --build-arg TZ=Europe/Berlin

2. Run the container interactively:

        podman run --rm -it --cap-add SYS_ADMIN --device /dev/fuse \
           -v ~/.config/pcloudcc:/root/.pcloud \
           -v /host_path_for_sync:/container_sync_path \
           pcloudcc bash

3. In the container, login to pCloud for the first time and let the password be stored in the DB (configured by the `-s` flag of the container CMD):

        pcloudcc -s -u user@example.com

   Use the command line arguments `-d` for running it in the background and `-k` for issuing sub-commands to set up sync folders:

    - For example, configure sync folders like this: In the interactive container session, run the daemon first (user credentials should be cached already) and connect to it with the command promnpt:
  
          pcloudcc -d -u user@example.com
          pcloudcc -k

      Output of the last command ('?' shows pcloudcc commands help):
      
          pCloud console client (git-lneely)
          pcloud> ?
          Supported commands are:
            help(?): Show this help message
            crypto(c):
              start <crypto pass>: Unlock crypto folder
              stop: Lock crypto folder
            sync(s):
              list(ls): List sync folders
              add <localpath> <remotepath>: Add sync folder
              remove(rm) <folderid>: Remove sync folder
            finalize(f): Kill daemon and quit
            quit(q): Exit this program
          pcloud>

      Configure the earlier given host path (`/host_path_for_sync`) to sync to remote pCloud folder `/my-host` (which has to exist already in pCloud!):

          sync add /container_sync_path /my-host

      Quit and stop the daemon and quit the interactive container session.
      It will be started again headless by the systemd unit in the next step:
      
          finalize

      ⯈ The sync path config is stored in pCloud client database and restarting pcloudcc container from service file below picks this up accordingly.

5. Once the config is done and everything works as expected, stop the interactive container and install it with systemd by adjusting and copying `pcloudcc.container` to `~/.config/containers/systemd/pcloudcc.container` and

        systemctl --user daemon-reload
        systemctl --user start pcloudcc
