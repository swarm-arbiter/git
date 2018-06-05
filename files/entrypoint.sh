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

if [[ -f /home/git/admin.pub ]] ; then
		# If the admin.pub key exists then reset gitolite's admin key
		/bin/su -s /bin/sh -c 'gitolite setup -pk /home/git/admin.pub' git
else
		# Even if the admin key does not exist, ensure gitolite's internal
		# state is synced with the repositiories (eg, git hooks)
		/bin/su -s /bin/sh -c 'gitolite setup' git
fi

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
