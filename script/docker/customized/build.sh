#!/bin/sh

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cd `dirname $0`
# 当前脚本目录
CURRENT_DIR=`pwd`

# 编译上下文目录
CONTEXT_DIR=`pwd`
cp ../../../collector/target/hertzbeat-collector.jar ./hertzbeat-collector-1.0.jar
cp ../../../manager/target/hertzbeat.jar ./hertzbeat.jar
cp -r ../../../manager/src/main/resources/define/ ./conf/define
cp -r ../../../web-app/dist/ ./

echo "docker build -t hertzbeat:customized -f $CURRENT_DIR/Dockerfile $CONTEXT_DIR"

docker build -t hertzbeat:customized -f $CURRENT_DIR/Dockerfile $CONTEXT_DIR

docker save -o hertzbeat_customized.tar hertzbeat:customized

read -p "press -> end"