#!/bin/bash

set -euo pipefail

NONROOT_USER=${NONROOT_USER:-ubuntu}
NONROOT_GROUP=${NONROOT_GROUP:-ubuntu}
NONROOT_UID=${NONROOT_UID:-1000}
NONROOT_GID=${NONROOT_GID:-1000}

# Check if the group already exists, if not create it
if getent group "$NONROOT_GROUP" > /dev/null 2>&1; then
  echo "Group $NONROOT_GROUP already exists"
else
  echo "Creating group $NONROOT_GROUP with GID $NONROOT_GID"
  groupadd -g "$NONROOT_GID" "$NONROOT_GROUP"
fi

# Check if the user already exists, if not create it
if id -u "$NONROOT_USER" > /dev/null 2>&1; then
  echo "User $NONROOT_USER already exists"
  # Add the user to the group if it's not already a member
  if id -nG "$NONROOT_USER" | grep -qw "$NONROOT_GROUP"; then
    echo "User $NONROOT_USER is already a member of group $NONROOT_GROUP"
  else
    echo "Adding user $NONROOT_USER to group $NONROOT_GROUP"
    usermod -aG "$NONROOT_GROUP" "$NONROOT_USER"
  fi
else
  echo "Creating user $NONROOT_USER with UID $NONROOT_UID and GID $NONROOT_GID"
  useradd -m -u "$NONROOT_UID" -g "$NONROOT_GID" -s /bin/bash "$NONROOT_USER"
fi

# Add sudoers settings
echo "$NONROOT_USER ALL=NOPASSWD: ALL" > "/etc/sudoers.d/${NONROOT_USER}"
chmod 440 "/etc/sudoers.d/${NONROOT_USER}"
visudo -c
