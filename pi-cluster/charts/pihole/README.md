
Architecture
------------

       router           browser
          │ 53              │ 8080
          ▼                 ▼
    ┌─────────────┐   ┌─────────────┐
    │ pihole-dns  │   │ pihole-web  │
    │ LB  53→53   │   │ LB 8080→80  │
    └──────┬──────┘   └──────┬──────┘
           └─── app=pihole ──┘
                   ▼ 
          ┌─────────────────┐
          │  deploy/pihole  │
          │  53/udp 53/tcp  │
          │  80/tcp         │
          └───────┬─────────┘
                  │ 
                  ├──▶ pvc/pihole           /etc/pihole
                  ├──▶ secret/pihole-admin  api password
                  └──▶ 1.1.1.1 ; 1.0.0.1    upstreams
