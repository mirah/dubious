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
javac -classpath $CP -d $OUTDIR testing/Dir.java
javac -classpath $CP -d $OUTDIR testing/SimpleJava.java
dubyc -c $CP -d $OUTDIR testing/SimpleDuby.duby
dubyc -c $CP -d $OUTDIR stdlib/array.duby
dubyc -c $CP -d $OUTDIR stdlib/io.duby
dubyc -c $CP -d $OUTDIR stdlib/ha.duby
javac -classpath $CP -d $OUTDIR dubious/ScopedParameterMap.java
javac -classpath $CP -d $OUTDIR dubious/Inflection.java
dubyc -c $CP -d $OUTDIR dubious/inflections.duby
dubyc -c $CP -d $OUTDIR dubious/time_conversion.duby
dubyc -c $CP -d $OUTDIR dubious/text_helper.duby
dubyc -c $CP -d $OUTDIR dubious/params.duby
dubyc -c $CP -d $OUTDIR dubious/form_helper.duby
dubyc -c $CP -d $OUTDIR dubious/action_controller.duby
dubyc -c $CP -j         dubious/action_controller.duby
cd ../app
dubyc -c $CP -d $OUTDIR models/contacts.duby
dubyc -c $CP -j         models/contacts.duby
dubyc -c $CP -d $OUTDIR controllers/application_controller.duby
dubyc -c $CP -d $OUTDIR controllers/shout_controller.duby
dubyc -c $CP -d $OUTDIR controllers/source_controller.duby
dubyc -c $CP -d $OUTDIR controllers/info_properties_controller.duby
dubyc -c $CP -d $OUTDIR controllers/contacts_controller.duby
dubyc -c $CP -j controllers/contacts_controller.duby
cd $OUTDIR
jar -cf ../WEB-INF/lib/application.jar models/* controllers/*
jar -cf ../WEB-INF/lib/dubious.jar testing/* stdlib/* dubious/*
cd ..
