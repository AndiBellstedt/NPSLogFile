﻿#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Modul "NPSLogFile"
# Author:  Andreas Bellstedt

#region type defintion
#---------------------
Add-Type -TypeDefinition @"
namespace NPS {
    namespace LogFile {
        public static class Cache {
            public static System.Collections.Hashtable Data = new System.Collections.Hashtable();
        }

        public static class Lookup {
            public static System.Collections.Hashtable AuthenticationSource = new System.Collections.Hashtable();
            public static System.Collections.Hashtable AuthenticationTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable FilterPacketTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable NasPortTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable PacketTypes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable ReasonCodes = new System.Collections.Hashtable();
            public static System.Collections.Hashtable IasAttributeTypes = new System.Collections.Hashtable();
        }
    }
}
"@

#endregion type defintion


#region Constants
#--------------------------
New-Variable -Option ReadOnly, Constant -Scope Script -Name BaseType -Value "NPS.LogFile"

[NPS.LogFile.Lookup]::FilterPacketTypes = @{
    'Access-Request'                             = 1
    'Access-Accept'                              = 2
    'Access-Reject'                              = 3
    'Accounting-Request'                         = 4
    'Accounting-Response'                        = 5
    'Accounting-Status (now Interim Accounting)' = 6
    'Password-Request'                           = 7
    'Password-Ack'                               = 8
    'Password-Reject'                            = 9
    'Accounting-Message'                         = 10
    'Access-Challenge'                           = 11
    'Status-Server (experimental)'               = 12
    'Status-Client (experimental)'               = 13
    'Resource-Free-Request'                      = 21
    'Resource-Free-Response'                     = 22
    'Resource-Query-Request'                     = 23
    'Resource-Query-Response'                    = 24
    'Alternate-Resource-Reclaim-Request'         = 25
    'NAS-Reboot-Request'                         = 26
    'NAS-Reboot-Response'                        = 27
    'Reserved'                                   = @(28, 254, 255)
    'Next-Passcode'                              = 29
    'New-Pin'                                    = 30
    'Terminate-Session'                          = 31
    'Password-Expired'                           = 32
    'Event-Request'                              = 33
    'Event-Response'                             = 34
    #35-39 = 'Unassigned'
    'Disconnect-Request'                         = 40
    'Disconnect-ACK'                             = 41
    'Disconnect-NAK'                             = 42
    'CoA-Request'                                = 43
    'CoA-ACK'                                    = 44
    'CoA-NAK'                                    = 45
    #46-49 = 'Unassigned'
    'IP-Address-Allocate'                        = 50
    'IP-Address-Release'                         = 51
    'Protocol-Error'                             = 52
    #53-249 = 'Unassigned'
    'Experimental Use'                           = @(250, 251, 252, 253)
}

#http://www.iana.org/assignments/radius-types/radius-types.xhtml
[NPS.LogFile.Lookup]::PacketTypes = @{
    1   = 'Access-Request'
    2   = 'Access-Accept'
    3   = 'Access-Reject'
    4   = 'Accounting-Request'
    5   = 'Accounting-Response'
    6   = 'Accounting-Status (now Interim Accounting)'
    7   = 'Password-Request'
    8   = 'Password-Ack'
    9   = 'Password-Reject'
    10  = 'Accounting-Message'
    11  = 'Access-Challenge'
    12  = 'Status-Server (experimental)'
    13  = 'Status-Client (experimental)'
    21  = 'Resource-Free-Request'
    22  = 'Resource-Free-Response'
    23  = 'Resource-Query-Request'
    24  = 'Resource-Query-Response'
    25  = 'Alternate-Resource-Reclaim-Request'
    26  = 'NAS-Reboot-Request'
    27  = 'NAS-Reboot-Response'
    28  = 'Reserved'
    29  = 'Next-Passcode'
    30  = 'New-Pin'
    31  = 'Terminate-Session'
    32  = 'Password-Expired'
    33  = 'Event-Request'
    34  = 'Event-Response'
    #35-39 = 'Unassigned'
    40  = 'Disconnect-Request'
    41  = 'Disconnect-ACK'
    42  = 'Disconnect-NAK'
    43  = 'CoA-Request'
    44  = 'CoA-ACK'
    45  = 'CoA-NAK'
    #46-49 = 'Unassigned'
    50  = 'IP-Address-Allocate'
    51  = 'IP-Address-Release'
    52  = 'Protocol-Error'
    #53-249 = 'Unassigned'
    250 = 'Experimental Use'
    251 = 'Experimental Use'
    252 = 'Experimental Use'
    253 = 'Experimental Use'
    254 = 'Reserved'
    255 = 'Reserved'
}

#http://www.iana.org/assignments/radius-types/radius-types.xhtml
[NPS.LogFile.Lookup]::ReasonCodes = @{
    0  = "IAS_SUCCESS"
    1  = "IAS_INTERNAL_ERROR"
    2  = "IAS_ACCESS_DENIED"
    3  = "IAS_MALFORMED_REQUEST"
    4  = "IAS_GLOBAL_CATALOG_UNAVAILABLE"
    5  = "IAS_DOMAIN_UNAVAILABLE"
    6  = "IAS_SERVER_UNAVAILABLE"
    7  = "IAS_NO_SUCH_DOMAIN"
    8  = "IAS_NO_SUCH_USER"
    16 = "IAS_AUTH_FAILURE"
    17 = "IAS_CHANGE_PASSWORD_FAILURE"
    18 = "IAS_UNSUPPORTED_AUTH_TYPE"
    32 = "IAS_LOCAL_USERS_ONLY"
    33 = "IAS_PASSWORD_MUST_CHANGE"
    34 = "IAS_ACCOUNT_DISABLED"
    35 = "IAS_ACCOUNT_EXPIRED"
    36 = "IAS_ACCOUNT_LOCKED_OUT"
    37 = "IAS_INVALID_LOGON_HOURS"
    38 = "IAS_ACCOUNT_RESTRICTION"
    48 = "IAS_NO_POLICY_MATCH"
    64 = "IAS_DIALIN_LOCKED_OUT"
    65 = "IAS_DIALIN_DISABLED"
    66 = "IAS_INVALID_AUTH_TYPE"
    67 = "IAS_INVALID_CALLING_STATION"
    68 = "IAS_INVALID_DIALIN_HOURS"
    69 = "IAS_INVALID_CALLED_STATION"
    70 = "IAS_INVALID_PORT_TYPE"
    71 = "IAS_INVALID_RESTRICTION"
    80 = "IAS_NO_RECORD"
    96 = "IAS_SESSION_TIMEOUT"
    97 = "IAS_UNEXPECTED_REQUEST"
}

[NPS.LogFile.Lookup]::AuthenticationTypes = @{
    1  = "PAP"
    2  = "CHAP"
    3  = "MS-CHAP"
    4  = "MS-CHAP v2"
    5  = "EAP"
    7  = "None"
    8  = "Custom"
    11 = "PEAP"
}

[NPS.LogFile.Lookup]::NasPortTypes = @{
    0  = "Async"
    1  = "Sync"
    2  = "ISDN Sync"
    3  = "ISDN Async V.120"
    4  = "ISDN Async V.110"
    5  = "Virtual"
    6  = "PIAFS"
    7  = "HDLC Clear Channel"
    8  = "X.25"
    9  = "X.75"
    10 = "G.3 Fax"
    11 = "SDSL - Symmetric DSL"
    12 = "ADSL-CAP - Asymmetric DSL, Carrierless Amplitude Phase Modulation"
    13 = "ADSL-DMT - Asymmetric DSL, Discrete Multi-Tone"
    14 = "IDSL - ISDN Digital Subscriber Line"
    15 = "Ethernet"
    16 = "xDSL - Digital Subscriber Line of unknown type"
    17 = "Cable"
    18 = "Wireless - Other"
    19 = "Wireless - IEEE 802.11"
    20 = "Token-Ring"
    21 = "FDDI"
    22 = "Wireless - CDMA2000"
    23 = "Wireless - UMTS"
    24 = "Wireless - 1X-EV"
    25 = "IAPP"
    26 = "FTTP - Fiber to the Premises"
    27 = "Wireless - IEEE 802.16"
    28 = "Wireless - IEEE 802.20"
    29 = "Wireless - IEEE 802.22"
    30 = "PPPoA - PPP over ATM"
    31 = "PPPoEoA - PPP over Ethernet over ATM"
    32 = "PPPoEoE - PPP over Ethernet over Ethernet"
    33 = "PPPoEoVLAN - PPP over Ethernet over VLAN"
    34 = "PPPoEoQinQ - PPP over Ethernet over IEEE 802.1QinQ"
    35 = "xPON - Passive Optical Network"
    36 = "Wireless - XGP"
    37 = "WiMAX Pre-Release 8 IWK Function"
    38 = "WIMAX-WIFI-IWK: WiMAX WIFI Interworking"
    39 = "WIMAX-SFF: Signaling Forwarding Function for LTE/3GPP2"
    40 = "WIMAX-HA-LMA: WiMAX HA and or LMA function"
    41 = "WIMAX-DHCP: WIMAX DCHP service"
    42 = "WIMAX-LBS: WiMAX location based service"
    43 = "WIMAX-WVS: WiMAX voice service"
}

[NPS.LogFile.Lookup]::AuthenticationSource = @{
    0 = "None"
    1 = "Windows"
    2 = "Radius Proxy"
}

<#
http://www.iana.org/assignments/radius-types/radius-types.xhtml
https://technet.microsoft.com/de-de/library/dd197432(v=ws.10).aspx
http://www.radiusreporting.com/IAS-Standard-Vendor-Specific-Attribute-Table.html
http://www.radiusreporting.com/IAS-Standard-Attribute-Table.html
http://www.deepsoftware.com/iasviewer/attributeslist.html
#>
[NPS.LogFile.Lookup]::IasAttributeTypes = @{
    "-91"  = "EAP-Protocol"
    "-90"  = "MS-MPPE-Encryption-Types"
    "-89"  = "MS-MPPE-Encryption-Policy"
    "-88"  = "MS-BAP-Usage"
    "-87"  = "MS-Link-Drop-Time-Limit"
    "-86"  = "MS-Link-Utilization-Threshold"
    "-85"  = "Allowed-Port-Type"
    "1"    = "User-Name"
    "2"    = "User-Password"
    "3"    = "CHAP-Password"
    "4"    = "NAS-IP-Address"
    "5"    = "NAS-Port"
    "6"    = @{
        Name       = "Service-Type"
        Enumerator = @{
            "1"  = "Login"
            "2"  = "Framed"
            "3"  = "Callback Login"
            "4"  = "Callback Framed"
            "5"  = "Outbound"
            "6"  = "Administrative"
            "7"  = "NAS Prompt"
            "8"  = "Authenticate Only"
            "9"  = "Callback Nas Prompt"
            "10" = "Call Check"
            "11" = "Callback Administrative"
            "12" = "Authorize only"
            "13" = "Fax"
            "14" = "Modem Relay"
            "15" = "IAPP-Register"
            "16" = "IAPP-AP-Check"
            "17" = "Authorize Only"
            "18" = "Framed-Management"
            "19" = "Additional-Authorization"
        }
    }
    "7"    = @{
        Name       = "Framed-Protocol"
        Enumerator = @{
            "1"   = "PPP"
            "2"   = "SLIP"
            "3"   = "AppleTalk Remote Access Protocol (ARAP)"
            "4"   = "Gandalf Proprietary SingleLink/MultiLink protocol"
            "5"   = "Xylogics proprietary IPX/SLIP"
            "6"   = "X.75 Synchronous"
            "7"   = "GPRS PDP Context"
            "256" = "MPP"
            "257" = "EURAW"
            "258" = "EUUI"
            "259" = "X25"
            "260" = "COMB"
            "261" = "FR"
        }
    }
    "8"    = "Framed-IP-Address"
    "9"    = "Framed-IP-Netmask"
    "10"   = @{
        Name       = "Framed-Routing"
        Enumerator = @{
            "0" = "None"
            "1" = "Send routing packets"
            "2" = "Listen for routing packets"
            "3" = "Send and Listen"
        }
    }
    "11"   = "Filter-Id"
    "12"   = "Framed-MTU"
    "13"   = @{
        Name       = "Framed-Compression"
        Enumerator = @{
            "0" = "None"
            "1" = "Van Jacobson TCP/IP header compression"
            "2" = "IPX Header compression"
            "3" = "Stac-LZS compression"
        }
    }
    "14"   = "Login-IP-Host"
    "15"   = @{
        Name       = "Login-Service"
        Enumerator = @{
            "0" = "Telnet"
            "1" = "Rlogin"
            "2" = "TCP Clear"
            "3" = "Portmaster (proprietary)"
            "4" = "LAT"
            "5" = "X25-PAD"
            "6" = "X25-T3POS"
            "8" = "TCP Clear Quiet (suppresses any NAS-generated connect string)"
        }
    }
    "16"   = "Login-TCP-Port"
    "18"   = "Reply-Message"
    "19"   = "Callback-Number"
    "20"   = "Callback-Id"
    "22"   = "Framed-Route"
    "23"   = "Framed-IPX-Network"
    "24"   = "State"
    "25"   = "Class"
    "26"   = "Vendor-Specific"
    "27"   = "Session-Timeout"
    "28"   = "Idle-Timeout"
    "29"   = @{
        Name       = "Termination-Action"
        Enumerator = @{
            "0" = "Default"
            "1" = "RADIUS-Request"
        }
    }
    "30"   = "Called-Station-Id"
    "31"   = "Calling-Station-Id"
    "32"   = "NAS-Identifier"
    "33"   = "Proxy-State"
    "34"   = "Login-LAT-Service"
    "35"   = "Login-LAT-Node"
    "36"   = "Login-LAT-Group"
    "37"   = "Framed-AppleTalk-Link"
    "38"   = "Framed-AppleTalk-Network"
    "39"   = "Framed-AppleTalk-Zone"
    "40"   = @{
        Name       = "Acct-Status-Type"
        Enumerator = @{
            "1"  = "Start"
            "2"  = "Stop"
            "3"  = "Interim Update"
            "7"  = "Accounting-On"
            "8"  = "Accounting-Off"
            "9"  = "Tunnel-Start"
            "10" = "Tunnel-Stop"
            "11" = "Tunnel-Reject"
            "12" = "Tunnel-Link-Start"
            "13" = "Tunnel-Link-Stop"
            "14" = "Tunnel-Link-Reject"
            "15" = "Failed"
        }
    }
    "41"   = "Acct-Delay-Time"
    "42"   = "Acct-Input-Octets"
    "43"   = "Acct-Output-Octets"
    "44"   = "Acct-Session-Id"
    "45"   = @{
        Name       = "Acct-Authentic"
        Enumerator = @{
            "0" = "None"
            "1" = "RADIUS"
            "2" = "Local"
            "3" = "Remote"
            "4" = "Diameter"
        }
    }
    "46"   = "Acct-Session-Time"
    "47"   = "Acct-Input-Packets"
    "48"   = "Acct-Output-Packets"
    "49"   = @{
        Name       = "Acct-Terminate-Cause"
        Enumerator = @{
            "1"  = "User Request"
            "2"  = "Lost Carrier"
            "3"  = "Lost Service"
            "4"  = "Idle Timeout"
            "5"  = "Session Timeout"
            "6"  = "Admin Reset"
            "7"  = "Admin Reboot"
            "8"  = "Port Error"
            "9"  = "NAS Error"
            "10" = "NAS Request"
            "11" = "NAS Reboot"
            "12" = "Port Unneeded"
            "13" = "Port Preempted"
            "14" = "Port Suspended"
            "15" = "Service Unavailable"
            "16" = "Callback"
            "17" = "User Error"
            "18" = "Host Request"
            "19" = "Supplicant Restart"
            "20" = "Reauthentication Failure"
            "21" = "Port Reinitialized"
            "22" = "Port Administratively Disabled"
            "23" = "Lost Power"
        }
    }
    "50"   = "Acct-Multi-Session-Id"
    "51"   = "Acct-Link-Count"
    "52"   = "Acct-Input-Gigawords"
    "53"   = "Acct-Output-Gigawords"
    "55"   = "Event-Timestamp"
    "60"   = "CHAP-Challenge"
    "61"   = @{
        Name       = "NAS-Port-Type"
        Enumerator = @{
            "0"  = "Async"
            "1"  = "Sync"
            "2"  = "ISDN Sync"
            "3"  = "ISDN Async V.120"
            "4"  = "ISDN Async V.110"
            "5"  = "Virtual"
            "6"  = "PIAFS"
            "7"  = "HDLC Clear Channel"
            "8"  = "X.25"
            "9"  = "X.75"
            "10" = "G.3 Fax"
            "11" = "SDSL - Symmetric DSL"
            "12" = "ADSL-CAP - Asymmetric DSL, Carrierless Amplitude Phase Modulation"
            "13" = "ADSL-DMT - Asymmetric DSL, Discrete Multi-Tone"
            "14" = "IDSL - ISDN Digital Subscriber Line"
            "15" = "Ethernet"
            "16" = "xDSL - Digital Subscriber Line of unknown type"
            "17" = "Cable"
            "18" = "Wireless - Other"
            "19" = "Wireless - IEEE 802.11"
            "20" = "Token-Ring"
            "21" = "FDDI"
            "22" = "Wireless - CDMA2000"
            "23" = "Wireless - UMTS"
            "24" = "Wireless - 1X-EV"
            "25" = "IAPP"
            "26" = "FTTP - Fiber to the Premises"
            "27" = "Wireless - IEEE 802.16"
            "28" = "Wireless - IEEE 802.20"
            "29" = "Wireless - IEEE 802.22"
            "30" = "PPPoA - PPP over ATM"
            "31" = "PPPoEoA - PPP over Ethernet over ATM"
            "32" = "PPPoEoE - PPP over Ethernet over Ethernet"
            "33" = "PPPoEoVLAN - PPP over Ethernet over VLAN"
            "34" = "PPPoEoQinQ - PPP over Ethernet over IEEE 802.1QinQ"
            "35" = "xPON - Passive Optical Network"
            "36" = "Wireless - XGP"
            "37" = "WiMAX Pre-Release 8 IWK Function"
            "38" = "WIMAX-WIFI-IWK: WiMAX WIFI Interworking"
            "39" = "WIMAX-SFF: Signaling Forwarding Function for LTE/3GPP2"
            "40" = "WIMAX-HA-LMA: WiMAX HA and or LMA function"
            "41" = "WIMAX-DHCP: WIMAX DCHP service"
            "42" = "WIMAX-LBS: WiMAX location based service"
            "43" = "WIMAX-WVS: WiMAX voice service"
        }
    }
    "62"   = "Port-Limit"
    "63"   = "Login-LAT-Port"
    "64"   = @{
        Name       = "Tunnel-Type"
        Enumerator = @{
            "1"     = "Point-to-Point Tunneling Protocol (PPTP)"
            "2"     = "Layer Two Forwarding (L2F)"
            "3"     = "Layer Two Tunneling Protocol (L2TP)"
            "4"     = "Ascend Tunnel Management Protocol (ATMP)"
            "5"     = "Virtual Tunneling Protocol (VTP)"
            "6"     = "IP Authentication Header in the Tunnel-mode (AH)"
            "7"     = "IP-in-IP Encapsulation (IP-IP)"
            "8"     = "Minimal IP-in-IP Encapsulation (MIN-IP-IP)"
            "9"     = "IP Encapsulating Security Payload in the Tunnel-mode (ESP)"
            "10"    = "Generic Route Encapsulation (GRE)"
            "11"    = "Bay Dial Virtual Services (DVS)"
            "12"    = "IP-in-IP Tunneling"
            "13"    = "Virtual LANs (VLAN)"
            "79617" = "Secure Socket Tunneling Protocol (SSTP)"            
        }
    }
    "65"   = @{
        Name       = "Tunnel-Medium-Type"
        Enumerator = @{
            "1"  = "IP (IP version 4)"
            "2"  = "IP6 (IP version 6)"
            "3"  = "NSAP"
            "4"  = "HDLC (8-bit multidrop)"
            "5"  = "BBN 1822"
            "6"  = "802 (includes all 802 media plus Ethernet canonical format)"
            "7"  = "E.163 (POTS)"
            "8"  = "E.164 (SMDS Frame Relay ATM)"
            "9"  = "F.69 (Telex)"
            "10" = "X.121 (X.25 Frame Relay)"
            "11" = "IPX"
            "12" = "Appletalk"
            "13" = "Decnet IV"
            "14" = "Banyan Vines"
            "15" = "E.164 with NSAP format subaddress"
        }
    }
    "66"   = "Tunnel-Client-Endpt"
    "67"   = "Tunnel-Server-Endpt"
    "68"   = "Acct-Tunnel-Connection"
    "69"   = "Tunnel-Password"
    "70"   = "ARAP-Password"
    "71"   = "ARAP-Features"
    "72"   = @{
        Name       = "ARAP-Zone-Access"
        Enumerator = @{
            "1" = "Only allow access to default zone"
            "2" = "Use zone filter inclusively"
            "3" = "(not used)"
            "4" = "Use zone filter exclusively"
        }
    }
    "73"   = "ARAP-Security"
    "74"   = "ARAP-Security-Data"
    "75"   = "Password-Retry"
    "76"   = @{
        Name       = "Prompt"
        Enumerator = @{
            "0" = "No Echo"
            "1" = "Echo"
        }
    }
    "77"   = "Connect-Info"
    "78"   = "Configuration-Token"
    "79"   = "EAP-Message"
    "80"   = "Message-Authenticator"
    "81"   = "Tunnel-Pvt-Group-ID"
    "82"   = "Tunnel-Assignment-ID"
    "83"   = "Tunnel-Preference"
    "84"   = "ARAP-Challenge-Response"
    "85"   = "Acct-Interim-Interval"
    "86"   = "Acct-Tunnel-Packets-Lost"
    "87"   = "NAS-Port-Id"
    "88"   = "Framed-Pool"
    "90"   = "Tunnel-Client-Auth-ID"
    "91"   = "Tunnel-Server-Auth-ID"
    "95"   = "NAS-IPv6-Address"
    "96"   = "Framed-Interface-Id"
    "97"   = "Framed-IPv6-Prefix"
    "98"   = "Login-IPv6-Host"
    "99"   = "Framed-IPv6-Route"
    "100"  = "Framed-IPv6-Pool"
    "101"  = @{
        Name       = "Error-Cause"
        Enumerator = @{
            "201" = "Residual Session Context Removed"
            "202" = "Invalid EAP Packet (Ignored)"
            "401" = "Unsupported Attribute"
            "402" = "Missing Attribute"
            "403" = "NAS Identification Mismatch"
            "404" = "Invalid Request"
            "405" = "Unsupported Service"
            "406" = "Unsupported Extension"
            "407" = "Invalid Attribute Value"
            "501" = "Administratively Prohibited"
            "502" = "Request Not Routable (Proxy)"
            "503" = "Session Context Not Found"
            "504" = "Session Context Not Removable"
            "505" = "Other Proxy Processing Error"
            "506" = "Resources Unavailable"
            "507" = "Request Initiated"
            "508" = "Multiple Session Selection Unsupported"
            "509" = "Location-Info-Required"
            "601" = "Response Too Big"
        }
    }
    "102"  = "EAP-Key-Name"
    "107"  = "Ascend-Calling-Subaddress"
    "108"  = "Ascend-Callback-Delay"
    "109"  = "Ascend-Endpoint-Disc"
    "110"  = "Ascend-Remote-FW"
    "111"  = "Ascend-Multicast-G-Leave-Delay"
    "112"  = "Ascend-CBCP-Enable"
    "113"  = "Ascend-CBCP-Mode"
    "114"  = "Ascend-CBCP-Delay"
    "115"  = "Ascend-CBCP-Trunk-Group"
    "116"  = "Ascend-Appletalk-Route"
    "117"  = "Ascend-Appletalk-Peer-Mode"
    "118"  = "Ascend-Route-Appletalk"
    "119"  = "Ascend-FCP-Parameter"
    "120"  = "Ascend-Modem-Port-No"
    "121"  = "Ascend-Modem-Slot-No"
    "122"  = "Ascend-Modem-Shelf-No"
    "123"  = "Ascend-CallAttempt-Limit"
    "124"  = "Ascend-CallBlock-Duration"
    "125"  = "Ascend-Maximum-Call-Duration"
    "126"  = "Ascend-Route-Preference"
    "127"  = "Ascend-Tunneling-Protocol"
    "128"  = "Ascend-Shared-Profile-Enable"
    "129"  = "Ascend-Primary-Home-Agent"
    "130"  = "Ascend-Secondary-Home-Agent"
    "131"  = "Ascend-Dialout-Allowed"
    "132"  = "Ascend-Client-Gateway"
    "133"  = "Ascend-BACP-Enable"
    "134"  = "Ascend-DHCP-Maximum-Leases"
    "135"  = "Ascend-Client-Primary-DNS"
    "136"  = "Ascend-Client-Secondary-DNS"
    "137"  = "Ascend-Client-Assign-DNS"
    "138"  = "Ascend-User-Acct-Type"
    "139"  = "Ascend-User-Acct-Host"
    "140"  = "Ascend-User-Acct-Port"
    "141"  = "Ascend-User-Acct-Key"
    "142"  = "Ascend-User-Acct-Base"
    "143"  = "Ascend-User-Acct-Time"
    "144"  = "Ascend-Assign-IP-Client"
    "145"  = "Ascend-Assign-IP-Server"
    "146"  = "Ascend-Assign-IP-Global-Pool"
    "147"  = "Ascend-DHCP-Reply"
    "148"  = "Ascend-DHCP-Pool-Number"
    "149"  = "Ascend-Expect-Callback"
    "150"  = "Ascend-Event-Type"
    "151"  = "Ascend-Session-Svr-Key"
    "152"  = "Ascend-Multicast-Rate-Limit"
    "153"  = "Ascend-IF-Netmask"
    "154"  = "Ascend-Remote-Addr"
    "155"  = "Ascend-Multicast-Client"
    "156"  = "Ascend-FR-Circuit-Name"
    "157"  = "Ascend-FR-Link-Up"
    "158"  = "Ascend-FR-Nailed-Grp"
    "159"  = "Ascend-FR-Type"
    "160"  = "Ascend-FR-Link-Mgt"
    "161"  = "Ascend-FR-N391"
    "162"  = "Ascend-FR-DCE-N392"
    "163"  = "Ascend-FR-DTE-N392"
    "164"  = "Ascend-FR-DCE-N393"
    "165"  = "Ascend-FR-DTE-N393"
    "166"  = "Ascend-FR-T391"
    "167"  = "Ascend-FR-T392"
    "168"  = "Ascend-Bridge-Address"
    "169"  = "Ascend-TS-Idle-Limit"
    "170"  = "Ascend-TS-Idle-Mode"
    "171"  = "Ascend-DBA-Monitor"
    "172"  = "Ascend-Base-Channel-Count"
    "173"  = "Ascend-Minimum-Channels"
    "174"  = "Ascend-IPX-Route"
    "175"  = "Ascend-FT1-Caller"
    "176"  = "Ascend-Backup"
    "177"  = "Ascend-Call-Type"
    "178"  = "Ascend-Group"
    "179"  = "Ascend-FR-DLCI"
    "180"  = "Ascend-FR-Profile-Name"
    "181"  = "Ascend-Ara-PW"
    "182"  = "Ascend-IPX-Node-Addr"
    "183"  = "Ascend-Home-Agent-IP-Addr"
    "184"  = "Ascend-Home-Agent-Password"
    "185"  = "Ascend-Home-Network-Name"
    "186"  = "Ascend-Home-Agent-UDP-Port"
    "187"  = "Ascend-Multilink-ID"
    "188"  = "Ascend-Num-In-Multilink"
    "189"  = "Ascend-First-Dest"
    "190"  = "Ascend-Pre-Input-Octets"
    "191"  = "Ascend-Pre-Output-Octets"
    "192"  = "Ascend-Pre-Input-Packets"
    "193"  = "Ascend-Pre-Output-Packets"
    "194"  = "Ascend-Maximum-Time"
    "195"  = "Ascend-Disconnect-Cause"
    "196"  = "Ascend-Connect-Progress"
    "197"  = "Ascend-Data-Rate"
    "198"  = "Ascend-Pre-Session-Time"
    "199"  = "Ascend-Token-Idle"
    "200"  = "Ascend-Token-Immediate"
    "201"  = "Ascend-Require-Auth"
    "202"  = "Ascend-Number-Sessions"
    "203"  = "Ascend-Authen-Alias"
    "204"  = "Ascend-Token-Expiry"
    "205"  = "Ascend-Menu-Selector"
    "206"  = "Ascend-Menu-Item"
    "207"  = "Ascend-PW-Warntime"
    "208"  = "Ascend-PW-Lifetime"
    "209"  = "Ascend-IP-Direct"
    "210"  = "Ascend-PPP-VJ-Slot-Comp"
    "211"  = "Ascend-PPP-VJ-1172"
    "212"  = "Ascend-PPP-Async-Map"
    "213"  = "Ascend-Third-Prompt"
    "214"  = "Ascend-Send-Secret"
    "215"  = "Ascend-Receive-Secret"
    "216"  = "Ascend-IPX-PeerMode"
    "217"  = "Ascend-IP-Pool-Definition"
    "218"  = "Ascend-Assign-IP-Pool"
    "219"  = "Ascend-FR-Direct"
    "220"  = "Ascend-FR-Direct-Profile"
    "221"  = "Ascend-FR-Direct-DLCI"
    "222"  = "Ascend-Handle-IPX"
    "223"  = "Ascend-Netware-Timeout"
    "224"  = "Ascend-IPX-Alias"
    "225"  = "Ascend-Metric"
    "226"  = "Ascend-PRI-Number-Type"
    "227"  = "Ascend-Dial-Number"
    "228"  = "Ascend-Route-IP"
    "229"  = "Ascend-Route-IPX"
    "230"  = "Ascend-Bridge"
    "231"  = "Ascend-Send-Auth"
    "232"  = "Ascend-Send-Passwd"
    "233"  = "Ascend-Link-Compression"
    "234"  = "Ascend-Target-Util"
    "235"  = "Ascend-Maximum-Channels"
    "236"  = "Ascend-Inc-Channel-Count"
    "237"  = "Ascend-Dec-Channel-Count"
    "238"  = "Ascend-Seconds-Of-History"
    "239"  = "Ascend-History-Weigh-Type"
    "240"  = "Ascend-Add-Seconds"
    "241"  = "Ascend-Remove-Seconds"
    "242"  = "Ascend-Data-Filter"
    "243"  = "Ascend-Call-Filter"
    "244"  = "Ascend-Idle-Limit"
    "245"  = "Ascend-Preempt-Limit"
    "246"  = "Ascend-Callback"
    "247"  = "Ascend-Data-Svc"
    "248"  = "Ascend-Force56"
    "249"  = "Ascend-Billing-Number"
    "250"  = "Ascend-Call-By-Call"
    "251"  = "Ascend-Transit-Number"
    "252"  = "Ascend-Host-Info"
    "253"  = "Ascend-PPP-Address"
    "254"  = "Ascend-MPP-Idle-Percent"
    "255"  = "Ascend-Xmit-Rate"
    "4096" = "Saved-Radius-Framed-IP-Address"
    "4097" = "Saved-Radius-Callback-Number"
    "4098" = "NP-Calling-Station-ID"
    "4099" = "Saved-NP-Calling-Station-Id"
    "4100" = "Saved-Radius-Framed-Route"
    "4102" = "Day-And-Time-Restrictions"
    "4103" = "NP-Called-Station-ID"
    "4104" = @{
        Name       = "NP-Allowed-Port-Types"
        Enumerator = @{
            "0"  = "Async (Modem)"
            "1"  = "Sync (T1 Line)"
            "2"  = "ISDN Sync"
            "3"  = "ISDN Async V.120"
            "4"  = "ISDN Async V.110"
            "5"  = "Virtual (VPN)"
            "6"  = "PIAFS"
            "7"  = "HDLC Clear Channel"
            "8"  = "X.25"
            "9"  = "X.75"
            "10" = "G.3 Fax"
            "11" = "SDSL - Symmetric DSL"
            "12" = "ADSL-CAP - Asymmetric DSL Carrierless Amplitude Phase Modulation"
            "13" = "ADSL-DMT - Asymmetric DSL Discrete Multi-Tone"
            "14" = "IDSL - ISDN Digital Subscriber Line"
            "15" = "Ethernet"
            "16" = "xDSL - Digital Subscriber Line of unknown type"
            "17" = "Cable"
            "18" = "Wireless - Other"
            "19" = "Wireless - IEEE 802.11"
            "20" = "Token Ring"
            "21" = "FDDI"
        }
    }
    "4105" = @{
        Name       = "NP-Authentication-Type"
        Enumerator = @{
            "0"  = "IAS_AUTH_INVALID"
            "1"  = "IAS_AUTH_PAP"
            "2"  = "IAS_AUTH_MD5CHAP"
            "3"  = "IAS_AUTH_MSCHAP"
            "4"  = "IAS_AUTH_MSCHAP2"
            "5"  = "IAS_AUTH_EAP"
            "6"  = "IAS_AUTH_ARAP"
            "7"  = "IAS_AUTH_NONE"
            "8"  = "IAS_AUTH_CUSTOM"
            "9"  = "IAS_AUTH_MSCHAP_CPW"
            "10" = "IAS_AUTH_MSCHAP2_CPW"
            "11" = "IAS_AUTH_PEAP"
        }
    }
    "4106" = "NP-Allowed-EAP-Type"
    "4107" = "Shared-Secret"
    "4108" = "Client-IP-Address"
    "4109" = "Client-Packet-Header"
    "4110" = "Token-Groups"
    "4111" = "NP-Allow-Dial-in"
    "4112" = "Request-ID"
    "4113" = @{
        Name       = "Manipulation-Target"
        Enumerator = @{
            "1"  = "User-Name"
            "30" = "Called-Station-Id"
            "31" = "Calling-Station-Id"
        }
    }
    "4114" = "Manipulation-Rule"
    "4115" = "Original-User-Name"
    "4116" = @{
        Name       = "Client-Vendor"
        Enumerator = @{
            "0"    = "RADIUS Standard"
            "1"    = "Proteon"
            "5"    = "ACC"
            "9"    = "Cisco"
            "14"   = "BBN"
            "15"   = "Xylogics, Inc."
            "43"   = "3Com"
            "52"   = "Cabletron Systems"
            "64"   = "Gandalf"
            "117"  = "Telebit"
            "166"  = "Shiva Corporation"
            "181"  = "ADC Kentrox"
            "244"  = "Lantronix"
            "272"  = "BinTec Communications GmbH"
            "307"  = "Livingston Enterprises, Inc."
            "311"  = "Microsoft"
            "332"  = "Digi International"
            "343"  = "Intel Corporation"
            "429"  = "U.S. Robotics, Inc."
            "434"  = "EICON"
            "529"  = "Ascend Communications Inc."
            "562"  = "Nortel Networks"
            "2352" = "RedBack Networks"
        }
    }
    "4117" = "Client-UDP-Port"
    "4118" = "MS-CHAP-Challenge"
    "4119" = "MS-CHAP-Response"
    "4120" = "MS-CHAP-Domain"
    "4121" = "MS-CHAP-Error"
    "4122" = "MS-CHAP-CPW-1"
    "4123" = "MS-CHAP-CPW-2"
    "4124" = "MS-CHAP-LM-Enc-PW"
    "4125" = "MS-CHAP-NT-Enc-PW"
    "4126" = "MS-CHAP-MPPE-Keys"
    "4127" = @{
        Name       = "Authentication-Type"
        Enumerator = @{
            "0"  = "Invalid"
            "1"  = "PAP"
            "2"  = "CHAP"
            "3"  = "MS-CHAP v1"
            "4"  = "MS-CHAP v2"
            "5"  = "EAP"
            "6"  = "ARAP"
            "7"  = "Unauthenticated"
            "8"  = "Extension"
            "9"  = "MS-CHAP v1 CPW"
            "10" = "MS-CHAP v2 CPW"
            "11" = "PEAP"
        }
    }
    "4128" = "Client-Friendly-Name"
    "4129" = "SAM-Account-Name"
    "4130" = "Fully-Qualifed-User-Name"
    "4131" = "Windows-Groups"
    "4132" = "EAP-Friendly-Name"
    "4133" = @{
        Name       = "Auth-Provider-Type"
        Enumerator = @{
            "0" = "None"
            "1" = "Windows"
            "2" = "RADIUS Proxy"
        }
    }
    "4134" = "MS-Acct-Auth-Type"
    "4135" = "MS-Acct-EAP-Type"
    "4136" = @{
        Name       = "Packet-Type"
        Enumerator = @{
            "1"  = "Accept-Request"
            "2"  = "Access-Accept"
            "3"  = "Access-Reject"
            "4"  = "Accounting-Request"
            "5"  = "Accounting-Response"
            "11" = "Access-Challenge"
        }
    }
    "4137" = "Auth-Provider-Name"
    "4138" = @{
        Name       = "Acct-Provider-Type"
        Enumerator = @{}
    }
    "4139" = "Acct-Provider-Name"
    "4140" = "MS-MPPE-Send-Key"
    "4141" = "MS-MPPE-Recv-Key"
    "4142" = @{
        Name       = "Reason-Code"
        Enumerator = @{
            "0"   = "Success"
            "1"   = "Internal error" 
            "2"   = "Access denied"
            "3"   = "Malformed request"
            "4"   = "Global catalog unavailable"
            "5"   = "Domain unavailable"
            "6"   = "Server unavailable"
            "7"   = "No such domain"
            "8"   = "No such user"
            "9"   = "The request was discarded by a third-party extension DLL file."
            "10"  = "A third-party extension DLL has failed and cannot perform its function."
            "16"  = "Authentication failure"
            "17"  = "Password change failure"
            "18"  = "Unsupported authentication type"
            "19"  = "No reversibly encrypted password is stored for the user account"
            "20"  = "Lan Manager Authentication is not enabled."
            "21"  = "An IAS extension dynamic link library (DLL) that is installed on the NPS server rejected the connection request."
            "22"  = "The client could not be authenticated because the EAP type cannot be processed by the server."
            "23"  = "Unexpected error. Possible error in server or client configuration."
            "32"  = "Local users only"
            "33"  = "Password must be changed"
            "34"  = "Account disabled" 
            "35"  = "Account expired"
            "36"  = "Account locked out"
            "37"  = "Logon hours are not valid"
            "38"  = "Account restriction"
            "48"  = "Did not match network policy"
            "49"  = "Did not match connection request policy"
            "64"  = "Dial-in locked out"
            "65"  = "Dial-in disabled"
            "66"  = "Authentication type is not valid"
            "67"  = "Calling station is not valid" 
            "68"  = "Dial-in hours are not valid"
            "69"  = "Called station is not valid"
            "70"  = "Port type is not valid"
            "71"  = "Restriction is not valid"
            "72"  = "The user cannot change his or her password because the change password option is not enabled for the matching remote access policy"
            "73"  = "The Enhanced Key Usage (EKU) extensions, section of the user or computer certificate are not valid or are missing."
            "80"  = "No record"
            "96"  = "Session timed out"
            "97"  = "Unexpected request"
            "112" = "The remote RADIUS server did not process the authentication request."
            "113" = "The local NPS proxy attempted to forward a connection request to a member of a remote RADIUS server group that does not exist."
            "115" = "The local NPS proxy did not forward a RADIUS message because it is not an accounting request or a connection request."
            "116" = "The local NPS proxy server cannot forward the connection request to the remote RADIUS server because either the proxy cannot open a Windows socket over which to send the connection request, or the proxy server attempted to send the connection request but received Windows sockets errors that prevented successful completion of the send operation."
            "117" = "The remote RADIUS (Remote Authentication Dial-In User Service) server did not respond."
            "118" = "The local NPS proxy server received a RADIUS message that is malformed from a remote RADIUS server, and the message is unreadable."
            "256" = "The certificate provided by the user or computer as proof of their identity is a revoked certificate. Because of this, the user or computer was not authenticated, and NPS rejected the connection request."
            "257" = "Due to a missing dynamic link library (DLL) or exported function, NPS cannot access the certificate revocation list to verify whether the user or client computer certificate is valid or is revoked."
            "258" = "The revocation function was unable to check revocation for the certificate."
            "259" = "The certification authority that manages the certificate revocation list is not available. NPS cannot verify whether the certificate is valid or is revoked. Because of this, authentication failed."
            "260" = "The message supplied for verification has been altered."
            "261" = "NPS cannot contact Active Directory Domain Services (AD DS) or the local user accounts database to perform authentication and authorization. The connection request is denied for this reason."
            "262" = "The supplied message is incomplete. The signature was not verified."
            "263" = "NPS did not receive complete credentials from the user or computer. The connection request is denied for this reason."
            "264" = "The Security Support Provider Interface (SSPI) called by EAP reports that the system clocks on the NPS server and the access client are not synchronized."
            "265" = "The certificate that the user or client computer provided to NPS as proof of identity chains to an enterprise root certification authority that is not trusted by the NPS server."
            "266" = "The message received was unexpected or badly formatted."
            "267" = "The certificate provided by the connecting user or computer is not valid because it is not configured with the Client Authentication purpose in Application Policies or Enhanced Key Usage (EKU) extensions. NPS rejected the connection request for this reason."
            "268" = "The certificate provided by the connecting user or computer is expired. NPS rejected the connection request for this reason."
            "269" = "The Security Support Provider Interface (SSPI) called by EAP reports that the NPS server and the access client cannot communicate because they do not possess a common algorithm."
            "270" = "Based on the matching NPS network policy, the user is required to log on with a smart card, but they have attempted to log on by using other credentials. NPS rejected the connection request for this reason."
            "271" = "The connection request was not processed because the NPS server was in the process of shutting down or restarting when it received the request."
            "272" = "The certificate that the user or client computer provided to NPS as proof of identity maps to multiple user or computer accounts rather than one account. NPS rejected the connection request for this reason."
            "273" = "Authentication failed. NPS called Windows Trust Verification Services, and the trust provider is not recognized on this computer. A trust provider is a software module that implements the algorithm for application-specific policies regarding trust."
            "274" = "Authentication failed. NPS called Windows Trust Verification Services, and the trust provider does not support the specified action. Each trust provider provides its own unique set of action identifiers. For information about the action identifiers supported by a trust provider, see the documentation for that trust provider."
            "275" = "Authentication failed. NPS called Windows Trust Verification Services, and the trust provider does not support the specified form. A trust provider is a software module that implements the algorithm for application-specific policies regarding trust. Trust providers support subject forms that describe where the trust information is located and what trust actions to take regarding the subject."
            "276" = "Authentication failed. NPS called Windows Trust Verification Services, but the binary file that calls EAP cannot be verified and is not trusted."
            "277" = "Authentication failed. NPS called Windows Trust Verification Services, but the binary file that calls EAP is not signed, or the signer certificate cannot be found."
            "278" = "Authentication failed. The certificate that was provided by the connecting user or computer is expired."
            "279" = "Authentication failed. The certificate is not valid because the validity periods of certificates in the chain do not match. For example, the following End Certificate and Issuer Certificate validity periods do not match: End Certificate validity period: 2007-2010; Issuer Certificate validity period: 2006-2008."
            "280" = "Authentication failed. The certificate is not valid and was not issued by a valid certification authority (CA)."
            "281" = "Authentication failed. The path length constraint in the certification chain has been exceeded. This constraint restricts the maximum number of CA certificates that can follow this certificate in the certificate chain."
            "282" = "Authentication failed. The certificate contains a critical extension that is unrecognized by NPS."
            "283" = "Authentication failed. The certificate does not contain the Client Authentication purpose in Application Policies extensions, and cannot be used for authentication."
            "284" = "Authentication failed. The certificate is not valid because the certificate issuer and the parent of the certificate in the certificate chain are required to match but do not match."
            "285" = "Authentication failed. NPS cannot locate the certificate, or the certificate is incorrectly formed and is missing important information."
            "286" = "Authentication failed. The certificate provided by the connecting user or computer is issued by a certification authority (CA) that is not trusted by the NPS server."
            "287" = "Authentication failed. The certificate provided by the connecting user or computer does not chain to an enterprise root CA that NPS trusts."
            "288" = "Authentication failed due to an unspecified trust failure."
            "289" = "Authentication failed. The certificate provided by the connecting user or computer is revoked and is not valid."
            "290" = "Authentication failed. A test or trial certificate is in use, however the test root CA is not trusted, according to local or domain policy settings."
            "291" = "Authentication failed because NPS cannot locate and access the certificate revocation list to verify whether the certificate has or has not been revoked. This issue can occur if the revocation server is not available or if the certificate revocation list cannot be located in the revocation server database."
            "292" = "Authentication failed. The value of the User-Name attribute in the connection request does not match the value of the common name (CN) property in the certificate."
            "293" = "Authentication failed. The certificate provided by the connecting user or computer is not valid because it is not configured with the Client Authentication purpose in Application Policies or Enhanced Key Usage (EKU) extensions. NPS rejected the connection request for this reason."
            "294" = "Authentication failed because the certificate was explicitly marked as untrusted by the Administrator. Certificates are designated as untrusted when they are imported into the Untrusted Certificates folder in the certificate store for the Current User or Local Computer in the Certificates Microsoft Management Console (MMC) snap-in."
            "295" = "Authentication failed. The certificate provided by the connecting user or computer is issued by a CA that is not trusted by the NPS server."
            "296" = "Authentication failed. The certificate provided by the connecting user or computer is not valid because it is not configured with the Client Authentication purpose in Application Policies or Enhanced Key Usage (EKU) extensions. NPS rejected the connection request for this reason."
            "297" = "Authentication failed. The certificate provided by the connecting user or computer is not valid because it does not have a valid name."
            "298" = "Authentication failed. Either the certificate does not contain a valid user principal name (UPN) or the value of the User-Name attribute in the connection request does not match the certificate."
            "299" = "Authentication failed. The sequence of information provided by internal components or protocols during message verification is incorrect."
            "300" = "Authentication failed. The certificate is malformed and Extensible Authentication Protocl (EAP) cannot locate credential information in the certificate."
            "301" = "NPS terminated the authentication process. NPS received a cryptobinding type length value (TLV) from the access client that is not valid. This issue occurs when an attempt to breach your network security has occurred and a man-in-the-middle (MITM) attack is in progress. During MITM attacks on your network, attackers use unauthorized computers to intercept traffic between your legitimate hosts while posing as one of the legitimate hosts. The attacker's computer attempts to gain data from your other network resources. This enables the attacker to use the unauthorized computer to intercept, decrypt, and access all network traffic that would otherwise go to one of your legitimate network resources."
            "302" = "NPS terminated the authentication process. NPS did not receive a required cryptobinding type length value (TLV) from the access client during the authentication process."
        }
    }
    "4143" = "MS-Filter"
    "4144" = "MS-CHAP2-Response"
    "4145" = "MS-CHAP2-Success"
    "4146" = "MS-CHAP2-CPW"
    "4147" = @{
        Name       = "MS-RAS-Vendor"
        Enumerator = @{
            "0"    = "RADIUS Standard"
            "1"    = "Proteon"
            "5"    = "ACC"
            "9"    = "Cisco"
            "14"   = "BBN"
            "15"   = "Xylogics, Inc."
            "43"   = "3Com"
            "52"   = "Cabletron Systems"
            "64"   = "Gandalf"
            "117"  = "Telebit"
            "166"  = "Shiva Corporation"
            "181"  = "ADC Kentrox"
            "244"  = "Lantronix"
            "272"  = "BinTec Communications GmbH"
            "307"  = "Livingston Enterprises, Inc."
            "311"  = "Microsoft"
            "332"  = "Digi International"
            "343"  = "Intel Corporation"
            "429"  = "U.S. Robotics, Inc."
            "434"  = "EICON"
            "529"  = "Ascend Communications Inc."
            "562"  = "Nortel Networks"
            "2352" = "RedBack Networks"
        }
    }
    "4148" = "MS-RAS-Version"
    "4149" = "NP-Policy-Name"
    "4150" = "MS-Primary-DNS-Server"
    "4151" = "MS-Secondary-DNS-Server"
    "4152" = "MS-Primary-NBNS-Server"
    "4153" = "MS-Secondary-NBNS-Server"
    "4154" = "Proxy-Policy-Name"
    "4155" = @{
        Name       = "Provider-Type"
        Enumerator = @{
            "0" = "None"
            "1" = "Windows"
            "2" = "RADIUS Proxy"
        }
    }
    "4156" = "Provider-Name"
    "4157" = "Remote-Server-Address"
    "4158" = "Generate-Class-Attribute"
    "4159" = "MS-RAS-Client-Name"
    "4160" = "MS-RAS-Client-Version"
    "4161" = "Allowed-Certificate-OID"
    "4162" = "Extension-State"
    "4163" = "Generate-Session-Timeout"
    "4164" = "MS-Session-Timeout"
    "4165" = "MS-Quarantine-IPFilter"
    "4166" = "MS-Quarantine-Session-Timeout"
    "4167" = "MS-User-Security-Identity"
    "4168" = "Remote-RADIUS-to-Windows-User-Mapping"
    "4169" = "Passport-User-Mapping-UPN-Suffix"
    "4170" = "Tunnel-Tag"
    "4171" = "NP-PEAPUpfront-Enabled"
    "5000" = "Cisco-AV-Pair"
    "6000" = @{
        Name       = "Nortel-Port-QOS"
        Enumerator = @{
            "0" = "Standard"
            "1" = "Custom"
            "2" = "Bronze"
            "3" = "Silver"
            "4" = "Gold"
            "5" = "Platinum"
            "6" = "Premium"
            "7" = "Critical Network"
        }
    }
    "6001" = "Nortel-Port-Priority"
    "8096" = "ARAP-Guest-Logon"
    "8097" = "Certificate-EKU"
    "8098" = "EAP-Configuration"
    "8099" = "PEAP-Embedded-EAP-TypeId"
    "8100" = "PEAP-Fast-Roamed-Session"
    "8101" = "IAS-EAP-TypeId"
    "8102" = "MS-EAP-TLV"
    "8103" = "Reject-Reason-Code"
    "8104" = "Proxy-EAP-Configuration"
    "8105" = "Session"
    "8107" = "Clear-Text-Password"
    "8108" = @{
        Name       = "MS-Identity-Type"
        Enumerator = @{
            "1" = "Machine health check"
        }
    }
    "8109" = "MS-Service-Class"
    "8110" = "MS-Quarantine-User-Class"
    "8111" = @{
        Name       = "MS-Quarantine-State"
        Enumerator = @{
            "0" = "Full Access"
            "1" = "Quarantine"
            "2" = "Probation"
        }
    }
    "8112" = "Override-RAP-Auth"
    "8116" = "Windows-Machine-Groups"
    "8117" = "Windows-User-Groups"
    "8120" = "MS-Quarantine-Grace-Time"
    "8121" = "Quarantine-URL"
    "8123" = "Not-Quarantine-Capable"
    "8124" = "System-Health-Result"
    "8125" = "System-Health-Validators"
    "8129" = "Fully-Qualified-Machine-Name"
    "8130" = "Quarantine-Fixup-Servers-Configuration"
    "8132" = @{
        Name       = "MS-Network-Access-Server-Type"
        Enumerator = @{
            "0" = "Unspecified"
            "1" = "Terminal Server Gateway"
            "2" = "Remote Access Server (VPN-Dial up)"
            "3" = "DHCP Server"
            "5" = "Health Registration Authority"
            "6" = "HCAP Server"
        }
    }
    "8133" = "Quarantine-Session-Id"
    "8134" = @{
        Name       = "MS-AFW-Zone"
        Enumerator = @{
            "1" = "Boundary"
            "2" = "Non Boundary"
        }
    }
    "8135" = @{
        Name       = "MS-AFW-Protection-Level"
        Enumerator = @{
            "1" = "Signed"
            "2" = "Encrypted"
        }
    }
    "8136" = "Quarantine-Update-Non-Compliant"
    "8138" = "MS-Machine-Name"
    "8139" = "Client-IPv6-Address"
    "8140" = "Saved-Radius-Framed-Interface-Id"
    "8141" = "Saved-Radius-Framed-IPv6-Prefix"
    "8142" = "Saved-Radius-Framed-IPv6-Route"
    "8143" = "Quarantine-Grace-Time-Configuration"
    "8144" = "MS-IPv6-Filter"
    "8145" = "MS-IPv4-Remediation-Servers"
    "8146" = "MS-IPv6-Remediation-Servers"
    "8148" = "Machine-Inventory"
    "8149" = "Absolute-Time"
    "8150" = "MS-Quarantine-SoH"
    "8151" = "EAP-Types-Configured-In-ProxyPolicy"
    "8152" = "HCAP-Location-Group-Name"
    "8153" = @{
        Name       = "MS-Extended-Quarantine-State"
        Enumerator = @{
            "0" = "No Data"
            "1" = "Transition"
            "2" = "Infected"
            "3" = "Unknown"
        }
    }
    "8155" = "HCAP-User-Groups"
    "8156" = "Saved-Machine-HealthCheck-Only"
    "8158" = "MS-RAS-Correlation-ID"
    "8159" = "HCAP-User-Name"
    "8160" = "SAM-HCAP-Account-Name"
    "8164" = "User-IPv4-Address"
    "8165" = "User-IPv6-Address"
    "8166" = "TSG-Device-Redirection"
}

#endregion

#region basic functions
#----------------------
. $psscriptroot\scripts\Get-NPSLog.ps1

#endregion


#region Helper functions
#-----------------------

#endregion

Export-ModuleMember -Function *-NPS**
