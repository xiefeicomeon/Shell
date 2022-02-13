#!/bin/bash
cd /home/smart/update_SSH/6366-WQJK-security
./6366-security-WQJK.sh
./forbid.sh
./modify_rc.local.sh



cd /home/smart
rm -rf update_SSH

