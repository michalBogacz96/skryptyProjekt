#!/bin/bash

arguments_amount=$#
args=($@)
scriptName=${0##*/}
firstArgument=${args[0]}

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$DIR/help.sh"

file_names=('./bashScript.sh' './help.sh' './client.pl' './server.pl' './messages.pm' './edge.py' './graph.py'
            './main.py' './dijkstra.py')
directory="DIRECTORY"
path_is_passed=0

function check_arguments() {
  path_to_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

  if [ $arguments_amount == 0 ]; then
    basic_oeprations $path_to_script
  else
    check_help_in_arguments
    if [ -d "${args[0]}" ]; then
      path_is_passed=1
      if [ $arguments_amount -gt 1 ]; then
        check_options 1
      fi
      basic_oeprations ${args[0]}
    else
      check_options 0
      basic_oeprations $path_to_script
    fi
  fi
}

function check_help_in_arguments() {
  for ((index = start_index; index < arguments_amount; index++)); do
    if [ "${args[index]}" == "-h" ] || [ "${args[index]}" == "--help" ]; then
      help
      exit 0
    fi
  done
}

function check_options() {
  start_index=$1
  for ((index = start_index; index < arguments_amount; index++)); do

    if [[ "${args[index]}" == "-z" || "${args[index]}" == "--zip" ]]; then
      if [ -d "${args[index + 1]}" ] || [ -f "${args[index + 1]}" ]; then
        zip_directories "${args[index + 1]}"
        index+=1
      else
        zip_directories 0
      fi
    elif [[ "${args[index]}" == "-uz" || "${args[index]}" == "--unzip" ]]; then
      if [ -d "${args[index + 1]}" ] || [ -f "${args[index + 1]}" ]; then
        unzip_directories ${args[index + 1]}
        index+=1
      else
        unzip_directories 0
      fi
    elif [ "${args[index]}" == "-rm" ]; then
      if [ -d "${args[index + 1]}" ] || [ -f "${args[index + 1]}" ]; then
        remove_file ${args[index + 1]}
        index+=1
      else
        remove_file 0
      fi
    fi
  done
}

function basic_oeprations() {
  path=$1
  remove_empty_files
  the_same=0
  for fname in $(
    find . -maxdepth 1 -type f
  ); do
    for i in "${file_names[@]}"; do
      if [ "$i" == $fname ]; then
        the_same=1
        break
      fi
    done

    if [ $the_same == 0 ]; then
      extension=${fname##*\.}
      name=$(basename $fname .$extension)
      directoryName=$extension$directory
      if ! [ "./$scriptName" == "$fname" ] && ! [ -d "$directoryName" ]; then
        mkdir -p $directoryName
      fi

      if [ "./$scriptName" != "$fname" ]; then
        mv /$path/$name.$extension /$path/$directoryName
      fi
    fi
    the_same=0
  done
}

function info_about_installation() {
  arg=$1
  printf "
  Nie mozna wykonac danej operacji, poniewaz nie masz zainstalowanego programu: '$arg'
  Zeby zainstalowac program '$arg' wpisz w konsoli polecenie:
  'sudo apt-get install $arg'
  "
}

function zip_directories() {
  path=$1

  if ! command -v zip &> /dev/null
  then
    info_about_installation 'zip'
    exit
  fi

  super_directory=($(dirname $path))
  super_directory_path=$(realpath $super_directory)

  path_of_script=$(realpath $scriptName)
  directory_of_script=$(dirname $path_of_script)
  superdirectory_directory_of_script=$(dirname $directory_of_script)
  bash_script_is_in_path=0

  if [ -d "$path" ] || [ -f "$path" ]; then
    if [ $path_is_passed == 1 ]; then
      if [ $super_directory_path -ef "${args[0]}" ]; then
        zip -r "$path.zip" "$path"
      else
        echo "czy na pewno chcesz zippowac katalog: $super_directory nacisnij [y/n]?"
        read varpozwolenie
        if [ $varpozwolenie == "y" ]; then
          zip -r "$path.zip" "$path"
        fi
      fi
    else
      if [ $super_directory_path -ef $directory_of_script ]; then
        if [ -f "$path" ]; then
          file_extension=${path##*\.}
          file_name=$(basename $path .$file_extension)
        fi
        zip -r "$file_name.zip" "$path"
      else
        echo "czy na pewno chcesz zippowac katalog: $super_directory nacisnij [y/n]?"
        read varpozwolenie
        if [ $varpozwolenie == "y" ]; then
          zip -r "$path.zip" "$path"
        fi
      fi
    fi
  else
    if [ $path_is_passed == 1 ]; then

      for fname in ${args[0]}/*; do
        if [ $fname == $path_of_script ]; then
          bash_script_is_in_path=1
          break
        fi
      done
      if [ $bash_script_is_in_path == 1 ]; then
        echo "w podanym floderze: ${args[0]} jest skrypt : $scriptName . Czy chcesz go rowniez zippowac [y/n]?"
        read varpozwolenie
        if [ $varpozwolenie == "y" ]; then
          zip -r "${args[0]}.zip" "${args[0]}"
        elif [ $varpozwolenie == "n" ]; then
          mv $path_of_script $superdirectory_directory_of_script
          zip -r "${args[0]}.zip" "${args[0]}"
          mv $superdirectory_directory_of_script/$scriptName $path_of_script
        fi
      else
        zip -r "${args[0]}.zip" "${args[0]}"
      fi
    else
      echo "Czy chcesz zippowac folder lacznie ze skryptem: $scriptName [y/n]?"
      read varpozwolenie
      if [ $varpozwolenie == "y" ]; then
        zip -r $directory_of_script.zip $directory_of_script
      elif [ $varpozwolenie == "n" ]; then
        mv $path_of_script $superdirectory_directory_of_script
        zip -r $directory_of_script.zip $directory_of_script
        mv $superdirectory_directory_of_script/$scriptName $path_of_script
      fi
    fi
  fi
}

function unzip_directories() {
  path=$1

  if ! command -v unzip &> /dev/null
  then
    info_about_installation 'unzip'
    exit
  fi

  extension=${path##*\.}
  local zip_file_name=$(basename $path .$extension)
  path_of_script=$(realpath $scriptName)
  directory_of_script=$(dirname $path_of_script)

  if [ -f $path ] && [ $extension == "zip" ]; then
    unzipped_file_name="unzip_"$directory
    mkdir -p $unzipped_file_name
    unzip -j "$path" -d $unzipped_file_name
  elif [ $path == "0" ]; then
    if [ $path_is_passed == 1 ]; then
      for fname in ${args[0]}/*; do

        path_to_the_file=$(basename $fname)
        if [ -f $fname ]; then
          extension_the_file=${path_to_the_file##*\.}
          if [ $extension_the_file == "zip" ]; then
            echo "Chcesz unzipowac plik: $fname?[y/n]"
            read varpozwolenie
            if [ $varpozwolenie == "y" ]; then
              fname_basename=$(basename $fname .$extension_the_file)
              unzipped_file_name="unzip_"$fname_basename
              mkdir -p $unzipped_file_name
              unzip -j "$path_to_the_file" -d $unzipped_file_name
            fi
          fi
        fi
      done
    else
      for fname in $directory_of_script/*; do
        path_to_the_file=$(basename $fname)
        if [ -f $fname ]; then
          extension_the_file=${path_to_the_file##*\.}
          if [ $extension_the_file == "zip" ]; then
            echo "Chcesz unzipowac plik: $fname?[y/n]"
            read varpozwolenie
            if [ $varpozwolenie == "y" ]; then
              fname_basename=$(basename $fname .$extension_the_file)
              unzipped_file_name="unzip_"$fname_basename
              mkdir -p $unzipped_file_name
              unzip -j "$path_to_the_file" -d $unzipped_file_name

            fi
          fi
        fi
      done
    fi
  fi
}

function remove_file() {
  path=$1
  path_of_script=$(realpath $scriptName)
  directory_of_script=$(dirname $path_of_script)
  if [ -f "$path" ] && ! [ $path -ef $scriptName ]; then
    rm -i $path
  elif [ $path == 0 ]; then
    help
  fi
}

function remove_empty_files() {
  for file in $(
    find . -maxdepth 1 -type f
  ); do

    if ! [ -s $file ]; then
      rm -i $file
    fi
  done
}

function main() {
  check_arguments
}

main
