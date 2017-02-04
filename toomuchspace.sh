#!/bin/bash

# Sets text display widget on your wallpaper
# Created by DoITCreative
#
# Script depends on:
# imagemagick-full-git
# feh


#Variables

	display_size_x=$(xrandr | grep \*|cut -d " " -f4 | cut -d "x" -f1)
	display_size_y=$(xrandr | grep \*|cut -d " " -f4 | cut -d "x" -f2)
	
	#Size of logo
	logo_size_x=90
	logo_size_y=90
	
	#Position of logo on screeen
	logo_margin_x="+990"
	logo_margin_y="+300"
	
	#Size of background (rectangle)
	background_size_x=350
	background_size_y=700
	
	#Position of background
	background_margin_x="+855"
	background_margin_y="+25"

	#Text position
	text_position_x="+25"
	text_position_y="+50"
	
	#Path to files to use
	path_to_logo=gfx/logo.png
	path_to_wallpaper=gfx/wallpaper.jpg
	path_to_background=gfx/background.png
	path_to_greeter=./greeter.txt
	path_to_temorary_files=/tmp
	path_to_icon=gfx/icon.png
	path_to_selector=gfx/selector.png

	#Icon options
	icon_size=50

	icon1_margin_x="+35"
	icon1_margin_y="+590"

	icon2_margin_x="+95"
	icon2_margin_y="+590"
	
	icon3_margin_x="+155"
	icon3_margin_y="+590"

	icon4_margin_x="+215"
	icon4_margin_y="+590"

	icon5_margin_x="+275"
	icon5_margin_y="+590"

	#Selector options
	selector_size_x=50
	selector_size_y=5

	selector_margin_x="+95"
	selector_margin_y="+635"

	#Font settings
	font_to_use=Hack-Regular
	font_size=10
	
	#Screen update time
	time_to_wait=30

#--------------------------------------------------

#Functions:
	edit_text()
	{
	#Creates text to show on image
	cp $path_to_greeter $path_to_temorary_files/tms_text.txt
	fortune|cowsay>>$path_to_temorary_files/tms_text.txt
	echo -e "\nYour notes bellow this point \".\"" >> $path_to_temorary_files/tms_text.txt
	}
	
	draw_stuff()
	{

	#Draws logo on screen
	composite -geometry $logo_margin_x$logo_margin_y $path_to_logo $path_to_wallpaper $path_to_temorary_files/tms_output.png
	#Combines text and background
	convert $path_to_background -pointsize $font_size -fill white -font $font_to_use -annotate $text_position_x$text_position_y @$path_to_temorary_files/tms_text.txt $path_to_temorary_files/tms_background_text.png
	#Icons draw
	composite -geometry $icon1_margin_x$icon1_margin_y $path_to_icon $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_background_text.png
	composite -geometry $icon2_margin_x$icon2_margin_y $path_to_icon $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_background_text.png
	composite -geometry $icon3_margin_x$icon3_margin_y $path_to_icon $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_background_text.png
	composite -geometry $icon4_margin_x$icon4_margin_y $path_to_icon $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_background_text.png
	composite -geometry $icon5_margin_x$icon5_margin_y $path_to_icon $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_background_text.png
	#Draws selector
	composite -geometry $selector_margin_x$selector_margin_y $path_to_selector $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_background_text.png

	composite -geometry $background_margin_x$background_margin_y $path_to_temorary_files/tms_background_text.png $path_to_temorary_files/tms_output.png $path_to_temorary_files/tms_output.png
	}
	
	remove_trash()
	{
	#Removes temporary files
	rm $path_to_temorary_files/tms_background_text.png 
	rm $path_to_temorary_files/tms_text.txt
	}
	
	convert_images()
	{
	#Resizing of images
	convert $path_to_wallpaper -resize $display_size_x'x'$display_size_y $path_to_temorary_files/wallpaper_resized.jpg
	convert $path_to_background -resize $background_size_x'x'$background_size_y\! $path_to_temorary_files/background_resized.png
	convert $path_to_logo -resize $logo_size_x'x'$logo_size_y\! $path_to_temorary_files/logo_resized.png
	convert $path_to_icon -resize $icon_size'x'$icon_size\! $path_to_temorary_files/icon_resized.png
	convert $path_to_selector -resize $selector_size_x'x'$selector_size_y\! $path_to_temorary_files/selector_resized.png
	
	path_to_wallpaper=$path_to_temorary_files/wallpaper_resized.jpg
	path_to_background=$path_to_temorary_files/background_resized.png
	path_to_logo=$path_to_temorary_files/logo_resized.png
	path_to_icon=$path_to_temorary_files/icon_resized.png
	path_to_selector=$path_to_temorary_files/selector_resized.png
	}
#--------------------------------------------------
#Program:

convert_images
while :
do
	convert_images
	edit_text
	draw_stuff
	remove_trash
	feh --bg-scale $path_to_temorary_files/tms_output.png
	sleep $time_to_wait
done

