#!/bin/bash

# Author : Javier Rojas
# StarMeUp : https://www.starmeup.com/profile/0097a78720cf6cfdaad554bbbba31d46
BBLUE="$(tput setab 4)"
FLIGHTBLUE="$(tput setaf 6)"
BOLD="$(tput bold)"
ENDCOLOR="$(tput sgr0)"
FYELLOW="$(tput setaf 3)"
DATESTAMP=`date +"%d-%m-%Y %T"`
WORKER="Worker"
CheckForDepencies (){
    echo "${FYELLOW}Checking Dependencies:${ENDCOLOR}"
    if ! command -v yq &> /dev/null
    then
        echo "${FYELLOW}WARING:${ENDCOLOR} ${BOLD}yq${ENDCOLOR} could not be found, please install from https://mikefarah.github.io/yq/"
        exit
    else
        echo "${FYELLOW}yq OK${ENDCOLOR}"
        SLS_FUNCTIONS=$(yq ea -N -I 0 '.functions.[] | path | .[-1]' serverless.yml)
        SLS_WORKERS=$(yq ea -N -I 0 '.constructs.[] | path | .[-1]' serverless.yml)
    fi

    if ! command -v sls &> /dev/null
    then
        echo "${FYELLOW}WARING:${ENDCOLOR} ${BOLD}Serverless${ENDCOLOR} could not be found, please install"
        exit
    else
        echo "${FYELLOW}Serverless OK${ENDCOLOR}"
    fi

    if ! command -v aws &> /dev/null
    then
        echo "${FYELLOW}WARING:${ENDCOLOR} ${BOLD}AWS CLI${ENDCOLOR} could not be found, please install"
        exit
    else
        echo "${FYELLOW}AWS CLI OK${ENDCOLOR}"
    fi
}


ListFunctions () {
    printf "Functions List: \n\n"
    ITERATOR=1
    for sls_function in $SLS_FUNCTIONS
    do
        echo -e "${BOLD}${BBLUE}  $ITERATOR > ${ENDCOLOR} $sls_function"
        ITERATOR=`echo "$ITERATOR+1" | bc`
    done
    ITERATORB=`echo "$ITERATOR" | bc`
    for sls_worker in $SLS_WORKERS
    do
        echo -e "${BOLD}${BBLUE}  $ITERATORB > ${ENDCOLOR} $sls_worker$WORKER"
        ITERATORB=`echo "$ITERATORB+1" | bc`
    done
    ProcessDeployment
}
FunctionNotFound () {
    clear
    printf "${FYELLOW}That function doesn't exist.${ENDCOLOR} \n"
    read -p "${FYELLOW}Do you want to continue? ${ENDCOLOR} [Y/n]: " continue_res
    if [[ $continue_res == "Y" || $continue_res == "y" ]]; then
        ListFunctions
    else
        exit
    fi
}
ProcessDeployment () {
    printf "\n"
    echo -n "${FLIGHTBLUE} Select a Function to deploy: ${ENDCOLOR}"
    read sls_function_selected
    ITERATOR=1
    ISFOUND=0
    for sls_function in $SLS_FUNCTIONS
    do
        
        if [ $ITERATOR = $sls_function_selected ]
        then
            ISFOUND=1
            echo "${FLIGHTBLUE} Are you sure to deploy function ${ENDCOLOR} ${BOLD}${BBLUE} $sls_function ${ENDCOLOR}? ${FYELLOW}(y or n)${ENDCOLOR}"
            read deploy
            if [[ $deploy = "y" || $deploy = "Y" ]]
            then
                clear
                echo "${FLIGHTBLUE} Deploying${ENDCOLOR} $sls_function..."
                sls deploy -f $sls_function
                echo "${FLIGHTBLUE} Deployed${ENDCOLOR} @ ${DATESTAMP}"
                echo "${FLIGHTBLUE} Do you want to select another function?${ENDCOLOR} ${FYELLOW}(y or n)${ENDCOLOR}"
                read restart_function
                if [[ $restart_function = "y" || $restart_function = "Y" ]]
                then
                    clear
                    ListFunctions
                else
                    echo "${FYELLOW}See you soon racoon!${ENDCOLOR}"
                    exit 1
                fi
            else
                echo "${FLIGHTBLUE} Do you want to select another function?${ENDCOLOR} ${FYELLOW}(y or n)${ENDCOLOR}"
                read restart_function
                if [[ $restart_function = "y" || $restart_function = "Y" ]]
                then
                    clear
                    ListFunctions
                else
                    echo "${FYELLOW}See you soon racoon!${ENDCOLOR}"
                    exit 1
                fi
            fi
        fi
        ITERATOR=`echo "$ITERATOR+1" | bc`
    done
    ITERATORB=`echo "$ITERATOR" | bc`
    for sls_worker in $SLS_WORKERS
    do
        
        if [ $ITERATORB = $sls_function_selected ]
        then
            ISFOUND=1
            echo "${FLIGHTBLUE} Are you sure to deploy function ${ENDCOLOR} ${BOLD}${BBLUE} $sls_worker$WORKER ${ENDCOLOR}? ${FYELLOW}(y or n)${ENDCOLOR}"
            read deploy
            if [[ $deploy = "y" || $deploy = "Y" ]]
            then
                clear
                echo "${FLIGHTBLUE} Deploying${ENDCOLOR} $sls_worker$WORKER..."
                sls deploy -f $sls_worker$WORKER
                echo "${FLIGHTBLUE} Deployed${ENDCOLOR} @ ${DATESTAMP}"
                echo "${FLIGHTBLUE} Do you want to select another function?${ENDCOLOR} ${FYELLOW}(y or n)${ENDCOLOR}"
                read restart_function
                if [[ $restart_function = "y" || $restart_function = "Y" ]]
                then
                    clear
                    ListFunctions
                else
                    echo "${FYELLOW}See you soon racoon!${ENDCOLOR}"
                    exit 1
                fi
            else
                echo "${FLIGHTBLUE} Do you want to select another function?${ENDCOLOR} ${FYELLOW}(y or n)${ENDCOLOR}"
                read restart_function
                if [[ $restart_function = "y" || $restart_function = "Y" ]]
                then
                    clear
                    ListFunctions
                else
                    echo "${FYELLOW}See you soon racoon!${ENDCOLOR}"
                    exit 1
                fi
            fi
        fi
        ITERATOR=`echo "$ITERATOR+1" | bc`
    done
    if [ $ISFOUND == 0 ]; then
        FunctionNotFound
    fi
}
CheckForDepencies
ListFunctions
