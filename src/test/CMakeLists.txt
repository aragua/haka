# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Tests
include(TestPcap)

TEST_PCAP(core rule-error)
TEST_PCAP(core onexit)
TEST_PCAP(core timestamp)
TEST_PCAP(core alert)
TEST_PCAP(core gettingstarted CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/gettingstarted/gettingstarted.lua)
TEST_PCAP(core standard-http CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/ruleset/config.lua)
TEST_PCAP(core standard-ipv4 CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/ruleset/config.lua)
TEST_PCAP(core standard-tcp CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/ruleset/config.lua)
TEST_PCAP(core hellopacket CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/hellopacket/hellopacket.lua)
TEST_PCAP(core sqli-simple CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/sqli/sqli-simple.lua)
TEST_PCAP(core sqli-decode CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/sqli/sqli-decode.lua)
TEST_PCAP(core sqli-fine-grained CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/sqli/sqli-fine-grained.lua)
TEST_PCAP(core sqli-groups CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/sqli/sqli-groups.lua)
TEST_PCAP(core sqli-white-list CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/sqli/sqli-white-list.lua)
TEST_PCAP(core ipfilter CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/filter/ipfilter.lua)
TEST_PCAP(core groupfilter CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/filter/groupfilter.lua)
TEST_PCAP(core httpfilter CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/filter/httpfilter.lua)
TEST_PCAP(core httpmodif CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/filter/httpmodif.lua)
TEST_PCAP(core tcpfilter CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/filter/tcpfilter.lua)
TEST_PCAP(core stats_on_exit CONFIG ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/share/haka/sample/stats/stats_on_exit.lua)
TEST_PCAP(core doc-alert CONFIG ${CMAKE_CURRENT_SOURCE_DIR}/../../doc/ref/alert-test.lua)
