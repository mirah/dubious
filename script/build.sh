#!/bin/sh
OUTDIR=`pwd`/build
WEB_INF_LIB=`pwd`/WEB-INF/lib

### Construct the path to jars we need
SDK_DIR="/usr/local/appengine-java-sdk-1.3.5"
export APPENGINE_JAVA_SDK=$SDK_DIR
SERVLET="$SDK_DIR/lib/shared/geronimo-servlet_2.5_spec-1.2.jar"
SDK_API="$WEB_INF_LIB/appengine-api-1.0-sdk-1.3.5.jar"
LABSJAR="$WEB_INF_LIB/user/appengine-api-labs-1.3.5.jar"
DBMODEL="$WEB_INF_LIB/dubydatastore.jar"

### Make sure we have the jars we need
mkdir -p $OUTDIR
mkdir -p $WEB_INF_LIB
script/environment.rb # copy dubydatastore.jar (unless exists)

### Generate class files
CP=$SERVLET:$SDK_API:$OUTDIR:$DBMODEL:.
cd lib

### Dubious Tests
javac -classpath $CP -d $OUTDIR testing/SimpleJava.java
mirahc -c $CP -d $OUTDIR testing/SimpleDuby.duby

#### Dubious's classes

mirahc -c $CP -d $OUTDIR stdlib/array.duby
mirahc -c $CP -d $OUTDIR stdlib/io.duby
mirahc -c $CP -d $OUTDIR stdlib/ha.duby
javac -classpath $CP -d $OUTDIR dubious/ScopedParameterMap.java
javac -classpath $CP -d $OUTDIR dubious/Inflection.java
mirahc -c $CP -d $OUTDIR dubious/asset_timestamps_cache.duby
mirahc -c $CP -d $OUTDIR dubious/inflections.duby
mirahc -c $CP -d $OUTDIR dubious/time_conversion.duby
mirahc -c $CP -d $OUTDIR dubious/text_helper.duby
mirahc -c $CP -d $OUTDIR dubious/params.duby
mirahc -c $CP -d $OUTDIR dubious/form_helper.duby
mirahc -c $CP -d $OUTDIR dubious/action_controller.duby

#### App classes 

cd ../app
mirahc -c $CP -d $OUTDIR models/contacts.duby
mirahc -c $CP -d $OUTDIR controllers/application_controller.duby
mirahc -c $CP -d $OUTDIR controllers/shout_controller.duby
mirahc -c $CP -d $OUTDIR controllers/source_controller.duby
mirahc -c $CP -d $OUTDIR controllers/info_properties_controller.duby
mirahc -c $CP -d $OUTDIR controllers/contacts_controller.duby

cd $OUTDIR
jar -cf ../WEB-INF/lib/application.jar models/* controllers/*
jar -cf ../WEB-INF/lib/dubious.jar testing/* stdlib/* dubious/*
cd ..
