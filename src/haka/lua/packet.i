/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

%module packet

%include "haka/lua/swig.si"
%include "haka/lua/packet.si"
%include "haka/lua/object.si"

%{
#include <haka/packet.h>
#include <haka/packet_module.h>
#include <haka/error.h>

void lua_pushppacket(lua_State *L, struct packet *pkt)
{
	if (!lua_object_push(L, pkt, &pkt->lua_object, SWIGTYPE_p_packet, 1)) {
		lua_error(L);
	}
}

#define _new(s) __new(L, s)

%}

%include "time.si"

%rename(ACCEPT) FILTER_ACCEPT;
%rename(DROP) FILTER_DROP;

enum filter_result { FILTER_ACCEPT, FILTER_DROP };

%nodefaultctor;
%nodefaultdtor;

%newobject packet::forge;
%newobject packet::timestamp;

struct packet {
	%extend {
		%immutable;
		size_t length;
		struct time_lua *timestamp;
		const char *dissector;
		const char *next_dissector;

		~packet()
		{
			if ($self) {
				packet_release($self);
			}
		}

		size_t __len(void *dummy)
		{
			return packet_length($self);
		}

		int __getitem(int index)
		{
			--index;
			if (index < 0 || index >= packet_length($self)) {
				error(L"out-of-bound index");
				return 0;
			}
			return packet_data($self)[index];
		}

		void __setitem(int index, int value)
		{
			--index;
			if (index < 0 || index >= packet_length($self)) {
				error(L"out-of-bound index");
				return;
			}
			packet_data_modifiable($self)[index] = value;
		}

		void resize(int size);
		void drop();
		void accept();
		void send();

		struct packet *forge()
		{
			packet_accept($self);
			return NULL;
		}
	}
};

%rename(NORMAL) MODE_NORMAL;
%rename(PASSTHROUGH) MODE_PASSTHROUGH;

enum packet_mode { MODE_NORMAL, MODE_PASSTHROUGH };

%rename(mode) packet_mode;
enum packet_mode packet_mode();

%rename(new) packet_new;
%newobject packet_new;
struct packet *packet_new(int size = 0);

%{
size_t packet_length_get(struct packet *pkt) {
	return packet_length(pkt);
}

struct time_lua *packet_timestamp_get(struct packet *pkt) {
	return mk_lua_time(packet_timestamp(pkt));
}

const char *packet_dissector_get(struct packet *pkt) {
	return "raw";
}

const char *packet_next_dissector_get(struct packet *pkt) {
	return packet_dissector(pkt);
}

%}
