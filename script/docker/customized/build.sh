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

echo "替换：$1"
echo "favicon：$2"

cd ../../../web-app
FROM="router.getCurrentNavigation()?.previousNavigation?.finalUrl.toString() === '/passport/login'"
TO="router.getCurrentNavigation()?.previousNavigation?.finalUrl.toString() === '/customized'"
sed -i "s\\$FROM\\$TO\g" src/app/layout/basic/widgets/user.component.ts
npm run build
sed -i "s\\$TO\\$FROM\g" src/app/layout/basic/widgets/user.component.ts

cd ../script/docker/customized

cd `dirname $0`
# 当前脚本目录
CURRENT_DIR=`pwd`

# 编译上下文目录
CONTEXT_DIR=`pwd`
cp ../../../collector/target/hertzbeat-collector.jar ./hertzbeat-collector-1.0.jar
cp ../../../manager/target/hertzbeat.jar ./hertzbeat.jar
cp -r ../../../manager/src/main/resources/define/ ./conf/define
cp -r ../../../web-app/dist/ ./

sed -i "1a\<style type=\"text/css\">global-footer{height:0\!important;display:none\!important}layout-default-header .alain-default__nav li.ng-star-inserted:nth-child(2),layout-default-header .alain-default__nav li.ng-star-inserted:nth-child(3),layout-default-header .alain-default__nav header-user,layout-default-header .alain-default__header-logo img,layout-basic .alain-default__aside .alain-default__aside-user,img[src*='assets/brand'],img[src*='assets/logo']{display:none\!important}.slide.slick-slide nz-tag.ant-tag{font-size:1.2em;line-height:1.3;padding:0.1em 0.5em}a.alain-default__header-logo-link{text-align:left;padding:0 12px;font-size:1.75em;line-height:1}a.alain-default__header-logo-link:before{content:\"$1\";color:white}.alain-default__collapsed .alain-default__header-logo{width:auto\!important}</style>" dist/index.html
sed -i "4s/HertzBeat/$(echo $1)/" dist/index.html
sed -i "3s/HertzBeat/$(echo $1)/" dist/assets/app-data.json
sed -ri "s/hertzbeat/$(echo $1)/Ig" dist/assets/i18n/en-US.json
sed -ri "s/hertzbeat/$(echo $1)/Ig" dist/assets/i18n/zh-CN.json
sed -ri "s/hertzbeat/$(echo $1)/Ig" dist/assets/i18n/zh-TW.json
cp -f $2 dist/favicon.ico

echo "docker build -t hertzbeat:customized -f $CURRENT_DIR/Dockerfile $CONTEXT_DIR"

docker build -t hertzbeat:customized -f $CURRENT_DIR/Dockerfile $CONTEXT_DIR

docker save -o hertzbeat_customized.tar hertzbeat:customized

read -p "press -> end"