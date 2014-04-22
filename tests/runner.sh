#!/usr/bin/env sh
message() {
  printf "\e[1;34m:: \e[1;37m%s\e[0m\n" "$*"
}

failure() {
  printf "\n\e[1;31mFAILURE\e[0m: \e[1;37m%s\e[0m\n\n" "$*" >&2;
  continue
}

vagrant_destroy() {
  if [ -z "$KEEP_VM" ]; then
    vagrant destroy --force
  fi
}

message "Building latest scripts"
./bin/build.sh

for vagrantfile in tests/Vagrantfile.*; do
  message "Testing with $vagrantfile"

  ln -sf "$vagrantfile" ./Vagrantfile || failure 'Unable to link Vagrantfile'

  message 'Destroying and recreating virtual machine'
  vagrant_destroy
  vagrant up || failure 'Unable to start virtual machine'


	vagrant ssh -c 'echo vagrant | bash /vagrant/linux' \
		|| failure 'Installation script failed to run'

  vagrant ssh -c '[ "$SHELL" = "/usr/bin/zsh" ]' \
    || failure 'Installation did not set $SHELL to ZSH'

  go_version="go version go1.2.1 linux/386"

  vagrant ssh -c 'zsh -i -l -c "go version" | grep -Fq "$go_version"' \
    || failure 'Installation did not install the correct go'

	# TODO: Weitere Tests

  message "$vagrantfile tested successfully, shutting down VM"
  vagrant halt
  sleep 30
  vagrant_destroy
  sleep 30
done
