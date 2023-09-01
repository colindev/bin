#!/bin/bash

parse_level_id(){
    
    level=${1%%s/*}
    id=${1##*/}
    echo $level $id
}

cmd=${1}

case $cmd in
    -h|--help|help)
        echo ${0} gen [level/id:organizations/1234] [role id] [roles...]
        iam-roles -h
        ;;
    gen)
        
        level_id=${2:?level/id}
        role_id=${3:?role id}
        shift 3

        level=${level_id%%s/*}
        id=${level_id##*/}
        key=
        case "$level" in
            organization)
                key=org_id
                ;;
            project)
                key=project
                ;;
            *)
                echo not support $level >&2
                exit 1
        esac
        
        echo 'resource "google_'${level}'_iam_custom_role" "'${role_id}'" {'
        echo '  '${key}'      = "'${id}'"'
        echo '  role_id     = "'${role_id}'"'
        echo '  stage       = "ALPHA"'
        echo '  title       = "'${role_id}'"'
        echo '  description = <<EOT'
        echo 'EOT'
        echo '  permissions = ['
        iam-roles merge $@|wrap-permissions.sh
        echo '  ]'
        echo '}'
        
        import="terraform import google_${level}_iam_custom_role.${role_id} ${id}/${role_id}"
        echo '#> '$import
        echo $import >&2
        echo '#> '${0} $cmd $org_id $role_id $@
        echo ${0} $cmd $org_id $role_id $@ >&2

        exit 0

        ;;
    *)
        iam-roles $@
        ;;

esac

