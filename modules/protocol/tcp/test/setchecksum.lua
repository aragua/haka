-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

-- Basic test that will output some basic information about the

-- received packets.

require("protocol/ipv4")
require("protocol/tcp")

haka.rule {
	hooks = { "tcp-up" },
	eval = function (self, pkt)
		pkt:compute_checksum()
	end
}
