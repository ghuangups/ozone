# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

*** Settings ***
Documentation       Smoketest ozone cluster startup
Library             OperatingSystem
Library             BuiltIn
Resource            ../commonlib.robot
Test Timeout        5 minutes

*** Variables ***

*** Test Cases ***
Run scm roles
    ${output} =         Execute          ozone admin scm roles
                        Should Match Regexp   ${output}  [scm:9894(:LEADER|)]

List scm roles as JSON
    ${output} =         Execute          ozone admin scm roles --json
    ${leader} =         Execute          echo '${output}' | jq -r '.[] | select(.raftPeerRole == "LEADER")'
                        Should Not Be Equal       ${leader}       ${EMPTY}

List scm roles as TABLE
    ${output} =         Execute          ozone admin scm roles --table
                        Should Match Regexp   ${output}  \\|.*LEADER.*