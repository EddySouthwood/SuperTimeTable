global whichWeek
--Set one or two week timetable here
set whichWeek to {"A", "B"}
global daysOfWeek
--If you work on the weekend bad luck, and add the days here
set daysOfWeek to {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"}
global periods
--This is where you add the periods of the day
set periods to {"1", "2", "3"} --, "4", "5"}
global startTimes
--Start times for lessons here. The code only currently supports one hour lessons
set startTimes to {{hour:8, min:55}, {hour:10, min:0}, {hour:11, min:20}} --, {hour:13, min:35}, {hour:14, min:40}}
global startDate

-- I cant remember what this was for?
--set i to 1
--repeat while i ≤ (count of daysOfWeek)
--	display dialog daysOfWeek's item i
--	set i to (i + 1)
--end repeat

--Warning to users
display dialog "A Calendar needs to exist for each class you teach. For example in iCal creat a calendar called Y7 (and set it with a nice colour) then when prompted to fill in your time table enter the same name. If you make a mistake you'll get an error message."

--Get start date
display dialog "What is the date of the first Monday W1P1?" default answer "02/01/2017"
set temp to text returned of result
set startDate to date temp
global endDate

--Get end Date
display dialog "What is the date end of term (Last non school day)? Syntax YYYYMMDD" default answer "20170211"
set endDate to text returned of result

--Code to change day of the week to a number
on list_position(this_item, this_list)
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then return i
	end repeat
	return "not in list"
end list_position




on getLesson(period)
	display dialog "What class do you have " & period default answer period
	return text returned of result
end getLesson

on makeEvent(week, dayy, period, lesson)
	
	set dayPeriodicity to (list_position(dayy as string, daysOfWeek) - 1)
	set weekPeriodicity to (list_position(week as string, whichWeek) - 1)
	--set lessonPeriodicity to (dayPeriodicity * weekPeriodicity)
	set temp to startTimes's item period
	
	set calError to false
	
	tell application "Calendar"
		tell calendar lesson
			try
				make new event at end with properties {summary:lesson, start date:(startDate + ((weekPeriodicity * 7) + dayPeriodicity) * days + (hour of temp) * hours + (min of temp) * minutes), end date:(startDate + ((weekPeriodicity * 7) + dayPeriodicity) * days + ((hour of temp) + 1) * hours + (min of temp) * minutes), recurrence:"FREQ=WEEKLY;INTERVAL=2;UNTIL=" & endDate}
			on error msg number -1728
				display dialog "No such Calendar"
				set calError to true
			end try
		end tell
	end tell
	if calError then
		set calError to false
		set lesson to getLesson(period)
		makeEvent(week, dayy, period, lesson)
	end if
end makeEvent

repeat with week in whichWeek
	
	set weekPeriodicity to list_position(week as string, whichWeek)
	--display dialog week & " = " & weekPeriodicity
	repeat with dayy in daysOfWeek
		set dayPeriodicity to (list_position(dayy as string, daysOfWeek))
		--display dialog "Day = " & dayy & " Debug dayPeriodicity = " & dayPeriodicity
		repeat with period in periods
			set temp to week & " " & dayy & period
			set lesson to getLesson(temp)
			--set dayPeriodicity to (list_position(dayy, daysOfWeek))
			--set weekPeriodicity to list_position(week, whichWeek)
			set lessonPeriodicity to (dayPeriodicity * weekPeriodicity)
			--display dialog "Day = " & dayy & "
			--Lesson = " & lesson & "
			--dayPeriodicity = " & dayPeriodicity & "
			--weekPeriodicity = " & weekPeriodicity &YY " 
			--lessonPeriodicity = " & lessonPeriodicity
			makeEvent(week, dayy, period, lesson)
		end repeat
	end repeat
end repeat
