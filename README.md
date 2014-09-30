Wraith
======
[Live example](http://hvz.xgallardo.com)

Source code for a website that can help run HvZ (Humans vs Zombies games). It has support for clans, timed mission unlocks, a player voting system, antiviruses, and achievements (badges). Built using AngularJS, and Rails-API, it comes out of the box with a token-based API that one can use to build their own applications on devices (e.g. iOS/Android).

### Setup
Necessary software:

* Vagrant 1.5+
* Vagrant provider (e.g. VirtualBox)
* Saltstack 0.17+

Steps:

1. Setup the VM. `vagrant up`

2. Log into the VM. `vagrant ssh`

3. Navigate to the shared VM folder. `cd /vagrant`

4. Copy and edit the provided .env file `cp .env.example .env`

5. Start the server processes. `foreman start`

### Additional Information

rsync has been enabled in the VM. Use `vagrant rsync-auto` to edit files outside the VM.

The web server is accessible at `localhost:3000` on the host machine.