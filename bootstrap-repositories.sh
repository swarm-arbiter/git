#!/usr/bin/env bash
#
# This script bootstraps a gitolite repository directory where the
# user running the script is the admin

set -e

if [[ "$#" < 1 ]]; then
		echo "Usage: ${0} [output_directory]"
		exit 1
fi

OUTDIR=$(readlink --canonicalize ${1})

if [ ! -f ~/.ssh/id_rsa.pub ] || [ ! -f ~/.ssh/id_rsa.pub ]; then
		echo "Current user does not have an ssh key!"
		exit 1
fi

#############################################################
# Check if output directory already exists
if [[ -e $OUTDIR ]]; then
		echo "Output directory already exists, continuing will destroy the current contents"
	  read -r -p "Are you sure you wish to continue? [y/n]" response
		response=${response,,} # tolower
		if [[ ! $response =~ ^(yes|y|no|n) ]]; then
				echo "Invalid choice"
				exit 1
		fi

		if [[ ! $response =~ ^(yes|y) ]]; then
				echo "Operation aborted"
				exit 1
		fi

		sudo rm -rf $OUTDIR
fi

#############################################################
# Create working directory
WORKDIR=$(readlink --canonicalize "$(pwd)/.tmp.bootstrap.$(date +%s)")
mkdir -p ${WORKDIR}/gitolite-admin

cd ${WORKDIR}/gitolite-admin



#############################################################
# Setup gitolite admin repository
git init

mkdir conf
mkdir keydir

cat << EOF > conf/gitolite.conf
@admins = $(whoami)

repo gitolite-admin
    RW+ = @admins
EOF

cp ~/.ssh/id_rsa.pub "./keydir/$(whoami)@$(hostname).pub"

git add *
git commit -m "Create gitolite admin repository"

#############################################################
# Setup output directory
mkdir -p "${OUTDIR}/gitolite-admin.git"
cd "${OUTDIR}/gitolite-admin.git"

git clone --local --bare $WORKDIR/gitolite-admin .
echo "gitolite management repository" > description

#############################################################
# Cleanup
rm -rf $WORKDIR
