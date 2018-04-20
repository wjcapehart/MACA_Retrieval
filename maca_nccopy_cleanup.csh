#!/bin/bash



unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
   export NCARG_ROOT=/usr/local/ncl-6.4.0
   export NCARG_RANGS=/usr/local/rangs
   export DYLD_FALLBACK_LIBRARY_PATH=/usr/local/Cellar/gcc/7.3.0/lib/gcc/7/:$DYLD_FALLBACK_LIBRARY_PATH
   export PATH=$NCARG_ROOT/bin:"$PATH"


   ### Environment for Local use on Kyrill file syetem.

   export CASE="HISTORICAL"
   # export CASE="FUTURE"

   # South Dakota with full Cheyenne Basin and Big Sioux Basin

   export SODAK_CHEY_CLIP=" -d lat,42.24,46.299 -d lon,253.78,264.59 "
   export SODAK_CHEY_CLIP=" -d lat,42.24,46.299 -d lon,-106.220,-95.4100 "

   ### NCL COMMANDS TO FETCH GRIDCELLS BY LAT/LON
   #
   #   deg_target = lat({46.299 })
   #   index = ind(lat .eq. deg_target)
   #   print(index + " " +  lat(index))
   #
   #
   ##################

   export LONCLIP="[445:1:705]"
   export LATCLIP="[412:1:510]"


   export NCCOPY="nccopy"

   # CIDA THREDDS Address for both Historical and Future Scenarios

   export     FUTURE_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/macav2metdata_daily_future"
   export HISTORICAL_ORIGINAL_URL="https://cida.usgs.gov/thredds/dodsC/macav2metdata_daily_historical"

   # Setting Local Points to Revieved Clipped Data

   export CLIPPED_PREFIX="/projects/ECEP/LOCA_MACA_Ensembles/MACA/MACA_OUTPUT/grid/SODAK_MACA"

   # setting the CIDA THREDDS Address



   declare -a TIND_VALS=(    0
                             1
                             2
                             3
                             4
                             5
                             6
                             7
                             8
                             9
                            10
                            11
                            12
                            13
                            14
                            15
                            16
                            17
                            18
                            19
                            20
                            21
                            22
                            23
                            24
                            25
                            26
                            27
                            28
                            29
                            30
                            31
                            32
                            33
                            34
                            35
                            36
                            37
                            38
                            39
                            40
                            41
                            42
                            43
                            44
                            45
                            46
                            47
                            48
                            49
                            50
                            51
                            52
                            53
                            54
                            55
                            56
                            57
                            58
                            59
                            60
                            61
                            62
                            63
                            64
                            65
                            66
                            67
                            68
                            69
                            70
                            71
                            72
                            73
                            74
                            75
                            76
                            77
                            78
                            79
                            80
                            81
                            82
                            83
                            84
                            85
                            86
                            87
                            88
                            89
                            90
                            91
                            92
                            93
                            94
                            95
                            96
                            97
                            98
                            99
                           100
                           101
                           102
                           103
                           104
                           105
                           106
                           107
                           108
                           109
                           110
                           111 )


   declare -a TIMECLIPCODE=(  "__T001"
                           "__T002"
                           "__T003"
                           "__T004"
                           "__T005"
                           "__T006"
                           "__T007"
                           "__T008"
                           "__T009"
                           "__T010"
                           "__T011"
                           "__T012"
                           "__T013"
                           "__T014"
                           "__T015"
                           "__T016"
                           "__T017"
                           "__T018"
                           "__T019"
                           "__T020"
                           "__T021"
                           "__T022"
                           "__T023"
                           "__T024"
                           "__T025"
                           "__T026"
                           "__T027"
                           "__T028"
                           "__T029"
                           "__T030"
                           "__T031"
                           "__T032"
                           "__T033"
                           "__T034"
                           "__T035"
                           "__T036"
                           "__T037"
                           "__T038"
                           "__T039"
                           "__T040"
                           "__T041"
                           "__T042"
                           "__T043"
                           "__T044"
                           "__T045"
                           "__T046"
                           "__T047"
                           "__T048"
                           "__T049"
                           "__T050"
                           "__T051"
                           "__T052"
                           "__T053"
                           "__T054"
                           "__T055"
                           "__T056"
                           "__T057"
                           "__T058"
                           "__T059"
                           "__T060"
                           "__T061"
                           "__T062"
                           "__T063"
                           "__T064"
                           "__T065"
                           "__T066"
                           "__T067"
                           "__T068"
                           "__T069"
                           "__T070"
                           "__T071"
                           "__T072"
                           "__T073"
                           "__T074"
                           "__T075"
                           "__T076"
                           "__T077"
                           "__T078"
                           "__T079"
                           "__T080"
                           "__T081"
                           "__T082"
                           "__T083"
                           "__T084"
                           "__T085"
                           "__T086"
                           "__T087"
                           "__T088"
                           "__T089"
                           "__T090"
                           "__T091"
                           "__T092"
                           "__T093"
                           "__T094"
                           "__T095"
                           "__T096"
                           "__T097"
                           "__T098"
                           "__T099"
                           "__T100"
                           "__T101"
                           "__T102"
                           "__T103"
                           "__T104"
                           "__T105"
                           "__T106"
                           "__T107"
                           "__T108"
                           "__T109"
                           "__T110"
                           "__T111"
                           "__T112" )

   # setting the Setting the Available RCP Scenarios




   # setting the Setting the Available ensembles
   #   currently only those members that have hits
   #   for all three variables!

   declare -a ENSEMBLE=(
                           "BNU-ESM_r1i1p1"
                           "CCSM4_r6i1p1"
                           "CNRM-CM5_r1i1p1"
                           "CSIRO-Mk3-6-0_r1i1p1"
                           "CanESM2_r1i1p1"
                           "GFDL-ESM2G_r1i1p1"
                           "GFDL-ESM2M_r1i1p1"
                           "HadGEM2-CC365_r1i1p1"
                           "HadGEM2-ES365_r1i1p1"
                           "IPSL-CM5A-LR_r1i1p1"
                           "IPSL-CM5A-MR_r1i1p1"
                           "IPSL-CM5B-LR_r1i1p1"
                           "MIROC-ESM_r1i1p1"
                           "MIROC-ESM-CHEM_r1i1p1"
                           "MIROC5_r1i1p1"
                           "MRI-CGCM3_r1i1p1"
                           "NorESM1-M_r1i1p1"
                           "bcc-csm1-1-m_r1i1p1"
                           "bcc-csm1-1_r1i1p1"
                           "inmcm4_r1i1p1"
                        )

   # setting the available variables

   declare -a    PARAM=(
                          "pr"
                          "tasmax"
                          "tasmin"
                          "huss"
                          "rhsmax"
                          "rhsmin"
                          "rsds"
                          "uas"
                          "vas"
                          )


   declare -a    PARAM=(   "pr"
                           "tasmax"
                           "tasmin"
                           "huss"
                         )


    declare -a SCENARIO=(  "historical"
                           "rcp85"
                           "rcp45")

   ######## Start Loop!


    declare -a PASSES=(  "1"
                         "2"  )


   for PASS in  "${PASSES[@]}"
   do

      echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      echo
      for SCEN in "${SCENARIO[@]}"
      do

         if [ ${SCEN} == "historical" ]
         then
            export ORIGINAL_URL=${HISTORICAL_ORIGINAL_URL}
            declare -a TIMECLIP=(   "[00000:1:00183]"
                                    "[00184:1:00365]"
                                    "[00366:1:00548]"
                                    "[00549:1:00730]"
                                    "[00731:1:00913]"
                                    "[00914:1:01096]"
                                    "[01097:1:01278]"
                                    "[01279:1:01461]"
                                    "[01462:1:01644]"
                                    "[01645:1:01826]"
                                    "[01827:1:02009]"
                                    "[02010:1:02191]"
                                    "[02192:1:02374]"
                                    "[02375:1:02557]"
                                    "[02558:1:02739]"
                                    "[02740:1:02922]"
                                    "[02923:1:03104]"
                                    "[03105:1:03287]"
                                    "[03288:1:03470]"
                                    "[03471:1:03652]"
                                    "[03653:1:03835]"
                                    "[03836:1:04018]"
                                    "[04019:1:04200]"
                                    "[04201:1:04383]"
                                    "[04384:1:04565]"
                                    "[04566:1:04748]"
                                    "[04749:1:04931]"
                                    "[04932:1:05113]"
                                    "[05114:1:05296]"
                                    "[05297:1:05478]"
                                    "[05479:1:05661]"
                                    "[05662:1:05844]"
                                    "[05845:1:06026]"
                                    "[06027:1:06209]"
                                    "[06210:1:06392]"
                                    "[06393:1:06574]"
                                    "[06575:1:06757]"
                                    "[06758:1:06939]"
                                    "[06940:1:07122]"
                                    "[07123:1:07305]"
                                    "[07306:1:07487]"
                                    "[07488:1:07670]"
                                    "[07671:1:07852]"
                                    "[07853:1:08035]"
                                    "[08036:1:08218]"
                                    "[08219:1:08400]"
                                    "[08401:1:08583]"
                                    "[08584:1:08766]"
                                    "[08767:1:08948]"
                                    "[08949:1:09131]"
                                    "[09132:1:09313]"
                                    "[09314:1:09496]"
                                    "[09497:1:09679]"
                                    "[09680:1:09861]"
                                    "[09862:1:10044]"
                                    "[10045:1:10227]"
                                    "[10228:1:10409]"
                                    "[10410:1:10592]"
                                    "[10593:1:10774]"
                                    "[10775:1:10957]"
                                    "[10958:1:11140]"
                                    "[11141:1:11322]"
                                    "[11323:1:11505]"
                                    "[11506:1:11687]"
                                    "[11688:1:11870]"
                                    "[11871:1:12053]"
                                    "[12054:1:12235]"
                                    "[12236:1:12418]"
                                    "[12419:1:12601]"
                                    "[12602:1:12783]"
                                    "[12784:1:12966]"
                                    "[12967:1:13148]"
                                    "[13149:1:13331]"
                                    "[13332:1:13514]"
                                    "[13515:1:13696]"
                                    "[13697:1:13879]"
                                    "[13880:1:14061]"
                                    "[14062:1:14244]"
                                    "[14245:1:14427]"
                                    "[14428:1:14609]"
                                    "[14610:1:14792]"
                                    "[14793:1:14975]"
                                    "[14976:1:15157]"
                                    "[15158:1:15340]"
                                    "[15341:1:15522]"
                                    "[15523:1:15705]"
                                    "[15706:1:15888]"
                                    "[15889:1:16070]"
                                    "[16071:1:16253]"
                                    "[16254:1:16435]"
                                    "[16436:1:16618]"
                                    "[16619:1:16801]"
                                    "[16802:1:16983]"
                                    "[16984:1:17166]"
                                    "[17167:1:17349]"
                                    "[17350:1:17531]"
                                    "[17532:1:17714]"
                                    "[17715:1:17896]"
                                    "[17897:1:18079]"
                                    "[18080:1:18262]"
                                    "[18263:1:18444]"
                                    "[18445:1:18627]"
                                    "[18628:1:18809]"
                                    "[18810:1:18992]"
                                    "[18993:1:19175]"
                                    "[19176:1:19357]"
                                    "[19358:1:19540]"
                                    "[19541:1:19723]"
                                    "[19724:1:19905]"
                                    "[19906:1:20088]"
                                    "[20089:1:20270]"
                                    "[20271:1:20453]" )


         else
            export ORIGINAL_URL=${FUTURE_ORIGINAL_URL}
            declare -a TIMECLIP=(   "[00000:1:00310]"
                                    "[00311:1:00620]"
                                    "[00621:1:00929]"
                                    "[00930:1:01239]"
                                    "[01240:1:01549]"
                                    "[01550:1:01859]"
                                    "[01860:1:02169]"
                                    "[02170:1:02478]"
                                    "[02479:1:02788]"
                                    "[02789:1:03098]"
                                    "[03099:1:03408]"
                                    "[03409:1:03718]"
                                    "[03719:1:04027]"
                                    "[04028:1:04337]"
                                    "[04338:1:04647]"
                                    "[04648:1:04957]"
                                    "[04958:1:05267]"
                                    "[05268:1:05576]"
                                    "[05577:1:05886]"
                                    "[05887:1:06196]"
                                    "[06197:1:06506]"
                                    "[06507:1:06815]"
                                    "[06816:1:07125]"
                                    "[07126:1:07435]"
                                    "[07436:1:07745]"
                                    "[07746:1:08055]"
                                    "[08056:1:08364]"
                                    "[08365:1:08674]"
                                    "[08675:1:08984]"
                                    "[08985:1:09294]"
                                    "[09295:1:09604]"
                                    "[09605:1:09913]"
                                    "[09914:1:10223]"
                                    "[10224:1:10533]"
                                    "[10534:1:10843]"
                                    "[10844:1:11153]"
                                    "[11154:1:11462]"
                                    "[11463:1:11772]"
                                    "[11773:1:12082]"
                                    "[12083:1:12392]"
                                    "[12393:1:12702]"
                                    "[12703:1:13011]"
                                    "[13012:1:13321]"
                                    "[13322:1:13631]"
                                    "[13632:1:13941]"
                                    "[13942:1:14251]"
                                    "[14252:1:14560]"
                                    "[14561:1:14870]"
                                    "[14871:1:15180]"
                                    "[15181:1:15490]"
                                    "[15491:1:15800]"
                                    "[15801:1:16109]"
                                    "[16110:1:16419]"
                                    "[16420:1:16729]"
                                    "[16730:1:17039]"
                                    "[17040:1:17349]"
                                    "[17350:1:17658]"
                                    "[17659:1:17968]"
                                    "[17969:1:18278]"
                                    "[18279:1:18588]"
                                    "[18589:1:18897]"
                                    "[18898:1:19207]"
                                    "[19208:1:19517]"
                                    "[19518:1:19827]"
                                    "[19828:1:20137]"
                                    "[20138:1:20446]"
                                    "[20447:1:20756]"
                                    "[20757:1:21066]"
                                    "[21067:1:21376]"
                                    "[21377:1:21686]"
                                    "[21687:1:21995]"
                                    "[21996:1:22305]"
                                    "[22306:1:22615]"
                                    "[22616:1:22925]"
                                    "[22926:1:23235]"
                                    "[23236:1:23544]"
                                    "[23545:1:23854]"
                                    "[23855:1:24164]"
                                    "[24165:1:24474]"
                                    "[24475:1:24784]"
                                    "[24785:1:25093]"
                                    "[25094:1:25403]"
                                    "[25404:1:25713]"
                                    "[25714:1:26023]"
                                    "[26024:1:26333]"
                                    "[26334:1:26642]"
                                    "[26643:1:26952]"
                                    "[26953:1:27262]"
                                    "[27263:1:27572]"
                                    "[27573:1:27882]"
                                    "[27883:1:28191]"
                                    "[28192:1:28501]"
                                    "[28502:1:28811]"
                                    "[28812:1:29121]"
                                    "[29122:1:29430]"
                                    "[29431:1:29740]"
                                    "[29741:1:30050]"
                                    "[30051:1:30360]"
                                    "[30361:1:30670]"
                                    "[30671:1:30979]"
                                    "[30980:1:31289]"
                                    "[31290:1:31599]"
                                    "[31600:1:31909]"
                                    "[31910:1:32219]"
                                    "[32220:1:32528]"
                                    "[32529:1:32838]"
                                    "[32839:1:33148]"
                                    "[33149:1:33458]"
                                    "[33459:1:33768]"
                                    "[33769:1:34077]"
                                    "[34078:1:34387]"
                                    "[34388:1:34697]" )
         fi

         for PAR in "${PARAM[@]}"
         do

            for ENS in "${ENSEMBLE[@]}"
            do
               echo --------------------------------------
               echo
               echo Processing ${PAR}_${ENS}_${SCEN}
               echo

               for TIND in "${TIND_VALS[@]}"
               do

                  export FILENAME=${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc

                  export FILENAME=${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                  export  VARNAME=${PAR}_${ENS}_${SCEN}

                  ncl -Q -n file_name='"'${FILENAME}'"' variable_name='"'${VARNAME}'"'  vartype='"'${PAR}'"' macaloca_scan_and_check.ncl

                  if [ ! -f ${FILENAME} ]; then
                     echo missing ${FILENAME}
                     echo

                     export TYX_COORDS=${TIMECLIP[${TIND}]}${LATCLIP}${LONCLIP}

                     export ALWAYS_GET_US=lon${LONCLIP},lat${LATCLIP},time${TIMECLIP[${TIND}]}


                     echo  nohup nccopy -7 -d 8 ${ORIGINAL_URL}?${ALWAYS_GET_US},${PAR}_${ENS}_${SCEN}${TYX_COORDS} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                           nohup nccopy -7 -d 8 ${ORIGINAL_URL}?${ALWAYS_GET_US},${PAR}_${ENS}_${SCEN}${TYX_COORDS} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                     echo

                     echo nohup ncks -h --mk_rec_dmn time  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          nohup ncks -h --mk_rec_dmn time  ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]} ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo

                     echo  rm -frv   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                           rm -frv   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}
                     echo

                     echo  nohup ncpdq -h -U   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           nohup ncpdq -h -U   ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc              temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                           mv -fv                           temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo

                     echo nohup ncap2 --overwrite --history --script 'where(lon>180) lon=lon-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          nohup ncap2 --overwrite --history --script 'where(lon>180) lon=lon-360' ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo

                     echo mv -fv temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                          mv -fv temp_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc ${CLIPPED_PREFIX}_${PAR}_${ENS}_${SCEN}_${TIMECLIPCODE[$TIND]}.nc
                     echo


                  fi

               done
               echo
               echo --------------------------------------
               echo
            done
         done
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo ======================================
         echo
      done

      echo $PASS COMPLETE

   done



else

   echo This Script Only Works on our Macs at Present.

fi



echo "We're Out of Here Like Vladimir"
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
