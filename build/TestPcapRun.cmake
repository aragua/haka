# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set(ENV{BUILD_DIR} ${CTEST_MODULE_DIR})
set(ENV{DIFF} ${DIFF})
set(ENV{TSHARK} ${TSHARK})
set(ENV{LUA_PATH} ${PROJECT_SOURCE_DIR}/src/lua/?.lua)
set(ENV{HAKA_PATH} ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX})
set(ENV{LD_LIBRARY_PATH} ${TEST_RUNDIR}/${HAKA_INSTALL_PREFIX}/lib)
set(ENV{TZ} Europe/Paris)

message("Executing TZ=\"Europe/Paris\" LUA_PATH=\"$ENV{LUA_PATH}\" HAKA_PATH=\"$ENV{HAKA_PATH}\" LD_LIBRARY_PATH=\"$ENV{LD_LIBRARY_PATH}\" ${EXE} -d ${EXE_OPTIONS} -o ${DST}.pcap ${SRC} ${CONF}")

if(VALGRIND AND NOT "$ENV{QUICK}" STREQUAL "yes")
	set(DO_VALGRIND 1)
endif()

if(DO_VALGRIND)
	execute_process(COMMAND ${VALGRIND} --log-file=${DST}-valgrind.txt ${EXE} -d ${EXE_OPTIONS} -o ${DST}.pcap ${SRC} ${CONF}
		RESULT_VARIABLE HAD_ERROR OUTPUT_FILE ${DST}-tmp.txt)
else()
	execute_process(COMMAND ${EXE} -d ${EXE_OPTIONS} -o ${DST}.pcap ${SRC} ${CONF}
		RESULT_VARIABLE HAD_ERROR OUTPUT_FILE ${DST}-tmp.txt)
endif()

execute_process(COMMAND cat ${DST}-tmp.txt OUTPUT_VARIABLE CONTENT)
message("${CONTENT}")

if(HAD_ERROR)
	message(FATAL_ERROR "Haka script failed")
endif(HAD_ERROR)

# Filter out some initialization and exit messages
execute_process(COMMAND gawk -f ${CTEST_MODULE_DIR}/CompareOutput.awk ${DST}-tmp.txt OUTPUT_FILE ${DST}.txt)

# Compare output
message("")
message("-- Comparing output")

if(EXISTS "${REF}-${REFVER}.txt")
	set(REFTXT "${REF}-${REFVER}.txt")
elseif(EXISTS "${REF}.txt")
	set(REFTXT "${REF}.txt")
endif()

if(EXISTS "${REFTXT}")
	execute_process(COMMAND ${DIFF} ${DST}.txt ${REFTXT} RESULT_VARIABLE HAD_ERROR OUTPUT_VARIABLE CONTENT)
	message("${CONTENT}")
	message("Generated output file is ${CMAKE_CURRENT_SOURCE_DIR}/${DST}.txt")
	message("Original output file is ${REFTXT}")
	if(HAD_ERROR)
		if(NOT "$ENV{HAKA_TEST_FIX}" STREQUAL "")
			execute_process(COMMAND echo cp ${CMAKE_CURRENT_SOURCE_DIR}/${DST}.txt ${REFTXT} OUTPUT_FILE $ENV{HAKA_TEST_FIX})
		endif()
		message(FATAL_ERROR "Output different")
	endif(HAD_ERROR)
else()
	message("Generated output file is ${CMAKE_CURRENT_SOURCE_DIR}/${DST}.txt")
	message("Original output file is ${REF}.txt")
	message("No output reference")
endif()

# Compare pcap
message("")
message("-- Comparing pcap")

if(EXISTS "${REF}-${REFVER}.pcap")
	set(REFPCAP "${REF}-${REFVER}.pcap")
elseif(EXISTS "${REF}.pcap")
	set(REFPCAP "${REF}.pcap")
endif()

if(EXISTS "${REFPCAP}")
	execute_process(COMMAND bash ${CTEST_MODULE_DIR}/ComparePcap.sh ${DST}.pcap ${REFPCAP}
		RESULT_VARIABLE HAD_ERROR OUTPUT_VARIABLE CONTENT)
	message("${CONTENT}")
	message("Generated pcap file is ${CMAKE_CURRENT_SOURCE_DIR}/${DST}.pcap")
	message("Original pcap file is ${REFPCAP}")
	if(HAD_ERROR)
		if(ENV{HAKA_TEST_FIX})
			execute_process(COMMAND echo cp ${CMAKE_CURRENT_SOURCE_DIR}/${DST}.pcap ${REFPCAP} OUTPUT_FILE $ENV{HAKA_TEST_FIX})
		endif()
		message(FATAL_ERROR "Pcap different")
	endif(HAD_ERROR)
else()
	message("Generated pcap file is ${CMAKE_CURRENT_SOURCE_DIR}/${DST}.pcap")
	message("Original pcap file is ${REF}.pcap")
	message("No pcap reference")
endif()

# Memory leak
if(DO_VALGRIND)
	message("")
	message("-- Memory leak check")
	execute_process(COMMAND gawk -f ${CTEST_MODULE_DIR}/CheckValgrind.awk ${DST}-valgrind.txt OUTPUT_VARIABLE VALGRIND_OUT)
	list(GET VALGRIND_OUT 0 VALGRIND_LEAK)
	list(GET VALGRIND_OUT 1 VALGRIND_REACHABLE)

	if(VALGRIND_LEAK GREATER 0)
		message(FATAL_ERROR "Memory leak detected: ${VALGRIND_LEAK} lost bytes")
	endif()

	if(VALGRIND_REACHABLE GREATER 32)
		message(FATAL_ERROR "Memory leak detected: ${VALGRIND_REACHABLE} reachable bytes")
	endif()

	message("No leak detected")
endif()
