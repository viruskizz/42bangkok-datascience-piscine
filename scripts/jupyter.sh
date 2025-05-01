#!/bin/bash
USER=jovyan
DIR=/home/$USER/work/ds02
chown $USER:users -R $DIR
chmod a+w -R $DIR