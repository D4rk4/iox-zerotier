##### Drop-in modern DMVPN replacement PoC based on ZeroTier and Cisco IOx

JumpStart on IOS XE side:
```
iox
!
 interface VirtualPortGroup0
 ip address 172.17.0.1 255.255.255.0
 ip nat inside
 description IOx network
!
 interface VirtualPortGroup1
 ip address 172.30.21.5 255.255.255.0
 ip ospf network broadcast
 description ZeroTier
 service-insertion waas
!
router ospf 1
 network 172.30.21.0 0.0.0.255 area 0
!
end
```
For join network modify network ID from changeme to real ID in package.yaml.example and rename it to package.yaml


Start session inside the container:
```app-hosting connect appid ZeroTier session```
