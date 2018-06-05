#!/bin/sh

set -e

# Generate SSH HostKeys if they do not exist
# Note these are in a subdirectory of /etc/ssh (requiring non-standard
# sshd_config) such that they may be sourced from a volumn on the host
# so that host keys do not change when the container is restarted
for ALG in rsa dsa ecdsa ed25519; do
		if [[ ! -f "/etc/ssh/hostkeys/ssh_host_${ALG}_key" ]] ; then
				echo "Generating host key for ${ALG}"
				ssh-keygen -t ${ALG} -f "/etc/ssh/hostkeys/ssh_host_${ALG}_key" -N ''
		fi
done

# Ensure everything in git's home is owned by git user
chown -R git:git /home/git

if [[ ! -d /home/git/repositories/gitolite-admin.git ]]; then
		echo "FATAL: Repositories volume is not mounted or is empty"
		echo "       You may bootstrap a repository volume by running the script:"
		echo "         bootstrap-repositories.sh"
		echo "       on the host, then using the output_directory as the volume"
		exit 1
fi

if [ ! -d /home/git/repositories/.gitolite ] ; then
		echo "Bootstrapping gitolite..."

		# Preserve existing admin repo, since gitolite setup will overwrite it
		mv /home/git/repositories/gitolite-admin.git /home/git/repositories/gitolite-admin.git-tmp

		# Setup gitolite with dummy user as having admin access
		/bin/su -s /bin/sh -c 'gitolite setup -a dummy' git

		# Ensure log directory exists
		/bin/su -s /bin/sh -c 'mkdir -p /home/git/.gitolite/logs' git

		# Replace gitolite generated admin repo with our own
		rm -r /home/git/repositories/gitolite-admin.git
		mv /home/git/repositories/gitolite-admin.git-tmp /home/git/repositories/gitolite-admin.git

		# Reset up hooks
		su git -c "gitolite setup --hooks-only"

		# Regenerate authorized_keys file based on the new admin repo
		# Done by triggering the post-update hook
		su git -c "cd /home/git/repositories/gitolite-admin.git && GL_LIBDIR=$(gitolite query-rc GL_LIBDIR) PATH=$PATH:/home/git/bin hooks/post-update refs/heads/master"

		# Clean up the auto-generated testing repository
		rm -rf /home/git/repositories/testing.git

		echo "Completed gitolite bootstrap!"
fi

# Ensure internal gitolite status is syned with config/hooks in repositories
/bin/su -s /bin/sh -c 'gitolite setup' git


printf "\n\n"
printf "+===========================================\n"
printf "| Completed git-server setup\n"
printf "+-------------------------------------------\n"
printf "| Container Version : "
cat /VERSION
printf "\n"
printf "| Gitolite Version  : "
cat /usr/lib/gitolite/VERSION
printf "| Launch command    : ${@}\n"
printf "| Hostname          : $HOSTNAME\n"
printf "| Local ip          : $(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')\n"
printf "+===========================================\n"
printf "\n\n"

if [[ ${1} = 'sshd' ]]; then
		echo "Starting ssh server..."
		exec /usr/sbin/sshd -D
elif [[ ${1} = 'sh' ]]; then
		echo "Starting interactive shell..."
		exec /bin/sh
else
		echo "Starting custom process..."
		exec "${@}"
fi
