Gandi LiveDDNS
==============

Available on [github](https://github.com/fmasclef/gandi-liveddns)

Purpose
-------

So you're hosting a tiny server on a residential network? I imagine your ISP uses DHCP leases. So you need a reliable dynamic DNS. Should you consider routing your own domain name registered at gandi.net, you're at the right place.

This bash script make use of `dig` and the Gandi LiveDNS API to keep your domain routred to your server.

Setup
-----

```
mkdir -p /data/git/gandi-liveddns
git clone https://github.com/fmasclef/gandi-liveddns /data/git/gandi-liveddns
```

You're almost done ;)

Run `gandi-liveddns-setup.sh` to create a configuration file or just `cp gandi-liveddns.conf.sample gandi-liveddns.conf` and edit the file.

You should use `cron` to make sure the script is actualy scheduled. You do **NOT** need root level privileges to run this script. Your cronjobs should look like:

```
@reboot /data/git/gandi-liveddns/gandi-liveddns.sh >>/var/log/gandi-liveddns.log 2>&1
*/5 * * * *  /data/git/gandi-liveddns/gandi-liveddns.sh >>/var/log/gandi-liveddns.log 2>&1
```
