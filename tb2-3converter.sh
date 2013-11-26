#! /bin/bash

scriptAction=$1
fileStream=$2

if [[ -n "$scriptAction" ]] && [[ -n "$fileStream" ]] && ([ "$scriptAction" == "convert" ] || [ "$scriptAction" == "revert" ])
  then
    if [[ -e "$fileStream" ]]
      then
        # Array pretending to be a Pythonic dictionary
        # There are 42 possible classes to convert.
        ARRAY=(
          "container-fluid:container"
          "row-fluid:row"
          "offset:col-md-offset-"
          "span:col-md-"
          "brand:navbar-brand"
          "nav-collapse:navbar-collapse"
          "nav-toggle:navbar-toggle"
          "btn-navbar:navbar-btn"
          "hero-unit:jumbotron"
          "icon-:glyphicon glyphicon-"
          "putThisBtnBack-mini:btn-xs"
          "putThisBtnBack-small:btn-sm"
          "putThisBtnBack-large:btn-lg"
          "btn:btn btn-default"
          "alert-error:alert-danger"
          "visible-phone:visible-xs"
          "visible-tablet:visible-sm"
          "visible-desktop:visible-md"
          "hidden-phone:hidden-xs"
          "hidden-tablet:hidden-sm"
          "hidden-desktop:hidden-md"
          "input-small:input-sm"
          "input-large:input-lg"
          "control-group:form-group"
          "checkbox inline:checkbox-inline"
          "radio inline:radio-inline"
          "input-prepend:input-group"
          "input-append:input-group"
          "add-on:input-group-addon"
          "img-polaroid:img-thumbnail"
          "unstyled:list-unstyled"
          "inline:list-inline"
          "muted:text-muted"
          "text-error:text-danger"
          "table error:table danger"
          "bar:progress-bar"
          "bar-:progress-bar-"
          "accordion:panel-group"
          "accordion-group:panel panel-default"
          "accordion-heading:panel-heading"
          "accordion-body:panel-collapse"
          "accordion-inner:panel-body"
        )

        echo "Action: ${scriptAction}"
        echo "File: ${fileStream}"
        rm $fileStream.bak
        cp $fileStream $fileStream.bak

        if test $scriptAction == "convert"
        then
          for tbClass in "${ARRAY[@]}" ; do
            tb2Class="${tbClass%%:*}"
            tb3Class="${tbClass##*:}"
            # echo "${tb2Class}"
            printf "."
            perl -pi -w -e "s/\<span/\<putThisSpanBack/g;" $fileStream
            perl -pi -w -e "s/\<\/span/\<\/putThisSpanBack/g;" $fileStream
            perl -pi -w -e "s/-btn/-putThisBtnBack/g;" $fileStream
            perl -pi -w -e "s/btn-/putThisBtnBack-/g;" $fileStream
            perl -pi -w -e "s/${tb2Class}/${tb3Class}/g;" $fileStream
            perl -pi -w -e "s/\<putThisSpanBack/\<span/g;" $fileStream
            perl -pi -w -e "s/\<\/putThisSpanBack/\<\/span/g;" $fileStream
            perl -pi -w -e "s/-putThisBtnBack/-btn/g;" $fileStream
            perl -pi -w -e "s/putThisBtnBack-/btn-/g;" $fileStream
          done
          echo "\r\nDone."
        fi

        if test $scriptAction == "revert"
        then
          for tbClass in "${ARRAY[@]}" ; do
            tb2Class="${tbClass%%:*}"
            tb3Class="${tbClass##*:}"
            # echo "${tb3Class}"
            printf "."

            perl -pi -w -e "s/-container/-putThisContainerBack/g;" $fileStream
            perl -pi -w -e "s/container-/putThisContainerBack-/g;" $fileStream

            perl -pi -w -e "s/${tb3Class}/${tb2Class}/g;" $fileStream

            perl -pi -w -e "s/-putThisContainerBack/-container/g;" $fileStream
            perl -pi -w -e "s/putThisContainerBack-/container-/g;" $fileStream
            perl -pi -w -e "s/-putThisBtnBack/-btn/g;" $fileStream
            perl -pi -w -e "s/putThisBtnBack-/btn-/g;" $fileStream
          done
          echo "\r\nDone."
        fi
    else
      echo "File $fileStream does not exist."
    fi
else
  echo "Usage: sh ./convertTB2-3.sh convert <filename> or sh ./convertTB2-3.sh revert <filename>"
fi



