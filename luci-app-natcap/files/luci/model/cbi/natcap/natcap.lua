-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008-2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local nt = require "luci.sys".net

local m = Map("natcapd", luci.util.pcdata(translate("Natcap Service")), translate("Natcap to avoid censorship/filtering/logging"))

m:section(SimpleSection).template  = "natcap/natcap"

local s = m:section(TypedSection, "natcapd", "")
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Settings"))
s:tab("advanced", translate("Advance Settings"))
s:tab("macfilter", translate("Mac Filter"))
s:tab("ipfilter", translate("IP Filter"))

e = s:taboption("general", Flag, "enabled", translate("Enable Natcap"))
e.default = e.disabled
e.rmempty = false

e = s:taboption("general", Value, "account", translate("Natcap Account"))
e.rmempty = true
e.placeholder = 'account'

e = s:taboption("general", DynamicList, "server", translate("Natcap Servers"), translate("Please fill in the server by format (ip:port)"))
e.datatype = "list(ipaddrport(1))"
e.placeholder = "1.2.3.4:0"

e = s:taboption("general", Flag, "cnipwhitelist_mode", translate("Domestic and International Diversion"), translate("Generally do not need to be enabled unless used to play games."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("general", Flag, "full_cone_nat", translate("Full Cone Nat"), translate("Generally do not need to be enabled unless used to play games."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("advanced", Value, "dns_server", translate("DNS Server"), translate("Please fill in the server by format (ip:port)"))
e.datatype = "ipaddrport(1)"
e.placeholder = "8.8.8.8:53"

e = s:taboption("advanced", Flag, "enable_encryption", translate("Enable Encryption"))
e.default = e.enabled
e.rmempty = false

e = s:taboption("advanced", Value, "server_persist_timeout", translate("Server Switching Interval (s)"), translate("How long to switch the server."))
e.default = '60'
e.rmempty = true
e.placeholder = '60'

e = s:taboption("advanced", Value, "natcap_redirect_port", translate("Local TCP Listening Port"), translate("0 Disabled，Otherwise Enabled"))
e.datatype = "portrange"
e.rmempty = true
e.placeholder = '0'

e = s:taboption("advanced", Flag, "encode_mode", translate("Force TCP encode as UDP"), translate("Do not normally enable unless the normal mode is not working."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("advanced", Flag, "udp_encode_mode", translate("Force UDP encode as TCP"), translate("Do not normally enable unless the normal mode is not working."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("advanced", Flag, "sproxy", translate("TCP Proxy Acceleration"), translate("Recommended to use the server's TCP proxy and Google BBR algorithm to accelerate."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("advanced", Flag, "http_confusion", translate("HTTP Obfuscation"), translate("Disguise the traffic into HTTP."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("advanced", Value, "htp_confusion_host", translate("Obfuscation Host"))
e.rmempty = true
e.placeholder = 'bing.com'

e = s:taboption("general", Flag, "natcapovpn", translate("Enable OpenVPN Server"), translate("Allows you to use OpenVPN to connect to router, the router need to have a public IP."))
e.default = e.disabled
e.rmempty = false

e = s:taboption("general", Flag, "pptpd", translate("Enable The PPTP Server"), translate("Allows you to use VPN to connect to router, the router need to have a public IP."))
e.default = e.disabled
e.rmempty = false

local u = m:section(TypedSection, "pptpuser", "")
u.addremove = true
u.anonymous = true
u.template = "cbi/tblsection"

e = u:option(Value, "username", translate("PPTP Username"))
e.datatype = "string"
e.rmempty  = false

e = u:option(Value, "password", translate("Password"))
e.password = true
e.rmempty  = false

e = s:taboption("macfilter", ListValue, "macfilter", translate("Mac Address Filter"))
e:value("", translate("Disabled"))
e:value("allow", translate("whitelist (Allow to use Natcap)"))
e:value("deny", translate("blacklist (Forbid to use Natcap)"))

e = s:taboption("macfilter", DynamicList, "maclist", translate("Mac List"))
e.datatype = "macaddr"
e:depends({macfilter="allow"})
e:depends({macfilter="deny"})
nt.mac_hints(function(mac, name) e:value(mac, "%s (%s)" %{ mac, name }) end)

e = s:taboption("ipfilter", ListValue, "ipfilter", translate("IP Address Filter"))
e:value("", translate("Disabled"))
e:value("allow", translate("whitelist (Allow to use Natcap)"))
e:value("deny", translate("blacklist (Forbid to use Natcap)"))

e = s:taboption("ipfilter", DynamicList, "iplist", translate("IP List"))
e.datatype = "ipaddr"
e.placeholder = '192.168.1.0/24'
e:depends({ipfilter="allow"})
e:depends({ipfilter="deny"})

return m
