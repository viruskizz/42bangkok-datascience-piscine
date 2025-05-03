#!/bin/bash
USER=jovyan
DIR=/home/$USER/work/
chown $USER:users -R $DIR
chmod a+w -R $DIR