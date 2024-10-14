#!/usr/bin/env bash

# NO USED ANYMORE
# a quick bunck of functions to generate
# animated_gif and add watermark on videos

MYWEBSITE="www.mywebsite.com"

# ajout bandeau defilant sur toute la video
function add_txt_vid {

 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: add_txt_vid filename.mp4 [SEC (cut the fist x SECONDS)]"
    return 1
 
 else
  # 3eme argument = nombre de secondes a couper au debut
    if [  "$2" ]; then
      cuttime=" -ss $2 "
      starttimelogo=$(($2+1))
    else
      cuttime=""
      starttimelogo="1"
    fi
    echo "cutt :$cuttime: //// starttime :$starttimelogo:"
    if [ -f "$1" ] ; then
      param=$1
      filename="${param%.*}"
      extension="${param##*.}"

      # portrait or landscape pour definir la taille de la police
      vidH=$(ffmpeg -i "$param" 2>&1 | grep "Stream.*Vide" | cut -d"," -f 3 | cut -f2 -d" " | cut -f1 -d"x")
      vidL=$(ffmpeg -i "$param" 2>&1 | grep "Stream.*Vide" | cut -d"," -f 3 | cut -f2 -d" " | cut -f2 -d"x")
      if [[ $vidH -lt $vidL ]] ; then
        mmode=1
      else
        mmode=0
      fi
      if (( $mmode == 0 )) ; then
        echo "LANDSCAPE"
        TitlePale="10"
        Titlefixe="20"
        Titledefil="15"
      else
        echo "PORTRAIT"
        TitlePale="20"
        Titlefixe="30"
        Titledefil="25"
      fi

      # on calcule le nbr de bandeau en fonction de la durée de la video

      vidLenght=$(ffmpeg -i "$param" 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')
      if (( $vidLenght <= 180  )) ; then
        nbrTxt="2"
      elif (( $vidLenght >= 180 && $vidLenght <= 600  )) ; then
        nbrTxt="3"
      elif (( $vidLenght >= 600 && $vidLenght <= 900  )) ; then
        nbrTxt="6"
      elif (( $vidLenght >= 900 && $vidLenght <= 1200  )) ; then
        nbrTxt="10"
      elif (( $vidLenght >= 1200 )) ; then
        nbrTxt="14"
      fi

      # boucle pour rajouter les param du bandeau
      # drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='More Videos on\n---------\nhttps\:\/\/${MYWEBSITE}': fontcolor=red: fontsize=60: x=(w-text_w)/2: y=if(lt(t\,3)\,(-h+((3*h-200)*t/6))\,(h-200)/2):enable='between(t,1,10)'
      #bandeau="drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='https\:\/\/${MYWEBSITE}': fontcolor=white: fontsize=20: x=10:y=h-th-10,drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='https\:\/\/${MYWEBSITE}': fontcolor=white: fontsize=30: y=(h-text_h)/3:x=(w-(t-12)*w/9.5)"
      bandeau="drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='https\:\/\/${MYWEBSITE}': fontcolor=white:shadowcolor=black:shadowx=2:shadowy=2: fontsize=(h/$Titlefixe): x=10:y=h-th-10,drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: textfile='/tmp/titlesVideos.txt': fontcolor=red:shadowcolor=black:shadowx=2:shadowy=2: fontsize=(h/$TitlePale): x=(w-text_w)/2: y=if(lt(t\,3)\,(-h+((3*h-200)*t/6))\,(h-200)/2):enable='between(t,$starttimelogo,11)'"
      nbrTxtadd=$(($nbrTxt - 1))
      (( part = vidLenght / nbrTxt ))
      result=$part
      while (( result <= vidLenght )) ; do
        bandeau=$bandeau",drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='https\:\/\/${MYWEBSITE}': fontcolor=LightGrey:shadowcolor=black:shadowx=2:shadowy=2: fontsize=(h/$Titledefil): y=(h-text_h)/3:x=(w-(t-$result)*w/9.5)"
        #printf '%d ' $result
        (( result += part ))
      done

      ffmpeg -loglevel panic -y -i "$param" $cuttime  -vf "[in]hflip,$bandeau[out]" -c:a copy "$filename"_WM.$extension
      #ffmpeg -y -i "$param" $cuttime  -vf "[in]hflip,$bandeau[out]" -c:a copy "$filename"_WM.$extension
      echo "filnemae :$filename: //// extension :$extension:"
      echo "filename :$param: /// Lenght : $vidLenght : /// nbrbandeau :$nbrTxt:"
      echo "bandeau :$bandeau:"
      
    else
      echo "'$1' - file does not exist"
      return 1
    fi
 fi



}

# MEMO :
# to convert a batch of file :
# SAVEIFS=$IFS; IFS=$(echo -en "\n\b") ; for i in `ls *.mp4`; do FILE=${i%.*}; for j in `cat $FILE.txt.2.txt`; do agif_white $i $j ; done ; done
#
# to genereate empty txt file:
# SAVEIFS=$IFS; IFS=$(echo -en "\n\b") ; for i in `ls *.mp4`; do  FILE=${i%.*}; touch $FILE.txt; done
#
# to generate the previous .txt.2.txt used before :
# SAVEIFS=$IFS; IFS=$(echo -en "\n\b") ; for i in `ls *.txt`; do cat $i | awk -F: '{ print ($1 * 60) +  $2 }' > $i.2.txt ; done
# with .txt like :
# 2:44
# 0:09
# 15:12

function agif_white {
 if [ -z "$2" ]; then
    # display usage if no parameters given
    echo "Usage: agif filename.mp4 start_time(seconds) v[optional : vertical] b[optional : font in black]"
    return 1
 else
    if [ -f "$1" ] ; then
      param=$1
      time=$2
      filename="${param%.*}"
      ffmpeg -ss $time -t 8 -i "$param" -vf "scale=320:-1,drawtext=text='https\:\/\/${MYWEBSITE}':fontsize=14:fontcolor=white:x=10: y=30" frame%04d.png
      ~/Documents/Perso/tmp/november/gifski/gifski/target/release/gifski --fps 10 -o "$filename"."$time".gif frame*.png
      rm frame*.png
      ffmpeg -ss $time -t 8 -i "$param" -vf "scale=320:-1" frame%04d.png
      ~/Documents/Perso/tmp/november/gifski/gifski/target/release/gifski --fps 10 -o "$filename"."$time"_noWM.gif frame*.png
      rm frame*.png

      #ffmpeg -y -ss $time -t 7 -i "$param" -vf "fps=10,scale=240:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse,drawtext=text='https\:\/\/${MYWEBSITE}':sh ontsize=12:fontcolor=white:x=10: y=30" -loop 0 "$filename"."$time".gif
      #ffmpeg -y -ss $time -t 7 -i "$param" -vf "fps=10,scale=240:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$filename"."$time"_noWM.gif
      echo "filename :$filename:"
      
    else
      echo "'$1' - file does not exist"
      return 1
    fi
 fi
}
function agif_black {
 if [ -z "$2" ]; then
    # display usage if no parameters given
    echo "Usage: agif filename.mp4 start_time(seconds) v[optional : vertical] b[optional : font in black]"
    return 1
 else
    if [ -f "$1" ] ; then
      param=$1
      time=$2
      filename="${param%.*}"
      ffmpeg -y -ss $time -t 7 -i "$param" -vf "fps=10,scale=240:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse,drawtext=text='https\:\/\/${MYWEBSITE}':fontsize=12:fontcolor=red:x=10: y=30" -loop 0 "$filename"."$time".gif
      ffmpeg -y -ss $time -t 7 -i "$param" -vf "fps=10,scale=240:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$filename"."$time"_noWM.gif
      echo "filename :$filename:"
      
    else
      echo "'$1' - file does not exist"
      return 1
    fi
 fi
}