# linuxutils
Linux Utilities Container for Troubleshooting tasks

To run this with a locally mounted folder to persist data when working in the docker container run:

docker run -it -v "$(pwd)"/mydata:/tools/data andrewglass3/troubleshooter /bin/bash
