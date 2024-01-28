#!/bin/bash
#script auto nftabnles


echo -e "
#!/usr/sbin/nft -f

flush ruleset


table inet filter {
        chain input {
                type filter hook input priority filter; policy accept;
                        tcp dport { 22 , 80 , 443 } iifname "enp0s3" accept
        } w

        chain forward {
                type filter hook forward priority filter; policy accept;
                        ip saddr 10.10.10.0/24 iifname "enp0s9" oifname "enp0s8" icmp type echo-request counter drop;
                        ip daddr 10.10.10.0/24 iifname "enp0s8" oifname "enp0s9" icmp type echo-reply counter drop;


                        # DMZ a Internet (ICMP)
                        ip saddr 10.10.10.0/24 iifname "enp0s9" oifname "enp0s3" icmp type echo-request counter accept;
                        ip daddr 10.10.10.0/24 iifname "enp0s3" oifname "enp0s9" icmp type echo-reply counter accept;

                        # Block SSH to LAN from DMZ
                        ip saddr 10.10.10.0/24 iifname "enp0s9" oifname "enp0s8" tcp dport 22 counter drop;
                        ip daddr 10.10.10.0/24 iifname "enp0s8" oifname "enp0s9" icmp type echo-reply counter drop;
        }
        chain output {
                type filter hook output priority filter; policy accept;
        }

}
table ip nat {

        chain prerouting {
                type nat hook prerouting priority 100; policy accept;
                        iifname "enp0s3" tcp dport { 22 , 80 , 443 } counter dnat to 10.10.10.20;
        }

        chain postrouting {
                type nat hook postrouting priority 100; policy accept;
                        oifname "enp0s3" masquerade;

        }
}






"