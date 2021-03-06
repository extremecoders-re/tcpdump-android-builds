#!/bin/bash

output_dir=libpcap_all_targets
android_targets="arm arm64 x86 x86_64"
android_api_min=21
android_api_max=30

if [ ${OUTPUT_DIR} ]
then
    output_dir=${OUTPUT_DIR}
fi

if [ ${TARGETS} ]
then
    android_targets=${TARGETS}
fi

if [ ${API_MIN} ]
then
    android_api_min=${API_MIN}
fi

if [ ${API_MAX} ]
then
    android_api_max=${API_MAX}
fi

echo "________________________________________"
echo ""
echo "Output dir :   ${output_dir}"
echo "Targets    :   ${android_targets}"
echo "Android API:   ${android_api_min}..${android_api_max}"
echo "________________________________________"

read -p "Press enter to start or ctrl+c to abort"

rm -rf ${output_dir}

for android_target in ${android_targets}
do
    for android_api in $(eval echo {${android_api_min}..${android_api_max}})
    do
        rm -rf tcpdumpbuild-${android_target}/
        ANDROID_API=${android_api} ./build_${android_target}.sh || continue
        dest_dir=${output_dir}/${android_target}/${android_api}
        mkdir -p ${dest_dir}
        cp tcpdumpbuild-${android_target}/libpcap-1.9.0/libpcap.a ${dest_dir}
        echo "**** DONE ${dest_dir} ****"
    done
done
