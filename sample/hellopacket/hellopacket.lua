------------------------------------
-- This is an example lua file for the hellopacket tutorial
--
-- Use this file with hakapcap tool:
--
-- hakapcap hellopacket.pcap hellopacket.lua
--
------------------------------------

------------------------------------
-- Loading dissectors
------------------------------------
-- Each dissector provides hooks to intercept and modify packets.
-- We need ipv4 to intercept incoming packets
-- We need tcp to intercept new connectiosn
require('protocol/ipv4')
require('protocol/tcp')

------------------------------------
-- Log all incoming packets, reporting the source and destination IP address
------------------------------------
haka.rule{
	-- Intercept all ipv4 packet before they are passed to tcp
	hooks = { 'ipv4-up' },

	-- Function to call on all packets.
	--     self : the dissector object that handles the packet (here, ipv4 dissector)
	--     pkt : the packet that we are intercepting
	eval = function (self, pkt)
		-- All fields are accessible through accessors
		-- See the Haka documentation for a complete list.
		haka.log("Hello", "packet from %s to %s", pkt.src, pkt.dst)
	end
}

------------------------------------
-- Log all new connection, logging address and port of source and destination
------------------------------------
haka.rule{
	-- Intercept connection establishement, detected by the TCP dissector
	hooks = { 'tcp-connection-new' },
	eval = function (self, pkt)
		-- Fields from previous layer are accessible too
		haka.log("Hello", "TCP connection from %s:%d to %s:%d", pkt.tcp.ip.src,
			pkt.tcp.srcport, pkt.tcp.ip.dst, pkt.tcp.dstport)

		-- Raise a simple alert for testing purpose
		haka.alert{
			description = "A simple alert",
			severity = "low"
		}
	end
}
