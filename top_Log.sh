HOSTNAME=`hostname`

#Delete top_GAA.csv
rm top_GAA.csv

if [ "$HOSTNAME" = "usplsgaavmias04" -o "$HOSTNAME" = "usplsgaavmias06" ]
then
   GAA_ADMIN="gaa_admin"
   GAA_JVMS="gaa001 gaa005 gaa009 gaa013 gaa017 gaa021"
   PREFETCH_JVMS="gaa025"
   WS_JVMS="gaa029"
   JMS_JVMS="gaa033"
fi

if [ "$HOSTNAME" = "usplsgaavmias05" -o "$HOSTNAME" = "usplsgaavmias07" ]
then
   GAA_ADMIN=""
   GAA_JVMS="gaa002 gaa006 gaa010 gaa014 gaa018 gaa022"
   PREFETCH_JVMS="gaa026"
   WS_JVMS="gaa030"
   JMS_JVMS="gaa034"
fi

if [ "$HOSTNAME" = "usplsgaavmias08" -o "$HOSTNAME" = "usplsgaavmias13" ]
then
   GAA_ADMIN=""
   GAA_JVMS="gaa003 gaa007 gaa011 gaa015 gaa019 gaa023"
   PREFETCH_JVMS="gaa027"
   WS_JVMS="gaa031"
   JMS_JVMS="gaa035"
fi

if [ "$HOSTNAME" = "usplsgaavmias09" -o "$HOSTNAME" = "usplsgaavmias14" ]
then
   GAA_ADMIN=""
   GAA_JVMS="gaa004 gaa008 gaa012 gaa016 gaa020 gaa024"
   PREFETCH_JVMS="gaa028"
   WS_JVMS="gaa032"
   JMS_JVMS="gaa036"
fi

if [ "$HOSTNAME" = "usplsgasvmias03" -o "$HOSTNAME" = "usplsgasvmias07" -o "$HOSTNAME" = "usplsgasvmias05" -o "$HOSTNAME" = "usplsgasvmias09" ]
then
   GAA_ADMIN="gaa_admin"
   GAA_JVMS=""
   PREFETCH_JVMS=""
   WS_JVMS="gaa001 gaa003 gaa005"
   JMS_JVMS=""
fi

if [ "$HOSTNAME" = "usplsgasvmias04" -o "$HOSTNAME" = "usplsgasvmias08" -o "$HOSTNAME" = "usplsgasvmias06" -o "$HOSTNAME" = "usplsgasvmias10" ]
then
   GAA_ADMIN=""
   GAA_JVMS=""
   PREFETCH_JVMS=""
   WS_JVMS="gaa002 gaa004 gaa006"
   JMS_JVMS=""
fi

START=`date +%H`;
STOP=`date +%H`;
ELAPSED=0;
OEM=`ps -ef | grep '/vol01/local/oracle/agent12cHome/core/12.1.0.3.0/jdk/bin/java' | grep 'oem' | awk '{print $2}'`;

echo "The top for below JVMs is being taken"

for JVM in ${GAA_ADMIN} ${GAA_JVMS} ${PREFETCH_JVMS} ${WS_JVMS} ${JMS_JVMS};
do

   jvmPid=`ps -ef | grep Bgaa | grep "oracle/wls103602/"        | grep "Dweblogic.Name=${JVM} " | grep -v grep | awk '{print $2}'`

   echo "  ${JVM} - pid: ${jvmPid}"
   echo "  ${JVM} - pid: ${jvmPid}" >> top_GAA.csv      ;

done

        echo "  OEMJVM - pid: ${OEM}"
        echo "  OEMJVM - pid: ${OEM}" >> top_GAA.csv


echo "TIME      JVM     ProcessID       SHRD_MEM        %CPU    %MEM\n">>top_GAA.csv;
while [ $ELAPSED != 3600 ]
do
        for JVM in ${GAA_ADMIN} ${GAA_JVMS} ${PREFETCH_JVMS} ${WS_JVMS} ${JMS_JVMS}
        do
                jvmPid=`ps -ef | grep Bgaa | grep "oracle/wls103602/" | grep "Dweblogic.Name=${JVM} " | grep -v grep | awk '{print $2}'`
                if [ "$jvmPid" != "" ]
                        then
                                #echo "  ${JVM} - pid: ${jvmPid}"
                                #`top  -d2  -n 1 -H -b | grep ${jvmPid} | tee -a  top_GAA.csv &`;
                                echo `date | awk '{printf $4"   "}'` ${JVM} `top  -d2  -n 1  -b | grep ${jvmPid} |  awk '{printf $1"    "$7"    "$9"    "$10"\n"  }'` >> top_GAA.csv;
                                # it actually works - echo "justlike that \n">>top_GAA.csv;
                              
                                
                                #echo " $(JVM) - $(variable)" >> top_GAA_trial.csv  &;
                                #`kill -9 ${jvmPid}`;
				STOP=$(date +"%s");
				ELAPSED=$(($STOP - $START));
				#echo $ELAPSED;
				#echo  $STOP $ELAPSED;
                fi
        done
        #echo "-just to see if it works">> top_GAA.csv;
        echo `date | awk '{printf $4"   "}'` "OEMJVM" `top  -d2  -n 1 -b | grep ${OEM} |  awk '{printf $1"      "$7"    "$9"    "$10"\n"  }'` >> top_GAA.csv
done

