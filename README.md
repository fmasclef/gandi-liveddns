Gandi LiveDDNS
==============

Available on [github](https://github.com/fmasclef/gandi-liveddns)

Purpose
-------

So you're hosting a tiny server on a residential network? I imagine your ISP uses DHCP leases. So you need a reliable dynamic DNS. Should you consider routing your own domain name registered at gandi.net, you're at the right place.

This bash script make use of `dig` and the Gandi LiveDNS API to keep your domain routed to your server.

Setup
-----

```
git clone https://github.com/fmasclef/gandi-liveddns
./gandi-liveddns/gandi-liveddns.sh
```

You're done ;)

On first run, the script will create a `.config` file. You'll be prompted for your Gandi LiveDNS API key and a space separated list of FQDNs to update.

A cron job will be created to run the script every 5 minutes. You should use `crontab -l` to make sure the script is actualy scheduled. You do **NOT** need root level privileges to run this script.

Reconfigure
-----------

In the case you need to change something, just run the `--reconfigure` command line parameter:

```
./gandi-liveddns.sh --reconfigure
```

Enjoy.

